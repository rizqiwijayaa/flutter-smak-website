import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../site_chrome.dart';

const _blue = Color(0xFF075ACB);
const _navy = Color(0xFF073A7A);
const _text = Color(0xFF102F65);
const _muted = Color(0xFF64748B);
const _gold = Color(0xFFF4B617);
const _green = Color(0xFF3AA35C);
const _background = Color(0xFFF5F8FC);
const _line = Color(0xFFDDE7F2);

class OsisPage extends StatefulWidget {
  const OsisPage({super.key});

  @override
  State<OsisPage> createState() => _OsisPageState();
}

class _OsisPageState extends State<OsisPage> {
  Map<String, List<Map<String, dynamic>>> _data = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    const tables = [
      'osis_hero',
      'osis_pengenalan',
      'osis_statistik',
      'osis_visi_misi',
      'osis_pengurus',
      'osis_bidang',
      'osis_program',
      'osis_agenda',
      'osis_galeri',
      'osis_kutipan',
      'osis_cta',
    ];
    try {
      final results = await Future.wait(
        tables.map((table) => const SmakApi().getTable(table, limit: 100)),
      );
      if (!mounted) return;
      setState(() {
        _data = {
          for (var index = 0; index < tables.length; index++)
            tables[index]: results[index].map(_decodeOsisRow).toList(),
        };
      });
    } catch (_) {
      // Keep the existing static content as a safe fallback when API is offline.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: _OsisDataScope(
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
              const _OsisHero(),
              const _OsisContent(),
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

class _OsisDataScope extends InheritedWidget {
  const _OsisDataScope({required this.data, required super.child});
  final Map<String, List<Map<String, dynamic>>> data;

  static List<Map<String, dynamic>> rows(BuildContext context, String table) =>
      context
          .dependOnInheritedWidgetOfExactType<_OsisDataScope>()
          ?.data[table] ??
      const [];

  @override
  bool updateShouldNotify(_OsisDataScope oldWidget) => oldWidget.data != data;
}

Map<String, dynamic> _decodeOsisRow(Map<String, dynamic> row) {
  final raw = '${row['data_json'] ?? ''}'.trim();
  Map<String, dynamic> data = {};
  if (raw.isNotEmpty) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) data = Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  for (final key in ['judul', 'deskripsi', 'gambar']) {
    if (row[key] != null) data[key] = row[key];
  }
  return data;
}

String _osisValue(
  BuildContext context,
  String table,
  int index,
  String key,
  String fallback,
) {
  final rows = _OsisDataScope.rows(context, table);
  if (index >= rows.length) return fallback;
  dynamic value = rows[index];
  for (final part in key.split('.')) {
    if (value is Map) {
      value = value[part];
    } else if (value is List) {
      final listIndex = int.tryParse(part);
      value = listIndex == null || listIndex >= value.length
          ? null
          : value[listIndex];
    } else {
      value = null;
    }
  }
  return value == null || '$value'.trim().isEmpty ? fallback : '$value';
}

ImageProvider _osisImage(String source) {
  if (source.startsWith('assets/')) return AssetImage(source);
  return NetworkImage(
    source.startsWith('http') ? source : const SmakApi().getFileUrl(source),
  );
}

class _OsisHero extends StatelessWidget {
  const _OsisHero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 720;
    return Container(
      width: double.infinity,
      height: compact ? 315 : 330,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(
            _osisValue(context, 'osis_hero', 0, 'gambar', ''),
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xF5073979),
                  Color(0xD4073979),
                  Color(0x33073979),
                ],
                stops: [0, .46, 1],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: compact ? 22 : 38),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 540,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Beranda  >  Kesiswaan  >  OSIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 18),
                          Text(
                            _osisValue(
                              context,
                              'osis_hero',
                              0,
                              'judul',
                              'Organisasi Siswa\nIntra Sekolah',
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              height: 1.12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            _osisValue(
                              context,
                              'osis_hero',
                              0,
                              'deskripsi',
                              'Wadah siswa untuk belajar memimpin, melayani, dan bertumbuh bersama.',
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              height: 1.55,
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

class _OsisContent extends StatelessWidget {
  const _OsisContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 38, 24, 52),
          child: Column(
            children: [
              const _Introduction(),
              const SizedBox(height: 24),
              const _StatsStrip(),
              const SizedBox(height: 36),
              const _VisionMission(),
              const SizedBox(height: 38),
              const _SectionTitle('Pengurus Inti OSIS'),
              const SizedBox(height: 18),
              const _MemberGrid(),
              const SizedBox(height: 38),
              const _SectionTitle('Bidang OSIS'),
              const SizedBox(height: 18),
              const _DivisionGrid(),
              const SizedBox(height: 38),
              const _ProgramsSection(),
              const SizedBox(height: 36),
              const _SectionTitle('Agenda OSIS 2026/2027'),
              const SizedBox(height: 18),
              const _AgendaTimeline(),
              const SizedBox(height: 38),
              const _SectionTitle('Dokumentasi Kegiatan'),
              const SizedBox(height: 18),
              const _DocumentationGrid(),
              const SizedBox(height: 34),
              const _StudentQuote(),
              const SizedBox(height: 34),
              const _JoinSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Introduction extends StatelessWidget {
  const _Introduction();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final description = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _osisValue(
                context,
                'osis_pengenalan',
                0,
                'judul',
                'Mengenal OSIS SMAK',
              ),
              style: const TextStyle(
                color: _text,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 14),
            Text(
              _osisValue(
                context,
                'osis_pengenalan',
                0,
                'deskripsi',
                'OSIS SMAK Mgr. Soegijapranata adalah organisasi siswa yang hangat dan kompak. Kami berkomitmen menjadi sahabat bagi seluruh siswa dan berkontribusi positif bagi sekolah dan lingkungan sekitar.',
              ),
              style: const TextStyle(color: _muted, height: 1.65, fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              _osisValue(
                context,
                'osis_pengenalan',
                0,
                'lanjutan',
                'Melalui kebersamaan, kami belajar memimpin, berkarya, dan melayani dengan hati.',
              ),
              style: const TextStyle(color: _muted, height: 1.65, fontSize: 15),
            ),
          ],
        );
        const identity = _IdentityCard();
        if (compact) {
          return Column(
            children: [description, const SizedBox(height: 22), identity],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: description),
            const SizedBox(width: 38),
            Expanded(child: identity),
          ],
        );
      },
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_blue, _navy]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A075ACB),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 112,
            height: 112,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image(
              image: _osisImage(
                _osisValue(
                  context,
                  'osis_pengenalan',
                  0,
                  'logo',
                  'assets/images/logo_sekolah.png',
                ),
              ),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.school_rounded, color: _blue, size: 64),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _osisValue(
                    context,
                    'osis_pengenalan',
                    0,
                    'nama',
                    'OSIS SMAK',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  _osisValue(
                    context,
                    'osis_pengenalan',
                    0,
                    'sekolah',
                    'Mgr. Soegijapranata',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _osisValue(
                    context,
                    'osis_pengenalan',
                    0,
                    'masa_bakti',
                    'Masa Bakti 2026/2027',
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 12),
                Divider(color: _gold, thickness: 2),
                Text(
                  _osisValue(
                    context,
                    'osis_pengenalan',
                    0,
                    'motto',
                    'Berkarya  â€¢  Melayani  â€¢  Menginspirasi',
                  ),
                  style: const TextStyle(
                    color: _gold,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (false)
                  Text(
                    'Berkarya  •  Melayani  •  Menginspirasi',
                    style: TextStyle(
                      color: _gold,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatData(
        Icons.groups_rounded,
        _osisValue(context, 'osis_statistik', 0, 'nilai', '8'),
        _osisValue(context, 'osis_statistik', 0, 'judul', 'Pengurus'),
      ),
      _StatData(
        Icons.account_tree_rounded,
        _osisValue(context, 'osis_statistik', 1, 'nilai', '4'),
        _osisValue(context, 'osis_statistik', 1, 'judul', 'Bidang'),
      ),
      _StatData(
        Icons.assignment_rounded,
        _osisValue(context, 'osis_statistik', 2, 'nilai', '6'),
        _osisValue(context, 'osis_statistik', 2, 'judul', 'Program Kerja'),
      ),
      _StatData(
        Icons.calendar_month_rounded,
        _osisValue(context, 'osis_statistik', 3, 'nilai', '1'),
        _osisValue(context, 'osis_statistik', 3, 'judul', 'Tahun Masa Bakti'),
      ),
    ];
    return _whiteCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth < 600
              ? constraints.maxWidth
              : (constraints.maxWidth - 3) / 4;
          return Wrap(
            children: [
              for (final item in items)
                SizedBox(
                  width: width,
                  child: _StatItem(data: item),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.data});
  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _roundIcon(data.icon, _blue, 52),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: const TextStyle(
                  color: _text,
                  fontSize: 23,
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
}

class _VisionMission extends StatelessWidget {
  const _VisionMission();

  @override
  Widget build(BuildContext context) {
    final pillars = [
      _PillarData(
        Icons.person_rounded,
        _osisValue(context, 'osis_visi_misi', 1, 'judul', 'Kepemimpinan'),
        _osisValue(
          context,
          'osis_visi_misi',
          1,
          'deskripsi',
          'Mengembangkan jiwa kepemimpinan serta tanggung jawab dalam diri setiap siswa.',
        ),
        _green,
      ),
      _PillarData(
        Icons.favorite_rounded,
        _osisValue(context, 'osis_visi_misi', 2, 'judul', 'Kepedulian'),
        _osisValue(
          context,
          'osis_visi_misi',
          2,
          'deskripsi',
          'Menumbuhkan kepedulian sosial dan semangat melayani kepada sesama.',
        ),
        _gold,
      ),
      _PillarData(
        Icons.handshake_rounded,
        _osisValue(context, 'osis_visi_misi', 3, 'judul', 'Kerja Sama'),
        _osisValue(
          context,
          'osis_visi_misi',
          3,
          'deskripsi',
          'Membangun kerja sama yang baik dalam setiap kegiatan OSIS.',
        ),
        _blue,
      ),
    ];
    return Column(
      children: [
        const _SectionTitle('Visi dan Misi OSIS'),
        const SizedBox(height: 18),
        _whiteCard(
          child: Padding(
            padding: EdgeInsets.all(22),
            child: Column(
              children: [
                Icon(Icons.format_quote_rounded, color: _navy, size: 34),
                Text(
                  'VISI',
                  style: TextStyle(color: _blue, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 6),
                Text(
                  _osisValue(
                    context,
                    'osis_visi_misi',
                    0,
                    'deskripsi',
                    'Menjadi OSIS yang berkarakter, peduli, dan berkontribusi positif demi terwujudnya lingkungan sekolah yang nyaman dan bermakna.',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _text, height: 1.55),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 680;
            final width = compact
                ? constraints.maxWidth
                : constraints.maxWidth / 3;
            return Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (final pillar in pillars)
                  SizedBox(
                    width: width,
                    child: _Pillar(data: pillar),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Pillar extends StatelessWidget {
  const _Pillar({required this.data});
  final _PillarData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _roundIcon(data.icon, data.color, 64),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 7),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, height: 1.5, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _MemberGrid extends StatelessWidget {
  const _MemberGrid();

  @override
  Widget build(BuildContext context) {
    final rows = _OsisDataScope.rows(context, 'osis_pengurus');
    final members = rows.isEmpty
        ? const [
            ('Ketua OSIS', 'Nama Ketua', 'Kelas XI', ''),
            ('Wakil Ketua', 'Nama Wakil', 'Kelas XI', ''),
            ('Sekretaris', 'Nama Sekretaris', 'Kelas X', ''),
            ('Bendahara', 'Nama Bendahara', 'Kelas X', ''),
            ('Koordinator Kegiatan', 'Nama Koordinator', 'Kelas XI', ''),
          ]
        : rows
              .map(
                (row) => (
                  '${row['judul'] ?? ''}',
                  '${row['nama'] ?? ''}',
                  '${row['kelas'] ?? ''}',
                  '${row['gambar'] ?? ''}',
                ),
              )
              .toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 560
            ? 2
            : constraints.maxWidth < 900
            ? 3
            : 5;
        final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (final member in members)
              SizedBox(
                width: width,
                child: _MemberCard(
                  role: member.$1,
                  name: member.$2,
                  grade: member.$3,
                  photo: member.$4,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.role,
    required this.name,
    required this.grade,
    required this.photo,
  });
  final String role;
  final String name;
  final String grade;
  final String photo;

  @override
  Widget build(BuildContext context) {
    return _whiteCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipOval(
              child: SizedBox(
                width: 76,
                height: 76,
                child: websiteContentImage(photo, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              role,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _blue,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _text,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(grade, style: const TextStyle(color: _muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _DivisionGrid extends StatelessWidget {
  const _DivisionGrid();

  @override
  Widget build(BuildContext context) {
    final divisions = [
      _DivisionData(
        Icons.church_rounded,
        _osisValue(context, 'osis_bidang', 0, 'judul', 'Kerohanian & Karakter'),
        _osisValue(
          context,
          'osis_bidang',
          0,
          'deskripsi',
          'Menguatkan nilai iman, karakter, dan kedisiplinan siswa.',
        ),
        _green,
      ),
      _DivisionData(
        Icons.lightbulb_rounded,
        _osisValue(
          context,
          'osis_bidang',
          1,
          'judul',
          'Akademik & Kreativitas',
        ),
        _osisValue(
          context,
          'osis_bidang',
          1,
          'deskripsi',
          'Mendukung kegiatan belajar dan mengembangkan kreativitas siswa.',
        ),
        Color(0xFF8B5CF6),
      ),
      _DivisionData(
        Icons.sports_basketball_rounded,
        _osisValue(
          context,
          'osis_bidang',
          2,
          'judul',
          'Olahraga & Kebersamaan',
        ),
        _osisValue(
          context,
          'osis_bidang',
          2,
          'deskripsi',
          'Mendorong gaya hidup sehat dan mempererat kebersamaan siswa.',
        ),
        Color(0xFFF59E0B),
      ),
      _DivisionData(
        Icons.eco_rounded,
        _osisValue(context, 'osis_bidang', 3, 'judul', 'Sosial & Lingkungan'),
        _osisValue(
          context,
          'osis_bidang',
          3,
          'deskripsi',
          'Menumbuhkan kepedulian sosial dan menjaga lingkungan sekolah.',
        ),
        _blue,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 620
            ? 1
            : constraints.maxWidth < 940
            ? 2
            : 4;
        final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final division in divisions)
              SizedBox(
                width: width,
                child: _DivisionCard(data: division),
              ),
          ],
        );
      },
    );
  }
}

class _DivisionCard extends StatelessWidget {
  const _DivisionCard({required this.data});
  final _DivisionData data;

  @override
  Widget build(BuildContext context) {
    return _whiteCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(data.icon, color: data.color, size: 48),
            const SizedBox(height: 12),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 7),
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, height: 1.5, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramsSection extends StatelessWidget {
  const _ProgramsSection();

  @override
  Widget build(BuildContext context) {
    final programs = [
      _ProgramData(
        Icons.diversity_3_rounded,
        _osisValue(
          context,
          'osis_program',
          0,
          'judul',
          'Masa Pengenalan Siswa',
        ),
        _osisValue(
          context,
          'osis_program',
          0,
          'deskripsi',
          'Menyambut siswa baru agar cepat beradaptasi dengan lingkungan sekolah.',
        ),
        _green,
      ),
      _ProgramData(
        Icons.calendar_month_rounded,
        _osisValue(
          context,
          'osis_program',
          1,
          'judul',
          'Perayaan Hari Besar Sekolah',
        ),
        _osisValue(
          context,
          'osis_program',
          1,
          'deskripsi',
          'Memperingati hari besar untuk menumbuhkan nilai kebersamaan dan iman.',
        ),
        Color(0xFF8B5CF6),
      ),
      _ProgramData(
        Icons.emoji_events_rounded,
        _osisValue(context, 'osis_program', 2, 'judul', 'Class Meeting'),
        _osisValue(
          context,
          'osis_program',
          2,
          'deskripsi',
          'Kegiatan olahraga dan lomba untuk menyalurkan bakat dan sportivitas.',
        ),
        Color(0xFFF59E0B),
      ),
      _ProgramData(
        Icons.volunteer_activism_rounded,
        _osisValue(context, 'osis_program', 3, 'judul', 'Bakti Sosial'),
        _osisValue(
          context,
          'osis_program',
          3,
          'deskripsi',
          'Berbagi dan melayani sebagai wujud kepedulian terhadap sesama.',
        ),
        _blue,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 800;
        final picture = _ActivityPlaceholder(
          height: compact ? 250 : 330,
          image: _osisValue(context, 'osis_program', 0, 'gambar', ''),
        );
        final list = Column(
          children: [
            for (final program in programs) _ProgramTile(data: program),
          ],
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Program Unggulan'),
            const SizedBox(height: 18),
            if (compact) ...[
              picture,
              const SizedBox(height: 18),
              list,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: picture),
                  const SizedBox(width: 28),
                  Expanded(child: list),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _ProgramTile extends StatelessWidget {
  const _ProgramTile({required this.data});
  final _ProgramData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _roundIcon(data.icon, data.color, 50),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.description,
                  style: const TextStyle(
                    color: _muted,
                    height: 1.45,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaTimeline extends StatelessWidget {
  const _AgendaTimeline();

  @override
  Widget build(BuildContext context) {
    final rows = _OsisDataScope.rows(context, 'osis_agenda');
    final fallbackItems = [
      _AgendaData(
        _osisValue(context, 'osis_agenda', 0, 'judul', 'Agustus'),
        _osisValue(
          context,
          'osis_agenda',
          0,
          'kegiatan',
          'Pelantikan\nPengurus',
        ),
        Icons.groups_rounded,
        _green,
      ),
      _AgendaData(
        _osisValue(context, 'osis_agenda', 1, 'judul', 'Desember'),
        _osisValue(context, 'osis_agenda', 1, 'kegiatan', 'Class\nMeeting'),
        Icons.emoji_events_rounded,
        Color(0xFFF59E0B),
      ),
      _AgendaData(
        _osisValue(context, 'osis_agenda', 2, 'judul', 'Februari'),
        _osisValue(context, 'osis_agenda', 2, 'kegiatan', 'Bakti\nSosial'),
        Icons.favorite_rounded,
        Color(0xFFE65050),
      ),
      _AgendaData(
        _osisValue(context, 'osis_agenda', 3, 'judul', 'Juni'),
        _osisValue(
          context,
          'osis_agenda',
          3,
          'kegiatan',
          'Evaluasi &\nRegenerasi',
        ),
        Icons.calendar_month_rounded,
        _blue,
      ),
    ];
    const icons = [
      Icons.groups_rounded,
      Icons.emoji_events_rounded,
      Icons.favorite_rounded,
      Icons.calendar_month_rounded,
    ];
    const colors = [_green, Color(0xFFF59E0B), Color(0xFFE65050), _blue];
    final items = rows.isEmpty
        ? fallbackItems
        : List.generate(
            rows.length,
            (index) => _AgendaData(
              '${rows[index]['judul'] ?? ''}',
              '${rows[index]['kegiatan'] ?? ''}',
              icons[index % icons.length],
              colors[index % colors.length],
            ),
          );
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;
        if (compact) {
          return Column(
            children: [for (final item in items) _AgendaItem(data: item)],
          );
        }
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 25,
              left: 50,
              right: 50,
              child: Container(height: 2, color: _navy),
            ),
            Row(
              children: [
                for (final item in items)
                  Expanded(child: _AgendaItem(data: item)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AgendaItem extends StatelessWidget {
  const _AgendaItem({required this.data});
  final _AgendaData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          _roundIcon(data.icon, data.color, 52),
          const SizedBox(height: 9),
          Text(
            data.month,
            style: TextStyle(color: data.color, fontWeight: FontWeight.w900),
          ),
          Text(
            data.activity,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _text, fontSize: 12, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _DocumentationGrid extends StatelessWidget {
  const _DocumentationGrid();

  @override
  Widget build(BuildContext context) {
    final rows = _OsisDataScope.rows(context, 'osis_galeri');
    final items = rows.isEmpty
        ? const [
            {'judul': 'FOTO KEGIATAN', 'gambar': ''},
            {'judul': 'FOTO KEGIATAN', 'gambar': ''},
            {'judul': 'FOTO KEGIATAN', 'gambar': ''},
          ]
        : rows;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 650 ? 1 : 3;
        final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _ActivityPlaceholder(
                  height: 190,
                  image: '${item['gambar'] ?? ''}',
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ActivityPlaceholder extends StatelessWidget {
  const _ActivityPlaceholder({required this.height, this.image = ''});
  final double height;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFBCD5F5), Color(0xFF6F91BC)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: image.trim().isEmpty || websiteUsesFallbackImage(image)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: websiteFallbackImage(
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image(
                image: _osisImage(image),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
    );
  }
}

class _StudentQuote extends StatelessWidget {
  const _StudentQuote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_blue, _navy]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final quote = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _osisValue(
                  context,
                  'osis_kutipan',
                  0,
                  'deskripsi',
                  'â€œOSIS mengajarkan saya arti tanggung jawab, kerja sama, dan pelayanan. Di sini saya belajar memimpin dengan hati dan menghadirkan perubahan kecil yang berdampak besar.â€',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.55,
                ),
              ),
              if (false)
                Text(
                  '“OSIS mengajarkan saya arti tanggung jawab, kerja sama, dan pelayanan. Di sini saya belajar memimpin dengan hati dan menghadirkan perubahan kecil yang berdampak besar.”',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.55,
                  ),
                ),
              SizedBox(height: 8),
              Text(
                _osisValue(
                  context,
                  'osis_kutipan',
                  0,
                  'penulis',
                  'â€“ Siswa SMAK',
                ),
                style: const TextStyle(
                  color: _gold,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (false)
                Text(
                  '– Siswa SMAK',
                  style: TextStyle(color: _gold, fontWeight: FontWeight.w900),
                ),
            ],
          );
          const avatar = CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 58),
          );
          if (constraints.maxWidth < 620) {
            return Column(
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  color: Colors.white,
                  size: 44,
                ),
                const SizedBox(height: 10),
                avatar,
                const SizedBox(height: 18),
                quote,
              ],
            );
          }
          return Row(
            children: [
              const Icon(
                Icons.format_quote_rounded,
                color: Colors.white,
                size: 52,
              ),
              const SizedBox(width: 20),
              avatar,
              const SizedBox(width: 24),
              Expanded(child: quote),
            ],
          );
        },
      ),
    );
  }
}

class _JoinSection extends StatelessWidget {
  const _JoinSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionTitle(
          _osisValue(
            context,
            'osis_cta',
            0,
            'judul',
            'Ingin Menjadi Bagian dari OSIS?',
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final first = _JoinStep(
              number: '1',
              title: _osisValue(
                context,
                'osis_cta',
                0,
                'langkah.0.judul',
                'Sampaikan Minat',
              ),
              description: _osisValue(
                context,
                'osis_cta',
                0,
                'langkah.0.deskripsi',
                'Tunjukkan minatmu untuk bergabung dan berkontribusi di OSIS.',
              ),
            );
            final second = _JoinStep(
              number: '2',
              title: _osisValue(
                context,
                'osis_cta',
                0,
                'langkah.1.judul',
                'Berdiskusi dengan Pembina',
              ),
              description: _osisValue(
                context,
                'osis_cta',
                0,
                'langkah.1.deskripsi',
                'Berdiskusilah dengan pembina untuk mengetahui informasi lebih lanjut.',
              ),
            );
            if (constraints.maxWidth < 650) {
              return Column(children: [first, SizedBox(height: 14), second]);
            }
            return Row(
              children: [
                Expanded(child: first),
                SizedBox(width: 16),
                Expanded(child: second),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: () => openSharedLink(
            _osisValue(
              context,
              'osis_cta',
              0,
              'kontak',
              'https://wa.me/628155099445',
            ),
          ),
          icon: const Icon(Icons.chat_rounded),
          label: Text(_osisValue(context, 'osis_cta', 0, 'teks_tombol', 'Hubungi Pembina OSIS')),
          style: FilledButton.styleFrom(
            backgroundColor: _blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _JoinStep extends StatelessWidget {
  const _JoinStep({
    required this.number,
    required this.title,
    required this.description,
  });
  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return _whiteCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              radius: 15,
              child: Text(
                number,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
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
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: _muted,
                      height: 1.45,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _text,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
  }
}

Widget _whiteCard({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0B173B65),
          blurRadius: 16,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: child,
  );
}

Widget _roundIcon(IconData icon, Color color, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Icon(icon, color: Colors.white, size: size * .5),
  );
}

class _StatData {
  const _StatData(this.icon, this.value, this.label);
  final IconData icon;
  final String value;
  final String label;
}

class _PillarData {
  const _PillarData(this.icon, this.title, this.description, this.color);
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class _DivisionData {
  const _DivisionData(this.icon, this.title, this.description, this.color);
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class _ProgramData {
  const _ProgramData(this.icon, this.title, this.description, this.color);
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class _AgendaData {
  const _AgendaData(this.month, this.activity, this.icon, this.color);
  final String month;
  final String activity;
  final IconData icon;
  final Color color;
}
