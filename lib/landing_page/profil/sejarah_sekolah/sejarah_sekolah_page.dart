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
import '../struktur_organisasi/struktur_organisasi_page.dart';
import '../visi_misi/visi_misi_page.dart';

const _historyBlue = Color(0xFF0B57D0);
const _historyNavy = Color(0xFF0A2F66);
const _historyText = Color(0xFF123A73);
const _historyMuted = Color(0xFF5F718A);
const _historyBg = Color(0xFFF5F8FD);
const _historyLine = Color(0xFFE2EAF4);
const _historyGold = Color(0xFFE0AC21);

class SejarahSekolahPage extends StatelessWidget {
  const SejarahSekolahPage({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder<List<dynamic>>(
    future: Future.wait([
      const SmakApi().getTable('sejarah_utama', limit: 1),
      const SmakApi().getTable('sejarah_timeline', limit: 20),
      const SmakApi().getTable('sejarah_era', limit: 20),
      const SmakApi().getTable('sejarah_nilai', limit: 20),
      const SmakApi().getTable('sejarah_galeri', limit: 20),
      const SmakApi().getTable('sejarah_tokoh', limit: 20),
      const SmakApi().getTable('sejarah_statistik', limit: 20),
      const SmakApi().getTable('sejarah_cta', limit: 1),
    ]),
    builder: (context, snapshot) {
      List<Map<String, dynamic>> rows(int index) => snapshot.data == null
          ? const []
          : (snapshot.data![index] as List).cast<Map<String, dynamic>>();
      return Scaffold(
        backgroundColor: _historyBg,
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
              _SejarahDatabaseContent(
                utama: rows(0),
                timeline: rows(1),
                era: rows(2),
                nilai: rows(3),
                galeri: rows(4),
                tokoh: rows(5),
                statistik: rows(6),
                cta: rows(7),
              ),
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
    },
  );
}

class _SejarahDatabaseContent extends StatelessWidget {
  const _SejarahDatabaseContent({
    required this.utama,
    required this.timeline,
    required this.era,
    required this.nilai,
    required this.galeri,
    required this.tokoh,
    required this.statistik,
    required this.cta,
  });

  final List<Map<String, dynamic>> utama,
      timeline,
      era,
      nilai,
      galeri,
      tokoh,
      statistik,
      cta;

  List<Map<String, dynamic>> _active(List<Map<String, dynamic>> rows) {
    final result = rows
        .where(
          (row) =>
              '${row['status'] ?? 'aktif'}'.trim().toLowerCase() != 'nonaktif',
        )
        .toList();
    result.sort(
      (a, b) => (int.tryParse('${a['urutan'] ?? 0}') ?? 0).compareTo(
        int.tryParse('${b['urutan'] ?? 0}') ?? 0,
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return _SejarahDataScope(
      utama: _active(utama),
      timeline: _active(timeline),
      era: _active(era),
      nilai: _active(nilai),
      galeri: _active(galeri),
      tokoh: _active(tokoh),
      statistik: _active(statistik),
      cta: _active(cta),
      child: const Column(children: [_HistoryHero(), _HistoryBody()]),
    );
  }
}

class _SejarahDataScope extends InheritedWidget {
  const _SejarahDataScope({
    required this.utama,
    required this.timeline,
    required this.era,
    required this.nilai,
    required this.galeri,
    required this.tokoh,
    required this.statistik,
    required this.cta,
    required super.child,
  });

  final List<Map<String, dynamic>> utama,
      timeline,
      era,
      nilai,
      galeri,
      tokoh,
      statistik,
      cta;

  static _SejarahDataScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SejarahDataScope>()!;

  @override
  bool updateShouldNotify(covariant _SejarahDataScope oldWidget) => true;
}

String _historyValue(
  Map<String, dynamic>? row,
  List<String> keys,
  String fallback,
) {
  if (row != null) {
    for (final key in keys) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
  }
  return fallback;
}

String _historyImage(Map<String, dynamic>? row) =>
    _historyValue(row, const ['gambar', 'foto', 'banner'], '');

Widget _historyDbImage(
  BuildContext context,
  String source, {
  required BoxFit fit,
  double? width,
  double? height,
}) {
  final value = source.trim();
  if (value.isEmpty) {
    return websiteFallbackImage(fit: fit, width: width, height: height);
  }
  if (value.startsWith('assets/')) {
    return Image.asset(
      value,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) =>
          websiteFallbackImage(fit: fit, width: width, height: height),
    );
  }
  return Image.network(
    const SmakApi().getFileUrl(value),
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (_, _, _) =>
        websiteFallbackImage(fit: fit, width: width, height: height),
  );
}

class _HistoryHero extends StatelessWidget {
  const _HistoryHero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    final data = _SejarahDataScope.of(context);
    final utama = data.utama.isEmpty ? null : data.utama.first;
    final title = _historyValue(utama, const ['judul'], 'Sejarah Sekolah');
    final subtitle = _historyValue(
      utama,
      const ['subtitle', 'subjudul'],
      'Menelusuri perjalanan panjang SMAK Mgr. Soegijapranata dalam membentuk generasi beriman, berilmu, dan berkarakter.',
    );
    final banner = _historyValue(utama, const ['banner'], '');
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: compact ? 320 : 290),
      color: _historyNavy,
      child: Stack(
        children: [
          Positioned.fill(
            child: compact
                ? _historyDbImage(
                    context,
                    banner,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Row(
                    children: [
                      const Expanded(
                        flex: 48,
                        child: ColoredBox(color: _historyNavy),
                      ),
                      Expanded(
                        flex: 52,
                        child: _historyDbImage(
                          context,
                          banner,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
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
                          _historyNavy.withOpacity(.92),
                          _historyNavy.withOpacity(.78),
                          _historyNavy.withOpacity(.36),
                        ]
                      : [
                          _historyNavy,
                          _historyNavy,
                          _historyNavy.withOpacity(.7),
                          _historyNavy.withOpacity(.18),
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
                    width: 470,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: 72,
                          child: Divider(
                            color: _historyGold,
                            thickness: 3,
                            height: 3,
                          ),
                        ),
                        SizedBox(height: 22),
                        Text(
                          'Beranda   >   Profil   >   Sejarah Sekolah',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          subtitle,
                          style: TextStyle(
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

class _HistoryBody extends StatelessWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1220),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Column(
            children: const [
              _HistoryIntroSection(),
              SizedBox(height: 28),
              _JourneyTimelineSection(),
              SizedBox(height: 28),
              _HistoryQuoteBanner(),
              SizedBox(height: 28),
              _EraSection(),
              SizedBox(height: 28),
              _ValuesSection(),
              SizedBox(height: 28),
              _HistoryGallerySection(),
              SizedBox(height: 28),
              _PeopleAndStatsSection(),
              SizedBox(height: 28),
              _HistoryBottomCta(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryIntroSection extends StatelessWidget {
  const _HistoryIntroSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    final data = _SejarahDataScope.of(context);
    final utama = data.utama.isEmpty ? null : data.utama.first;
    final image = _historyValue(utama, const ['gambar', 'foto'], '');
    final card = _HistoryImageCard(
      label: 'Foto Sejarah Sekolah',
      height: compact ? 240 : 290,
      source: image,
    );
    return compact
        ? Column(
            children: [
              card,
              const SizedBox(height: 18),
              const _IntroTextCard(),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: card),
              const SizedBox(width: 24),
              const Expanded(flex: 5, child: _IntroTextCard()),
            ],
          );
  }
}

class _IntroTextCard extends StatelessWidget {
  const _IntroTextCard();

  @override
  Widget build(BuildContext context) {
    final data = _SejarahDataScope.of(context);
    final utama = data.utama.isEmpty ? null : data.utama.first;
    final title = _historyValue(utama, const [
      'judul_perjalanan',
      'judul_awal',
    ], 'Perjalanan SMAK Mgr. Soegijapranata');
    final description = _historyValue(
      utama,
      const ['isi', 'deskripsi'],
      'SMAK Mgr. Soegijapranata berdiri sebagai buah dari semangat pelayanan dan cinta kasih kepada dunia pendidikan. Berakar pada nilai-nilai Kristiani dan semangat pendidikan karakter, sekolah ini hadir untuk membentuk peserta didik yang unggul dalam iman, ilmu, dan tindakan.\n\nSelama lebih dari empat dekade, SMAK terus bertumbuh, beradaptasi, dan bertransformasi mengikuti perkembangan zaman tanpa melupakan jati diri serta nilai-nilai yang menjadi pondasi sejak awal berdiri.',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _historyText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(
          width: 62,
          child: Divider(color: _historyGold, thickness: 3, height: 3),
        ),
        const SizedBox(height: 18),
        Text(
          description,
          style: const TextStyle(
            color: _historyMuted,
            fontSize: 14.5,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

class _JourneyTimelineSection extends StatelessWidget {
  const _JourneyTimelineSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    final rows = _SejarahDataScope.of(context).timeline;
    if (rows.isEmpty) return const SizedBox.shrink();

    final cards = rows
        .map(
          (row) => _TimelineCard(
            year: _historyValue(row, const ['tahun', 'periode'], ''),
            title: _historyValue(row, const ['judul', 'nama'], ''),
            text: _historyValue(row, const ['deskripsi', 'isi'], ''),
            imageSource: _historyImage(row),
          ),
        )
        .toList();

    return Column(
      children: [
        const _CenteredSectionTitle('Jejak Perjalanan Kami'),
        const SizedBox(height: 22),
        if (compact)
          Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i != cards.length - 1) const SizedBox(height: 14),
              ],
            ],
          )
        else
          _DesktopTimeline(rows: rows),
      ],
    );
  }
}

class _DesktopTimeline extends StatelessWidget {
  const _DesktopTimeline({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          Align(
            alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: .46,
              child: _TimelineCard(
                year: _historyValue(rows[i], const ['tahun', 'periode'], ''),
                title: _historyValue(rows[i], const ['judul', 'nama'], ''),
                text: _historyValue(rows[i], const ['deskripsi', 'isi'], ''),
                imageSource: _historyImage(rows[i]),
              ),
            ),
          ),
          if (i != rows.length - 1) const SizedBox(height: 18),
        ],
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.year,
    required this.title,
    required this.text,
    this.icon,
    this.imageLabel,
    this.imageSource = '',
  });

  final String year;
  final String title;
  final String text;
  final IconData? icon;
  final String? imageLabel;
  final String imageSource;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _historyLine),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.image_rounded,
              color: _historyBlue,
              size: 28,
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
                    color: _historyText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: _historyMuted,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          if (imageSource.trim().isNotEmpty || imageLabel != null) ...[
            const SizedBox(width: 14),
            _MiniPlaceholderImage(label: imageLabel ?? '', source: imageSource),
          ],
        ],
      ),
    );
  }
}

class _YearNode extends StatelessWidget {
  const _YearNode(this.year);

  final String year;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: _historyNavy,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        year,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _HistoryQuoteBanner extends StatelessWidget {
  const _HistoryQuoteBanner();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    final data = _SejarahDataScope.of(context);
    final utama = data.utama.isEmpty ? null : data.utama.first;
    final quote = _historyValue(
      utama,
      const ['kutipan', 'pendiri'],
      'Beriman menuntun hati, berilmu menerangi pikiran, berkarakter membentuk tindakan. Bersama, kita membangun masa depan yang penuh harapan.',
    );
    final source = _historyValue(utama, const [
      'sumber_kutipan',
      'lokasi_awal',
    ], 'Mgr. Soegijapranata');
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 270),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F2FF), Color(0xFFD8E9FF)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              left: 42,
              bottom: 26,
              child: _HistoryRiceOrnament(),
            ),
            const Positioned(
              right: 42,
              bottom: 26,
              child: _HistoryRiceOrnament(mirror: true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 28 : 120,
                vertical: compact ? 32 : 38,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '“',
                      style: TextStyle(
                        color: _historyGold,
                        fontSize: 62,
                        height: .65,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      quote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _historyText,
                        fontSize: 24,
                        height: 1.55,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '— $source —',
                      style: TextStyle(
                        color: _historyGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRiceOrnament extends StatelessWidget {
  const _HistoryRiceOrnament({this.mirror = false});

  final bool mirror;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 158,
      child: CustomPaint(painter: _HistoryRicePainter(mirror: mirror)),
    );
  }
}

class _HistoryRicePainter extends CustomPainter {
  const _HistoryRicePainter({required this.mirror});

  final bool mirror;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    if (mirror) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }

    final stemPaint = Paint()
      ..color = const Color(0xFF78A8E9).withOpacity(.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final stem = Path()
      ..moveTo(size.width * .72, size.height * .92)
      ..cubicTo(
        size.width * .43,
        size.height * .76,
        size.width * .31,
        size.height * .38,
        size.width * .55,
        size.height * .08,
      );
    canvas.drawPath(stem, stemPaint);

    final grainPaint = Paint()
      ..color = const Color(0xFF78A8E9).withOpacity(.34)
      ..style = PaintingStyle.fill;

    const grains = <(double, double, double, bool)>[
      (.63, .78, -.72, true),
      (.46, .70, .62, false),
      (.51, .58, -.68, true),
      (.35, .50, .60, false),
      (.43, .39, -.62, true),
      (.32, .30, .55, false),
      (.48, .20, -.55, true),
      (.43, .11, .48, false),
    ];

    for (final grain in grains) {
      final center = Offset(size.width * grain.$1, size.height * grain.$2);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(grain.$3);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: grain.$4 ? 29 : 25,
        height: 11,
      );
      canvas.drawOval(rect, grainPaint);
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HistoryRicePainter oldDelegate) {
    return oldDelegate.mirror != mirror;
  }
}

class _EraSection extends StatelessWidget {
  const _EraSection();

  @override
  Widget build(BuildContext context) {
    final rows = _SejarahDataScope.of(context).era;
    if (rows.isEmpty) return const SizedBox.shrink();
    final items = rows
        .map(
          (row) => _EraData(
            title: _historyValue(row, const ['judul', 'nama'], ''),
            bullets: _historyValue(row, const ['deskripsi', 'isi'], '')
                .split(RegExp(r'\r?\n'))
                .where((item) => item.trim().isNotEmpty)
                .toList(),
            imageSource: _historyImage(row),
          ),
        )
        .toList();

    return Column(
      children: [
        const _CenteredSectionTitle('Dari Masa ke Masa'),
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
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: count == 1 ? 2.2 : .92,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => _EraCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _EraData {
  const _EraData({
    required this.title,
    required this.bullets,
    this.imageSource = '',
  });

  final String title;
  final List<String> bullets;
  final String imageSource;
}

class _EraCard extends StatelessWidget {
  const _EraCard(this.data);

  final _EraData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _historyLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HistoryImageCard(
            label: 'Placeholder Foto Era',
            height: 150,
            source: data.imageSource,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: _historyText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ...data.bullets.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: _historyBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: _historyMuted,
                              fontSize: 13,
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
          ),
        ],
      ),
    );
  }
}

class _ValuesSection extends StatelessWidget {
  const _ValuesSection();

  @override
  Widget build(BuildContext context) {
    final rows = _SejarahDataScope.of(context).nilai;
    if (rows.isEmpty) return const SizedBox.shrink();
    final values = rows
        .map(
          (row) => _ValueData(
            _historyValue(row, const ['judul', 'nama'], ''),
            _historyValue(row, const ['deskripsi', 'isi'], ''),
            Icons.volunteer_activism_rounded,
          ),
        )
        .toList();

    return Column(
      children: [
        const _CenteredSectionTitle('Warisan dan Nilai yang Dijaga'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: count == 1 ? 2.5 : 1.1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: values.map((item) => _ValueCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ValueData {
  const _ValueData(this.title, this.text, this.icon);

  final String title;
  final String text;
  final IconData icon;
}

class _ValueCard extends StatelessWidget {
  const _ValueCard(this.data);

  final _ValueData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _historyLine),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: _historyBlue, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _historyText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _historyMuted,
              fontSize: 13.5,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryGallerySection extends StatelessWidget {
  const _HistoryGallerySection();

  @override
  Widget build(BuildContext context) {
    final rows = _SejarahDataScope.of(context).galeri;
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const _CenteredSectionTitle('Galeri Sejarah'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: count == 1 ? 1.9 : .92,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: rows
                  .map(
                    (row) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _historyLine),
                      ),
                      child: Column(
                        children: [
                          _HistoryImageCard(
                            label: 'Placeholder Foto',
                            height: 150,
                            source: _historyImage(row),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              children: [
                                Text(
                                  _historyValue(row, const [
                                    'tahun',
                                    'periode',
                                    'angka',
                                  ], ''),
                                  style: const TextStyle(
                                    color: _historyText,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _historyValue(row, const [
                                    'deskripsi',
                                    'isi',
                                    'caption',
                                  ], ''),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: _historyMuted,
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
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _PeopleAndStatsSection extends StatelessWidget {
  const _PeopleAndStatsSection();

  @override
  Widget build(BuildContext context) {
    final data = _SejarahDataScope.of(context);
    final hasPeople = data.tokoh.isNotEmpty;
    final hasStats = data.statistik.isNotEmpty;
    if (!hasPeople && !hasStats) return const SizedBox.shrink();

    final compact = MediaQuery.sizeOf(context).width < 980;
    final people = hasPeople ? const _PeopleCard() : null;
    final stats = hasStats ? const _StatsCard() : null;

    if (compact) {
      return Column(
        children: [
          if (people != null) people,
          if (people != null && stats != null) const SizedBox(height: 18),
          if (stats != null) stats,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (people != null) Expanded(flex: 5, child: people),
        if (people != null && stats != null) const SizedBox(width: 18),
        if (stats != null) Expanded(flex: 4, child: stats),
      ],
    );
  }
}

class _PeopleCard extends StatelessWidget {
  const _PeopleCard();

  @override
  Widget build(BuildContext context) {
    final rows = _SejarahDataScope.of(context).tokoh;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _historyLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tokoh dalam Perjalanan Sekolah',
            style: TextStyle(
              color: _historyText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: rows
                .map(
                  (row) => SizedBox(
                    width: 280,
                    child: _PersonMiniCard(
                      name: _historyValue(row, const ['nama', 'judul'], ''),
                      role: _historyValue(row, const ['periode', 'tahun'], ''),
                      text: _historyValue(row, const ['deskripsi', 'isi'], ''),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _PersonMiniCard extends StatelessWidget {
  const _PersonMiniCard({
    required this.name,
    required this.role,
    required this.text,
  });

  final String name;
  final String role;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: _historyLine),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: _historyBlue,
                  size: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: _historyText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: const TextStyle(
                        color: _historyMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(
              color: _historyMuted,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    final rows = _SejarahDataScope.of(context).statistik;
    final items = rows
        .map(
          (row) => _StatData(
            Icons.bar_chart_rounded,
            _historyValue(row, const ['angka', 'tahun', 'periode'], ''),
            _historyValue(row, const ['judul', 'nama', 'deskripsi', 'isi'], ''),
          ),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _historyLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SMAK Hari Ini',
            style: TextStyle(
              color: _historyText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: items.map((item) => _StatCard(item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData(this.icon, this.value, this.label);

  final IconData icon;
  final String value;
  final String label;
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.data);

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _historyLine),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(data.icon, color: _historyBlue, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: const TextStyle(
                    color: _historyBlue,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  data.label,
                  style: const TextStyle(color: _historyMuted, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryBottomCta extends StatelessWidget {
  const _HistoryBottomCta();

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
                const _BottomCtaText(),
                const SizedBox(height: 18),
                _BottomCtaButtons(compact: compact),
              ],
            )
          : Row(
              children: [
                const Expanded(child: _BottomCtaText()),
                const SizedBox(width: 22),
                _BottomCtaButtons(compact: compact),
              ],
            ),
    );
  }
}

class _BottomCtaText extends StatelessWidget {
  const _BottomCtaText();

  @override
  Widget build(BuildContext context) {
    final rows = _SejarahDataScope.of(context).cta;
    final cta = rows.isEmpty ? <String, dynamic>{} : rows.first;
    return Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: Color(0x1FFFFFFF),
          child: Icon(Icons.shield_rounded, color: Colors.white, size: 40),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${cta['judul'] ?? 'Melanjutkan Sejarah Bersama'}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${cta['deskripsi'] ?? 'Mari terus menulis sejarah baru, melahirkan generasi beriman, berilmu, dan berkarakter untuk masa depan bangsa.'}',
                style: TextStyle(
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

class _BottomCtaButtons extends StatelessWidget {
  const _BottomCtaButtons({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final rows = _SejarahDataScope.of(context).cta;
    final cta = rows.isEmpty ? <String, dynamic>{} : rows.first;
    final text1 = '${cta['teks_tombol_1'] ?? ''}'.trim().isEmpty
        ? 'Lihat Profil Sekolah'
        : '${cta['teks_tombol_1']}'.trim();
    final link1 = '${cta['link_tombol_1'] ?? ''}'.trim().isEmpty
        ? PublicRoutes.profileIdentity
        : '${cta['link_tombol_1']}'.trim();
    final text2 = '${cta['teks_tombol_2'] ?? ''}'.trim().isEmpty
        ? 'Hubungi Kami'
        : '${cta['teks_tombol_2']}'.trim();
    final link2 = '${cta['link_tombol_2'] ?? ''}'.trim().isEmpty
        ? globalWhatsappUrl(context)
        : '${cta['link_tombol_2']}'.trim();
    void open(String link) {
      if (link.startsWith('/')) {
        publicRootNavigator(context).pushNamed(link);
      } else {
        openSharedLink(link);
      }
    }
    final profileButton = FilledButton.icon(
      onPressed: () => open(link1),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
      label: Text(text1),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _historyBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final contactButton = FilledButton.icon(
      onPressed: () => open(link2),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
      label: Text(text2),
      style: FilledButton.styleFrom(
        backgroundColor: _historyGold,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return SizedBox(
      width: compact ? double.infinity : 420,
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
                const SizedBox(width: 14),
                Expanded(child: contactButton),
              ],
            ),
    );
  }
}

class _CenteredSectionTitle extends StatelessWidget {
  const _CenteredSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _historyText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(
          width: 62,
          child: Divider(color: _historyGold, thickness: 3, height: 3),
        ),
      ],
    );
  }
}

class _HistoryImageCard extends StatelessWidget {
  const _HistoryImageCard({
    required this.label,
    required this.height,
    this.source = '',
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  final String label;
  final double height;
  final String source;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: _historyDbImage(
        context,
        source,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
      ),
    ),
  );
}

class _HistoryPlaceholderImage extends StatelessWidget {
  const _HistoryPlaceholderImage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => websiteFallbackImage(
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );
}

class _MiniPlaceholderImage extends StatelessWidget {
  const _MiniPlaceholderImage({required this.label, this.source = ''});

  final String label;
  final String source;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: _historyDbImage(
      context,
      source,
      fit: BoxFit.cover,
      width: 108,
      height: 84,
    ),
  );
}
