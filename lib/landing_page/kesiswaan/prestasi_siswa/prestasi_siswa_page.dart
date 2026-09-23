import 'package:flutter/material.dart';

import '../../site_chrome.dart';
import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';

const _blue = Color(0xFF0756C8);
const _navy = Color(0xFF083A7C);
const _text = Color(0xFF0B326B);
const _muted = Color(0xFF65758F);
const _background = Color(0xFFF4F8FD);
const _line = Color(0xFFE1EAF5);
const _gold = Color(0xFFF2B511);

class PrestasiSiswaPage extends StatefulWidget {
  const PrestasiSiswaPage({super.key});

  @override
  State<PrestasiSiswaPage> createState() => _PrestasiSiswaPageState();
}

class _PrestasiSiswaPageState extends State<PrestasiSiswaPage> {
  String category = 'Semua';
  Map<String, dynamic> _data = const {};

  List<_Achievement> get shown => category == 'Semua'
      ? _achievements
      : _achievements.where((item) => item.category == category).toList();

  List<_Achievement> get _achievements {
    final rows = (_data['prestasi'] as List? ?? const [])
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .where((row) => '${row['unggulan']}' != '1')
        .toList();
    return rows.map(_Achievement.fromRow).toList();
  }

  List<String> get _categories => [
    'Semua',
    ...{for (final item in _achievements) item.category},
  ];

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      final rows = await Future.wait([
        const SmakApi().getTable('prestasisiswa_konten', limit: 1),
        const SmakApi().getTable('prestasisiswa_prestasi', limit: 100),
        const SmakApi().getTable('prestasisiswa_bidang', limit: 50),
        const SmakApi().getTable('prestasisiswa_pembinaan', limit: 50),
        const SmakApi().getTable('prestasisiswa_perjalanan', limit: 50),
        const SmakApi().getTable('prestasisiswa_dokumentasi', limit: 50),
      ]);
      if (!mounted) return;
      setState(
        () => _data = {
          'konten': rows[0].isEmpty ? const <String, dynamic>{} : rows[0].first,
          'prestasi': rows[1],
          'bidang': rows[2],
          'pembinaan': rows[3],
          'perjalanan': rows[4],
          'dokumentasi': rows[5],
        },
      );
    } catch (_) {
      // Tampilan bawaan tetap dipakai bila API belum tersedia.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _background,
    body: _PrestasiSiswaDataScope(
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
            const _Hero(),
            _PageBody(
              category: category,
              shown: shown,
              categories: _categories,
              onCategory: (value) => setState(() => category = value),
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

class _PrestasiSiswaDataScope extends InheritedWidget {
  const _PrestasiSiswaDataScope({required this.data, required super.child});
  final Map<String, dynamic> data;

  static Map<String, dynamic> of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_PrestasiSiswaDataScope>()
          ?.data ??
      const {};

  @override
  bool updateShouldNotify(_PrestasiSiswaDataScope oldWidget) =>
      oldWidget.data != data;
}

String _contentText(BuildContext context, String key, String fallback) {
  final content = _PrestasiSiswaDataScope.of(context)['konten'];
  final value = content is Map ? '${content[key] ?? ''}'.trim() : '';
  return value.isEmpty ? fallback : value;
}

List<Map<String, dynamic>> _rows(BuildContext context, String key) =>
    (_PrestasiSiswaDataScope.of(context)[key] as List? ?? const [])
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();

Widget _image(
  String path, {
  required Widget fallback,
  BoxFit fit = BoxFit.cover,
}) => path.trim().isEmpty || websiteUsesFallbackImage(path)
    ? websiteFallbackImage(fit: fit)
    : path.startsWith('assets/')
    ? Image.asset(path, fit: fit, errorBuilder: (_, _, _) => fallback)
    : Image.network(
        path.startsWith('http://') || path.startsWith('https://')
            ? path
            : const SmakApi().getFileUrl(path),
        fit: fit,
        errorBuilder: (_, _, _) => fallback,
      );

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    return SizedBox(
      height: compact ? 310 : 320,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _image(
            _contentText(context, 'hero_gambar', ''),
            fallback: Container(color: _navy),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xF2083A7C),
                  Color(0xB0083A7C),
                  Color(0x28083A7C),
                ],
                stops: [0, .47, 1],
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Beranda  ›  Kesiswaan  ›  Prestasi Siswa',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _contentText(context, 'hero_judul', 'Prestasi Siswa'),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: compact ? 36 : 46,
                            fontWeight: FontWeight.w800,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _contentText(
                            context,
                            'hero_subjudul',
                            'Apresiasi atas bakat, kerja keras, dan pencapaian siswa di berbagai bidang.',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
        ],
      ),
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({
    required this.category,
    required this.shown,
    required this.categories,
    required this.onCategory,
  });
  final String category;
  final List<_Achievement> shown;
  final List<String> categories;
  final ValueChanged<String> onCategory;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1220),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 700;
          return Padding(
            padding: EdgeInsets.fromLTRB(
              mobile ? 18 : 30,
              46,
              mobile ? 18 : 30,
              52,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Introduction(),
                const SizedBox(height: 34),
                const _Title('Prestasi Pilihan'),
                const SizedBox(height: 16),
                const _FeaturedGrid(),
                const SizedBox(height: 38),
                const _Title('Daftar Prestasi Siswa'),
                const SizedBox(height: 14),
                _Filters(
                  selected: category,
                  categories: categories,
                  onSelected: onCategory,
                ),
                const SizedBox(height: 18),
                _AchievementGrid(items: shown),
                const SizedBox(height: 44),
                const _Fields(),
                const SizedBox(height: 44),
                const _StudentStory(),
                const SizedBox(height: 42),
                const _Coaching(),
                const SizedBox(height: 44),
                const _Journey(),
                const SizedBox(height: 42),
                const _Documentation(),
                const SizedBox(height: 42),
                const _CallToAction(),
              ],
            ),
          );
        },
      ),
    ),
  );
}

