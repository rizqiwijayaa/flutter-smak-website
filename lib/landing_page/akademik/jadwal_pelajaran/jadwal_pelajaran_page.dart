import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../site_chrome.dart';
import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../../routing/public_routes.dart';

const _blue = Color(0xFF0756C8);
const _navy = Color(0xFF083A7C);
const _text = Color(0xFF0B326B);
const _muted = Color(0xFF65758F);
const _background = Color(0xFFF4F8FD);
const _line = Color(0xFFE1EAF5);
const _softBlue = Color(0xFFEAF2FF);
const _softYellow = Color(0xFFFFF7DE);

const _defaultJadwalContent = <String, String>{
  'breadcrumb': 'Beranda  >  Akademik  >  Jadwal Pelajaran',
  'hero_title': 'Jadwal Pelajaran',
  'hero_subtitle': 'Informasi jadwal kegiatan belajar mengajar SMAK Mgr. Soegijapranata.',
  'hero_image': '',
  'page_title': 'Jadwal Pelajaran',
  'page_subtitle': 'Pilih tahun ajaran, tingkat, dan kelas untuk melihat jadwal pelajaran.',
  'schedule_note': 'Catatan: Jadwal dapat berubah sewaktu-waktu sesuai kebijakan sekolah.',
  'timing_title': 'Keterangan Jam Pelajaran',
  'information_title': 'Informasi Jadwal',
  'information_text': 'Perubahan jadwal pelajaran akan diinformasikan oleh wali kelas melalui pengumuman resmi sekolah. Pastikan untuk selalu memeriksa informasi terbaru.',
  'pdf_button_label': 'Unduh Jadwal PDF',
  'contact_button_label': 'Hubungi Sekolah',
  'reminder_text': 'Pastikan selalu memeriksa pembaruan jadwal sebelum kegiatan belajar dimulai.',
  'pdf_url': '',
};

class JadwalPelajaranPage extends StatefulWidget {
  const JadwalPelajaranPage({super.key});

  @override
  State<JadwalPelajaranPage> createState() => _JadwalPelajaranPageState();
}

