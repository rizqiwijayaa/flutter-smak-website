import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../services/smak_api.dart';
import '../../services/website_identity.dart';
import '../../routing/public_routes.dart';
import '../site_chrome.dart';

const _ppdbBlue = Color(0xFF0C4FB4);
const _ppdbNavy = Color(0xFF0A2E63);
const _ppdbText = Color(0xFF0D2B5C);
const _ppdbMuted = Color(0xFF5E6F86);
const _ppdbBg = Color(0xFFF4F8FD);
const _ppdbLine = Color(0xFFE3EBF5);
const _ppdbGold = Color(0xFFC58B00);

String _ppdbFileUrl(String value) {
  final path = value.trim();
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  return const SmakApi().getFileUrl(path);
}

String _ppdbRegistrationUrl(BuildContext context) {
  final main = _PpdbDataScope.of(context)['_utama'];
  return main is Map ? '${main['link_pendaftaran'] ?? ''}'.trim() : '';
}

class PpdbPage extends StatefulWidget {
  const PpdbPage({super.key});

  @override
  State<PpdbPage> createState() => _PpdbPageState();
}

class _PpdbPageState extends State<PpdbPage> {
  Map<String, dynamic> _data = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await const SmakApi().getTable('ppdb', limit: 1);
      if (rows.isEmpty) return;
      final raw = '${rows.first['frontend_data'] ?? ''}'.trim();
      final decoded = raw.isEmpty ? null : jsonDecode(raw);
      if (decoded is Map && mounted) {
        setState(
          () => _data = {
            ...Map<String, dynamic>.from(decoded),
            '_utama': rows.first,
          },
        );
      }
    } catch (_) {
      // Saat API belum tersedia, halaman tetap menampilkan data bawaan UI.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ppdbBg,
      body: _PpdbDataScope(
        data: _data,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              SharedSmakNavigationBar(
                profilePages: {},
                academicPages: {},
                studentPages: {},
                initialActive: 'PPDB',
              ),
              _PpdbHero(),
              _PpdbBody(),
              SharedSmakFooter(
                profilePages: {},
                academicPages: {},
                studentPages: {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PpdbDataScope extends InheritedWidget {
  const _PpdbDataScope({required this.data, required super.child});
  final Map<String, dynamic> data;

  static Map<String, dynamic> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PpdbDataScope>()?.data ??
      const {};

  @override
  bool updateShouldNotify(_PpdbDataScope oldWidget) => oldWidget.data != data;
}

String _ppdbValue(BuildContext context, String path, String fallback) {
  dynamic value = _PpdbDataScope.of(context);
  for (final part in path.split('.')) {
    if (value is Map)
      value = value[part];
    else
      return fallback;
  }
  final text = '${value ?? ''}'.trim();
  return text.isEmpty ? fallback : text;
}

List<Map<String, dynamic>> _ppdbRows(
  BuildContext context,
  String key,
  List<Map<String, dynamic>> fallback,
) {
  final source = _PpdbDataScope.of(context)[key];
  if (source is! List || source.isEmpty) return fallback;
  return source
      .whereType<Map>()
      .map((row) => Map<String, dynamic>.from(row))
      .toList();
}

List<Widget> _requirementGroups(BuildContext context) {
  final rows = _ppdbRows(context, 'persyaratan', const [
    {'kategori': 'Dokumen Pribadi', 'judul': 'Fotokopi Kartu Keluarga'},
    {'kategori': 'Dokumen Pribadi', 'judul': 'Fotokopi Akta Kelahiran'},
    {
      'kategori': 'Dokumen Pribadi',
      'judul': 'Pas Foto berwarna 3x4 (2 lembar)',
    },
    {'kategori': 'Dokumen Akademik', 'judul': 'Fotokopi Rapor Semester 1 - 5'},
    {
      'kategori': 'Dokumen Akademik',
      'judul': 'Fotokopi ijazah/SKL (jika sudah ada)',
    },
    {
      'kategori': 'Dokumen Pendukung',
      'judul': 'Sertifikat prestasi (jika ada)',
    },
    {
      'kategori': 'Dokumen Pendukung',
      'judul': 'Surat Keterangan Kelakuan Baik dari Sekolah Asal',
    },
  ]);
  final groups = <String, List<String>>{};
  for (final row in rows) {
    final category = '${row['kategori'] ?? 'Persyaratan'}';
    final title = '${row['judul'] ?? ''}'.trim();
    if (title.isNotEmpty) (groups[category] ??= []).add(title);
  }
  return [
    for (final entry in groups.entries) ...[
      _RequirementGroup(title: entry.key, items: entry.value),
      const SizedBox(height: 18),
    ],
  ];
}

class _PpdbHero extends StatelessWidget {
  const _PpdbHero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: compact ? 500 : 340),
      color: _ppdbNavy,
      child: Stack(
        children: [
          Positioned.fill(
            child: compact
                ? websiteContentImage(
                    _ppdbValue(context, 'hero.gambar', ''),
                    fit: BoxFit.cover,
                  )
                : Row(
                    children: [
                      const Expanded(
                        flex: 38,
                        child: ColoredBox(color: _ppdbNavy),
                      ),
                      Expanded(
                        flex: 62,
                        child: websiteContentImage(
                          _ppdbValue(context, 'hero.gambar', ''),
                          fit: BoxFit.cover,
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
                  stops: compact ? const [0, .62, 1] : const [0, .36, .58, 1],
                  colors: compact
                      ? [
                          _ppdbNavy.withOpacity(.9),
                          _ppdbNavy.withOpacity(.68),
                          _ppdbNavy.withOpacity(.38),
                        ]
                      : [
                          _ppdbNavy,
                          _ppdbNavy,
                          _ppdbNavy.withOpacity(.68),
                          _ppdbNavy.withOpacity(.16),
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
                  compact ? 20 : 24,
                  compact ? 28 : 24,
                  compact ? 20 : 24,
                  compact ? 34 : 24,
                ),
                child: compact
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PpdbHeroText(),
                          SizedBox(height: 24),
                          _PpdbHeroActions(),
                        ],
                      )
                    : const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: _PpdbHeroText()),
                          SizedBox(width: 54),
                          SizedBox(width: 320, child: _PpdbHeroActions()),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PpdbHeroText extends StatelessWidget {
  const _PpdbHeroText();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF2C79E6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _ppdbValue(context, 'hero.label', 'PPDB 2026/2027'),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          _ppdbValue(context, 'hero.judul', 'Penerimaan Peserta Didik Baru'),
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 33 : 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Beranda   >   PPDB',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          _ppdbValue(
            context,
            'hero.deskripsi',
            'Bersama SMAK, tumbuh menjadi pribadi beriman,\nberkarakter, dan berprestasi.',
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.65,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PpdbHeroActions extends StatelessWidget {
  const _PpdbHeroActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                _ppdbValue(context, 'hero.status', 'PENDAFTARAN DIBUKA'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _ppdbRegistrationUrl(context).isEmpty
                ? null
                : () =>
                      html.window.open(_ppdbRegistrationUrl(context), '_blank'),
            icon: const Icon(Icons.app_registration_rounded),
            label: Text(_ppdbValue(context, 'teks_bagian.tombol.daftar', 'Daftar Sekarang')),
            style: FilledButton.styleFrom(
              backgroundColor: _ppdbBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => openSharedLink(
              _ppdbValue(
                context,
                '_utama.whatsapp',
                'https://wa.me/628155099445',
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: Text(_ppdbValue(context, 'teks_bagian.tombol.konsultasi', 'Konsultasi WhatsApp')),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFB5C6DB)),
              padding: const EdgeInsets.symmetric(vertical: 17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PpdbBody extends StatelessWidget {
  const _PpdbBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth < 700 ? 16.0 : 28.0;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Padding(
              padding: EdgeInsets.fromLTRB(horizontal, 32, horizontal, 40),
              child: const Column(
                children: [
                  _PpdbTopOverview(),
                  SizedBox(height: 28),
                  _PpdbLearningSection(),
                  SizedBox(height: 28),
                  _PpdbFlowSection(),
                  SizedBox(height: 28),
                  _PpdbDocumentsSection(),
                  SizedBox(height: 28),
                  _PpdbScheduleSection(),
                  SizedBox(height: 28),
                  _PpdbFinanceSection(),
                  SizedBox(height: 28),
                  _PpdbFacilitiesSection(),
                  SizedBox(height: 28),
                  _PpdbTestimonialsSection(),
                  SizedBox(height: 28),
                  _PpdbFaqSection(),
                  SizedBox(height: 28),
                  _PpdbBottomCta(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PpdbTopOverview extends StatelessWidget {
  const _PpdbTopOverview();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 1120;
    return compact
        ? const Column(
            children: [
              _WhyChooseSection(),
              SizedBox(height: 18),
              _PpdbInfoCard(),
            ],
          )
        : const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _WhyChooseSection()),
              SizedBox(width: 18),
              Expanded(flex: 3, child: _PpdbInfoCard()),
            ],
          );
  }
}

class _WhyChooseSection extends StatelessWidget {
  const _WhyChooseSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _ppdbValue(
            context,
            'teks_bagian.mengapa_memilih.judul',
            'Mengapa Memilih SMAK?',
          ),
          style: TextStyle(
            color: _ppdbText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _ppdbValue(
            context,
            'teks_bagian.mengapa_memilih.deskripsi',
            'Lingkungan pendidikan yang mendampingi perkembangan akademik dan karakter putra-putri Anda.',
          ),
          style: TextStyle(color: _ppdbMuted, fontSize: 15, height: 1.55),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 840
                ? 4
                : constraints.maxWidth >= 440
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: columns == 1
                  ? 3.1
                  : columns == 2
                  ? 2.3
                  : 1.52,
              children:
                  _ppdbRows(context, 'mengapa_memilih', const [
                        {
                          'judul': 'Akreditasi A',
                          'deskripsi': 'Terakreditasi BAN-S/M',
                        },
                        {
                          'judul': 'Pembelajaran Berkualitas',
                          'deskripsi': 'Pembelajaran aktif dan terarah',
                        },
                        {
                          'judul': 'Pembentukan Karakter',
                          'deskripsi':
                              'Beriman, disiplin, dan bertanggung jawab',
                        },
                        {
                          'judul': 'Lingkungan Nyaman',
                          'deskripsi': 'Aman, suportif, dan kekeluargaan',
                        },
                      ])
                      .asMap()
                      .entries
                      .map(
                        (entry) => _WhyChooseCard(
                          icon: const [
                            Icons.workspace_premium_rounded,
                            Icons.school_rounded,
                            Icons.groups_rounded,
                            Icons.home_work_rounded,
                          ][entry.key % 4],
                          title: '${entry.value['judul'] ?? ''}',
                          subtitle: '${entry.value['deskripsi'] ?? ''}',
                          accent: entry.key == 0
                              ? const Color(0xFFF6B600)
                              : _ppdbBlue,
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

class _WhyChooseCard extends StatelessWidget {
  const _WhyChooseCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return _PpdbPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accent.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accent, size: 27),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                    color: _ppdbText,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ppdbMuted,
                    fontSize: 12.5,
                    height: 1.45,
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

class _PpdbInfoCard extends StatelessWidget {
  const _PpdbInfoCard();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 1120;
    final items = [
      _PpdbInfoMini(
        icon: Icons.calendar_month_rounded,
        title: _ppdbValue(context, 'ringkasan.gelombang', 'Gelombang 1'),
        value: _ppdbValue(
          context,
          'ringkasan.periode',
          '1 Mei -\n30 Juni 2026',
        ),
      ),
      _PpdbInfoMini(
        icon: Icons.groups_rounded,
        title: 'Kuota',
        value: _ppdbValue(context, 'ringkasan.kuota', '120 Siswa'),
      ),
      _PpdbInfoMini(
        icon: Icons.apartment_rounded,
        title: 'Jenjang',
        value: _ppdbValue(context, 'ringkasan.jenjang', 'SMA'),
      ),
      _PpdbInfoMini(
        icon: Icons.call_rounded,
        title: 'Kontak PPDB',
        value: _ppdbValue(context, 'ringkasan.kontak', '(0334) 890123'),
      ),
    ];

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(
              context,
              'ringkasan.judul',
              'PPDB Tahun Ajaran 2026/2027',
            ),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          if (compact) ...[
            Row(
              children: [
                Expanded(child: items[0]),
                Expanded(child: items[1]),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: items[2]),
                Expanded(child: items[3]),
              ],
            ),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final item in items) Expanded(child: item)],
            ),
        ],
      ),
    );
  }
}

class _PpdbInfoMini extends StatelessWidget {
  const _PpdbInfoMini({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: _ppdbLine)),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _ppdbBlue, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: _ppdbText,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ppdbMuted,
              fontSize: 11.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PpdbLearningSection extends StatelessWidget {
  const _PpdbLearningSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return _PpdbPanel(
      child: compact
          ? const Column(
              children: [
                _PpdbLearningImage(),
                SizedBox(height: 18),
                _PpdbLearningTextCard(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                    child: _PpdbLearningImage(height: 300),
                  ),
                ),
                SizedBox(width: 22),
                Expanded(flex: 5, child: _PpdbLearningTextCard()),
              ],
            ),
    );
  }
}

class _PpdbLearningImage extends StatelessWidget {
  const _PpdbLearningImage({this.height = 250});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: websiteContentImage(
        _ppdbValue(context, 'teks_bagian.lingkungan_belajar.gambar', ''),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _PpdbLearningTextCard extends StatelessWidget {
  const _PpdbLearningTextCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _ppdbValue(
            context,
            'teks_bagian.lingkungan_belajar.judul',
            'Mengenal Lingkungan Belajar SMAK',
          ),
          style: TextStyle(
            color: _ppdbText,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _ppdbValue(
            context,
            'teks_bagian.lingkungan_belajar.deskripsi',
            'SMAK menghadirkan lingkungan belajar yang aman, inspiratif, dan mendukung setiap siswa untuk berkembang secara utuh.',
          ),
          style: TextStyle(color: _ppdbMuted, fontSize: 14.5, height: 1.65),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final oneColumn = constraints.maxWidth < 520;
            return GridView.count(
              crossAxisCount: oneColumn ? 1 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 12,
              childAspectRatio: oneColumn ? 4.2 : 3.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children:
                  _ppdbRows(context, 'lingkungan_belajar', const [
                        {
                          'judul': 'Pendampingan Personal',
                          'deskripsi':
                              'Guru pembimbing mendampingi perkembangan akademik dan karakter.',
                        },
                        {
                          'judul': 'Fasilitas Pendukung',
                          'deskripsi':
                              'Fasilitas lengkap untuk menunjang proses belajar mengajar.',
                        },
                        {
                          'judul': 'Kegiatan Beragam',
                          'deskripsi':
                              'Program ekstrakurikuler dan kegiatan rohani yang membentuk pribadi unggul.',
                        },
                        {
                          'judul': 'Komunitas Beriman',
                          'deskripsi':
                              'Dibentuk dalam nilai kebersamaan, iman Katolik, dan pelayanan.',
                        },
                      ])
                      .asMap()
                      .entries
                      .map(
                        (entry) => _PpdbMiniInfo(
                          icon: const [
                            Icons.person_search_rounded,
                            Icons.apartment_rounded,
                            Icons.celebration_rounded,
                            Icons.favorite_rounded,
                          ][entry.key % 4],
                          title: '${entry.value['judul'] ?? ''}',
                          text: '${entry.value['deskripsi'] ?? ''}',
                        ),
                      )
                      .toList(),
            );
          },
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: () => publicRootNavigator(
            context,
          ).pushNamed(PublicRoutes.profileIdentity),
          style: FilledButton.styleFrom(
            backgroundColor: _ppdbBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _ppdbValue(context, 'teks_bagian.tombol.profil', 'Lihat Profil Sekolah'),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _PpdbMiniInfo extends StatelessWidget {
  const _PpdbMiniInfo({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF2FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _ppdbBlue, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ppdbText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: const TextStyle(
                  color: _ppdbMuted,
                  fontSize: 12.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PpdbFlowSection extends StatelessWidget {
  const _PpdbFlowSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 860;
    final steps =
        _ppdbRows(context, 'alur_pendaftaran', const [
              {
                'judul': 'Isi Formulir',
                'deskripsi':
                    'Isi formulir pendaftaran secara online dengan data yang benar.',
              },
              {
                'judul': 'Unggah Berkas',
                'deskripsi':
                    'Unggah dokumen persyaratan dalam format yang ditentukan.',
              },
              {
                'judul': 'Verifikasi',
                'deskripsi':
                    'Panitia memverifikasi dokumen dan menghubungi jika ada kekurangan.',
              },
              {
                'judul': 'Tes & Wawancara',
                'deskripsi':
                    'Mengikuti tes akademik dan wawancara sesuai jadwal.',
              },
              {
                'judul': 'Daftar Ulang',
                'deskripsi':
                    'Calon peserta yang diterima melakukan daftar ulang.',
              },
            ])
            .asMap()
            .entries
            .map(
              (entry) => _FlowStep(
                number: '${entry.key + 1}'.padLeft(2, '0'),
                icon: const [
                  Icons.description_outlined,
                  Icons.upload_file_rounded,
                  Icons.verified_user_outlined,
                  Icons.groups_rounded,
                  Icons.task_alt_rounded,
                ][entry.key % 5],
                title: '${entry.value['judul'] ?? ''}',
                text: '${entry.value['deskripsi'] ?? ''}',
              ),
            )
            .toList();
    /*
      _FlowStep(
        number: '01',
        icon: Icons.description_outlined,
        title: 'Isi Formulir',
        text: 'Isi formulir pendaftaran secara online dengan data yang benar.',
      ),
      _FlowStep(
        number: '02',
        icon: Icons.upload_file_rounded,
        title: 'Unggah Berkas',
        text: 'Unggah dokumen persyaratan dalam format yang ditentukan.',
      ),
      _FlowStep(
        number: '03',
        icon: Icons.verified_user_outlined,
        title: 'Verifikasi',
        text:
            'Panitia memverifikasi dokumen dan menghubungi jika ada kekurangan.',
      ),
      _FlowStep(
        number: '04',
        icon: Icons.groups_rounded,
        title: 'Tes & Wawancara',
        text: 'Mengikuti tes akademik dan wawancara sesuai jadwal.',
      ),
      _FlowStep(
        number: '05',
        icon: Icons.task_alt_rounded,
        title: 'Daftar Ulang',
        text: 'Calon peserta yang diterima melakukan daftar ulang.',
      ),
    ];*/

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.alur', 'Alur Pendaftaran'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 22),
          compact
              ? GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 18,
                  childAspectRatio: .9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: steps,
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      Expanded(child: steps[i]),
                      if (i != steps.length - 1)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              height: 2,
                              color: const Color(0xFF2B67D7),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
        ],
      ),
    );
  }
}

class _FlowStep extends StatelessWidget {
  const _FlowStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.text,
  });

  final String number;
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: _ppdbBlue,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F5FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _ppdbBlue, size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _ppdbText, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _ppdbMuted, fontSize: 12, height: 1.45),
        ),
      ],
    );
  }
}

class _PpdbDocumentsSection extends StatelessWidget {
  const _PpdbDocumentsSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 1020;
    return compact
        ? const Column(
            children: [
              _PpdbRequirementsFullCard(),
              SizedBox(height: 18),
              _PpdbDownloadCard(),
            ],
          )
        : const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PpdbRequirementsFullCard()),
              SizedBox(width: 18),
              Expanded(child: _PpdbDownloadCard()),
            ],
          );
  }
}

class _PpdbRequirementsFullCard extends StatelessWidget {
  const _PpdbRequirementsFullCard();

  @override
  Widget build(BuildContext context) {
    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.persyaratan', 'Persyaratan Pendaftaran'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 18),
          ..._requirementGroups(context),
        ],
      ),
    );
  }
}

