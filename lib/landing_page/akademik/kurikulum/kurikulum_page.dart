import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../../routing/public_routes.dart';
import '../../site_chrome.dart';

const _blue = Color(0xFF0756C8);
const _navy = Color(0xFF083A7C);
const _text = Color(0xFF0B326B);
const _muted = Color(0xFF63748E);
const _background = Color(0xFFF5F8FD);
const _line = Color(0xFFE2EAF4);
const _gold = Color(0xFFF2B313);

class KurikulumPage extends StatefulWidget {
  const KurikulumPage({super.key});

  @override
  State<KurikulumPage> createState() => _KurikulumPageState();
}

class _KurikulumPageState extends State<KurikulumPage> {
  Map<String, dynamic> _data = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      const tables = [
        'kurikulum_hero',
        'kurikulum_pengantar',
        'kurikulum_prinsip',
        'kurikulum_kerangka',
        'kurikulum_mata_pelajaran',
        'kurikulum_pendekatan',
        'kurikulum_program',
        'kurikulum_penilaian',
        'kurikulum_komitmen',
        'kurikulum_cta',
      ];
      final groups = await Future.wait([
        for (final table in tables) const SmakApi().getTable(table, limit: 100),
      ]);
      final data = <String, dynamic>{};
      for (var i = 0; i < tables.length; i++) {
        final key = tables[i].replaceFirst('kurikulum_', '');
        final values = groups[i]
            .map((row) {
              try {
                return jsonDecode('${row['data_json'] ?? ''}');
              } catch (_) {
                return null;
              }
            })
            .whereType<dynamic>()
            .toList();
        data[key] =
            const {
              'prinsip',
              'kerangka',
              'mata_pelajaran',
              'program',
              'penilaian',
            }.contains(key)
            ? values
            : (values.isEmpty ? null : values.first);
      }
      if (mounted) setState(() => _data = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: _KurikulumDataScope(
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
              Builder(
                builder: (scopeContext) => _CurriculumHero(
                  image: _kurikulumText(scopeContext, 'hero', 'gambar', ''),
                ),
              ),
              const _CurriculumContent(),
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

class _KurikulumDataScope extends InheritedWidget {
  const _KurikulumDataScope({required this.data, required super.child});
  final Map<String, dynamic> data;
  static Map<String, dynamic> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_KurikulumDataScope>()?.data ??
      const {};
  @override
  bool updateShouldNotify(_KurikulumDataScope oldWidget) =>
      oldWidget.data != data;
}

String _kurikulumText(
  BuildContext context,
  String section,
  String key,
  String fallback,
) {
  final value = _KurikulumDataScope.of(context)[section];
  final text = value is Map ? '${value[key] ?? ''}'.trim() : '';
  return text.isEmpty ? fallback : text;
}

List<Map<String, dynamic>> _kurikulumRows(
  BuildContext context,
  String section,
) {
  final value = _KurikulumDataScope.of(context)[section];
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}

IconData _kurikulumIcon(dynamic value, IconData fallback) {
  if (value is IconData) return value;
  final codePoint = value is int ? value : int.tryParse('${value ?? ''}');
  if (codePoint == null) return fallback;

  // Resolve DB code points only to compile-time Material icon constants.
  // This keeps release icon tree-shaking enabled and avoids constructing
  // IconData dynamically at runtime.
  final iconsByCodePoint = <int, IconData>{
    Icons.auto_stories_rounded.codePoint: Icons.auto_stories_rounded,
    Icons.menu_book_rounded.codePoint: Icons.menu_book_rounded,
    Icons.assignment_rounded.codePoint: Icons.assignment_rounded,
    Icons.emoji_events_rounded.codePoint: Icons.emoji_events_rounded,
    Icons.school_rounded.codePoint: Icons.school_rounded,
    Icons.chat_rounded.codePoint: Icons.chat_rounded,
  };

  return iconsByCodePoint[codePoint] ?? fallback;
}

_FeatureData _featureFromRow(Map<String, dynamic> row, IconData fallbackIcon) =>
    _FeatureData(
      _kurikulumIcon(row['icon'], fallbackIcon),
      '${row['judul'] ?? ''}'.trim(),
      '${row['deskripsi'] ?? ''}'.trim(),
    );

class _CurriculumHero extends StatelessWidget {
  const _CurriculumHero({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return SizedBox(
      width: double.infinity,
      height: compact ? 320 : 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xF2083A7C),
                  Color(0xD9083A7C),
                  Color(0x73083A7C),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 24 : 46),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Beranda  ›  Akademik  ›  Kurikulum',
                          style: TextStyle(
                            color: Color(0xFFDCE9FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _kurikulumText(context, 'hero', 'judul', 'Kurikulum'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(
                          width: 54,
                          child: Divider(color: _gold, thickness: 3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _kurikulumText(
                            context,
                            'hero',
                            'deskripsi',
                            'Pendidikan yang mengembangkan pengetahuan, karakter, iman, dan keterampilan untuk masa depan yang lebih baik.',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.65,
                            fontSize: 15,
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

class _CurriculumContent extends StatelessWidget {
  const _CurriculumContent();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1240),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 20 : 36,
          50,
          compact ? 20 : 36,
          58,
        ),
        child: const Column(
          children: [
            _CurriculumIntro(),
            SizedBox(height: 34),
            _PrincipleSection(),
            SizedBox(height: 66),
            _FrameworkSection(),
            SizedBox(height: 66),
            _SubjectSection(),
            SizedBox(height: 66),
            _LearningApproachSection(),
            SizedBox(height: 66),
            _FeaturedProgramsSection(),
            SizedBox(height: 66),
            _AssessmentSection(),
            SizedBox(height: 62),
            _CommitmentBanner(),
            SizedBox(height: 30),
            _BottomCta(),
          ],
        ),
      ),
    );
  }
}

class _CurriculumIntro extends StatelessWidget {
  const _CurriculumIntro();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 780;
        final description = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _kurikulumText(context, 'pengantar', 'judul', 'Kurikulum SMAK'),
              style: const TextStyle(
                color: _text,
                fontSize: 29,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _kurikulumText(
                context,
                'pengantar',
                'deskripsi',
                'SMAK Mgr. Soegijapranata menerapkan kurikulum yang berpusat pada peserta didik dengan mengintegrasikan Kurikulum Nasional, nilai-nilai Katolik, serta program pengembangan sekolah untuk membentuk insan yang cerdas, beriman, berkarakter, dan siap menghadapi perubahan zaman.',
              ),
              style: const TextStyle(color: _muted, fontSize: 14, height: 1.75),
            ),
          ],
        );
        final identity = Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F6FF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              websiteLogoImage(
                width: 94,
                height: 94,
              ),
              const SizedBox(width: 22),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _kurikulumText(
                        context,
                        'pengantar',
                        'tagline',
                        'Beriman • Berilmu • Berkarakter',
                      ),
                      style: const TextStyle(
                        color: _blue,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _kurikulumText(
                        context,
                        'pengantar',
                        'tagline_deskripsi',
                        'Kurikulum yang menumbuhkan kompetensi sekaligus membentuk kepribadian.',
                      ),
                      style: const TextStyle(color: _muted, height: 1.55),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        if (compact) {
          return Column(
            children: [description, const SizedBox(height: 24), identity],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 6, child: description),
            const SizedBox(width: 46),
            Expanded(flex: 5, child: identity),
          ],
        );
      },
    );
  }
}

class _PrincipleSection extends StatelessWidget {
  const _PrincipleSection();

