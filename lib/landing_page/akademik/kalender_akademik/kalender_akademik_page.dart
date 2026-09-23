import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../../routing/public_routes.dart';
import '../../site_chrome.dart';

const _blue = Color(0xFF075ACB);
const _navy = Color(0xFF073A7A);
const _text = Color(0xFF102D5C);
const _muted = Color(0xFF64748B);
const _background = Color(0xFFF5F8FC);
const _border = Color(0xFFDCE6F2);
const _softBlue = Color(0xFFEAF3FF);

class _CalendarTextScope extends InheritedWidget {
  const _CalendarTextScope({required this.download, required this.contact, required super.child});
  final String download;
  final String contact;
  static _CalendarTextScope? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_CalendarTextScope>();
  @override bool updateShouldNotify(_CalendarTextScope oldWidget) => download != oldWidget.download || contact != oldWidget.contact;
}

class KalenderAkademikPage extends StatefulWidget {
  const KalenderAkademikPage({super.key});

  @override
  State<KalenderAkademikPage> createState() => _KalenderAkademikPageState();
}

class _KalenderAkademikPageState extends State<KalenderAkademikPage> {
  static const int _firstAcademicYear = 1950;
  static const int _futureYearOffset = 10;

  late String _schoolYear;
  String _semester = 'Ganjil';
  bool _monthlyView = true;
  late DateTime _visibleMonth;
  List<_CalendarEvent> _databaseEvents = const [];
  String _pdfUrl = '';
  String _heroImage = '';
  String _heroTitle = 'Kalender Akademik';
  String _heroSubtitle =
      'Agenda dan kegiatan penting SMAK selama tahun ajaran.';
  String _introTitle = 'Kalender Akademik';
  String _introSubtitle =
      'Temukan jadwal kegiatan sekolah, ujian, libur, dan agenda penting lainnya.';
  String _updatedAt = '10 Agustus 2026';
  String _information =
      'Tanggal dan jadwal dapat berubah sewaktu-waktu sesuai kebijakan sekolah atau kondisi tertentu. Pastikan selalu memantau pembaruan resmi dari pihak sekolah.';
  String _reminder =
      'Pantau pembaruan kalender secara berkala agar tidak melewatkan kegiatan penting.';
  String _downloadButton = 'Unduh Kalender PDF';
  String _contactButton = 'Hubungi Sekolah';

  List<_CalendarEvent> get _allEvents =>
      _databaseEvents.isEmpty ? _events : _databaseEvents;

  int get _currentAcademicStartYear {
    final now = DateTime.now();
    return now.month >= 7 ? now.year : now.year - 1;
  }

  int get _selectedStartYear => int.parse(_schoolYear.split('/').first);

  int get _selectedEndYear => _selectedStartYear + 1;

  List<String> get _schoolYearOptions {
    final lastStartYear = DateTime.now().year + _futureYearOffset;
    return List.generate(lastStartYear - _firstAcademicYear + 1, (index) {
      final startYear = lastStartYear - index;
      return '$startYear/${startYear + 1}';
    });
  }