class _JadwalPelajaranPageState extends State<JadwalPelajaranPage> {
  String _selectedYear = _schoolYears.first;
  String _selectedLevel = _levels.first;
  String _selectedClass = _classOptions[_levels.first]!.first;
  String _selectedDay = _days.first;
  Map<String, _ScheduleMeta> _activeDatabase = Map<String, _ScheduleMeta>.from(
    _scheduleDatabase,
  );
  Map<String, String> _content = Map<String, String>.from(_defaultJadwalContent);
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    try {
      final rows = await const SmakApi().getTable(
        'jadwal_pelajaran',
        limit: 1000,
      );
      final contentRows = await const SmakApi().getTable('jadwal_konten');
      final database = _buildScheduleDatabase(rows);
      if (!mounted) return;
      setState(() {
        if (database.isNotEmpty) {
          _activeDatabase = database;
        }
        _content = _decodeJadwalContent(contentRows);
        _syncSelections();
        _loading = false;
        _loadError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _syncSelections();
        _loading = false;
        _loadError =
            'Data jadwal dari database belum bisa diambil. Halaman sementara memakai data cadangan.';
      });
    }
  }

  _ScheduleMeta get _currentSchedule {
    final key = '$_selectedYear|$_selectedLevel|$_selectedClass';
    return _activeDatabase[key] ?? _activeDatabase.values.first;
  }

  List<String> get _availableYears {
    final values =
        _activeDatabase.keys.map((key) => key.split('|').first).toSet().toList()
          ..sort((a, b) => b.compareTo(a));
    return values.isEmpty ? _schoolYears : values;
  }

  List<String> get _availableLevels {
    final values = _activeDatabase.keys
        .map((key) => key.split('|'))
        .where((parts) => parts.length == 3 && parts[0] == _selectedYear)
        .map((parts) => parts[1])
        .toSet()
        .toList();
    return values.isEmpty ? _levels : values;
  }

  List<String> get _availableClasses {
    final values =
        _activeDatabase.keys
            .map((key) => key.split('|'))
            .where(
              (parts) =>
                  parts.length == 3 &&
                  parts[0] == _selectedYear &&
                  parts[1] == _selectedLevel,
            )
            .map((parts) => parts[2])
            .toSet()
            .toList()
          ..sort();
    return values.isEmpty
        ? (_classOptions[_selectedLevel] ?? const ['X-A'])
        : values;
  }

  void _syncSelections() {
    final years = _availableYears;
    if (!years.contains(_selectedYear)) {
      _selectedYear = years.first;
    }
    final levels = _availableLevels;
    if (!levels.contains(_selectedLevel)) {
      _selectedLevel = levels.first;
    }
    final classes = _availableClasses;
    if (!classes.contains(_selectedClass)) {
      _selectedClass = classes.first;
    }
    if (!_days.contains(_selectedDay)) {
      _selectedDay = _days.first;
    }
  }

  void _onYearChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedYear = value;
      final levels = _availableLevels;
      _selectedLevel = levels.contains(_selectedLevel)
          ? _selectedLevel
          : levels.first;
      final classes = _availableClasses;
      _selectedClass = classes.first;
      _selectedDay = _days.first;
    });
  }

  void _onLevelChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedLevel = value;
      final classes = _availableClasses;
      _selectedClass = classes.first;
      _selectedDay = _days.first;
    });
  }

  void _onClassChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedClass = value;
      _selectedDay = _days.first;
    });
  }

  void _showSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Menampilkan jadwal $_selectedClass untuk tahun ajaran $_selectedYear.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SharedSmakNavigationBar(
              profilePages: sharedProfilePages(),
              academicPages: sharedAcademicPages(),
              studentPages: sharedStudentPages(),
              initialActive: 'Akademik',
            ),
            _HeroSection(content: _content),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: LayoutBuilder(
                  builder: (context, constraints) => Padding(
                    padding: EdgeInsets.fromLTRB(
                      constraints.maxWidth < 760 ? 18 : 30,
                      constraints.maxWidth < 760 ? 30 : 42,
                      constraints.maxWidth < 760 ? 18 : 30,
                      constraints.maxWidth < 760 ? 36 : 50,
                    ),
                    child: Column(
                      children: [
                        _FilterSection(
                          content: _content,
                          selectedYear: _selectedYear,
                          selectedLevel: _selectedLevel,
                          selectedClass: _selectedClass,
                          yearOptions: _availableYears,
                          levelOptions: _availableLevels,
                          classOptions: _availableClasses,
                          schedule: _currentSchedule,
                          onYearChanged: _onYearChanged,
                          onLevelChanged: _onLevelChanged,
                          onClassChanged: _onClassChanged,
                          onShowSchedule: _showSchedule,
                        ),
                        if (_loading || _loadError != null) ...[
                          const SizedBox(height: 16),
                          _DatabaseStatusCard(
                            loading: _loading,
                            message: _loadError,
                            onRetry: _loadSchedules,
                          ),
                        ],
                        const SizedBox(height: 28),
                        _ScheduleTableSection(
                          content: _content,
                          selectedDay: _selectedDay,
                          schedule: _currentSchedule,
                          onDaySelected: (day) {
                            setState(() => _selectedDay = day);
                          },
                        ),
                        const SizedBox(height: 24),
                        _BottomInfoSection(
                          content: _content,
                          schedule: _currentSchedule,
                          onDownload: () {
                            final pdfUrl = _content['pdf_url']?.trim() ?? '';
                            if (pdfUrl.isEmpty) return;
                            final resolved = pdfUrl.startsWith('http://') || pdfUrl.startsWith('https://')
                                ? pdfUrl
                                : const SmakApi().getFileUrl(pdfUrl);
                            html.window.open(resolved, '_blank');
                          },
                          onContact: () => publicRootNavigator(
                            context,
                          ).pushNamed(PublicRoutes.contact),
                        ),
                        const SizedBox(height: 24),
                        _ReminderStrip(content: _content),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SharedSmakFooter(
              profilePages: sharedProfilePages(),
              academicPages: sharedAcademicPages(),
              studentPages: sharedStudentPages(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.content});

  final Map<String, String> content;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return SizedBox(
      width: double.infinity,
      height: compact ? 310 : 290,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(
            content['hero_image'] ?? '',
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xED0A3E83),
                  Color(0xD10A3E83),
                  Color(0x660A3E83),
                ],
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 22 : 34),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 540,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content['breadcrumb']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          content['hero_title']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 54,
                          child: Divider(
                            color: Color(0xFFF2B313),
                            thickness: 3,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          content['hero_subtitle']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.content,
    required this.selectedYear,
    required this.selectedLevel,
    required this.selectedClass,
    required this.yearOptions,
    required this.levelOptions,
    required this.classOptions,
    required this.schedule,
    required this.onYearChanged,
    required this.onLevelChanged,
    required this.onClassChanged,
    required this.onShowSchedule,
  });

  final Map<String, String> content;
  final String selectedYear;
  final String selectedLevel;
  final String selectedClass;
  final List<String> yearOptions;
  final List<String> levelOptions;
  final List<String> classOptions;
  final _ScheduleMeta schedule;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onLevelChanged;
  final ValueChanged<String?> onClassChanged;
  final VoidCallback onShowSchedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content['page_title']!,
          style: const TextStyle(
            color: _text,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content['page_subtitle']!,
          style: const TextStyle(color: _muted, fontSize: 16, height: 1.6),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 880;
            final fields = [
              _DropdownField(
                label: 'Tahun Ajaran',
                value: selectedYear,
                items: yearOptions,
                onChanged: onYearChanged,
              ),
              _DropdownField(
                label: 'Tingkat',
                value: selectedLevel,
                items: levelOptions,
                onChanged: onLevelChanged,
              ),
              _DropdownField(
                label: 'Kelas',
                value: selectedClass,
                items: classOptions,
                onChanged: onClassChanged,
              ),
            ];

            if (stacked) {
              return Column(
                children: [
                  for (final field in fields) ...[
                    field,
                    const SizedBox(height: 14),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: _PrimaryButton(
                      icon: Icons.calendar_month_rounded,
                      label: 'Tampilkan Jadwal',
                      onTap: onShowSchedule,
                    ),
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < fields.length; i++) ...[
                  Expanded(child: fields[i]),
                  if (i != fields.length - 1) const SizedBox(width: 18),
                ],
                const SizedBox(width: 18),
                SizedBox(
                  width: 220,
                  child: _PrimaryButton(
                    icon: Icons.calendar_month_rounded,
                    label: 'Tampilkan Jadwal',
                    onTap: onShowSchedule,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: _softBlue,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFC9DDF9)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 780;
              final items = [
                _InfoChip(
                  icon: Icons.calendar_today_rounded,
                  text: schedule.semester,
                ),
                _InfoChip(
                  icon: Icons.person_rounded,
                  text: 'Wali Kelas: ${schedule.homeroomTeacher}',
                ),
                _InfoChip(
                  icon: Icons.schedule_rounded,
                  text: 'Terakhir diperbarui: ${schedule.updatedAt}',
                ),
              ];

              if (compact) {
                return Column(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      items[i],
                      if (i != items.length - 1) const SizedBox(height: 12),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: items[0]),
                  const _VerticalDividerLine(),
                  Expanded(child: items[1]),
                  const _VerticalDividerLine(),
                  Expanded(child: items[2]),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ScheduleTableSection extends StatelessWidget {
  const _ScheduleTableSection({
    required this.content,
    required this.selectedDay,
    required this.schedule,
    required this.onDaySelected,
  });

  final Map<String, String> content;
  final String selectedDay;
  final _ScheduleMeta schedule;
  final ValueChanged<String> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final rows = schedule.days[selectedDay] ?? <_LessonRow>[];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120B2F60),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              if (compact) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final day in _days)
                      _DayTab(
                        label: day,
                        active: day == selectedDay,
                        onTap: () => onDaySelected(day),
                      ),
                  ],
                );
              }

              return Row(
                children: [
                  for (final day in _days)
                    Expanded(
                      child: _DayTab(
                        label: day,
                        active: day == selectedDay,
                        onTap: () => onDaySelected(day),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1100),
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xFFEAF2FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Row(
                        children: [
                          _HeaderCell('Jam Ke', width: 110),
                          _HeaderCell('Waktu', width: 160),
                          _HeaderCell('Mata Pelajaran', width: 280),
                          _HeaderCell('Guru', width: 350),
                          _HeaderCell('Ruang', width: 200),
                        ],
                      ),
                    ),
                    for (final row in rows) _ScheduleRowWidget(row: row),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              content['schedule_note']!,
              style: const TextStyle(color: _muted, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomInfoSection extends StatelessWidget {
  const _BottomInfoSection({
    required this.content,
    required this.schedule,
    required this.onDownload,
    required this.onContact,
  });

  final Map<String, String> content;
  final _ScheduleMeta schedule;
  final VoidCallback onDownload;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final left = _TimeLegendCard(content: content, schedule: schedule);
        final right = _ScheduleInfoCard(
          content: content,
          onDownload: onDownload,
          onContact: onContact,
        );

        if (compact) {
          return Column(children: [left, const SizedBox(height: 18), right]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 18),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _TimeLegendCard extends StatelessWidget {
  const _TimeLegendCard({required this.content, required this.schedule});

  final Map<String, String> content;
  final _ScheduleMeta schedule;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: content['timing_title']!,
      child: Column(
        children: [
          for (int i = 0; i < schedule.timings.length; i++) ...[
            _LegendRow(item: schedule.timings[i]),
            if (i != schedule.timings.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: _line, height: 1),
              ),
          ],
        ],
      ),
    );
  }
}

class _ScheduleInfoCard extends StatelessWidget {
  const _ScheduleInfoCard({
    required this.content,
    required this.onDownload,
    required this.onContact,
  });

  final Map<String, String> content;
  final VoidCallback onDownload;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: content['information_title']!,
      accentLine: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: _blue, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  content['information_text']!,
                  style: const TextStyle(color: _muted, fontSize: 15, height: 1.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _PrimaryButton(
              icon: Icons.picture_as_pdf_rounded,
              label: content['pdf_button_label']!,
              onTap: onDownload,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onContact,
              style: OutlinedButton.styleFrom(
                foregroundColor: _blue,
                side: const BorderSide(color: _blue),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              icon: const Icon(Icons.call_rounded),
              label: Text(content['contact_button_label']!),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderStrip extends StatelessWidget {
  const _ReminderStrip({required this.content});

  final Map<String, String> content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: _softBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8E6FB)),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_none_rounded, color: _blue, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              content['reminder_text']!,
              style: const TextStyle(
                color: _text,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DatabaseStatusCard extends StatelessWidget {
  const _DatabaseStatusCard({
    required this.loading,
    required this.message,
    required this.onRetry,
  });

  final bool loading;
  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final isError = !loading && message != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFF7E8) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isError ? const Color(0xFFF3CF7A) : const Color(0xFFD8E6FB),
        ),
      ),
      child: Row(
        children: [
          if (loading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          else
            Icon(
              Icons.info_outline_rounded,
              color: isError ? const Color(0xFFB7791F) : _blue,
              size: 20,
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              loading
                  ? 'Memuat jadwal pelajaran dari database...'
                  : (message ?? 'Data jadwal berhasil dimuat dari database.'),
              style: TextStyle(
                color: isError ? const Color(0xFF8A5A12) : _text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isError)
            TextButton(
              onPressed: () => onRetry(),
              child: const Text('Coba Lagi'),
            ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _text),
              style: const TextStyle(
                color: _text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _blue, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _VerticalDividerLine extends StatelessWidget {
  const _VerticalDividerLine();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 28,
    color: _line,
    margin: const EdgeInsets.symmetric(horizontal: 16),
  );
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? _blue : _line,
              width: active ? 3 : 1,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? _text : _muted,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label, {required this.width});

  final String label;
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        label,
        style: const TextStyle(
          color: _text,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class _ScheduleRowWidget extends StatelessWidget {
  const _ScheduleRowWidget({required this.row});

  final _LessonRow row;

  @override
  Widget build(BuildContext context) {
    final isBreak = row.isBreak;
    return Container(
      decoration: BoxDecoration(
        color: isBreak ? _softYellow : Colors.white,
        border: const Border(bottom: BorderSide(color: _line)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: isBreak
                  ? Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 20,
                          color: Color(0xFF9A7B19),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            row.period,
                            style: const TextStyle(
                              color: _text,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      row.period,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          _TableCell(text: row.time, width: 160),
          _TableCell(text: row.subject, width: 280, emphasized: isBreak),
          _TableCell(text: row.teacher, width: 350),
          _TableCell(text: row.room, width: 200),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    required this.width,
    this.emphasized = false,
  });

  final String text;
  final double width;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        text,
        style: TextStyle(
          color: emphasized ? const Color(0xFF8F6D0D) : _text,
          fontSize: 15,
          height: 1.5,
          fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.child,
    this.accentLine = false,
  });

  final String title;
  final Widget child;
  final bool accentLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120A315E),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (accentLine) ...[
            const SizedBox(height: 8),
            Container(
              width: 52,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFF2B313),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.item});

  final _TimingItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.schedule_rounded, color: _blue, size: 28),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            item.label,
            style: const TextStyle(
              color: _text,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          item.time,
          style: const TextStyle(
            color: _text,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TimingItem {
  const _TimingItem(this.label, this.time);

  final String label;
  final String time;
}

class _LessonRow {
  const _LessonRow({
    required this.period,
    required this.time,
    required this.subject,
    required this.teacher,
    required this.room,
    this.isBreak = false,
  });

  final String period;
  final String time;
  final String subject;
  final String teacher;
  final String room;
  final bool isBreak;
}

class _ScheduleMeta {
  const _ScheduleMeta({
    required this.semester,
    required this.homeroomTeacher,
    required this.updatedAt,
    required this.timings,
    required this.days,
  });

  final String semester;
  final String homeroomTeacher;
  final String updatedAt;
  final List<_TimingItem> timings;
  final Map<String, List<_LessonRow>> days;
}

Map<String, String> _decodeJadwalContent(
  List<Map<String, dynamic>> rows,
) {
  if (rows.isEmpty) return Map<String, String>.from(_defaultJadwalContent);

  try {
    final decoded = jsonDecode('${rows.first['data_json'] ?? '{}'}');
    if (decoded is! Map<String, dynamic>) {
      return Map<String, String>.from(_defaultJadwalContent);
    }
    return {
      ..._defaultJadwalContent,
      for (final entry in decoded.entries)
        if (entry.value != null) entry.key: '${entry.value}',
    };
  } catch (_) {
    return Map<String, String>.from(_defaultJadwalContent);
  }
}

Map<String, _ScheduleMeta> _buildScheduleDatabase(
  List<Map<String, dynamic>> rows,
) {
  final grouped = <String, List<Map<String, dynamic>>>{};
  for (final row in rows) {
    final year = '${row['tahun_ajaran'] ?? ''}'.trim();
    final level = '${row['tingkat'] ?? ''}'.trim();
    final className = '${row['kelas'] ?? ''}'.trim();
    if (year.isEmpty || level.isEmpty || className.isEmpty) continue;
    final key = '$year|$level|$className';
    grouped.putIfAbsent(key, () => []).add(row);
  }

  final database = <String, _ScheduleMeta>{};
  for (final entry in grouped.entries) {
    final records = entry.value
      ..sort((a, b) {
        final dayA = int.tryParse('${a['urutan_hari'] ?? 0}') ?? 0;
        final dayB = int.tryParse('${b['urutan_hari'] ?? 0}') ?? 0;
        if (dayA != dayB) return dayA.compareTo(dayB);
        final orderA = int.tryParse('${a['urutan_jam'] ?? 0}') ?? 0;
        final orderB = int.tryParse('${b['urutan_jam'] ?? 0}') ?? 0;
        return orderA.compareTo(orderB);
      });
    final first = records.first;
    final days = <String, List<_LessonRow>>{};
    for (final record in records) {
      final day = '${record['hari'] ?? ''}'.trim();
      if (day.isEmpty) continue;
      days
          .putIfAbsent(day, () => [])
          .add(
            _LessonRow(
              period: '${record['jam_ke'] ?? ''}',
              time: '${record['waktu'] ?? ''}',
              subject: '${record['mata_pelajaran'] ?? ''}',
              teacher: '${record['guru'] ?? ''}',
              room: '${record['ruang'] ?? ''}',
              isBreak:
                  '${record['is_break'] ?? 0}' == '1' ||
                  '${record['is_break'] ?? false}'.toLowerCase() == 'true',
            ),
          );
    }
    for (final day in _days) {
      days.putIfAbsent(day, () => const []);
    }
    database[entry.key] = _ScheduleMeta(
      semester: '${first['semester'] ?? 'Semester Ganjil'}',
      homeroomTeacher: '${first['wali_kelas'] ?? '-'}',
      updatedAt: '${first['diperbarui_pada'] ?? '-'}',
      timings: [
        _TimingItem('Jam Masuk', '${first['jam_masuk'] ?? '07.00 WIB'}'),
        _TimingItem('Istirahat I', '${first['istirahat_1'] ?? '09.15 WIB'}'),
        _TimingItem('Istirahat II', '${first['istirahat_2'] ?? '11.45 WIB'}'),
        _TimingItem('Selesai', '${first['selesai'] ?? '13.00 WIB'}'),
      ],
      days: days,
    );
  }
  return database;
}

const _schoolYears = ['2026/2027', '2025/2026', '2024/2025'];
const _levels = ['Kelas X', 'Kelas XI', 'Kelas XII'];
const _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

const _classOptions = {
  'Kelas X': ['X-A', 'X-B'],
  'Kelas XI': ['XI-A', 'XI-B'],
  'Kelas XII': ['XII-A', 'XII-B'],
};

const _defaultTimings = [
  _TimingItem('Jam Masuk', '07.00 WIB'),
  _TimingItem('Istirahat I', '09.15 WIB'),
  _TimingItem('Istirahat II', '11.45 WIB'),
  _TimingItem('Selesai', '13.00 WIB'),
];

const _scheduleDatabase = {
  '2026/2027|Kelas X|X-A': _ScheduleMeta(
    semester: 'Semester Ganjil',
    homeroomTeacher: 'Maria Magdalena, S.Pd.',
    updatedAt: '10 Agustus 2026',
    timings: _defaultTimings,
    days: {
      'Senin': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Pendidikan Agama',
          teacher: 'Y. Daniel, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Matematika',
          teacher: 'Antonius W., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Bahasa Indonesia',
          teacher: 'Maria Cecilia, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '09.15-09.30',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '4',
          time: '09.30-10.15',
          subject: 'Fisika',
          teacher: 'Fransiskus D., S.Si.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '5',
          time: '10.15-11.00',
          subject: 'Bahasa Inggris',
          teacher: 'Theresia Indah, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '6',
          time: '11.00-11.45',
          subject: 'Informatika',
          teacher: 'Agnes Viviana, S.Kom.',
          room: 'Lab Komputer',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '11.45-12.15',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '7',
          time: '12.15-13.00',
          subject: 'PJOK',
          teacher: 'Yohanes Daniel, S.Pd.',
          room: 'Lapangan',
        ),
      ],
      'Selasa': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Biologi',
          teacher: 'Sr. Natalia, S.Pd.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Matematika',
          teacher: 'Antonius W., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Sejarah Indonesia',
          teacher: 'Petrus Bima, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '09.15-09.30',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '4',
          time: '09.30-10.15',
          subject: 'Seni Budaya',
          teacher: 'Lidya Angel, S.Sn.',
          room: 'Ruang Seni',
        ),
        _LessonRow(
          period: '5',
          time: '10.15-11.00',
          subject: 'Bahasa Inggris',
          teacher: 'Theresia Indah, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '6',
          time: '11.00-11.45',
          subject: 'Pendidikan Pancasila',
          teacher: 'Cecilia M., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '11.45-12.15',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '7',
          time: '12.15-13.00',
          subject: 'BK',
          teacher: 'Martha Dian, S.Psi.',
          room: 'Ruang BK',
        ),
      ],
      'Rabu': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Kimia',
          teacher: 'Paulus K., S.Si.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Geografi',
          teacher: 'Albertus Y., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Matematika',
          teacher: 'Antonius W., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '09.15-09.30',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '4',
          time: '09.30-10.15',
          subject: 'Bahasa Jawa',
          teacher: 'Siska N., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '5',
          time: '10.15-11.00',
          subject: 'Informatika',
          teacher: 'Agnes Viviana, S.Kom.',
          room: 'Lab Komputer',
        ),
        _LessonRow(
          period: '6',
          time: '11.00-11.45',
          subject: 'Bahasa Indonesia',
          teacher: 'Maria Cecilia, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '11.45-12.15',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '7',
          time: '12.15-13.00',
          subject: 'Prakarya',
          teacher: 'Santo R., S.Pd.',
          room: 'Workshop',
        ),
      ],
      'Kamis': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Bahasa Inggris',
          teacher: 'Theresia Indah, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Fisika',
          teacher: 'Fransiskus D., S.Si.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Pendidikan Agama',
          teacher: 'Y. Daniel, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '09.15-09.30',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '4',
          time: '09.30-10.15',
          subject: 'Sosiologi',
          teacher: 'Benedikta S., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '5',
          time: '10.15-11.00',
          subject: 'Matematika',
          teacher: 'Antonius W., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '6',
          time: '11.00-11.45',
          subject: 'Biologi',
          teacher: 'Sr. Natalia, S.Pd.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '11.45-12.15',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '7',
          time: '12.15-13.00',
          subject: 'Literasi',
          teacher: 'Tim Perpustakaan',
          room: 'Perpustakaan',
        ),
      ],
      'Jumat': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Doa Pagi dan Refleksi',
          teacher: 'Wali Kelas',
          room: 'X-A',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Bahasa Indonesia',
          teacher: 'Maria Cecilia, S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'PPKn',
          teacher: 'Cecilia M., S.Pd.',
          room: 'X-A',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '09.15-09.30',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '4',
          time: '09.30-10.15',
          subject: 'Ekstrakurikuler Kelas',
          teacher: 'Pendamping Kelas',
          room: 'Aula',
        ),
        _LessonRow(
          period: '5',
          time: '10.15-11.00',
          subject: 'Pembinaan Karakter',
          teacher: 'Tim Kesiswaan',
          room: 'Aula',
        ),
        _LessonRow(
          period: '6',
          time: '11.00-11.45',
          subject: 'Rapat Kelas',
          teacher: 'Wali Kelas',
          room: 'X-A',
        ),
      ],
    },
  ),
  '2026/2027|Kelas X|X-B': _ScheduleMeta(
    semester: 'Semester Ganjil',
    homeroomTeacher: 'Antonia Lusia, S.Pd.',
    updatedAt: '9 Agustus 2026',
    timings: _defaultTimings,
    days: {
      'Senin': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Matematika',
          teacher: 'Antonius W., S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Pendidikan Agama',
          teacher: 'Y. Daniel, S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Bahasa Inggris',
          teacher: 'Theresia Indah, S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '09.15-09.30',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '4',
          time: '09.30-10.15',
          subject: 'Biologi',
          teacher: 'Sr. Natalia, S.Pd.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '5',
          time: '10.15-11.00',
          subject: 'Bahasa Indonesia',
          teacher: 'Maria Cecilia, S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: '6',
          time: '11.00-11.45',
          subject: 'Informatika',
          teacher: 'Agnes Viviana, S.Kom.',
          room: 'Lab Komputer',
        ),
        _LessonRow(
          period: 'Istirahat',
          time: '11.45-12.15',
          subject: 'Waktu istirahat peserta didik',
          teacher: '-',
          room: '-',
          isBreak: true,
        ),
        _LessonRow(
          period: '7',
          time: '12.15-13.00',
          subject: 'PJOK',
          teacher: 'Yohanes Daniel, S.Pd.',
          room: 'Lapangan',
        ),
      ],
      'Selasa': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Fisika',
          teacher: 'Fransiskus D., S.Si.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'PPKn',
          teacher: 'Cecilia M., S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Sejarah Indonesia',
          teacher: 'Petrus Bima, S.Pd.',
          room: 'X-B',
        ),
      ],
      'Rabu': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Kimia',
          teacher: 'Paulus K., S.Si.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Matematika',
          teacher: 'Antonius W., S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Seni Budaya',
          teacher: 'Lidya Angel, S.Sn.',
          room: 'Ruang Seni',
        ),
      ],
      'Kamis': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Bahasa Indonesia',
          teacher: 'Maria Cecilia, S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Geografi',
          teacher: 'Albertus Y., S.Pd.',
          room: 'X-B',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Pendidikan Agama',
          teacher: 'Y. Daniel, S.Pd.',
          room: 'X-B',
        ),
      ],
      'Jumat': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Pembinaan Karakter',
          teacher: 'Tim Kesiswaan',
          room: 'Aula',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Ekstrakurikuler Kelas',
          teacher: 'Pendamping Kelas',
          room: 'Aula',
        ),
      ],
    },
  ),
  '2026/2027|Kelas XI|XI-A': _ScheduleMeta(
    semester: 'Semester Ganjil',
    homeroomTeacher: 'Paulus Joni, S.Pd.',
    updatedAt: '8 Agustus 2026',
    timings: _defaultTimings,
    days: {
      'Senin': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Ekonomi',
          teacher: 'Veronika M., S.Pd.',
          room: 'XI-A',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Bahasa Inggris',
          teacher: 'Theresia Indah, S.Pd.',
          room: 'XI-A',
        ),
        _LessonRow(
          period: '3',
          time: '08.30-09.15',
          subject: 'Matematika Lanjut',
          teacher: 'Antonius W., S.Pd.',
          room: 'XI-A',
        ),
      ],
      'Selasa': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Biologi',
          teacher: 'Sr. Natalia, S.Pd.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Kimia',
          teacher: 'Paulus K., S.Si.',
          room: 'Lab IPA',
        ),
      ],
      'Rabu': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Sejarah',
          teacher: 'Petrus Bima, S.Pd.',
          room: 'XI-A',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Sosiologi',
          teacher: 'Benedikta S., S.Pd.',
          room: 'XI-A',
        ),
      ],
      'Kamis': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Fisika',
          teacher: 'Fransiskus D., S.Si.',
          room: 'Lab IPA',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Informatika',
          teacher: 'Agnes Viviana, S.Kom.',
          room: 'Lab Komputer',
        ),
      ],
      'Jumat': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Pendalaman Iman',
          teacher: 'Tim Rohani',
          room: 'Kapel',
        ),
      ],
    },
  ),
  '2025/2026|Kelas XII|XII-A': _ScheduleMeta(
    semester: 'Semester Genap',
    homeroomTeacher: 'Bonaventura Agus, S.Pd.',
    updatedAt: '2 Mei 2026',
    timings: _defaultTimings,
    days: {
      'Senin': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Bahasa Indonesia',
          teacher: 'Maria Cecilia, S.Pd.',
          room: 'XII-A',
        ),
        _LessonRow(
          period: '2',
          time: '07.45-08.30',
          subject: 'Matematika',
          teacher: 'Antonius W., S.Pd.',
          room: 'XII-A',
        ),
      ],
      'Selasa': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Try Out Sekolah',
          teacher: 'Tim Akademik',
          room: 'Aula',
        ),
      ],
      'Rabu': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Pendampingan SNBT',
          teacher: 'Guru BK',
          room: 'Ruang BK',
        ),
      ],
      'Kamis': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Literasi',
          teacher: 'Tim Perpustakaan',
          room: 'Perpustakaan',
        ),
      ],
      'Jumat': [
        _LessonRow(
          period: '1',
          time: '07.00-07.45',
          subject: 'Refleksi Pekanan',
          teacher: 'Wali Kelas',
          room: 'XII-A',
        ),
      ],
    },
  ),
};