class _RequirementGroup extends StatelessWidget {
  const _RequirementGroup({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _ppdbBlue,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: _ppdbBlue,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(color: _ppdbText, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PpdbDownloadCard extends StatelessWidget {
  const _PpdbDownloadCard();

  @override
  Widget build(BuildContext context) {
    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.dokumen', 'Dokumen yang Dapat Diunduh'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 18),
          ..._ppdbRows(context, 'dokumen_unduhan', const [
            {
              'judul': 'Brosur PPDB 2026/2027',
              'deskripsi': 'Informasi lengkap mengenai PPDB SMAK',
            },
            {
              'judul': 'Formulir Pendaftaran',
              'deskripsi': 'Formulir pendaftaran peserta didik baru',
            },
            {
              'judul': 'Panduan Pendaftaran',
              'deskripsi': 'Panduan lengkap demi langkah pendaftaran',
            },
          ]).asMap().entries.expand(
            (entry) => [
              _DownloadItem(
                icon: const [
                  Icons.picture_as_pdf_rounded,
                  Icons.description_rounded,
                  Icons.menu_book_rounded,
                ][entry.key % 3],
                iconColor: const [
                  Color(0xFFE54B4B),
                  Color(0xFF39A862),
                  _ppdbBlue,
                ][entry.key % 3],
                title: '${entry.value['judul'] ?? ''}',
                subtitle: '${entry.value['deskripsi'] ?? ''}',
                fileUrl: '${entry.value['file_url'] ?? ''}',
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class _DownloadItem extends StatelessWidget {
  const _DownloadItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.fileUrl,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: _ppdbLine),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ppdbText,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: _ppdbMuted, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: fileUrl.trim().isEmpty
                ? null
                : () => html.window.open(_ppdbFileUrl(fileUrl), '_blank'),
            icon: const Icon(Icons.download_rounded, size: 18),
            label: Text(_ppdbValue(context, 'teks_bagian.tombol.unduh', 'Unduh')),
            style: FilledButton.styleFrom(
              backgroundColor: _ppdbBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _PpdbScheduleSection extends StatelessWidget {
  const _PpdbScheduleSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 920;
    final items =
        _ppdbRows(context, 'jadwal', const [
              {
                'tanggal': '1 Mei - 30 Juni 2026',
                'judul': 'Pendaftaran',
                'deskripsi':
                    'Pengisian formulir dan unggah berkas pendaftaran.',
              },
              {
                'tanggal': '4 Juli 2026',
                'judul': 'Tes & Wawancara',
                'deskripsi': 'Tes akademik dan wawancara sesuai jadwal.',
              },
              {
                'tanggal': '7 Juli 2026',
                'judul': 'Pengumuman',
                'deskripsi':
                    'Pengumuman hasil seleksi diterbitkan secara online.',
              },
              {
                'tanggal': '10 - 12 Juli 2026',
                'judul': 'Daftar Ulang',
                'deskripsi': 'Peserta yang diterima melakukan daftar ulang.',
              },
            ])
            .asMap()
            .entries
            .map(
              (entry) => _ScheduleStage(
                icon: const [
                  Icons.edit_calendar_rounded,
                  Icons.groups_rounded,
                  Icons.campaign_rounded,
                  Icons.task_alt_rounded,
                ][entry.key % 4],
                date: '${entry.value['tanggal'] ?? ''}',
                title: '${entry.value['judul'] ?? ''}',
                text: '${entry.value['deskripsi'] ?? ''}',
              ),
            )
            .toList();
    /*
      _ScheduleStage(
        icon: Icons.edit_calendar_rounded,
        date: '1 Mei - 30 Juni 2026',
        title: 'Pendaftaran',
        text: 'Pengisian formulir dan unggah berkas pendaftaran.',
      ),
      _ScheduleStage(
        icon: Icons.groups_rounded,
        date: '4 Juli 2026',
        title: 'Tes & Wawancara',
        text: 'Tes akademik dan wawancara sesuai jadwal.',
      ),
      _ScheduleStage(
        icon: Icons.campaign_rounded,
        date: '7 Juli 2026',
        title: 'Pengumuman',
        text: 'Pengumuman hasil seleksi diterbitkan secara online.',
      ),
      _ScheduleStage(
        icon: Icons.task_alt_rounded,
        date: '10 - 12 Juli 2026',
        title: 'Daftar Ulang',
        text: 'Peserta yang diterima melakukan daftar ulang.',
      ),
    ];*/

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.jadwal', 'Jadwal PPDB'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          compact
              ? Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      items[i],
                      if (i != items.length - 1) const SizedBox(height: 14),
                    ],
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      Expanded(child: items[i]),
                      if (i != items.length - 1)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: Container(
                              height: 2,
                              color: const Color(0xFF2B67D7),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
          const SizedBox(height: 16),
          Text(
            'Catatan: ${_ppdbValue(context, 'teks_bagian.jadwal.catatan', 'Jadwal dapat berubah sewaktu-waktu. Silakan pantau informasi terbaru di website resmi atau media sosial SMAK.')}',
            style: TextStyle(
              color: _ppdbMuted,
              fontSize: 12.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleStage extends StatelessWidget {
  const _ScheduleStage({
    required this.icon,
    required this.date,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String date;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF2FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _ppdbBlue, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          date,
          style: const TextStyle(
            color: _ppdbBlue,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: _ppdbText,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            color: _ppdbMuted,
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _PpdbFinanceSection extends StatelessWidget {
  const _PpdbFinanceSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 1020;
    return compact
        ? const Column(
            children: [
              _PpdbCostCard(),
              SizedBox(height: 18),
              _PpdbScholarshipWideCard(),
            ],
          )
        : const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PpdbCostCard()),
              SizedBox(width: 18),
              Expanded(child: _PpdbScholarshipWideCard()),
            ],
          );
  }
}

class _PpdbCostCard extends StatelessWidget {
  const _PpdbCostCard();

  @override
  Widget build(BuildContext context) {
    final rows = _ppdbRows(context, 'biaya', const [
      {'judul': 'Biaya Pendaftaran', 'nilai': 'Hubungi Panitia'},
      {'judul': 'Uang Pangkal', 'nilai': 'Hubungi Panitia'},
      {'judul': 'SPP', 'nilai': 'Hubungi Panitia'},
    ]);

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.biaya', 'Biaya Pendidikan'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _ppdbValue(
              context,
              'teks_bagian.biaya.deskripsi',
              'SMAK berkomitmen untuk memberikan layanan pendidikan berkualitas dengan biaya yang transparan dan dapat dikonsultasikan langsung dengan panitia.',
            ),
            style: TextStyle(color: _ppdbMuted, fontSize: 13.5, height: 1.6),
          ),
          const SizedBox(height: 18),
          ...rows.map(
            (row) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: _ppdbLine),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    '${row['judul'] ?? ''}',
                    style: const TextStyle(
                      color: _ppdbText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${row['nilai'] ?? ''}',
                    style: const TextStyle(
                      color: _ppdbBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: _ppdbBlue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Untuk informasi rinci mengenai biaya pendidikan, silakan hubungi panitia PPDB melalui kontak yang tersedia.',
                    style: TextStyle(
                      color: _ppdbMuted,
                      fontSize: 12.5,
                      height: 1.45,
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

class _PpdbScholarshipWideCard extends StatelessWidget {
  const _PpdbScholarshipWideCard();

  @override
  Widget build(BuildContext context) {
    final items = _ppdbRows(context, 'beasiswa', const [
      {
        'judul': 'Beasiswa Prestasi',
        'deskripsi':
            'diberikan bagi siswa berprestasi di bidang akademik maupun non-akademik.',
      },
      {
        'judul': 'Beasiswa Akademik',
        'deskripsi': 'berdasarkan pencapaian nilai akademik yang unggul.',
      },
      {
        'judul': 'Bantuan Pendidikan',
        'deskripsi':
            'bagi keluarga yang membutuhkan dukungan biaya pendidikan.',
      },
    ]).map((row) => '${row['judul']}: ${row['deskripsi']}').toList();

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.beasiswa', 'Beasiswa & Bantuan'),
            style: TextStyle(
              color: _ppdbGold,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _ppdbGold,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: _ppdbText,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          FilledButton(
            onPressed: () => openSharedLink(
              _ppdbValue(
                context,
                '_utama.whatsapp',
                'https://wa.me/628155099445',
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: _ppdbGold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _ppdbValue(context, 'teks_bagian.tombol.konsultasi_biaya', 'Konsultasi Biaya & Beasiswa'),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _PpdbFacilitiesSection extends StatelessWidget {
  const _PpdbFacilitiesSection();

  @override
  Widget build(BuildContext context) {
    final facilities =
        _ppdbRows(context, 'fasilitas', const [
              {
                'judul': 'Laboratorium',
                'deskripsi':
                    'Laboratorium IPA yang lengkap mendukung pembelajaran praktikum yang berkualitas.',
              },
              {
                'judul': 'Perpustakaan',
                'deskripsi':
                    'Koleksi buku lengkap dan ruang baca nyaman untuk mendukung literasi siswa.',
              },
              {
                'judul': 'Lapangan Olahraga',
                'deskripsi':
                    'Fasilitas olahraga memadai untuk mendukung kesehatan dan prestasi siswa.',
              },
              {
                'judul': 'Ruang Komputer',
                'deskripsi':
                    'Ruang komputer dengan perangkat modern untuk menunjang pembelajaran digital.',
              },
            ])
            .asMap()
            .entries
            .map(
              (entry) => _FacilityData(
                icon: const [
                  Icons.science_rounded,
                  Icons.menu_book_rounded,
                  Icons.sports_soccer_rounded,
                  Icons.computer_rounded,
                ][entry.key % 4],
                title: '${entry.value['judul'] ?? ''}',
                text: '${entry.value['deskripsi'] ?? ''}',
              ),
            )
            .toList();

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.fasilitas', 'Fasilitas untuk Mendukung Perkembangan Siswa'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth >= 1100
                  ? 4
                  : constraints.maxWidth >= 650
                  ? 2
                  : 1;
              return GridView.count(
                crossAxisCount: count,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: count == 1 ? 2.1 : .95,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: facilities
                    .map((item) => _FacilityCard(item))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FacilityData {
  const _FacilityData({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard(this.data);

  final _FacilityData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _ppdbLine),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF2FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, color: _ppdbBlue, size: 46),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(data.icon, color: _ppdbBlue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          color: _ppdbText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.text,
                  style: const TextStyle(
                    color: _ppdbMuted,
                    fontSize: 12.5,
                    height: 1.45,
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

class _PpdbTestimonialsSection extends StatelessWidget {
  const _PpdbTestimonialsSection();

  @override
  Widget build(BuildContext context) {
    final items =
        _ppdbRows(context, 'testimoni', const [
              {
                'nama': 'Ibu Maria',
                'peran': 'Orang Tua Siswa Kelas XI',
                'kutipan':
                    'SMAK membantu anak saya tumbuh menjadi pribadi yang beriman, disiplin, dan berprestasi. Guru-gurunya sangat peduli dan mendampingi.',
              },
              {
                'nama': 'Bapak Antonius',
                'peran': 'Orang Tua Siswa Kelas X',
                'kutipan':
                    'Fasilitas lengkap dan kegiatan yang beragam membuat anak saya betah belajar dan berkembang sesuai bakatnya.',
              },
              {
                'nama': 'Ibu Yuliana',
                'peran': 'Orang Tua Siswa Kelas XII',
                'kutipan':
                    'Lingkungan yang kekeluargaan dan nilai-nilai iman yang diajarkan sangat membantu karakter anak saya sehari-hari.',
              },
            ])
            .map(
              (row) => _TestimonialData(
                name: '${row['nama'] ?? ''}',
                role: '${row['peran'] ?? ''}',
                quote: '${row['kutipan'] ?? ''}',
              ),
            )
            .toList();

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.testimoni', 'Cerita dari Keluarga SMAK'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth >= 1100
                  ? 3
                  : constraints.maxWidth >= 720
                  ? 2
                  : 1;
              return GridView.count(
                crossAxisCount: count,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: count == 1 ? 2.2 : 1.42,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: items.map((item) => _TestimonialCard(item)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TestimonialData {
  const _TestimonialData({
    required this.name,
    required this.role,
    required this.quote,
  });

  final String name;
  final String role;
  final String quote;
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard(this.data);

  final _TestimonialData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: _ppdbLine),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFE7EFFC),
                child: Icon(Icons.person_rounded, color: _ppdbBlue, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '"${data.quote}"',
            style: const TextStyle(
              color: _ppdbMuted,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 12),
          Text(
            data.name,
            style: const TextStyle(
              color: _ppdbText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.role,
            style: const TextStyle(color: _ppdbMuted, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _PpdbFaqSection extends StatelessWidget {
  const _PpdbFaqSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return compact
        ? const Column(
            children: [_PpdbFaqCard(), SizedBox(height: 18), _PpdbAskCard()],
          )
        : const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: _PpdbFaqCard()),
              SizedBox(width: 18),
              Expanded(flex: 4, child: _PpdbAskCard()),
            ],
          );
  }
}

class _PpdbFaqCard extends StatelessWidget {
  const _PpdbFaqCard();

  @override
  Widget build(BuildContext context) {
    final faqs = _ppdbRows(context, 'faq', const [
      {
        'pertanyaan': 'Apa saja jalur pendaftaran yang tersedia?',
        'jawaban':
            'SMAK membuka pendaftaran melalui jalur reguler dan jalur prestasi. Informasi lengkap dapat dilihat pada brosur PPDB.',
      },
      {
        'pertanyaan': 'Apakah pendaftaran dapat dilakukan secara online?',
        'jawaban':
            'Ya, seluruh proses pendaftaran awal dapat dilakukan secara online melalui formulir dan pengunggahan berkas.',
      },
      {
        'pertanyaan': 'Bagaimana proses tes dan wawancara?',
        'jawaban':
            'Calon siswa akan mengikuti tes akademik dan wawancara sesuai jadwal yang diumumkan oleh panitia.',
      },
      {
        'pertanyaan': 'Apakah tersedia program beasiswa?',
        'jawaban':
            'Tersedia program beasiswa prestasi, akademik, dan bantuan pendidikan sesuai kebijakan sekolah.',
      },
      {
        'pertanyaan': 'Bagaimana jika dokumen belum lengkap?',
        'jawaban':
            'Panitia akan menghubungi pendaftar untuk melengkapi dokumen yang masih kurang dalam batas waktu tertentu.',
      },
      {
        'pertanyaan': 'Siapa yang dapat saya hubungi?',
        'jawaban':
            'Anda dapat menghubungi panitia PPDB melalui WhatsApp atau telepon sekolah pada jam operasional.',
      },
    ]);

    return _PpdbPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(context, 'teks_bagian.label.faq', 'Pertanyaan yang Sering Diajukan'),
            style: TextStyle(
              color: _ppdbText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          ...faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: _ppdbLine),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text(
                  '${faq['pertanyaan'] ?? ''}',
                  style: const TextStyle(
                    color: _ppdbText,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${faq['jawaban'] ?? ''}',
                      style: const TextStyle(
                        color: _ppdbMuted,
                        fontSize: 13,
                        height: 1.55,
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

class _PpdbAskCard extends StatelessWidget {
  const _PpdbAskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1263E5), Color(0xFF0A49B4)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _ppdbValue(
              context,
              'teks_bagian.tanya_panitia.judul',
              'Masih Punya Pertanyaan?',
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _ppdbValue(
              context,
              'teks_bagian.tanya_panitia.deskripsi',
              'Hubungi panitia melalui WhatsApp untuk mendapatkan informasi lebih lanjut seputar PPDB SMAK.',
            ),
            style: TextStyle(
              color: Color(0xFFE7F0FF),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => openSharedLink(
                _ppdbValue(
                  context,
                  '_utama.whatsapp',
                  'https://wa.me/628155099445',
                ),
              ),
              icon: const Icon(Icons.chat_rounded),
              label: Text(_ppdbValue(context, 'teks_bagian.tombol.chat', 'Chat WhatsApp')),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1A9E44),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone_rounded, color: _ppdbBlue),
                    SizedBox(width: 10),
                    Text(
                      'Call Center PPDB',
                      style: TextStyle(
                        color: _ppdbText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  _ppdbValue(context, 'ringkasan.kontak', '(0334) 890123'),
                  style: TextStyle(
                    color: _ppdbBlue,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _ppdbValue(
                    context,
                    'teks_bagian.tanya_panitia.jam_layanan',
                    'Senin - Jumat, 08.00 - 15.00 WIB',
                  ),
                  style: TextStyle(color: _ppdbMuted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PpdbBottomCta extends StatelessWidget {
  const _PpdbBottomCta();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [_ppdbNavy, Color(0xFF0B4DB3)],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 18 : 28,
            vertical: compact ? 20 : 24,
          ),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _PpdbBottomText(),
                    SizedBox(height: 18),
                    _PpdbBottomButtons(),
                  ],
                )
              : const Row(
                  children: [
                    Expanded(child: _PpdbBottomText()),
                    SizedBox(width: 24),
                    SizedBox(width: 360, child: _PpdbBottomButtons()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _PpdbBottomText extends StatelessWidget {
  const _PpdbBottomText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _ppdbValue(context, 'teks_bagian.cta_bawah.label', 'PPDB 2026/2027'),
          style: TextStyle(
            color: Color(0xFF9FC3FF),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 10),
        Text(
          _ppdbValue(
            context,
            'teks_bagian.cta_bawah.judul',
            'Mulai Langkahmu Bersama SMAK',
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        SizedBox(height: 10),
        Text(
          _ppdbValue(
            context,
            'teks_bagian.cta_bawah.deskripsi',
            'Bergabunglah dengan SMAK dan raih masa depan cerah bersama komunitas yang beriman, berkarakter, dan berprestasi.',
          ),
          style: TextStyle(color: Color(0xFFE5EEFF), fontSize: 15, height: 1.6),
        ),
      ],
    );
  }
}

class _PpdbBottomButtons extends StatelessWidget {
  const _PpdbBottomButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _ppdbRegistrationUrl(context).isEmpty
                ? null
                : () =>
                      html.window.open(_ppdbRegistrationUrl(context), '_blank'),
            icon: const Icon(Icons.app_registration_rounded),
            label: Text(_ppdbValue(context, 'teks_bagian.tombol.daftar', 'Daftar Sekarang')),
            style: FilledButton.styleFrom(
              backgroundColor: _ppdbBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => openSharedLink(
              _ppdbValue(
                context,
                '_utama.whatsapp',
                'https://wa.me/628155099445',
              ),
            ),
            icon: const Icon(Icons.call_rounded),
            label: Text(_ppdbValue(context, 'teks_bagian.tombol.hubungi', 'Hubungi Panitia')),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PpdbPanel extends StatelessWidget {
  const _PpdbPanel({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _ppdbLine),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
