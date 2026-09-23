import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../site_chrome.dart';

const _blue = Color(0xFF0756C8);
const _navy = Color(0xFF083A7C);
const _text = Color(0xFF0B326B);
const _muted = Color(0xFF63748E);
const _background = Color(0xFFF5F8FD);
const _line = Color(0xFFE2EAF4);
const _gold = Color(0xFFF2B313);

class PrestasiAkademikPage extends StatefulWidget {
  const PrestasiAkademikPage({super.key});

  @override
  State<PrestasiAkademikPage> createState() => _PrestasiAkademikPageState();
}

class _PrestasiAkademikPageState extends State<PrestasiAkademikPage> {
  Map<String, dynamic> _data = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await Future.wait([
        const SmakApi().getTable('akademik_hero', limit: 10),
        const SmakApi().getTable('akademik_prestasi', limit: 100),
        const SmakApi().getTable('akademik_bidang_prestasi', limit: 50),
        const SmakApi().getTable('akademik_pembinaan_prestasi', limit: 50),
      ]);
      final hero = rows[0]
          .where((row) => '${row['bagian']}' == 'hero')
          .toList();
      if (!mounted) return;
      setState(
        () => _data = {
          'hero': hero.isEmpty ? const <String, dynamic>{} : hero.first,
          'prestasi': rows[1]
              .where((row) => '${row['peserta'] ?? ''}'.trim().isNotEmpty)
              .toList(),
          'bidang': rows[2]
              .where((row) => '${row['deskripsi'] ?? ''}'.trim().isNotEmpty)
              .toList(),
          'pembinaan': rows[3]
              .where((row) => '${row['deskripsi'] ?? ''}'.trim().isNotEmpty)
              .toList(),
        },
      );
    } catch (_) {
      // UI bawaan tetap dipakai jika API belum bisa dijangkau.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: _AcademicDataScope(
        data: _data,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SharedSmakNavigationBar(
                profilePages: sharedProfilePages(),
                academicPages: sharedAcademicPages(),
                studentPages: sharedStudentPages(),
                initialActive: 'Akademik',
              ),
              const _AchievementHero(),
              const _AchievementContent(),
              SharedSmakFooter(
                profilePages: sharedProfilePages(),
                academicPages: sharedAcademicPages(),
                studentPages: sharedStudentPages(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AcademicDataScope extends InheritedWidget {
  const _AcademicDataScope({required this.data, required super.child});
  final Map<String, dynamic> data;

  static Map<String, dynamic> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AcademicDataScope>()?.data ??
      const {};

  @override
  bool updateShouldNotify(_AcademicDataScope oldWidget) =>
      oldWidget.data != data;
}

String _academicText(BuildContext context, String key, String fallback) {
  final value = _AcademicDataScope.of(context)['hero'];
  final text = value is Map ? '${value[key] ?? ''}'.trim() : '';
  return text.isEmpty ? fallback : text;
}

List<Map<String, dynamic>> _academicRows(BuildContext context, String key) =>
    (_AcademicDataScope.of(context)[key] as List? ?? const [])
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();

class _AchievementHero extends StatelessWidget {
  const _AchievementHero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return SizedBox(
      width: double.infinity,
      height: compact ? 310 : 285,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(
            _academicText(context, 'gambar', ''),
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xF20A438F),
                  Color(0xD90A438F),
                  Color(0x8A062D64),
                ],
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 24 : 48),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 630,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beranda  ›  Akademik  ›  Prestasi Akademik',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          _academicText(context, 'judul', 'Prestasi Akademik'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          _academicText(
                            context,
                            'subjudul',
                            'Mengukir prestasi melalui semangat belajar, disiplin, dan kerja keras.',
                          ),
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

class _AchievementContent extends StatelessWidget {
  const _AchievementContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1220),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 42, 22, 42),
          child: const Column(
            children: [
              _IntroSection(),
              SizedBox(height: 38),
              _FeaturedSection(),
              SizedBox(height: 44),
              _RecentSection(),
              SizedBox(height: 44),
              _FieldsSection(),
              SizedBox(height: 44),
              _MentoringSection(),
              SizedBox(height: 34),
              _StudentQuote(),
              SizedBox(height: 44),
              _JourneySection(),
              SizedBox(height: 38),
              _BottomCta(),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) {
    const stats = [
      _StatData(Icons.emoji_events_rounded, '24', 'Prestasi', _gold),
      _StatData(
        Icons.workspace_premium_rounded,
        '8',
        'Tingkat Nasional',
        _blue,
      ),
      _StatData(Icons.star_rounded, '12', 'Tingkat Provinsi', _gold),
      _StatData(Icons.account_balance_rounded, '4', 'Tingkat Kabupaten', _blue),
    ];
    return Column(
      children: [
        _SectionHeading(
          title: _academicText(
            context,
            'intro_judul',
            'Prestasi yang Membanggakan',
          ),
          subtitle: _academicText(
            context,
            'intro_deskripsi',
            'Berbagai capaian akademik menjadi bukti semangat belajar, dedikasi siswa, dan pendampingan guru.',
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 900
                ? 4
                : constraints.maxWidth >= 520
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 1 ? 3.2 : 2.2,
              children: stats.map((item) => _StatCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _text,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 9),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, fontSize: 14, height: 1.6),
          ),
        ),
      ],
    ],
  );
}

