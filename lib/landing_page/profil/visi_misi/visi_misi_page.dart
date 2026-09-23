import 'package:flutter/material.dart';

import '../../akademik/jadwal_pelajaran/jadwal_pelajaran_page.dart';
import '../../akademik/kalender_akademik/kalender_akademik_page.dart';
import '../../akademik/kurikulum/kurikulum_page.dart';
import '../../akademik/prestasi_akademik/prestasi_akademik_page.dart';
import '../../kesiswaan/ekstrakurikuler/ekstrakurikuler_page.dart';
import '../../kesiswaan/osis/osis_page.dart';
import '../../kesiswaan/prestasi_siswa/prestasi_siswa_page.dart';
import '../../kesiswaan/tata_tertib/tata_tertib_page.dart';
import '../../site_chrome.dart';
import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../../routing/public_routes.dart';
import '../identitas_sekolah/identitas_sekolah_page.dart';
import '../sambutan_kepala_sekolah/sambutan_kepala_sekolah_page.dart';
import '../sarana_prasarana/sarana_prasarana_page.dart';
import '../sejarah_sekolah/sejarah_sekolah_page.dart';
import '../struktur_organisasi/struktur_organisasi_page.dart';

const _visionBlue = Color(0xFF0B57D0);
const _visionNavy = Color(0xFF0A2F66);
const _visionText = Color(0xFF123A73);
const _visionMuted = Color(0xFF5F718A);
const _visionBg = Color(0xFFF5F8FD);
const _visionLine = Color(0xFFE2EAF4);
const _visionGold = Color(0xFFE0AC21);