class _Introduction extends StatelessWidget {
  const _Introduction();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final mobile = c.maxWidth < 760;
      final info = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(
            _contentText(context, 'intro_judul', 'Setiap Siswa Punya Potensi'),
          ),
          const SizedBox(height: 10),
          Text(
            _contentText(
              context,
              'intro_deskripsi',
              'SMAK mendampingi siswa mengembangkan kemampuan olahraga, seni dan budaya, kepemimpinan, serta kerohanian dan sosial. Setiap pencapaian adalah hasil latihan, pembinaan, dan dukungan seluruh komunitas sekolah.',
            ),
            style: const TextStyle(color: _muted, height: 1.7, fontSize: 14),
          ),
          const SizedBox(height: 22),
          const _Stats(),
        ],
      );
      final brand = _Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 112,
              height: 112,
              child: _image(
                _contentText(context, 'logo', 'assets/images/logo_sekolah.png'),
                fallback: const Icon(Icons.school, size: 74, color: _blue),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _contentText(context, 'nama_sekolah', 'SMAK Mgr. Soegijapranata'),
              style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              _contentText(
                context,
                'motto_sekolah',
                'Beriman • Berilmu • Berkarakter',
              ),
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      );
      if (mobile) {
        return Column(
          children: [
            SizedBox(height: 230, child: brand),
            const SizedBox(height: 22),
            info,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 260, child: brand),
          const SizedBox(width: 30),
          Expanded(child: info),
        ],
      );
    },
  );
}