class _StatData {
  const _StatData(this.icon, this.value, this.label, this.color);
  final IconData icon;
  final String value;
  final String label;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.data);
  final _StatData data;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    decoration: _whiteCard(),
    child: Row(
      children: [
        Icon(data.icon, size: 44, color: data.color),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.value,
              style: const TextStyle(
                color: _text,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              data.label,
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeading(title: _academicText(context, 'judul_unggulan', 'Prestasi Unggulan')),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 820;
            final main = const _AchievementCard(
              title: 'Juara Debat Bahasa Indonesia',
              level: 'TINGKAT NASIONAL',
              person: 'Tim Debat SMAK Lumajang',
              event: 'Kompetisi Debat Bahasa Indonesia Tingkat Nasional',
              date: '2026',
              height: 360,
              featured: true,
            );
            final side = const Column(
              children: [
                _AchievementCard(
                  title: 'Olimpiade Sains',
                  level: 'TINGKAT NASIONAL',
                  person: 'Tim OSN SMAK Lumajang',
                  event: 'Olimpiade Sains Nasional',
                  date: '2026',
                  height: 172,
                ),
                SizedBox(height: 16),
                _AchievementCard(
                  title: 'Lomba Karya Tulis Ilmiah',
                  level: 'TINGKAT PROVINSI',
                  person: 'Tim KTI SMAK Lumajang',
                  event: 'LKTI Pelajar Jawa Timur',
                  date: '2026',
                  height: 172,
                ),
              ],
            );
            if (compact) {
              return Column(children: [main, const SizedBox(height: 16), side]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: main),
                SizedBox(width: 16),
                Expanded(flex: 4, child: side),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.title,
    required this.level,
    required this.person,
    required this.event,
    required this.date,
    required this.height,
    this.featured = false,
  });
  final String title;
  final String level;
  final String person;
  final String event;
  final String date;
  final double height;
  final bool featured;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: _whiteCard(),
    clipBehavior: Clip.antiAlias,
    child: featured
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PhotoArea(label: level)),
              _AchievementInfo(
                title: title,
                person: person,
                event: event,
                date: date,
              ),
            ],
          )
        : Row(
            children: [
              Expanded(flex: 4, child: _PhotoArea(label: level)),
              Expanded(
                flex: 6,
                child: _AchievementInfo(
                  title: title,
                  person: person,
                  event: event,
                  date: date,
                ),
              ),
            ],
          ),
  );
}

class _PhotoArea extends StatelessWidget {
  const _PhotoArea({
    required this.label,
    this.icon = Icons.emoji_events_rounded,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDCEAFF), Color(0xFFF4F8FF)],
          ),
        ),
      ),
      Icon(icon, color: _blue, size: 58),
      Positioned(
        top: 12,
        left: 12,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    ],
  );
}

