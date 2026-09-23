import 'dart:convert';

import 'package:flutter/material.dart';

// Jika file ini ditempatkan di:
// lib/landing_page/kesiswaan/ekstrakurikuler/ekstrakurikuler_page.dart
// gunakan import berikut.
import '../../site_chrome.dart';
import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';

const _blue = Color(0xFF0756C8);
const _navy = Color(0xFF083A7C);
const _text = Color(0xFF0B326B);
const _muted = Color(0xFF63748E);
const _background = Color(0xFFF5F8FD);
const _line = Color(0xFFE2EAF4);
const _gold = Color(0xFFF2B313);

class ExtracurricularData {
  const ExtracurricularData({
    required this.name,
    required this.category,
    required this.description,
    required this.schedule,
    required this.location,
    required this.mentor,
    required this.icon,
    required this.image,
  });

  final String name;
  final String category;
  final String description;
  final String schedule;
  final String location;
  final String mentor;
  final IconData icon;
  final String image;
}

class EkstrakurikulerPage extends StatefulWidget {
  const EkstrakurikulerPage({super.key});

  @override
  State<EkstrakurikulerPage> createState() => _EkstrakurikulerPageState();
}

class _EkstrakurikulerPageState extends State<EkstrakurikulerPage> {
  int _selectedIndex = 0;
  Map<String, dynamic> _data = const {};

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      final rows = await Future.wait([
        const SmakApi().getTable('ekstrakulikuler_konten', limit: 1),
        const SmakApi().getTable('ekstrakulikuler_kegiatan', limit: 100),
      ]);
      if (mounted)
        setState(
          () => _data = {
            'konten': rows[0].isEmpty
                ? const <String, dynamic>{}
                : rows[0].first,
            'kegiatan': rows[1],
          },
        );
    } catch (_) {
      /* Data bawaan tetap tampil saat API belum aktif. */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: _EkstrakulikulerScope(
        data: _data,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SharedSmakNavigationBar(
                profilePages: sharedProfilePages(),
                academicPages: sharedAcademicPages(),
                studentPages: sharedStudentPages(),
                initialActive: 'Kesiswaan',
              ),
              const _HeroSection(),
              _PageContent(
                selectedIndex: _selectedIndex,
                onSelected: (index) => setState(() => _selectedIndex = index),
              ),
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

class _EkstrakulikulerScope extends InheritedWidget {
  const _EkstrakulikulerScope({required this.data, required super.child});
  final Map<String, dynamic> data;
  static Map<String, dynamic> of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_EkstrakulikulerScope>()
          ?.data ??
      const {};
  @override
  bool updateShouldNotify(_EkstrakulikulerScope oldWidget) =>
      oldWidget.data != data;
}

String _content(BuildContext context, String key, String fallback) {
  final row = _EkstrakulikulerScope.of(context)['konten'];
  final value = row is Map ? '${row[key] ?? ''}'.trim() : '';
  return value.isEmpty ? fallback : value;
}

List<Map<String, dynamic>> _extraRows(BuildContext context, String key) {
  final row = _EkstrakulikulerScope.of(context)['konten'];
  if (row is! Map) return const [];
  try {
    final decoded = jsonDecode('${row['frontend_json'] ?? '{}'}');
    final values = decoded is Map ? decoded[key] : null;
    return values is List
        ? values
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : const [];
  } catch (_) {
    return const [];
  }
}

List<ExtracurricularData> _activityData(BuildContext context) {
  final rows =
      (_EkstrakulikulerScope.of(context)['kegiatan'] as List? ?? const [])
          .whereType<Map>()
          .toList();
  if (rows.isEmpty) return const [];
  const icons = [
    Icons.sports_basketball_rounded,
    Icons.sports_volleyball_rounded,
    Icons.music_note_rounded,
    Icons.mic_rounded,
    Icons.local_fire_department_rounded,
  ];
  return List.generate(rows.length, (index) {
    final row = rows[index];
    return ExtracurricularData(
      name: '${row['nama'] ?? ''}',
      category: '${row['kategori'] ?? ''}',
      description: '${row['deskripsi'] ?? ''}',
      schedule: '${row['jadwal'] ?? ''}',
      location: '${row['lokasi'] ?? ''}',
      mentor: '${row['pembina'] ?? ''}',
      icon: icons[index % icons.length],
      image: '${row['gambar'] ?? ''}',
    );
  });
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 720;
    return SizedBox(
      width: double.infinity,
      height: compact ? 300 : 285,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(
            _content(context, 'hero_gambar', ''),
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFA083A7C),
                  Color(0xD9083A7C),
                  Color(0x52083A7C),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Beranda  ›  Kesiswaan  ›  Ekstrakurikuler',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _content(context, 'hero_judul', 'Ekstrakurikuler'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 34 : 42,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 500,
                        child: Text(
                          _content(
                            context,
                            'hero_subjudul',
                            'Ruang untuk bertumbuh, berkarya, dan menemukan potensi terbaikmu.',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
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

class _PageContent extends StatelessWidget {
  const _PageContent({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    final activities = _activityData(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1220),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 20 : 36,
            42,
            compact ? 20 : 36,
            56,
          ),
          child: Column(
            children: [
              const _IntroSection(),
              const SizedBox(height: 48),
              const _SectionTitle('Pilihan Ekstrakurikuler'),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final count = constraints.maxWidth >= 1050
                      ? 5
                      : constraints.maxWidth >= 650
                      ? 3
                      : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: count == 1 ? 2.3 : .76,
                    ),
                    itemBuilder: (_, index) => _ActivityCard(
                      data: activities[index],
                      selected: selectedIndex == index,
                      onTap: () => onSelected(index),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              if (activities.isNotEmpty)
                _InlineDetail(
                  data:
                      activities[selectedIndex
                          .clamp(0, activities.length - 1)
                          .toInt()],
                ),
              const SizedBox(height: 48),
              const _SectionTitle('Jadwal Kegiatan Mingguan'),
              const SizedBox(height: 20),
              const _ScheduleSection(),
              const SizedBox(height: 48),
              const _SectionTitle('Pembinaan Ekstrakurikuler'),
              const SizedBox(height: 20),
              const _GuidanceSection(),
              const SizedBox(height: 48),
              const _SectionTitle('Suasana Kegiatan'),
              const SizedBox(height: 20),
              const _GallerySection(),
              const SizedBox(height: 48),
              const _SectionTitle('Pertanyaan yang Sering Diajukan'),
              const SizedBox(height: 20),
              const _FaqSection(),
              const SizedBox(height: 36),
              const _CallToAction(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _text,
          fontSize: 27,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 9),
      Container(
        width: 54,
        height: 3,
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
}

class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      final compact = c.maxWidth < 760;
      final intro = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _content(context, 'intro_judul', 'Temukan Minat dan Bakatmu'),
            style: const TextStyle(
              color: _text,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 14),
          Text(
            _content(
              context,
              'intro_teks_1',
              'Melalui kegiatan ekstrakurikuler, siswa dapat mengembangkan minat, belajar bekerja sama, berani tampil, dan bertumbuh menjadi pribadi yang berkarakter.',
            ),
            style: const TextStyle(color: _muted, height: 1.7, fontSize: 15),
          ),
          SizedBox(height: 10),
          Text(
            _content(
              context,
              'intro_teks_2',
              'Pilih kegiatan yang sesuai dengan minatmu dan nikmati prosesnya bersama teman serta pembina yang mendukung.',
            ),
            style: const TextStyle(color: _muted, height: 1.7, fontSize: 15),
          ),
        ],
      );
      final databasePoints = _extraRows(context, 'introPoints');
      final pointRows = databasePoints.isEmpty
          ? const [
              {
                'title': 'Pilihan Kegiatan',
                'desc':
                    'Beragam kegiatan yang sesuai dengan minat dan bakat siswa.',
              },
              {
                'title': 'Pembinaan Terarah',
                'desc': 'Didampingi pembina yang peduli dan berpengalaman.',
              },
              {
                'title': 'Pengembangan Karakter',
                'desc':
                    'Membentuk sikap positif, disiplin, dan bertanggung jawab.',
              },
            ]
          : databasePoints;
      final points = Column(
        children: [
          for (var index = 0; index < pointRows.length; index++) ...[
            _IntroPoint(
              const [
                Icons.groups_rounded,
                Icons.person_pin_rounded,
                Icons.verified_user_rounded,
              ][index % 3],
              '${pointRows[index]['title'] ?? ''}',
              '${pointRows[index]['desc'] ?? ''}',
            ),
            if (index != pointRows.length - 1) const SizedBox(height: 16),
          ],
        ],
      );
      if (compact) {
        return Column(children: [intro, const SizedBox(height: 28), points]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: intro),
          const SizedBox(width: 70),
          Expanded(child: points),
        ],
      );
    },
  );
}

class _IntroPoint extends StatelessWidget {
  const _IntroPoint(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 26,
        backgroundColor: const Color(0xFFEAF2FF),
        child: Icon(icon, color: _blue),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: _text,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: _muted, height: 1.4)),
          ],
        ),
      ),
    ],
  );
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.data,
    required this.selected,
    required this.onTap,
  });
  final ExtracurricularData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _blue : _line,
            width: selected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0B326B),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _Picture(path: data.image),
                  if (selected)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Sedang dilihat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.category,
                        style: const TextStyle(
                          color: Color(0xFF8A6200),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.name,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        data.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          height: 1.35,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Picture extends StatelessWidget {
  const _Picture({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
    child: _ExtracurricularImage(path: path),
  );
}

class _ExtracurricularImage extends StatelessWidget {
  const _ExtracurricularImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.trim().isEmpty || websiteUsesFallbackImage(path)) {
      return websiteFallbackImage(
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return path.startsWith('assets/')
        ? Image.asset(
            path,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => websiteFallbackImage(
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          )
        : Image.network(
            path.startsWith('http://') || path.startsWith('https://')
                ? path
                : const SmakApi().getFileUrl(path),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => websiteFallbackImage(
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          );
  }
}

class _InlineDetail extends StatelessWidget {
  const _InlineDetail({required this.data});
  final ExtracurricularData data;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      final compact = c.maxWidth < 760;
      final image = SizedBox(
        height: compact ? 250 : 390,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: _ExtracurricularImage(path: data.image),
        ),
      );
      final info = Padding(
        padding: EdgeInsets.all(compact ? 20 : 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE9A1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.category,
                    style: const TextStyle(
                      color: Color(0xFF805900),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              data.description,
              style: const TextStyle(color: _muted, fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 22),
            _DetailRow(Icons.calendar_month_rounded, 'Jadwal', data.schedule),
            _DetailRow(Icons.location_on_outlined, 'Lokasi', data.location),
            _DetailRow(Icons.person_outline_rounded, 'Pembina', data.mentor),
            const _DetailRow(
              Icons.groups_rounded,
              'Peserta',
              'Siswa kelas X–XII',
            ),
            const SizedBox(height: 14),
            const Text(
              'ⓘ  Klik pilihan ekskul lain untuk mengganti informasi ini.',
              style: TextStyle(
                color: _blue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0B326B),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: compact
            ? Column(children: [image, info])
            : Row(
                children: [
                  Expanded(child: image),
                  Expanded(child: info),
                ],
              ),
      );
    },
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _blue, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: _muted)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ScheduleSection extends StatelessWidget {
  const _ScheduleSection();

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(_navy),
        headingTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        columns: const [
          DataColumn(label: SizedBox(width: 170, child: Text('Kegiatan'))),
          DataColumn(label: SizedBox(width: 170, child: Text('Hari'))),
          DataColumn(label: SizedBox(width: 160, child: Text('Waktu'))),
          DataColumn(label: SizedBox(width: 210, child: Text('Lokasi'))),
        ],
        rows: _activityData(context).map((item) {
          final parts = item.schedule.split(',');
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Icon(item.icon, color: _blue, size: 19),
                    const SizedBox(width: 9),
                    Text(item.name),
                  ],
                ),
              ),
              DataCell(Text(parts.first)),
              DataCell(Text(parts.length > 1 ? parts.last.trim() : '-')),
              DataCell(Text(item.location)),
            ],
          );
        }).toList(),
      ),
    ),
  );
}