class _Stats extends StatelessWidget {
  const _Stats();
  @override
  Widget build(BuildContext context) {
    final data = [
      (
        _contentText(context, 'statistik_total', '12'),
        'Prestasi',
        Icons.emoji_events,
        _blue,
      ),
      (
        _contentText(context, 'statistik_olahraga', '5'),
        'Olahraga',
        Icons.sports_basketball,
        const Color(0xFFF28B21),
      ),
      (
        _contentText(context, 'statistik_seni', '4'),
        'Seni & Budaya',
        Icons.palette,
        const Color(0xFF7C51C7),
      ),
      (
        _contentText(context, 'statistik_sosial', '3'),
        'Organisasi & Sosial',
        Icons.groups,
        const Color(0xFF21A76A),
      ),
    ];
    return LayoutBuilder(
      builder: (_, c) {
        final columns = c.maxWidth < 520 ? 2 : 4;
        final width = (c.maxWidth - 12 * (columns - 1)) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: data
              .map(
                (e) => SizedBox(
                  width: width,
                  child: _Card(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: e.$4.withValues(alpha: .1),
                          child: Icon(e.$3, color: e.$4, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.$1,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                e.$2,
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _FeaturedGrid extends StatelessWidget {
  const _FeaturedGrid();
  @override
  Widget build(BuildContext context) {
    final saved = _rows(context, 'prestasi')
        .where((row) => '${row['unggulan']}' == '1')
        .map(_Achievement.fromRow)
        .toList();
    final items = saved;
    return _ResponsiveGrid(
      minWidth: 280,
      children: items
          .map((e) => _AchievementCard(item: e, featured: true))
          .toList(),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.selected,
    required this.categories,
    required this.onSelected,
  });
  final String selected;
  final List<String> categories;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 9,
    runSpacing: 9,
    children: categories
        .map(
          (item) => ChoiceChip(
            label: Text(item),
            selected: selected == item,
            onSelected: (_) => onSelected(item),
            selectedColor: _blue,
            backgroundColor: Colors.white,
            side: const BorderSide(color: _line),
            labelStyle: TextStyle(
              color: selected == item ? Colors.white : _text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        )
        .toList(),
  );
}

class _AchievementGrid extends StatelessWidget {
  const _AchievementGrid({required this.items});
  final List<_Achievement> items;
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 220),
    child: _ResponsiveGrid(
      key: ValueKey(items.map((e) => e.title).join('|')),
      minWidth: 300,
      children: items.map((e) => _AchievementCard(item: e)).toList(),
    ),
  );
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.item, this.featured = false});
  final _Achievement item;
  final bool featured;
  @override
  Widget build(BuildContext context) => _Card(
    padding: EdgeInsets.zero,
    clip: true,
    child: featured
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_Photo(item.image, height: 150), _Details(item)],
          )
        : SizedBox(
            height: 142,
            child: Row(
              children: [
                SizedBox(width: 126, child: _Photo(item.image)),
                Expanded(child: _Details(item)),
              ],
            ),
          ),
  );
}

class _Details extends StatelessWidget {
  const _Details(this.item);
  final _Achievement item;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Tag(item.category),
        const SizedBox(height: 8),
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _text,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 7),
        Text(item.student, style: const TextStyle(color: _muted, fontSize: 11)),
        const SizedBox(height: 8),
        Text(
          '${item.date}  •  ${item.level}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _muted, fontSize: 10),
        ),
      ],
    ),
  );
}

class _Fields extends StatelessWidget {
  const _Fields();
  @override
  Widget build(BuildContext context) {
    final fallback = [
      (
        'Olahraga',
        'Sportivitas dan semangat juang',
        Icons.sports_basketball,
        _blue,
      ),
      (
        'Seni & Budaya',
        'Kreativitas dan pelestarian budaya',
        Icons.palette,
        Color(0xFF7C51C7),
      ),
      (
        'Kepemimpinan',
        'Karakter pemimpin yang bertanggung jawab',
        Icons.groups,
        Color(0xFFF28B21),
      ),
      (
        'Kerohanian & Sosial',
        'Iman dan kepedulian kepada sesama',
        Icons.volunteer_activism,
        Color(0xFF21A76A),
      ),
    ];
    final saved = _rows(context, 'bidang');
    final data = saved.isEmpty
        ? fallback
        : List.generate(saved.length, (index) {
            const icons = [
              Icons.sports_basketball,
              Icons.palette,
              Icons.groups,
              Icons.volunteer_activism,
            ];
            const colors = [
              _blue,
              Color(0xFF7C51C7),
              Color(0xFFF28B21),
              Color(0xFF21A76A),
            ];
            final row = saved[index];
            return (
              '${row['judul']}',
              '${row['deskripsi']}',
              icons[index % icons.length],
              colors[index % colors.length],
            );
          });
    return Column(
      children: [
        const _Title('Bidang Prestasi'),
        const SizedBox(height: 25),
        LayoutBuilder(
          builder: (_, c) => c.maxWidth < 700
              ? Column(
                  children: data
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _Field(e),
                        ),
                      )
                      .toList(),
                )
              : Row(
                  children: data
                      .map((e) => Expanded(child: _Field(e)))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.data);
  final (String, String, IconData, Color) data;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      CircleAvatar(
        radius: 29,
        backgroundColor: data.$4.withValues(alpha: .1),
        child: Icon(data.$3, color: data.$4, size: 28),
      ),
      const SizedBox(height: 10),
      Text(
        data.$1,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 5),
      Text(
        data.$2,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _muted, fontSize: 11, height: 1.35),
      ),
    ],
  );
}