class _AchievementInfo extends StatelessWidget {
  const _AchievementInfo({
    required this.title,
    required this.person,
    required this.event,
    required this.date,
  });
  final String title;
  final String person;
  final String event;
  final String date;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _text,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 9),
        _MetaLine(Icons.groups_outlined, person),
        const SizedBox(height: 5),
        _MetaLine(Icons.emoji_events_outlined, event),
        const SizedBox(height: 5),
        _MetaLine(Icons.calendar_month_outlined, date),
      ],
    ),
  );
}

class _MetaLine extends StatelessWidget {
  const _MetaLine(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: _blue, size: 14),
      const SizedBox(width: 7),
      Expanded(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _muted, fontSize: 11.5),
        ),
      ),
    ],
  );
}

class _RecentSection extends StatefulWidget {
  const _RecentSection();

  @override
  State<_RecentSection> createState() => _RecentSectionState();
}

class _RecentSectionState extends State<_RecentSection> {
  String _selectedYear = 'Semua';

  @override
  Widget build(BuildContext context) {
    final databaseItems = _academicRows(context, 'prestasi');
    final items = databaseItems.isEmpty
        ? const [
            (
              'Juara I Debat Bahasa Indonesia',
              'Tim Debat SMAK',
              'TINGKAT NASIONAL',
              '20 April 2026',
            ),
            (
              'Medali Perak Olimpiade Matematika',
              'Andreas Wijaya',
              'TINGKAT NASIONAL',
              '15 Maret 2025',
            ),
            (
              'Juara II Karya Tulis Ilmiah',
              'Tim KTI SMAK',
              'TINGKAT PROVINSI',
              '10 Februari 2024',
            ),
            (
              'Finalis Olimpiade Biologi',
              'Clara Angelina',
              'TINGKAT PROVINSI',
              '5 Februari 2025',
            ),
            (
              'Juara III Cerdas Cermat',
              'Tim Cerdas Cermat',
              'TINGKAT KABUPATEN',
              '28 Januari 2024',
            ),
            (
              'Best Presentation',
              'Gabriel Santoso',
              'TINGKAT NASIONAL',
              '18 Januari 2026',
            ),
          ]
        : databaseItems
              .map(
                (item) => (
                  '${item['judul'] ?? ''}',
                  '${item['peserta'] ?? ''}',
                  'TINGKAT ${item['tingkat'] ?? ''}',
                  '${item['tanggal'] ?? ''}',
                ),
              )
              .toList();
    const filters = ['Semua', '2026', '2025', '2024'];
    final visibleItems = _selectedYear == 'Semua'
        ? items
        : items.where((item) => item.$4.endsWith(_selectedYear)).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF5FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _SectionHeading(title: _academicText(context, 'judul_terbaru', 'Capaian Prestasi Terbaru')),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: filters
                .map(
                  (year) => _FilterChip(
                    year,
                    active: _selectedYear == year,
                    onTap: () => setState(() => _selectedYear = year),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 580
                  ? 2
                  : 1;
              return GridView.count(
                crossAxisCount: count,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: count == 1 ? 1.35 : .94,
                children: visibleItems
                    .map(
                      (item) => _RecentCard(
                        title: item.$1,
                        person: item.$2,
                        level: item.$3,
                        date: item.$4,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.label, {this.active = false, this.onTap});
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(999),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
      decoration: BoxDecoration(
        color: active ? _blue : Colors.white,
        border: Border.all(color: active ? _blue : _line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : _text,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({
    required this.title,
    required this.person,
    required this.level,
    required this.date,
  });
  final String title;
  final String person;
  final String level;
  final String date;

  @override
  Widget build(BuildContext context) => Container(
    decoration: _whiteCard(),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _PhotoArea(label: level)),
        _AchievementInfo(
          title: title,
          person: person,
          event: 'Kompetisi Akademik SMA',
          date: date,
        ),
      ],
    ),
  );
}

class _FieldsSection extends StatelessWidget {
  const _FieldsSection();

  @override
  Widget build(BuildContext context) {
    final databaseFields = _academicRows(context, 'bidang');
    final fields = databaseFields.isEmpty
        ? const [
            (
              Icons.science_outlined,
              'Sains & Matematika',
              'Olimpiade, penelitian, dan kompetisi sains.',
            ),
            (
              Icons.menu_book_rounded,
              'Bahasa & Literasi',
              'Debat, karya tulis, pidato, dan literasi.',
            ),
            (
              Icons.computer_rounded,
              'Teknologi & Inovasi',
              'Robotika, coding, dan inovasi digital.',
            ),
            (
              Icons.palette_outlined,
              'Seni & Kreativitas',
              'Seni rupa, musik, dan kreativitas siswa.',
            ),
          ]
        : databaseFields
              .asMap()
              .entries
              .map(
                (entry) => (
                  const [
                    Icons.science_outlined,
                    Icons.menu_book_rounded,
                    Icons.computer_rounded,
                    Icons.palette_outlined,
                  ][entry.key % 4],
                  '${entry.value['judul'] ?? ''}',
                  '${entry.value['deskripsi'] ?? ''}',
                ),
              )
              .toList();
    return Column(
      children: [
        _SectionHeading(title: _academicText(context, 'judul_bidang', 'Bidang Prestasi')),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 850
                ? 4
                : constraints.maxWidth >= 520
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 1 ? 2.4 : 1.25,
              children: fields
                  .map(
                    (item) => _FieldCard(
                      icon: item.$1,
                      title: item.$2,
                      text: item.$3,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.icon,
    required this.title,
    required this.text,
  });
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: _whiteCard(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: _blue, size: 45),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, fontSize: 12, height: 1.5),
        ),
      ],
    ),
  );
}

class _MentoringSection extends StatelessWidget {
  const _MentoringSection();

  @override
  Widget build(BuildContext context) {
    const text = _MentoringText();
    const photo = _MentoringPhoto();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 760) {
            return Column(children: [photo, text]);
          }
          return Row(
            children: [
              Expanded(flex: 5, child: photo),
              Expanded(flex: 6, child: text),
            ],
          );
        },
      ),
    );
  }
}