class VisiMisiPage extends StatelessWidget {
  const VisiMisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _visionBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SharedSmakNavigationBar(
              profilePages: {
                'identitas': const IdentitasSekolahPage(),
                'sambutan': const SambutanKepalaSekolahPage(),
                'sejarah': const SejarahSekolahPage(),
                'visi': const VisiMisiPage(),
                'struktur': const StrukturOrganisasiPage(),
                'sarana': const SaranaPrasaranaPage(),
              },
              academicPages: {
                'kurikulum': const KurikulumPage(),
                'kalender': const KalenderAkademikPage(),
                'jadwal': const JadwalPelajaranPage(),
                'prestasi': const PrestasiAkademikPage(),
              },
              studentPages: {
                'osis': const OsisPage(),
                'ekstra': const EkstrakurikulerPage(),
                'prestasi': const PrestasiSiswaPage(),
                'tata': const TataTertibPage(),
              },
              initialActive: 'Profil',
            ),
            const _VisionDatabaseContent(),
            SharedSmakFooter(
              profilePages: {
                'identitas': const IdentitasSekolahPage(),
                'sambutan': const SambutanKepalaSekolahPage(),
                'sejarah': const SejarahSekolahPage(),
                'visi': const VisiMisiPage(),
                'struktur': const StrukturOrganisasiPage(),
                'sarana': const SaranaPrasaranaPage(),
              },
              academicPages: {
                'kurikulum': const KurikulumPage(),
                'kalender': const KalenderAkademikPage(),
                'jadwal': const JadwalPelajaranPage(),
                'prestasi': const PrestasiAkademikPage(),
              },
              studentPages: {
                'osis': const OsisPage(),
                'ekstra': const EkstrakurikulerPage(),
                'prestasi': const PrestasiSiswaPage(),
                'tata': const TataTertibPage(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VisionDatabaseContent extends StatelessWidget {
  const _VisionDatabaseContent();

  @override
  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(
    future: Future.wait([
      const SmakApi().getTable('visi_utama', limit: 1),
      const SmakApi().getTable('visi_makna', limit: 20),
      const SmakApi().getTable('visi_misi', limit: 20),
      const SmakApi().getTable('visi_penerapan', limit: 20),
      const SmakApi().getTable('visi_nilai', limit: 20),
      const SmakApi().getTable('visi_tindakan', limit: 20),
      const SmakApi().getTable('visi_sasaran', limit: 20),
      const SmakApi().getTable('visi_cta', limit: 1),
    ]),
    builder: (context, snapshot) {
      List<Map<String, dynamic>> active(int index) {
        if (snapshot.data == null) return const [];
        return (snapshot.data![index] as List)
            .cast<Map<String, dynamic>>()
            .where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
            .toList();
      }

      final utama = active(0).isEmpty ? <String, dynamic>{} : active(0).first;
      final cta = active(7).isEmpty ? <String, dynamic>{} : active(7).first;

      // Keep the original visual composition. Database values only replace
      // the content; they do not replace/restructure the UI.
      return Column(
        children: [
          _VisionHero(data: utama),
          _VisionBody(
            utama: utama,
            makna: active(1),
            misi: active(2),
            penerapan: active(3),
            nilai: active(4),
            tindakan: active(5),
            sasaran: active(6),
            cta: cta,
          ),
        ],
      );
    },
  );
}

String _visionPlainText(dynamic value) {
  var text = '${value ?? ''}';
  if (text.isEmpty) return '';

  // Data edited by the admin may contain simple HTML. Flutter Text must not
  // display those tags literally.
  text = text
      .replaceAll(RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false), '\n')
      .replaceAll(
        RegExp(r'</\s*(p|div|h[1-6]|li)\s*>', caseSensitive: false),
        '\n',
      )
      .replaceAll(RegExp(r'<\s*li[^>]*>', caseSensitive: false), '• ')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');

  return text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join('\n');
}

String _visionValue(
  Map<String, dynamic> row,
  List<String> keys, [
  String fallback = '',
]) {
  for (final key in keys) {
    final value = _visionPlainText(row[key]);
    if (value.isNotEmpty) return value;
  }
  return fallback;
}

int _visionOrder(Map<String, dynamic> row, int fallback) {
  for (final key in const ['urutan', 'nomor', 'id']) {
    final parsed = int.tryParse('${row[key] ?? ''}');
    if (parsed != null) return parsed;
  }
  return fallback;
}

IconData _visionIcon(String key, IconData fallback) => switch (key.trim()) {
  'favorite' || 'favorite_border' => Icons.favorite_border_rounded,
  'book' || 'menu_book' || 'school' => Icons.menu_book_rounded,
  'groups' => Icons.groups_rounded,
  'diversity_3' => Icons.diversity_3_rounded,
  'star' || 'star_border' || 'star_outline' => Icons.star_outline_rounded,
  'light_mode' => Icons.light_mode_outlined,
  'church' => Icons.church_rounded,
  'add' => Icons.add_rounded,
  'shield' || 'verified_user' => Icons.verified_user_outlined,
  'auto_awesome' => Icons.auto_awesome_rounded,
  'volunteer_activism' => Icons.volunteer_activism_rounded,
  'public' => Icons.public_rounded,
  'schedule' => Icons.schedule_rounded,
  'workspace_premium' => Icons.workspace_premium_rounded,
  'psychology' || 'psychology_alt' => Icons.psychology_alt_rounded,
  'person' || 'person_outline' => Icons.person_outline_rounded,
  'emoji_events' => Icons.emoji_events_outlined,
  _ => fallback,
};

class _VisionDatabaseCard extends StatelessWidget {
  const _VisionDatabaseCard(this.data, {this.wide = false});
  final Map<String, dynamic> data;
  final bool wide;
  @override
  Widget build(BuildContext context) => Container(
    width: wide ? double.infinity : 270,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _visionLine),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${data['judul'] ?? ''}',
          style: const TextStyle(
            color: _visionText,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        if ('${data['deskripsi'] ?? ''}'.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${data['deskripsi']}',
            style: const TextStyle(color: _visionMuted, height: 1.5),
          ),
        ],
      ],
    ),
  );
}