class _StudentStory extends StatelessWidget {
  const _StudentStory();
  @override
  Widget build(BuildContext context) => _Card(
    padding: EdgeInsets.zero,
    clip: true,
    child: LayoutBuilder(
      builder: (_, c) {
        final mobile = c.maxWidth < 700;
        final copy = Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Title(
                _contentText(
                  context,
                  'cerita_judul',
                  'Cerita Siswa Berprestasi',
                ),
              ),
              SizedBox(height: 14),
              Icon(Icons.format_quote_rounded, color: _blue, size: 36),
              Text(
                _contentText(
                  context,
                  'cerita_kutipan',
                  'Prestasi bukan hanya tentang menang, tetapi tentang proses, disiplin, dan tidak mudah menyerah.',
                ),
                style: TextStyle(
                  color: _text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.55,
                ),
              ),
              SizedBox(height: 18),
              Divider(color: _line),
              SizedBox(height: 10),
              Text(
                _contentText(
                  context,
                  'cerita_siswa',
                  'Nama Siswa  •  Kelas XI',
                ),
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                _contentText(
                  context,
                  'cerita_prestasi',
                  'Juara II Basket Tingkat Kabupaten',
                ),
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
        );
        if (mobile) {
          return Column(
            children: [
              _Photo(_contentText(context, 'cerita_gambar', ''), height: 230),
              copy,
            ],
          );
        }
        return SizedBox(
          height: 290,
          child: Row(
            children: [
              Expanded(
                child: _Photo(_contentText(context, 'cerita_gambar', '')),
              ),
              Expanded(child: copy),
            ],
          ),
        );
      },
    ),
  );
}

class _Coaching extends StatelessWidget {
  const _Coaching();
  @override
  Widget build(BuildContext context) {
    final fallback = [
      (
        'Pendampingan Guru',
        'Guru membimbing dan mengarahkan potensi siswa.',
        Icons.groups,
      ),
      (
        'Latihan Terarah',
        'Latihan rutin sesuai minat dan kemampuan.',
        Icons.track_changes,
      ),
      (
        'Mengikuti Kegiatan',
        'Siswa didorong mengikuti lomba dan kompetisi.',
        Icons.emoji_events,
      ),
      (
        'Apresiasi Sekolah',
        'Sekolah memberikan penghargaan dan dukungan.',
        Icons.workspace_premium,
      ),
    ];
    final saved = _rows(context, 'pembinaan');
    final data = saved.isEmpty
        ? fallback
        : List.generate(saved.length, (index) {
            const icons = [
              Icons.groups,
              Icons.track_changes,
              Icons.emoji_events,
              Icons.workspace_premium,
            ];
            final row = saved[index];
            return (
              '${row['judul']}',
              '${row['deskripsi']}',
              icons[index % icons.length],
            );
          });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Title('Pembinaan Bakat Siswa'),
        const SizedBox(height: 17),
        _ResponsiveGrid(
          minWidth: 235,
          children: data
              .asMap()
              .entries
              .map(
                (entry) => _Card(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFEAF2FF),
                        child: Icon(entry.value.$3, color: _blue),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key + 1}. ${entry.value.$1}',
                              style: const TextStyle(
                                color: _text,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              entry.value.$2,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                                height: 1.35,
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
        ),
      ],
    );
  }
}