  @override
  Widget build(BuildContext context) {
    final rows = _kurikulumRows(context, 'prinsip');
    final items = rows
        .map((row) => _featureFromRow(row, Icons.auto_stories_rounded))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 620
            ? 1
            : constraints.maxWidth < 940
            ? 2
            : 4;
        final width = (constraints.maxWidth - ((columns - 1) * 16)) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items
              .map(
                (item) => SizedBox(
                  width: width,
                  child: _FeatureCard(data: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _FrameworkSection extends StatelessWidget {
  const _FrameworkSection();

  @override
  Widget build(BuildContext context) {
    final rows = _kurikulumRows(context, 'kerangka');
    final items = rows
        .map((row) => _featureFromRow(row, Icons.auto_stories_rounded))
        .toList();

    return Column(
      children: [
        _SectionHeading(
          title: _kurikulumText(context, 'cta', 'judul_kerangka', 'Kerangka Kurikulum'),
          subtitle: _kurikulumText(context, 'cta', 'subjudul_kerangka', 'Empat bagian yang saling terhubung dalam proses pendidikan siswa.'),
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return Column(
                children: List.generate(
                  items.length,
                  (index) => _MobileTimelinePoint(
                    data: items[index],
                    showLine: index != items.length - 1,
                  ),
                ),
              );
            }
            return SizedBox(
              height: 205,
              child: Stack(
                children: [
                  Positioned(
                    left: constraints.maxWidth / 8,
                    right: constraints.maxWidth / 8,
                    top: 47,
                    child: Container(height: 3, color: const Color(0xFFB9D4FA)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items
                        .map(
                          (item) =>
                              Expanded(child: _FrameworkPoint(data: item)),
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

class _SubjectSection extends StatelessWidget {
  const _SubjectSection();

  @override
  Widget build(BuildContext context) {
    final rows = _kurikulumRows(context, 'mata_pelajaran');
    final groups = rows
        .map(
          (row) => _SubjectData(
            _kurikulumIcon(row['icon'], Icons.menu_book_rounded),
            '${row['judul'] ?? ''}'.trim(),
            (row['items'] is List)
                ? (row['items'] as List)
                      .map((e) => '$e'.trim())
                      .where((e) => e.isNotEmpty)
                      .toList()
                : const <String>[],
          ),
        )
        .toList();

    return Column(
      children: [
        _SectionHeading(title: _kurikulumText(context, 'cta', 'judul_mata_pelajaran', 'Struktur Mata Pelajaran')),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 760 ? 1 : 3;
            final width =
                (constraints.maxWidth - ((columns - 1) * 18)) / columns;
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: groups
                  .map(
                    (group) => SizedBox(
                      width: width,
                      child: _SubjectCard(data: group),
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

class _LearningApproachSection extends StatelessWidget {
  const _LearningApproachSection();

  @override
  Widget build(BuildContext context) {
    final approach = _KurikulumDataScope.of(context)['pendekatan'];
    final approachMap = approach is Map
        ? Map<String, dynamic>.from(approach)
        : const <String, dynamic>{};
    final rows = approachMap['items'] is List
        ? (approachMap['items'] as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : const <Map<String, dynamic>>[];
    final features = rows
        .map((row) => _featureFromRow(row, Icons.auto_stories_rounded))
        .toList();
    final approachImage = '${approachMap['gambar'] ?? ''}'.trim();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _whiteCard(radius: 22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;
          final photo = ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: compact ? 16 / 9 : 5 / 4,
              child: websiteContentImage(
                approachImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          );
          final text = Padding(
            padding: EdgeInsets.all(compact ? 8 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _kurikulumText(
                    context,
                    'pendekatan',
                    'judul',
                    'Pendekatan Pembelajaran',
                  ),
                  style: const TextStyle(
                    color: _text,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                ...features.map((item) => _ApproachItem(data: item)),
              ],
            ),
          );
          if (compact) {
            return Column(children: [photo, const SizedBox(height: 20), text]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: photo),
              const SizedBox(width: 26),
              Expanded(flex: 6, child: text),
            ],
          );
        },
      ),
    );
  }
}

class _FeaturedProgramsSection extends StatelessWidget {
  const _FeaturedProgramsSection();

  @override
  Widget build(BuildContext context) {
    final rows = _kurikulumRows(context, 'program');
    final programs = rows
        .map((row) => _featureFromRow(row, Icons.auto_stories_rounded))
        .toList();

    return Column(
      children: [
        _SectionHeading(title: _kurikulumText(context, 'cta', 'judul_program', 'Program Unggulan Akademik')),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 650
                ? 1
                : constraints.maxWidth < 980
                ? 2
                : 3;
            final width =
                (constraints.maxWidth - ((columns - 1) * 16)) / columns;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: programs
                  .map(
                    (item) => SizedBox(
                      width: width,
                      child: _ProgramCard(data: item),
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

class _AssessmentSection extends StatelessWidget {
  const _AssessmentSection();

  @override
  Widget build(BuildContext context) {
    final rows = _kurikulumRows(context, 'penilaian');
    final items = rows
        .map((row) => _featureFromRow(row, Icons.assignment_rounded))
        .toList();

    return Column(
      children: [
        _SectionHeading(
          title: _kurikulumText(context, 'cta', 'judul_penilaian', 'Penilaian dan Evaluasi'),
          subtitle: _kurikulumText(context, 'cta', 'subjudul_penilaian', 'Proses berkelanjutan untuk mendukung perkembangan setiap peserta didik.'),
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return Column(
                children: List.generate(
                  items.length,
                  (index) => _MobileTimelinePoint(
                    data: items[index],
                    showLine: index != items.length - 1,
                  ),
                ),
              );
            }
            return SizedBox(
              height: 190,
              child: Stack(
                children: [
                  Positioned(
                    left: constraints.maxWidth / 8,
                    right: constraints.maxWidth / 8,
                    top: 47,
                    child: Container(height: 3, color: const Color(0xFFB9D4FA)),
                  ),
                  Row(
                    children: items
                        .map(
                          (item) =>
                              Expanded(child: _FrameworkPoint(data: item)),
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

class _CommitmentBanner extends StatelessWidget {
  const _CommitmentBanner();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 24 : 48,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF083A7C), Color(0xFF0756C8)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: compact
          ? Column(
              children: [
                const _CommitmentLogo(),
                const SizedBox(height: 20),
                _CommitmentText(),
              ],
            )
          : Row(
              children: [
                const _CommitmentLogo(),
                const SizedBox(width: 34),
                Expanded(child: _CommitmentText()),
              ],
            ),
    );
  }
}

class _CommitmentLogo extends StatelessWidget {
  const _CommitmentLogo();

  @override
  Widget build(BuildContext context) => websiteLogoImage(
    width: 96,
    height: 96,
  );
}

class _CommitmentText extends StatelessWidget {
  const _CommitmentText();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        '“',
        style: TextStyle(
          color: _gold,
          fontSize: 50,
          fontWeight: FontWeight.w900,
          height: .8,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          (() {
            final value = _KurikulumDataScope.of(context)['komitmen'];
            final text = '${value ?? ''}'.trim();
            return text.isEmpty
                ? 'Kami berkomitmen menyeimbangkan prestasi akademik, iman yang mendalam, dan karakter mulia untuk melahirkan generasi yang cerdas, berkarakter, dan siap melayani.'
                : text;
          })(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            height: 1.6,
            fontWeight: FontWeight.w700,
          ),
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
        FilledButton.icon(
          onPressed: () => publicRootNavigator(context).pushNamed(_kurikulumText(context, 'cta', 'link_tombol_1', PublicRoutes.academicAchievements)),
          icon: const Icon(Icons.emoji_events_rounded, size: 18),
          label: Text(_kurikulumText(context, 'cta', 'teks_tombol_1', 'Lihat Prestasi Akademik')),
        ),
        OutlinedButton.icon(
          onPressed: () => openSharedLink(
            _kurikulumText(
              context,
              'cta',
              'whatsapp',
              'https://wa.me/628155099445',
            ),
          ),
          icon: const Icon(Icons.chat_rounded, size: 18),
          label: Text(_kurikulumText(context, 'cta', 'teks_tombol_2', 'Informasi PPDB')),
          style: OutlinedButton.styleFrom(
            foregroundColor: _blue,
            side: const BorderSide(color: _blue),
          ),
        ),
      ],
    );
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _kurikulumText(
            context,
            'cta',
            'judul',
            'Siap Bertumbuh Bersama SMAK?',
          ),
          style: const TextStyle(
            color: _text,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          _kurikulumText(
            context,
            'cta',
            'deskripsi',
            'Mari menjadi bagian dari lingkungan belajar yang beriman, berkarakter, dan unggul.',
          ),
          style: const TextStyle(color: _muted, height: 1.5),
        ),
      ],
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: _whiteCard(radius: 18),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 20), buttons],
            )
          : Row(
              children: [
                Expanded(child: text),
                const SizedBox(width: 24),
                buttons,
              ],
            ),
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
          fontSize: 27,
          fontWeight: FontWeight.w900,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 8),
        Text(
          subtitle!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, height: 1.5),
        ),
      ],
      const SizedBox(height: 11),
      Container(
        width: 54,
        height: 3,
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    ],
  );
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.data});
  final _FeatureData data;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 190),
    padding: const EdgeInsets.all(20),
    decoration: _whiteCard(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoundIcon(icon: data.icon),
        const SizedBox(height: 17),
        Text(
          data.title,
          style: const TextStyle(
            color: _text,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.description,
          style: const TextStyle(color: _muted, height: 1.55, fontSize: 12.5),
        ),
      ],
    ),
  );
}

class _FrameworkPoint extends StatelessWidget {
  const _FrameworkPoint({required this.data});
  final _FeatureData data;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      children: [
        _RoundIcon(icon: data.icon, large: true),
        const SizedBox(height: 16),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 7),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, height: 1.45, fontSize: 11.5),
        ),
      ],
    ),
  );
}

class _MobileTimelinePoint extends StatelessWidget {
  const _MobileTimelinePoint({required this.data, required this.showLine});
  final _FeatureData data;
  final bool showLine;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 58,
        child: Column(
          children: [
            _RoundIcon(icon: data.icon),
            if (showLine)
              Container(width: 3, height: 66, color: const Color(0xFFB9D4FA)),
          ],
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.description,
                style: const TextStyle(color: _muted, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.data});
  final _SubjectData data;

  @override
  Widget build(BuildContext context) => Container(
    decoration: _whiteCard(),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_navy, _blue]),
          ),
          child: Row(
            children: [
              Icon(data.icon, color: Colors.white),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.subjects
                .map(
                  (subject) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7),
                          child: SizedBox(
                            width: 5,
                            height: 5,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: _blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            subject,
                            style: const TextStyle(color: _muted, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ),
  );
}

class _ApproachItem extends StatelessWidget {
  const _ApproachItem({required this.data});
  final _FeatureData data;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoundIcon(icon: data.icon),
        const SizedBox(width: 15),
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
              const SizedBox(height: 5),
              Text(
                data.description,
                style: const TextStyle(color: _muted, height: 1.45),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.data});
  final _FeatureData data;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 134),
    padding: const EdgeInsets.all(18),
    decoration: _whiteCard(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoundIcon(icon: data.icon),
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
              const SizedBox(height: 7),
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

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, this.large = false});
  final IconData icon;
  final bool large;

  @override
  Widget build(BuildContext context) => Container(
    width: large ? 62 : 48,
    height: large ? 62 : 48,
    decoration: BoxDecoration(
      color: large ? _blue : const Color(0xFFE8F1FF),
      shape: BoxShape.circle,
      border: large ? Border.all(color: Colors.white, width: 4) : null,
      boxShadow: large
          ? const [BoxShadow(color: Color(0x330756C8), blurRadius: 8)]
          : null,
    ),
    child: Icon(
      icon,
      color: large ? Colors.white : _blue,
      size: large ? 28 : 24,
    ),
  );
}

class _FeatureData {
  const _FeatureData(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

class _SubjectData {
  const _SubjectData(this.icon, this.title, this.subjects);
  final IconData icon;
  final String title;
  final List<String> subjects;
}

BoxDecoration _whiteCard({double radius = 16}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: _line),
  boxShadow: const [
    BoxShadow(color: Color(0x0D0B326B), blurRadius: 16, offset: Offset(0, 6)),
  ],
);