  @override
  void initState() {
    super.initState();
    final startYear = _currentAcademicStartYear;
    _schoolYear = '$startYear/${startYear + 1}';
    _visibleMonth = DateTime(
      startYear,
      DateTime.now().month.clamp(7, 12).toInt(),
    );
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      final result = await Future.wait([
        const SmakApi().getTable('kalender_agenda', limit: 100),
        const SmakApi().getTable('kalender_utama', limit: 1),
      ]);
      final rows = result[0];
      final events = <_CalendarEvent>[];
      for (final row in rows) {
        final date = DateTime.tryParse('${row['tanggal'] ?? ''}');
        if (date == null) continue;
        final category = '${row['kategori'] ?? 'Akademik'}';
        final type = category == 'Ujian/Penilaian'
            ? _EventType.assessment
            : category == 'Libur Nasional'
            ? _EventType.holiday
            : category == 'Kegiatan Sekolah'
            ? _EventType.school
            : _EventType.academic;
        events.add(
          _CalendarEvent(
            date: date,
            title: '${row['judul'] ?? ''}',
            shortTitle: '${row['judul_pendek'] ?? ''}',
            location: '${row['lokasi'] ?? ''}',
            type: type,
          ),
        );
      }
      final main = result[1].isEmpty
          ? const <String, dynamic>{}
          : result[1].first;
      final data = jsonDecode('${main['data_json'] ?? '{}'}');
      final pdfUrl = data is Map ? '${data['pdf_url'] ?? ''}'.trim() : '';
      final heroImage = data is Map && data['hero'] is Map
          ? '${data['hero']['gambar'] ?? ''}'.trim()
          : '';
      String value(dynamic raw, String fallback) {
        final text = '${raw ?? ''}'.trim();
        return text.isEmpty ? fallback : text;
      }

      final hero = data is Map && data['hero'] is Map
          ? data['hero'] as Map
          : const {};
      final intro = data is Map && data['pengantar'] is Map
          ? data['pengantar'] as Map
          : const {};
      if (mounted)
        setState(() {
          if (events.isNotEmpty) _databaseEvents = events;
          _pdfUrl = pdfUrl;
          _heroImage = heroImage;
          _heroTitle = value(hero['judul'], _heroTitle);
          _heroSubtitle = value(hero['deskripsi'], _heroSubtitle);
          _introTitle = value(intro['judul'], _introTitle);
          _introSubtitle = value(intro['deskripsi'], _introSubtitle);
          _updatedAt = value(
            data is Map ? data['diperbarui'] : null,
            _updatedAt,
          );
          _information = value(
            data is Map ? data['informasi'] : null,
            _information,
          );
          _reminder = value(data is Map ? data['pengingat'] : null, _reminder);
          _downloadButton = value(data is Map ? data['teks_tombol_unduh'] : null, _downloadButton);
          _contactButton = value(data is Map ? data['teks_tombol_kontak'] : null, _contactButton);
        });
    } catch (_) {}
  }

  List<_CalendarEvent> get _visibleEvents => _allEvents.where((event) {
    if (_semester == 'Ganjil') {
      return event.date.year == _selectedStartYear && event.date.month >= 7;
    }
    return event.date.year == _selectedEndYear && event.date.month <= 6;
  }).toList();

  void _changeMonth(int offset) {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    final allowed = _semester == 'Ganjil'
        ? next.year == _selectedStartYear && next.month >= 7 && next.month <= 12
        : next.year == _selectedEndYear && next.month >= 1 && next.month <= 6;
    if (allowed) setState(() => _visibleMonth = next);
  }

  void _changeSchoolYear(String? value) {
    if (value == null) return;
    setState(() {
      _schoolYear = value;
      final startYear = int.parse(value.split('/').first);
      _visibleMonth = _semester == 'Ganjil'
          ? DateTime(startYear, 7)
          : DateTime(startYear + 1, 1);
    });
  }

  void _changeSemester(String? value) {
    if (value == null) return;
    setState(() {
      _semester = value;
      _visibleMonth = value == 'Ganjil'
          ? DateTime(_selectedStartYear, 7)
          : DateTime(_selectedEndYear, 1);
    });
  }

  void _openDownload() {
    if (_pdfUrl.isEmpty) return;
    final resolved =
        _pdfUrl.startsWith('http://') || _pdfUrl.startsWith('https://')
        ? _pdfUrl
        : const SmakApi().getFileUrl(_pdfUrl);
    html.window.open(resolved, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return _CalendarTextScope(download: _downloadButton, contact: _contactButton, child: Scaffold(
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
            _CalendarHero(
              image: _heroImage,
              title: _heroTitle,
              subtitle: _heroSubtitle,
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 42, 24, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _introTitle,
                        style: TextStyle(
                          color: _text,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _introSubtitle,
                        style: TextStyle(color: _muted, fontSize: 15),
                      ),
                      const SizedBox(height: 26),
                      _FilterBar(
                        schoolYear: _schoolYear,
                        semester: _semester,
                        monthlyView: _monthlyView,
                        schoolYearOptions: _schoolYearOptions,
                        onSchoolYearChanged: _changeSchoolYear,
                        onSemesterChanged: _changeSemester,
                        onViewChanged: (monthly) {
                          setState(() => _monthlyView = monthly);
                        },
                        onDownload: _openDownload,
                      ),
                      const SizedBox(height: 18),
                      _SummaryStrip(
                        semester: _semester,
                        academicStartYear: _selectedStartYear,
                        updatedAt: _updatedAt,
                      ),
                      const SizedBox(height: 24),
                      if (_monthlyView)
                        _CalendarArea(
                          month: _visibleMonth,
                          events: _visibleEvents,
                          onPrevious: () => _changeMonth(-1),
                          onNext: () => _changeMonth(1),
                        )
                      else
                        _AgendaListView(events: _visibleEvents),
                      const SizedBox(height: 20),
                      const _LegendCard(),
                      const SizedBox(height: 22),
                      _LowerArea(
                        events: _visibleEvents,
                        information: _information,
                        onDownload: _openDownload,
                        onContact: () => publicRootNavigator(
                          context,
                        ).pushNamed(PublicRoutes.contact),
                      ),
                      const SizedBox(height: 22),
                      _ReminderBar(text: _reminder),
                    ],
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
    ));
  }
}