class _VisionHero extends StatelessWidget {
  const _VisionHero({this.data = const {}});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    final title = _visionValue(data, const ['judul'], 'Visi & Misi');
    final description = _visionValue(data, const [
      'deskripsi',
      'subtitle',
    ], 'Arah, tujuan, dan nilai yang menuntun perjalanan pendidikan SMAK.');
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: compact ? 320 : 290),
      color: _visionNavy,
      child: Stack(
        children: [
          Positioned.fill(
            child: compact
                ? const _VisionPlaceholderImage(label: 'Foto Bangunan SMAK')
                : Row(
                    children: const [
                      Expanded(flex: 48, child: ColoredBox(color: _visionNavy)),
                      Expanded(
                        flex: 52,
                        child: _VisionPlaceholderImage(
                          label: 'Foto Bangunan SMAK',
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: compact
                      ? [
                          _visionNavy.withOpacity(.92),
                          _visionNavy.withOpacity(.78),
                          _visionNavy.withOpacity(.36),
                        ]
                      : [
                          _visionNavy,
                          _visionNavy,
                          _visionNavy.withOpacity(.7),
                          _visionNavy.withOpacity(.18),
                        ],
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 22 : 28,
                  compact ? 28 : 24,
                  compact ? 22 : 28,
                  compact ? 34 : 24,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 430,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Beranda   >   Profil   >   Visi & Misi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.7,
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

class _VisionBody extends StatelessWidget {
  const _VisionBody({
    required this.utama,
    required this.makna,
    required this.misi,
    required this.penerapan,
    required this.nilai,
    required this.tindakan,
    required this.sasaran,
    required this.cta,
  });

  final Map<String, dynamic> utama;
  final List<Map<String, dynamic>> makna;
  final List<Map<String, dynamic>> misi;
  final List<Map<String, dynamic>> penerapan;
  final List<Map<String, dynamic>> nilai;
  final List<Map<String, dynamic>> tindakan;
  final List<Map<String, dynamic>> sasaran;
  final Map<String, dynamic> cta;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1220),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Column(
            children: [
              _VisionIntroSection(utama: utama, makna: makna),
              const SizedBox(height: 28),
              _MissionSection(rows: misi),
              const SizedBox(height: 28),
              _SchoolLifeSection(rows: penerapan),
              const SizedBox(height: 28),
              _CoreValuesSection(rows: nilai),
              const SizedBox(height: 28),
              _ValueFlowSection(rows: tindakan),
              const SizedBox(height: 28),
              _EducationTargetsSection(rows: sasaran),
              const SizedBox(height: 28),
              _VisionQuoteBanner(data: utama),
              const SizedBox(height: 28),
              const _CommitmentSection(),
              const SizedBox(height: 28),
              _VisionBottomCta(data: cta),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisionIntroSection extends StatelessWidget {
  const _VisionIntroSection({required this.utama, required this.makna});

  final Map<String, dynamic> utama;
  final List<Map<String, dynamic>> makna;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _visionValue(utama, const [
            'judul_section',
            'judul_intro',
          ], 'Arah Pendidikan SMAK'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _visionText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            _visionValue(
              utama,
              const ['arah_deskripsi', 'isi', 'deskripsi_arah'],
              'Visi dan misi kami menjadi kompas yang menuntun setiap langkah pendidikan di SMAK Mgr. Soegijapranata. Berlandaskan nilai-nilai iman Katolik, kami berkomitmen membentuk generasi yang utuh dalam iman, ilmu, dan kasih, siap menghadapi masa depan serta menjadi berkat bagi sesama.',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: _visionMuted, fontSize: 14.5, height: 1.75),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF0B53C8), Color(0xFF0B3B95)],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x160F172A),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              return compact
                  ? Column(
                      children: [
                        const _VisionLogoPlaceholder(),
                        const SizedBox(height: 20),
                        _VisionStatement(data: utama),
                      ],
                    )
                  : Row(
                      children: [
                        const _VisionLogoPlaceholder(),
                        const SizedBox(width: 24),
                        Expanded(child: _VisionStatement(data: utama)),
                      ],
                    );
            },
          ),
        ),
        const SizedBox(height: 28),
        const _CenteredVisionTitle('Makna dari Visi Kami'),
        const SizedBox(height: 22),
        _VisionMeaningGrid(rows: makna),
      ],
    );
  }
}

class _VisionLogoPlaceholder extends StatelessWidget {
  const _VisionLogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFF0D49A), width: 3),
      ),
      child: const _SchoolLogo(size: 146),
    );
  }
}