class _GuidanceSection extends StatelessWidget {
  const _GuidanceSection();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      final compact = c.maxWidth < 760;
      final image = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: websiteContentImage(
          _content(context, 'gambar_pembinaan', ''),
          height: 310,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
      final databaseGuidance = _extraRows(context, 'guidance');
      final guidance = databaseGuidance.isEmpty
          ? const [
              {
                'title': 'Pendampingan Pembina',
                'desc':
                    'Setiap kegiatan didampingi pembina yang siap membimbing.',
              },
              {
                'title': 'Jadwal Teratur',
                'desc':
                    'Kegiatan dilaksanakan rutin agar siswa berkembang maksimal.',
              },
              {
                'title': 'Kebersamaan',
                'desc':
                    'Belajar dan berkarya bersama untuk membangun kekompakan.',
              },
              {
                'title': 'Kesempatan Berkarya',
                'desc':
                    'Siswa memperoleh ruang untuk tampil dan mengembangkan diri.',
              },
            ]
          : databaseGuidance;
      final points = Column(
        children: [
          for (var index = 0; index < guidance.length; index++)
            _GuidancePoint(
              const [
                Icons.supervisor_account_rounded,
                Icons.event_available_rounded,
                Icons.diversity_3_rounded,
                Icons.emoji_events_rounded,
              ][index % 4],
              '${guidance[index]['title'] ?? ''}',
              '${guidance[index]['desc'] ?? ''}',
            ),
        ],
      );
      return compact
          ? Column(children: [image, const SizedBox(height: 22), points])
          : Row(
              children: [
                Expanded(child: image),
                const SizedBox(width: 34),
                Expanded(child: points),
              ],
            );
    },
  );
}