class _Journey extends StatelessWidget {
  const _Journey();
  @override
  Widget build(BuildContext context) {
    final saved = _rows(context, 'perjalanan');
    final data = saved.isEmpty
        ? [('2023', '5'), ('2024', '7'), ('2025', '9'), ('2026', '12')]
        : saved.map((row) => ('${row['tahun']}', '${row['jumlah']}')).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Title('Perjalanan Prestasi'),
        const SizedBox(height: 27),
        LayoutBuilder(
          builder: (_, c) {
            if (c.maxWidth < 600) {
              return Column(children: data.map((e) => _Year(e)).toList());
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 2, color: _blue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: data.map((e) => _Year(e)).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Year extends StatelessWidget {
  const _Year(this.data);
  final (String, String) data;
  @override
  Widget build(BuildContext context) => Container(
    color: _background,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
    child: Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: _blue,
            child: Text(
              data.$1,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '${data.$2} Prestasi',
          style: const TextStyle(
            color: _text,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class _Documentation extends StatelessWidget {
  const _Documentation();
  @override
  Widget build(BuildContext context) {
    final saved = _rows(context, 'dokumentasi');
    final data = saved
        .map((row) => ('${row['judul']}', '${row['gambar']}'))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Title('Dokumentasi Kegiatan'),
        const SizedBox(height: 16),
        _ResponsiveGrid(
          minWidth: 280,
          children: data
              .map(
                (e) => _Card(
                  padding: EdgeInsets.zero,
                  clip: true,
                  child: Column(
                    children: [
                      _Photo(e.$2, height: 175),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          e.$1,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _CallToAction extends StatelessWidget {
  const _CallToAction();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [_navy, _blue]),
      borderRadius: BorderRadius.circular(16),
    ),
    child: LayoutBuilder(
      builder: (_, c) {
        final mobile = c.maxWidth < 700;
        final title = Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: _image(
                _contentText(context, 'logo', 'assets/images/logo_sekolah.png'),
                fallback: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 58,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _contentText(
                      context,
                      'cta_judul',
                      'Terus Berkarya dan Menginspirasi',
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _contentText(
                      context,
                      'cta_deskripsi',
                      'Mari mengembangkan potensi dan membawa nama baik SMAK.',
                    ),
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        );
        final buttons = Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.tonal(
              onPressed: () {},
              child: Text(
                _contentText(context, 'cta_tombol_1', 'Lihat Kegiatan Siswa'),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
              ),
              child: Text(
                _contentText(context, 'cta_tombol_2', 'Hubungi Sekolah'),
              ),
            ),
          ],
        );
        return mobile
            ? Column(children: [title, const SizedBox(height: 20), buttons])
            : Row(
                children: [
                  Expanded(child: title),
                  buttons,
                ],
              );
      },
    ),
  );
}

class _Photo extends StatelessWidget {
  const _Photo(this.asset, {this.height});
  final String asset;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: _image(
        asset,
        fallback: websiteFallbackImage(
          fit: BoxFit.cover,
          width: double.infinity,
          height: height,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.clip = false,
  });
  final Widget child;
  final EdgeInsets padding;
  final bool clip;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: clip ? Clip.antiAlias : Clip.none,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A0B326B),
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({
    super.key,
    required this.children,
    required this.minWidth,
  });
  final List<Widget> children;
  final double minWidth;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      final count = (c.maxWidth / minWidth).floor().clamp(1, 4);
      const gap = 14.0;
      final width = (c.maxWidth - gap * (count - 1)) / count;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: children
            .map((child) => SizedBox(width: width, child: child))
            .toList(),
      );
    },
  );
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _text,
      fontSize: 22,
      fontWeight: FontWeight.w800,
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: _blue.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: _blue,
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _Achievement {
  const _Achievement(
    this.title,
    this.category,
    this.date,
    this.level,
    this.image, [
    this.student = 'Nama Siswa',
  ]);

  factory _Achievement.fromRow(Map<String, dynamic> row) => _Achievement(
    '${row['judul'] ?? ''}',
    '${row['kategori'] ?? ''}',
    '${row['tanggal'] ?? ''}',
    '${row['tingkat'] ?? ''}',
    '${row['gambar'] ?? ''}',
    '${row['siswa'] ?? 'Nama Siswa'}',
  );
  final String title;
  final String category;
  final String date;
  final String level;
  final String image;
  final String student;
}

const categories = [
  'Semua',
  'Olahraga',
  'Seni & Budaya',
  'Organisasi',
  'Kerohanian & Sosial',
];

const achievements = [
  _Achievement(
    'Juara I Futsal Putra',
    'Olahraga',
    'Maret 2026',
    'Kabupaten',
    'assets/images/prestasi_siswa/futsal.jpg',
  ),
  _Achievement(
    'Juara II Tenis Meja',
    'Olahraga',
    'Juni 2026',
    'Kabupaten',
    'assets/images/prestasi_siswa/tenis_meja.jpg',
  ),
  _Achievement(
    'Juara Harapan I Tari',
    'Seni & Budaya',
    'Mei 2026',
    'Kabupaten',
    'assets/images/prestasi_siswa/tari.jpg',
  ),
  _Achievement(
    'Juara II Band Pelajar',
    'Seni & Budaya',
    'Juni 2026',
    'Kabupaten',
    'assets/images/prestasi_siswa/band.jpg',
  ),
  _Achievement(
    'Juara II Lomba PMR',
    'Organisasi',
    'April 2026',
    'Kabupaten',
    'assets/images/prestasi_siswa/pmr.jpg',
  ),
  _Achievement(
    'Juara I Paduan Suara Rohani',
    'Kerohanian & Sosial',
    'Maret 2026',
    'Kabupaten',
    'assets/images/prestasi_siswa/paduan_suara.jpg',
  ),
];