class _VisionStatement extends StatelessWidget {
  const _VisionStatement({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final vision = _visionValue(
      data,
      const ['visi', 'isi_visi', 'value'],
      '“Terwujudnya generasi yang beriman, berilmu,\nberkarakter, unggul, serta mampu menjadi\nterang bagi sesama.”',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VISI',
          style: TextStyle(
            color: _visionGold,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          vision,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            height: 1.6,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _VisionMeaningGrid extends StatelessWidget {
  const _VisionMeaningGrid({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    const defaults = [
      _VisionMeaningData(
        Icons.favorite_border_rounded,
        'Beriman',
        'Berakar dalam iman Katolik dan mengandalkan Tuhan dalam setiap langkah.',
      ),
      _VisionMeaningData(
        Icons.menu_book_rounded,
        'Berilmu',
        'Menguasai ilmu pengetahuan dan teknologi untuk kebaikan hidup.',
      ),
      _VisionMeaningData(
        Icons.diversity_3_rounded,
        'Berkarakter',
        'Berpribadi luhur, jujur, disiplin, dan bertanggung jawab.',
      ),
      _VisionMeaningData(
        Icons.star_border_rounded,
        'Unggul',
        'Berprestasi dan kompeten dalam akademik maupun non-akademik.',
      ),
      _VisionMeaningData(
        Icons.light_mode_outlined,
        'Menjadi Terang',
        'Menginspirasi dan memberi manfaat bagi lingkungan dan sesama.',
      ),
    ];
    final items = rows.isEmpty
        ? defaults
        : List.generate(rows.length, (index) {
            final row = rows[index];
            final fallback = defaults[index % defaults.length];
            return _VisionMeaningData(
              _visionIcon('${row['icon'] ?? ''}', fallback.icon),
              _visionValue(row, const ['judul', 'nama', 'title']),
              _visionValue(row, const ['deskripsi', 'isi', 'subtitle']),
            );
          });

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 1000
            ? 5
            : constraints.maxWidth >= 700
            ? 3
            : 1;
        return GridView.count(
          crossAxisCount: count,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: count == 1 ? 3 : 1.08,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: items.map((item) => _VisionMeaningCard(item)).toList(),
        );
      },
    );
  }
}

class _VisionMeaningData {
  const _VisionMeaningData(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

class _VisionMeaningCard extends StatelessWidget {
  const _VisionMeaningCard(this.data);

  final _VisionMeaningData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _visionLine),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(data.icon, color: _visionBlue, size: 36),
          const SizedBox(height: 14),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _visionText,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _visionMuted,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionSection extends StatelessWidget {
  const _MissionSection({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    const defaults = [
      _MissionData(
        '01',
        'Pendidikan Berlandaskan Iman',
        'Menyelenggarakan pendidikan yang berlandaskan nilai-nilai iman Katolik untuk membentuk pribadi yang beriman, berakhlak, dan berintegritas.',
        Icons.church_rounded,
      ),
      _MissionData(
        '02',
        'Pembelajaran Berkualitas',
        'Menyediakan pembelajaran yang berkualitas, inovatif, dan relevan untuk mengembangkan kompetensi akademik dan keterampilan abad 21.',
        Icons.menu_book_rounded,
      ),
      _MissionData(
        '03',
        'Pembentukan Karakter',
        'Menanamkan nilai-nilai karakter positif seperti kejujuran, disiplin, tanggung jawab, dan kepedulian dalam kehidupan sehari-hari.',
        Icons.verified_user_outlined,
      ),
      _MissionData(
        '04',
        'Pengembangan Potensi',
        'Mengembangkan potensi dan bakat siswa melalui berbagai kegiatan akademik, ekstrakurikuler, dan pembinaan diri.',
        Icons.auto_awesome_rounded,
      ),
      _MissionData(
        '05',
        'Kepedulian Sosial',
        'Menumbuhkan kepedulian terhadap sesama dan lingkungan melalui aksi nyata dan pelayanan yang berkelanjutan.',
        Icons.volunteer_activism_rounded,
      ),
      _MissionData(
        '06',
        'Wawasan Global',
        'Membekali siswa dengan wawasan global dan spiritualitas yang kuat agar siap menjadi warga dunia yang bertanggung jawab.',
        Icons.public_rounded,
      ),
    ];
    final missions = rows.isEmpty
        ? defaults
        : List.generate(rows.length, (index) {
            final row = rows[index];
            final fallback = defaults[index % defaults.length];
            return _MissionData(
              _visionOrder(row, index + 1).toString().padLeft(2, '0'),
              _visionValue(row, const ['judul', 'nama', 'title']),
              _visionValue(row, const ['deskripsi', 'isi', 'subtitle']),
              _visionIcon('${row['icon'] ?? ''}', fallback.icon),
            );
          });

    return Column(
      children: [
        const _CenteredVisionTitle('Misi SMAK Mgr. Soegijapranata'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 980;
            if (compact) {
              return Column(
                children: [
                  for (var i = 0; i < missions.length; i++) ...[
                    _MissionCard(data: missions[i]),
                    if (i != missions.length - 1) const SizedBox(height: 14),
                  ],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _MissionCard(data: missions[0]),
                      const SizedBox(height: 14),
                      _MissionCard(data: missions[2]),
                      const SizedBox(height: 14),
                      _MissionCard(data: missions[4]),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                const _MissionConnector(),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      _MissionCard(data: missions[1]),
                      const SizedBox(height: 14),
                      _MissionCard(data: missions[3]),
                      const SizedBox(height: 14),
                      _MissionCard(data: missions[5]),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MissionData {
  const _MissionData(this.number, this.title, this.text, this.icon);

  final String number;
  final String title;
  final String text;
  final IconData icon;
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.data});

  final _MissionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _visionLine),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.number,
            style: const TextStyle(
              color: _visionBlue,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: _visionText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.text,
                  style: const TextStyle(
                    color: _visionMuted,
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(data.icon, color: _visionBlue, size: 34),
        ],
      ),
    );
  }
}

class _MissionConnector extends StatelessWidget {
  const _MissionConnector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Column(
        children: [
          const SizedBox(height: 26),
          Container(width: 2, height: 360, color: _visionBlue.withOpacity(.4)),
        ],
      ),
    );
  }
}

class _SchoolLifeSection extends StatelessWidget {
  const _SchoolLifeSection({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3F7FF), Color(0xFFEAF2FF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: compact
          ? Column(
              children: [
                const _LifeImagePlaceholder(),
                const SizedBox(height: 20),
                _LifeTextSection(rows: rows),
              ],
            )
          : Row(
              children: [
                const Expanded(flex: 4, child: _LifeImagePlaceholder()),
                const SizedBox(width: 22),
                Expanded(flex: 5, child: _LifeTextSection(rows: rows)),
              ],
            ),
    );
  }
}

class _LifeImagePlaceholder extends StatelessWidget {
  const _LifeImagePlaceholder();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: SizedBox(
      height: 280,
      width: double.infinity,
      child: websiteFallbackImage(
        fit: BoxFit.cover,
        width: double.infinity,
        height: 280,
      ),
    ),
  );
}

class _LifeTextSection extends StatelessWidget {
  const _LifeTextSection({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    const defaults = [
      _LifeData(
        'Di Dalam Kelas',
        'Pendidikan terintegrasi nilai iman, ilmu, dan karakter dalam setiap pembelajaran.',
      ),
      _LifeData(
        'Dalam Kegiatan Siswa',
        'Kegiatan ekstrakurikuler dan pembinaan untuk mengembangkan potensi diri.',
      ),
      _LifeData(
        'Dalam Pelayanan',
        'Melayani sesama melalui karya nyata dan kegiatan sosial yang bermakna.',
      ),
      _LifeData(
        'Dalam Kebersamaan',
        'Membangun komunitas sekolah yang saling menghargai dan mendukung.',
      ),
    ];
    final items = rows.isEmpty
        ? defaults
        : rows
              .map(
                (row) => _LifeData(
                  _visionValue(row, const ['judul', 'nama', 'title']),
                  _visionValue(row, const ['deskripsi', 'isi', 'subtitle']),
                ),
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visi & Misi dalam Kehidupan Sekolah',
          style: TextStyle(
            color: _visionText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        ...items.map((item) => _LifeItem(item)),
      ],
    );
  }
}

class _LifeData {
  const _LifeData(this.title, this.text);

  final String title;
  final String text;
}

class _LifeItem extends StatelessWidget {
  const _LifeItem(this.data);

  final _LifeData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: _visionBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: _visionText,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.text,
                  style: const TextStyle(
                    color: _visionMuted,
                    fontSize: 13,
                    height: 1.5,
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

class _CoreValuesSection extends StatelessWidget {
  const _CoreValuesSection({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    const defaults = [
      _CoreValueData(
        Icons.add_rounded,
        'Iman',
        'Kepercayaan yang hidup dan menjadi sumber kekuatan dalam bertindak.',
      ),
      _CoreValueData(
        Icons.verified_user_outlined,
        'Integritas',
        'Kejujuran, konsistensi, dan keteladanan dalam setiap perilaku.',
      ),
      _CoreValueData(
        Icons.schedule_rounded,
        'Disiplin',
        'Taat aturan, menghargai waktu, dan bertanggung jawab.',
      ),
      _CoreValueData(
        Icons.favorite_border_rounded,
        'Kasih',
        'Mengasihi Tuhan, sesama, dan alam ciptaan dengan tulus.',
      ),
      _CoreValueData(
        Icons.groups_rounded,
        'Tanggung Jawab',
        'Menjalankan tugas dengan sungguh-sungguh dan dapat diandalkan.',
      ),
      _CoreValueData(
        Icons.workspace_premium_rounded,
        'Keunggulan',
        'Berusaha memberikan yang terbaik dalam setiap kesempatan.',
      ),
    ];
    final items = rows.isEmpty
        ? defaults
        : List.generate(rows.length, (index) {
            final row = rows[index];
            final fallback = defaults[index % defaults.length];
            return _CoreValueData(
              _visionIcon('${row['icon'] ?? ''}', fallback.icon),
              _visionValue(row, const ['judul', 'nama', 'title']),
              _visionValue(row, const ['deskripsi', 'isi', 'subtitle']),
            );
          });

    return Column(
      children: [
        const _CenteredVisionTitle('Nilai-Nilai Utama'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 1000
                ? 3
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 1 ? 3 : 2.15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => _CoreValueCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CoreValueData {
  const _CoreValueData(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

class _CoreValueCard extends StatelessWidget {
  const _CoreValueCard(this.data);

  final _CoreValueData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _visionLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: _visionBlue, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: _visionText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.text,
                  style: const TextStyle(
                    color: _visionMuted,
                    fontSize: 12.8,
                    height: 1.5,
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

class _ValueFlowSection extends StatelessWidget {
  const _ValueFlowSection({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    const defaults = [
      _FlowValueData(
        Icons.psychology_alt_rounded,
        'Memahami',
        'Memahami nilai dan makna dalam kehidupan.',
      ),
      _FlowValueData(
        Icons.favorite_border_rounded,
        'Menghayati',
        'Menghayati nilai dan menjadikannya bagian diri.',
      ),
      _FlowValueData(
        Icons.volunteer_activism_rounded,
        'Melakukan',
        'Mengamalkan nilai dalam tindakan nyata setiap hari.',
      ),
      _FlowValueData(
        Icons.star_outline_rounded,
        'Menginspirasi',
        'Menjadi teladan dan menginspirasi orang lain.',
      ),
    ];
    final items = rows.isEmpty
        ? defaults
        : List.generate(rows.length, (index) {
            final row = rows[index];
            final fallback = defaults[index % defaults.length];
            return _FlowValueData(
              _visionIcon('${row['icon'] ?? ''}', fallback.icon),
              _visionValue(row, const ['judul', 'nama', 'title']),
              _visionValue(row, const ['deskripsi', 'isi', 'subtitle']),
            );
          });

    return Column(
      children: [
        const _CenteredVisionTitle('Dari Nilai Menjadi Tindakan'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;
            if (compact) {
              return Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    _FlowValueCard(items[i]),
                    if (i != items.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: _visionBlue,
                        ),
                      ),
                  ],
                ],
              );
            }
            return Row(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  Expanded(child: _FlowValueCard(items[i])),
                  if (i != items.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: _visionBlue,
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FlowValueData {
  const _FlowValueData(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

class _FlowValueCard extends StatelessWidget {
  const _FlowValueCard(this.data);

  final _FlowValueData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _visionLine),
      ),
      child: Column(
        children: [
          Icon(data.icon, color: _visionBlue, size: 34),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: const TextStyle(
              color: _visionText,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _visionMuted,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationTargetsSection extends StatelessWidget {
  const _EducationTargetsSection({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    const defaults = [
      _TargetData(
        Icons.person_outline_rounded,
        'Pribadi Utuh',
        'Membentuk pribadi beriman, berkarakter, sehat, dan seimbang secara intelektual, emosional, sosial, dan spiritual.',
      ),
      _TargetData(
        Icons.emoji_events_outlined,
        'Prestasi Berkelanjutan',
        'Meraih prestasi akademik dan non-akademik secara berkelanjutan dengan semangat pantang menyerah dan cinta belajar.',
      ),
      _TargetData(
        Icons.groups_rounded,
        'Kontribusi bagi Masyarakat',
        'Menjadi pribadi yang peduli, melayani, dan memberikan kontribusi positif bagi masyarakat, bangsa, dan dunia.',
      ),
    ];
    final items = rows.isEmpty
        ? defaults
        : List.generate(rows.length, (index) {
            final row = rows[index];
            final fallback = defaults[index % defaults.length];
            return _TargetData(
              _visionIcon('${row['icon'] ?? ''}', fallback.icon),
              _visionValue(row, const ['judul', 'nama', 'title']),
              _visionValue(row, const ['deskripsi', 'isi', 'subtitle']),
            );
          });

    return Column(
      children: [
        const _CenteredVisionTitle('Sasaran Pendidikan'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 900 ? 3 : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 1 ? 2.5 : 1.55,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => _TargetCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _TargetData {
  const _TargetData(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

class _TargetCard extends StatelessWidget {
  const _TargetCard(this.data);

  final _TargetData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _visionLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: _visionBlue, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: _visionText,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.text,
                  style: const TextStyle(
                    color: _visionMuted,
                    fontSize: 12.8,
                    height: 1.55,
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

class _VisionQuoteBanner extends StatelessWidget {
  const _VisionQuoteBanner({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0B53C8), Color(0xFF0B3B95)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          return compact
              ? Column(
                  children: [
                    const _VisionQuoteLogo(),
                    const SizedBox(height: 18),
                    _VisionQuoteText(data: data),
                    const SizedBox(height: 8),
                    const _VisionClosingQuote(),
                  ],
                )
              : Row(
                  children: [
                    const _VisionQuoteLogo(),
                    const SizedBox(width: 22),
                    Expanded(child: _VisionQuoteText(data: data)),
                    const SizedBox(width: 18),
                    const _VisionClosingQuote(),
                  ],
                );
        },
      ),
    );
  }
}

class _VisionQuoteLogo extends StatelessWidget {
  const _VisionQuoteLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 106,
      height: 106,
      padding: const EdgeInsets.all(9),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF4D9),
        shape: BoxShape.circle,
      ),
      child: const _SchoolLogo(size: 88),
    );
  }
}

class _VisionQuoteText extends StatelessWidget {
  const _VisionQuoteText({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Text(
      _visionValue(
        data,
        const ['quote', 'kutipan'],
        'Beriman dalam hati, berilmu dalam pikiran,\nberkarakter dalam tindakan, dan melayani dengan kasih.',
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        height: 1.55,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _VisionClosingQuote extends StatelessWidget {
  const _VisionClosingQuote();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '”',
      style: TextStyle(
        color: Color(0xFFF5D57A),
        fontSize: 58,
        height: 1,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _CommitmentSection extends StatelessWidget {
  const _CommitmentSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      _CommitmentData('Peserta Didik', [
        'Belajar sungguh-sungguh dan berdoa setiap hari.',
        'Menjadi pribadi berkarakter dan berintegritas.',
        'Aktif berkarya dan melayani sesama.',
        'Menjaga nama baik diri, sekolah, dan keluarga.',
      ]),
      _CommitmentData('Guru & Tenaga Kependidikan', [
        'Mendidik dengan hati dan keteladanan.',
        'Mengembangkan kompetensi profesional.',
        'Mendampingi perkembangan siswa secara utuh.',
        'Berkomitmen pada visi dan misi sekolah.',
      ]),
      _CommitmentData('Orang Tua & Keluarga', [
        'Mendukung pendidikan dan pembentukan karakter.',
        'Menjalin komunikasi dan kerja sama yang baik.',
        'Mendoakan dan mendampingi anak.',
        'Menjadi teladan dalam keluarga dan masyarakat.',
      ]),
    ];

    return Column(
      children: [
        const _CenteredVisionTitle('Komitmen Bersama'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 980
                ? 3
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 1 ? 2.1 : 1.1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => _CommitmentCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CommitmentData {
  const _CommitmentData(this.title, this.items);

  final String title;
  final List<String> items;
}

class _CommitmentCard extends StatelessWidget {
  const _CommitmentCard(this.data);

  final _CommitmentData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _visionLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: const TextStyle(
              color: _visionText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ...data.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _visionBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: _visionMuted,
                        fontSize: 12.8,
                        height: 1.45,
                      ),
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

class _VisionBottomCta extends StatelessWidget {
  const _VisionBottomCta({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 18 : 24,
        vertical: compact ? 18 : 20,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0B53C8), Color(0xFF0B3B95)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _VisionBottomText(data: data),
                const SizedBox(height: 18),
                _VisionBottomButtons(compact: compact, data: data),
              ],
            )
          : Row(
              children: [
                Expanded(child: _VisionBottomText(data: data)),
                const SizedBox(width: 22),
                _VisionBottomButtons(compact: compact, data: data),
              ],
            ),
    );
  }
}

class _VisionBottomText extends StatelessWidget {
  const _VisionBottomText({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final title = _visionValue(data, const [
      'judul',
      'title',
    ], 'Bersama Mewujudkan Visi SMAK');
    final description = _visionValue(
      data,
      const ['deskripsi', 'isi'],
      'Dengan iman, ilmu, dan kasih, mari kita berjalan bersama mewujudkan generasi yang unggul dan menjadi terang bagi sesama.',
    );
    return Row(
      children: [
        SizedBox(
          width: 82,
          height: 82,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFF4D9),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(7),
              child: _SchoolLogo(size: 68),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFE5EEFF),
                  fontSize: 14.5,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VisionBottomButtons extends StatelessWidget {
  const _VisionBottomButtons({required this.compact, required this.data});

  final bool compact;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    String value(String key, String fallback) {
      final text = '${data[key] ?? ''}'.trim();
      return text.isEmpty ? fallback : text;
    }
    void open(String link) {
      if (link.startsWith('/')) {
        publicRootNavigator(context).pushNamed(link);
      } else {
        openSharedLink(link);
      }
    }
    final profileButton = FilledButton(
      onPressed: () => open(value('link_tombol_1', PublicRoutes.profileIdentity)),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _visionBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        value('teks_tombol_1', 'Lihat Profil Sekolah'),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );

    final contactButton = FilledButton(
      onPressed: () => open(value('link_tombol_2', globalWhatsappUrl(context))),
      style: FilledButton.styleFrom(
        backgroundColor: _visionGold,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        value('teks_tombol_2', 'Hubungi Kami'),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );

    return SizedBox(
      width: compact ? double.infinity : 350,
      child: compact
          ? Column(
              children: [
                SizedBox(width: double.infinity, child: profileButton),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: contactButton),
              ],
            )
          : Row(
              children: [
                Expanded(child: profileButton),
                const SizedBox(width: 12),
                Expanded(child: contactButton),
              ],
            ),
    );
  }
}

class _CenteredVisionTitle extends StatelessWidget {
  const _CenteredVisionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _visionText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(
          width: 62,
          child: Divider(color: _visionGold, thickness: 3, height: 3),
        ),
      ],
    );
  }
}

class _VisionPlaceholderImage extends StatelessWidget {
  const _VisionPlaceholderImage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => websiteFallbackImage(
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );
}

class _SchoolLogo extends StatelessWidget {
  const _SchoolLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return websiteLogoImage(
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