class _CalendarHero extends StatelessWidget {
  const _CalendarHero({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width < 720 ? 285 : 330,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(image, fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xF2073979),
                  Color(0xC8073979),
                  Color(0x22073979),
                ],
                stops: [0, .42, 1],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 550),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Beranda   >   Akademik   >   Kalender Akademik',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.schoolYear,
    required this.schoolYearOptions,
    required this.semester,
    required this.monthlyView,
    required this.onSchoolYearChanged,
    required this.onSemesterChanged,
    required this.onViewChanged,
    required this.onDownload,
  });

  final String schoolYear;
  final List<String> schoolYearOptions;
  final String semester;
  final bool monthlyView;
  final ValueChanged<String?> onSchoolYearChanged;
  final ValueChanged<String?> onSemesterChanged;
  final ValueChanged<bool> onViewChanged;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final controls = [
          _SelectBox(
            label: 'Tahun Ajaran',
            value: schoolYear,
            items: schoolYearOptions,
            onChanged: onSchoolYearChanged,
          ),
          _SelectBox(
            label: 'Semester',
            value: semester,
            items: const ['Ganjil', 'Genap'],
            onChanged: onSemesterChanged,
          ),
          _ViewSwitch(monthly: monthlyView, onChanged: onViewChanged),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download_rounded),
              label: Text(_CalendarTextScope.of(context)?.download ?? 'Unduh Kalender PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ];
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final control in controls) ...[
                control,
                const SizedBox(height: 12),
              ],
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: controls[0]),
            const SizedBox(width: 16),
            Expanded(child: controls[1]),
            const SizedBox(width: 16),
            Expanded(child: controls[2]),
            const SizedBox(width: 28),
            controls[3],
          ],
        );
      },
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
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
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(fontSize: 11, color: _muted),
                      ),
                      Text(
                        item,
                        style: const TextStyle(
                          color: _text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ViewSwitch extends StatelessWidget {
  const _ViewSwitch({required this.monthly, required this.onChanged});

  final bool monthly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _switchButton('Bulanan', monthly, () => onChanged(true)),
          ),
          Expanded(
            child: _switchButton('Daftar', !monthly, () => onChanged(false)),
          ),
        ],
      ),
    );
  }

  Widget _switchButton(String label, bool selected, VoidCallback onTap) {
    return Material(
      color: selected ? _blue : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : _text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.semester,
    required this.academicStartYear,
    required this.updatedAt,
  });

  final String semester;
  final int academicStartYear;
  final String updatedAt;

  @override
  Widget build(BuildContext context) {
    final range = semester == 'Ganjil'
        ? 'Juli–Desember $academicStartYear'
        : 'Januari–Juni ${academicStartYear + 1}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
      decoration: BoxDecoration(
        color: _softBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 38,
        runSpacing: 14,
        alignment: WrapAlignment.spaceBetween,
        children: [
          _summary(Icons.calendar_today_rounded, 'Semester $semester'),
          _summary(Icons.date_range_rounded, range),
          _summary(Icons.history_rounded, 'Terakhir diperbarui: $updatedAt'),
        ],
      ),
    );
  }

  Widget _summary(IconData icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: _blue, size: 21),
      const SizedBox(width: 12),
      Text(
        text,
        style: const TextStyle(color: _text, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

class _CalendarArea extends StatelessWidget {
  const _CalendarArea({
    required this.month,
    required this.events,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final List<_CalendarEvent> events;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 840;
        final calendar = _MonthCalendar(
          month: month,
          events: events,
          onPrevious: onPrevious,
          onNext: onNext,
        );
        final agenda = _MonthAgenda(month: month, events: events);
        if (compact) {
          return Column(
            children: [calendar, const SizedBox(height: 18), agenda],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: calendar),
            const SizedBox(width: 18),
            Expanded(flex: 2, child: agenda),
          ],
        );
      },
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.month,
    required this.events,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final List<_CalendarEvent> events;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final startOffset = first.weekday - 1;
    final gridStart = first.subtract(Duration(days: startOffset));
    final cells = List.generate(
      42,
      (index) => gridStart.add(Duration(days: index)),
    );

    return _card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _arrow(Icons.chevron_left_rounded, onPrevious),
                Text(
                  '${_monthNames[month.month - 1]} ${month.year}',
                  style: const TextStyle(
                    color: _text,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                _arrow(Icons.chevron_right_rounded, onNext),
              ],
            ),
          ),
          Row(
            children: [
              for (final day in [
                'Sen',
                'Sel',
                'Rab',
                'Kam',
                'Jum',
                'Sab',
                'Min',
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: .82,
            ),
            itemCount: cells.length,
            itemBuilder: (context, index) {
              final date = cells[index];
              final event = _eventForDate(events, date);
              return _CalendarCell(
                date: date,
                inMonth: date.month == month.month,
                event: event,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _arrow(IconData icon, VoidCallback onPressed) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(48, 48),
      padding: EdgeInsets.zero,
      side: const BorderSide(color: _border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Icon(icon, color: _blue),
  );
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({required this.date, required this.inMonth, this.event});

  final DateTime date;
  final bool inMonth;
  final _CalendarEvent? event;

  @override
  Widget build(BuildContext context) {
    final isSunday = date.weekday == DateTime.sunday;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: event?.type.softColor ?? Colors.white,
        border: const Border(
          left: BorderSide(color: _border),
          top: BorderSide(color: _border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              color: !inMonth
                  ? const Color(0xFFB0BAC8)
                  : isSunday
                  ? Colors.red
                  : _text,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (event != null) ...[
            const Spacer(),
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: event!.type.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              event!.shortTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9, height: 1.15, color: _text),
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthAgenda extends StatelessWidget {
  const _MonthAgenda({required this.month, required this.events});

  final DateTime month;
  final List<_CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final monthEvents = events
        .where(
          (event) =>
              event.date.year == month.year && event.date.month == month.month,
        )
        .toList();
    return _card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agenda Bulan Ini',
              style: TextStyle(
                color: _text,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            if (monthEvents.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'Belum ada agenda pada bulan ini.',
                    style: TextStyle(color: _muted),
                  ),
                ),
              )
            else
              for (final event in monthEvents) _AgendaTile(event: event),
          ],
        ),
      ),
    );
  }
}

class _AgendaTile extends StatelessWidget {
  const _AgendaTile({required this.event});

  final _CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: event.type.softColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${event.date.day}',
                  style: TextStyle(
                    color: event.type.color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  _shortMonths[event.date.month - 1],
                  style: TextStyle(
                    color: event.type.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: event.type.softColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.type.label,
                    style: TextStyle(
                      color: event.type.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  event.location,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _muted),
        ],
      ),
    );
  }
}

class _AgendaListView extends StatelessWidget {
  const _AgendaListView({required this.events});

  final List<_CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Agenda Akademik',
              style: TextStyle(
                color: _text,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final event in events) _AgendaTile(event: event),
          ],
        ),
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: Wrap(
          spacing: 34,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Keterangan Kalender',
              style: TextStyle(
                color: _text,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            for (final type in _EventType.values)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: type.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(type.label, style: const TextStyle(color: _text)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LowerArea extends StatelessWidget {
  const _LowerArea({
    required this.events,
    required this.information,
    required this.onDownload,
    required this.onContact,
  });

  final List<_CalendarEvent> events;
  final String information;
  final VoidCallback onDownload;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final agenda = _ImportantAgenda(events: events);
        final info = _CalendarInformation(
          information: information,
          onDownload: onDownload,
          onContact: onContact,
        );
        if (constraints.maxWidth < 780) {
          return Column(children: [agenda, const SizedBox(height: 18), info]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: agenda),
            const SizedBox(width: 18),
            Expanded(flex: 2, child: info),
          ],
        );
      },
    );
  }
}