class _GuidancePoint extends StatelessWidget {
  const _GuidancePoint(this.icon, this.title, this.text);
  final IconData icon;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 11),
    child: Row(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: _navy,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(color: _muted, height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _GallerySection extends StatelessWidget {
  const _GallerySection();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      final count = c.maxWidth >= 850
          ? 4
          : c.maxWidth >= 520
          ? 2
          : 1;
      final galleryRows = _extraRows(context, 'gallery');
      final items = galleryRows.isEmpty
          ? _activityData(context)
                .take(4)
                .map((item) => {'title': item.name, 'image': item.image})
                .toList()
          : galleryRows;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.35,
        ),
        itemBuilder: (_, i) => Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _ExtracurricularImage(
                  path: '${items[i]['image'] ?? ''}',
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              '${items[i]['title'] ?? ''}',
              style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      );
    },
  );
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();
  @override
  Widget build(BuildContext context) {
    final databaseFaqs = _extraRows(context, 'faqs');
    final faqs = databaseFaqs.isEmpty
        ? const [
            {
              'question': 'Apakah siswa wajib mengikuti ekstrakurikuler?',
              'answer':
                  'Untuk sementara gunakan jawaban dummy: siswa dianjurkan mengikuti minimal satu kegiatan untuk membantu mengembangkan minat, bakat, dan karakter positif.',
            },
            {
              'question': 'Bagaimana cara memilih kegiatan?',
              'answer':
                  'Siswa dapat menyesuaikan pilihan dengan minat, jadwal, serta arahan dari wali kelas dan pembina.',
            },
            {
              'question': 'Apakah boleh berganti ekstrakurikuler?',
              'answer':
                  'Pergantian dapat dibicarakan terlebih dahulu bersama pembina dan pihak sekolah.',
            },
            {
              'question': 'Apakah ada biaya tambahan?',
              'answer':
                  'Informasi biaya menyesuaikan kebijakan masing-masing kegiatan dan dapat ditanyakan langsung kepada sekolah.',
            },
          ]
        : databaseFaqs;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          for (var index = 0; index < faqs.length; index++)
            _FaqTile(
              question: '${faqs[index]['question'] ?? ''}',
              answer: '${faqs[index]['answer'] ?? ''}',
              initiallyExpanded: index == 0,
            ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });
  final String question;
  final String answer;
  final bool initiallyExpanded;
  @override
  Widget build(BuildContext context) => ExpansionTile(
    initiallyExpanded: initiallyExpanded,
    iconColor: _blue,
    collapsedIconColor: _text,
    shape: const Border(),
    collapsedShape: const Border(),
    title: Text(
      question,
      style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: const TextStyle(color: _muted, height: 1.55),
          ),
        ),
      ),
    ],
  );
}

class _CallToAction extends StatelessWidget {
  const _CallToAction();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [_navy, _blue]),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 24,
      runSpacing: 18,
      children: [
        SizedBox(
          width: 660,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _content(
                  context,
                  'cta_judul',
                  'Ayo Temukan Kegiatan yang Kamu Sukai',
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 7),
              Text(
                _content(
                  context,
                  'cta_deskripsi',
                  'Informasi ekstrakurikuler dapat ditanyakan langsung kepada pihak sekolah.',
                ),
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => openSharedLink(
            _content(context, 'cta_link', 'https://wa.me/628155099445'),
          ),
          icon: const Icon(Icons.chat_rounded),
          label: Text(_content(context, 'cta_tombol', 'Tanya Sekolah')),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _blue,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
          ),
        ),
      ],
    ),
  );
}