class _MentoringPhoto extends StatelessWidget {
  const _MentoringPhoto();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 390,
    width: double.infinity,
    child: websiteContentImage(
      _academicText(context, 'pembinaan_gambar', ''),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 390,
    ),
  );
}

class _MentoringText extends StatelessWidget {
  const _MentoringText();

  @override
  Widget build(BuildContext context) {
    final databaseItems = _academicRows(context, 'pembinaan');
    final items = databaseItems.isEmpty
        ? const [
            (
              'Pendampingan Guru',
              'Guru pembimbing mendampingi siswa secara intensif.',
            ),
            (
              'Program Latihan',
              'Jadwal latihan rutin dan terstruktur sesuai bidang lomba.',
            ),
            (
              'Evaluasi Berkala',
              'Monitoring untuk meningkatkan kualitas dan hasil.',
            ),
            (
              'Dukungan Sekolah',
              'Fasilitas dan dukungan moral untuk setiap peserta.',
            ),
          ]
        : databaseItems
              .map(
                (item) =>
                    ('${item['judul'] ?? ''}', '${item['deskripsi'] ?? ''}'),
              )
              .toList();
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _academicText(
              context,
              'pembinaan_judul',
              'Pembinaan Prestasi Berkelanjutan',
            ),
            style: TextStyle(
              color: _text,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _academicText(
              context,
              'pembinaan_deskripsi',
              'Prestasi lahir dari proses yang terarah, dukungan yang konsisten, dan keberanian untuk terus belajar.',
            ),
            style: TextStyle(color: _muted, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 20),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _blue,
                    size: 20,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$1,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.$2,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 12.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentQuote extends StatelessWidget {
  const _StudentQuote();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF083A7C), Color(0xFF0861D3)],
      ),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        ClipOval(
          child: SizedBox(
            width: 84,
            height: 84,
            child: websiteContentImage(
              _academicText(context, 'kutipan_foto', ''),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _academicText(
                  context,
                  'kutipan',
                  '“Belajar dengan sungguh-sungguh, disiplin, dan tidak mudah menyerah adalah kunci untuk meraih prestasi.”',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${_academicText(context, 'kutipan_nama', 'Clara Angelina')} • ${_academicText(context, 'kutipan_kelas', 'XI IPA 2')}',
                style: const TextStyle(
                  color: Color(0xFFFFD65A),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _JourneySection extends StatelessWidget {
  const _JourneySection();

  @override
  Widget build(BuildContext context) {
    const data = [
      ('2023', '15'),
      ('2024', '18'),
      ('2025', '21'),
      ('2026', '24'),
    ];
    return Column(
      children: [
        _SectionHeading(title: _academicText(context, 'judul_perjalanan', 'Perjalanan Prestasi')),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 650;
            if (compact) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => _MobileJourneyPoint(
                      year: data[index].$1,
                      total: data[index].$2,
                      showLine: index != data.length - 1,
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 118,
              child: Stack(
                children: [
                  Positioned(
                    left: constraints.maxWidth / 8,
                    right: constraints.maxWidth / 8,
                    top: 56,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB9D4FA),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Row(
                    children: data
                        .map(
                          (item) => Expanded(
                            child: _JourneyPoint(year: item.$1, total: item.$2),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _JourneyPoint extends StatelessWidget {
  const _JourneyPoint({required this.year, required this.total});
  final String year;
  final String total;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        year,
        style: const TextStyle(
          color: _blue,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 17),
      Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: _blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [BoxShadow(color: Color(0x330756C8), blurRadius: 8)],
        ),
      ),
      const SizedBox(height: 15),
      Text(
        '$total Prestasi',
        style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
      ),
    ],
  );
}

class _MobileJourneyPoint extends StatelessWidget {
  const _MobileJourneyPoint({
    required this.year,
    required this.total,
    required this.showLine,
  });

  final String year;
  final String total;
  final bool showLine;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 26,
        child: Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: _blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
            ),
            if (showLine)
              Container(width: 3, height: 52, color: const Color(0xFFB9D4FA)),
          ],
        ),
      ),
      const SizedBox(width: 14),
      Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: const TextStyle(
                color: _blue,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$total Prestasi',
              style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    ],
  );
}

class _BottomCta extends StatelessWidget {
  const _BottomCta();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    final buttons = Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        OutlinedButton(
          onPressed: () => openSharedLink(
            _academicText(
              context,
              'cta_whatsapp',
              'https://wa.me/628155099445',
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
          ),
          child: Text(_academicText(context, 'cta_teks_tombol', 'Hubungi Sekolah')),
        ),
      ],
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0756C8), Color(0xFF083A7C)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: compact
          ? Column(
              children: [const _CtaText(), const SizedBox(height: 18), buttons],
            )
          : Row(
              children: [
                const Expanded(child: _CtaText()),
                const SizedBox(width: 24),
                buttons,
              ],
            ),
    );
  }
}

class _CtaText extends StatelessWidget {
  const _CtaText();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      websiteLogoImage(
        width: 74,
        height: 74,
      ),
      const SizedBox(width: 18),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _academicText(context, 'cta_judul', 'Bersama Meraih Prestasi'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              _academicText(
                context,
                'cta_deskripsi',
                'Mari terus belajar, menginspirasi, dan membawa nama baik SMAK.',
              ),
              style: const TextStyle(color: Color(0xFFE4EEFF), height: 1.5),
            ),
          ],
        ),
      ),
    ],
  );
}

BoxDecoration _whiteCard() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _line),
  boxShadow: const [
    BoxShadow(color: Color(0x0D0B326B), blurRadius: 16, offset: Offset(0, 6)),
  ],
);