class _ImportantAgenda extends StatelessWidget {
  const _ImportantAgenda({required this.events});

  final List<_CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agenda Penting Semester',
              style: TextStyle(
                color: _text,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final event in events.take(6)) _AgendaTile(event: event),
          ],
        ),
      ),
    );
  }
}

class _CalendarInformation extends StatelessWidget {
  const _CalendarInformation({
    required this.information,
    required this.onDownload,
    required this.onContact,
  });

  final VoidCallback onDownload;
  final VoidCallback onContact;
  final String information;

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Informasi Kalender',
              style: TextStyle(
                color: _text,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 22),
            const Icon(
              Icons.calendar_month_rounded,
              size: 100,
              color: Color(0xFF9CC5FF),
            ),
            const SizedBox(height: 18),
            Text(information, style: TextStyle(color: _muted, height: 1.65)),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download_rounded),
              label: Text(_CalendarTextScope.of(context)?.download ?? 'Unduh Kalender PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onContact,
              icon: const Icon(Icons.phone_rounded),
              label: Text(_CalendarTextScope.of(context)?.contact ?? 'Hubungi Sekolah'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _blue,
                side: const BorderSide(color: _blue),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderBar extends StatelessWidget {
  const _ReminderBar({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
      decoration: BoxDecoration(
        color: _softBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_rounded, color: _blue),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: _blue, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _card({required Widget child}) => Container(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: _border),
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(color: Color(0x0C153A64), blurRadius: 16, offset: Offset(0, 5)),
    ],
  ),
  child: child,
);

_CalendarEvent? _eventForDate(List<_CalendarEvent> events, DateTime date) {
  for (final event in events) {
    if (event.date.year == date.year &&
        event.date.month == date.month &&
        event.date.day == date.day) {
      return event;
    }
  }
  return null;
}

enum _EventType { academic, school, assessment, holiday }

extension on _EventType {
  String get label => switch (this) {
    _EventType.academic => 'Akademik',
    _EventType.school => 'Kegiatan Sekolah',
    _EventType.assessment => 'Ujian/Penilaian',
    _EventType.holiday => 'Libur Nasional',
  };

  Color get color => switch (this) {
    _EventType.academic => const Color(0xFF1263D6),
    _EventType.school => const Color(0xFF35A25A),
    _EventType.assessment => const Color(0xFF7851B8),
    _EventType.holiday => const Color(0xFFF0A515),
  };

  Color get softColor => switch (this) {
    _EventType.academic => const Color(0xFFEAF3FF),
    _EventType.school => const Color(0xFFEAF7EC),
    _EventType.assessment => const Color(0xFFF1ECFA),
    _EventType.holiday => const Color(0xFFFFF4D8),
  };
}

class _CalendarEvent {
  const _CalendarEvent({
    required this.date,
    required this.title,
    required this.shortTitle,
    required this.location,
    required this.type,
  });

  final DateTime date;
  final String title;
  final String shortTitle;
  final String location;
  final _EventType type;
}

final _events = <_CalendarEvent>[
  _CalendarEvent(
    date: DateTime(2026, 7, 13),
    title: 'Masa Pengenalan Lingkungan Sekolah (MPLS)',
    shortTitle: 'MPLS',
    location: 'Lingkungan sekolah',
    type: _EventType.academic,
  ),
  _CalendarEvent(
    date: DateTime(2026, 8, 3),
    title: 'Awal Tahun Ajaran',
    shortTitle: 'Awal Tahun Ajaran',
    location: 'Kegiatan Sekolah',
    type: _EventType.academic,
  ),
  _CalendarEvent(
    date: DateTime(2026, 8, 8),
    title: 'Pertemuan Orang Tua',
    shortTitle: 'Pertemuan Orang Tua',
    location: 'Aula',
    type: _EventType.school,
  ),
  _CalendarEvent(
    date: DateTime(2026, 8, 17),
    title: 'Upacara Kemerdekaan',
    shortTitle: 'Hari Kemerdekaan',
    location: 'Lapangan',
    type: _EventType.holiday,
  ),
  _CalendarEvent(
    date: DateTime(2026, 8, 24),
    title: 'Penilaian Tengah Semester',
    shortTitle: 'PTS',
    location: 'Kelas',
    type: _EventType.assessment,
  ),
  _CalendarEvent(
    date: DateTime(2026, 8, 31),
    title: 'Rekoleksi Siswa',
    shortTitle: 'Rekoleksi',
    location: 'Aula',
    type: _EventType.school,
  ),
  _CalendarEvent(
    date: DateTime(2026, 9, 14),
    title: 'Penilaian Tengah Semester (PTS)',
    shortTitle: 'PTS Ganjil',
    location: 'Ruang kelas',
    type: _EventType.assessment,
  ),
  _CalendarEvent(
    date: DateTime(2026, 10, 26),
    title: 'Retret dan Rekoleksi Siswa',
    shortTitle: 'Retret',
    location: 'Rumah retret',
    type: _EventType.school,
  ),
  _CalendarEvent(
    date: DateTime(2026, 11, 10),
    title: 'Upacara Hari Pahlawan',
    shortTitle: 'Hari Pahlawan',
    location: 'Lapangan',
    type: _EventType.school,
  ),
  _CalendarEvent(
    date: DateTime(2026, 12, 7),
    title: 'Penilaian Akhir Semester (PAS)',
    shortTitle: 'PAS',
    location: 'Ruang kelas',
    type: _EventType.assessment,
  ),
  _CalendarEvent(
    date: DateTime(2026, 12, 18),
    title: 'Pembagian Rapor Semester Ganjil',
    shortTitle: 'Pembagian Rapor',
    location: 'Ruang kelas',
    type: _EventType.academic,
  ),
  _CalendarEvent(
    date: DateTime(2027, 1, 4),
    title: 'Awal Semester Genap',
    shortTitle: 'Semester Genap',
    location: 'Sekolah',
    type: _EventType.academic,
  ),
  _CalendarEvent(
    date: DateTime(2027, 2, 13),
    title: 'Kegiatan Bakti Sosial',
    shortTitle: 'Bakti Sosial',
    location: 'Masyarakat',
    type: _EventType.school,
  ),
  _CalendarEvent(
    date: DateTime(2027, 3, 8),
    title: 'Penilaian Tengah Semester Genap',
    shortTitle: 'PTS Genap',
    location: 'Ruang kelas',
    type: _EventType.assessment,
  ),
  _CalendarEvent(
    date: DateTime(2027, 4, 2),
    title: 'Libur Jumat Agung',
    shortTitle: 'Jumat Agung',
    location: 'Libur sekolah',
    type: _EventType.holiday,
  ),
  _CalendarEvent(
    date: DateTime(2027, 5, 10),
    title: 'Ujian Sekolah Kelas XII',
    shortTitle: 'Ujian Sekolah',
    location: 'Ruang kelas',
    type: _EventType.assessment,
  ),
  _CalendarEvent(
    date: DateTime(2027, 6, 14),
    title: 'Penilaian Akhir Tahun',
    shortTitle: 'PAT',
    location: 'Ruang kelas',
    type: _EventType.assessment,
  ),
];

const _monthNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const _shortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];
