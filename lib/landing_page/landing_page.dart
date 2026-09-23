import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'site_chrome.dart';
import '../services/smak_api.dart';
import '../services/website_identity.dart';
import '../routing/public_routes.dart';

void openMapLink(String url) {
  html.window.open(url, '_blank');
}

void _openLandingLink(BuildContext context, String link) {
  final value = link.trim();
  if (value.isEmpty) return;
  if (value.startsWith('http://') || value.startsWith('https://')) {
    html.window.open(value, '_blank');
    return;
  }
  final normalized = value.toLowerCase();
  final route = normalized.contains('ppdb')
      ? PublicRoutes.admissions
      : normalized.contains('kontak')
      ? PublicRoutes.contact
      : normalized.contains('visi')
      ? PublicRoutes.profileVisionMission
      : normalized.contains('sejarah')
      ? PublicRoutes.profileHistory
      : normalized.contains('sambutan')
      ? PublicRoutes.profileWelcome
      : normalized.contains('sarana')
      ? PublicRoutes.profileFacilities
      : normalized.contains('struktur')
      ? PublicRoutes.profileOrganization
      : normalized.contains('kurikulum')
      ? PublicRoutes.academicCurriculum
      : normalized.contains('jadwal')
      ? PublicRoutes.academicSchedule
      : normalized.contains('kalender')
      ? PublicRoutes.academicCalendar
      : normalized.contains('prestasi-akademik')
      ? PublicRoutes.academicAchievements
      : normalized.contains('ekstrakurikuler')
      ? PublicRoutes.extracurricular
      : normalized.contains('osis')
      ? PublicRoutes.studentCouncil
      : normalized.contains('tata-tertib')
      ? PublicRoutes.studentRules
      : normalized.contains('prestasi-siswa')
      ? PublicRoutes.studentAchievements
      : normalized.contains('berita')
      ? PublicRoutes.news
      : normalized.contains('galeri')
      ? PublicRoutes.gallery
      : normalized.contains('profil')
      ? PublicRoutes.profileIdentity
      : null;
  if (route != null) {
    publicRootNavigator(context).pushNamed(route);
  } else {
    html.window.open(value, '_blank');
  }
}

enum LandingSection { top, ppdb, contact }

class _LandingMetadataScope extends InheritedWidget {
  const _LandingMetadataScope({required this.data, required super.child});
  final Map<String, dynamic> data;
  static Map<String, dynamic> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LandingMetadataScope>()?.data ?? const {};
  @override
  bool updateShouldNotify(_LandingMetadataScope oldWidget) => data != oldWidget.data;
}

String _landingText(BuildContext context, String key, String fallback) {
  final value = '${_LandingMetadataScope.of(context)[key] ?? ''}'.trim();
  return value.isEmpty ? fallback : value;
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.initialSection = LandingSection.top});

  final LandingSection initialSection;

  static const _blue = Color(0xFF064BAA);
  static const _darkBlue = Color(0xFF062C64);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _ppdbKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openInitialSection());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openInitialSection() {
    final targetKey = switch (widget.initialSection) {
      LandingSection.top => null,
      LandingSection.ppdb => _ppdbKey,
      LandingSection.contact => _contactKey,
    };
    final targetContext = targetKey?.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        alignment: widget.initialSection == LandingSection.contact ? 1 : .15,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: const SmakApi().getTable('beranda_slider', limit: 10),
      builder: (context, snapshot) {
        final slides = snapshot.data ?? const <Map<String, dynamic>>[];
        final metadata = slides.isEmpty ? const <String, dynamic>{} : slides.first;
        return _LandingMetadataScope(data: metadata, child: Scaffold(
      body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: SharedSmakNavigationBar(
                profilePages: sharedProfilePages(),
                academicPages: sharedAcademicPages(),
                studentPages: sharedStudentPages(),
                initialActive: 'Beranda',
              ),
            ),
            SliverToBoxAdapter(
              child: _HeroSection(slides: slides),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: Offset.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: KeyedSubtree(
                    key: _ppdbKey,
                    child: const _FeatureStrip(),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _MainContent()),
            SliverToBoxAdapter(
              child: KeyedSubtree(key: _contactKey, child: const SmakFooter()),
            ),
          ],
        ),
    ));});
  }
}

class _HeroSection extends StatefulWidget {
  const _HeroSection({required this.slides});
  final List<Map<String, dynamic>> slides;

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  final _pageController = PageController();
  Timer? _autoSlideTimer;
  var _currentPage = 0;

  List<Map<String, dynamic>> get _slides => widget.slides
      .where((slide) => '${slide['status'] ?? 'aktif'}' == 'aktif')
      .toList();

  Map<String, dynamic>? get _heroContent {
    if (widget.slides.isEmpty) return null;
    final rows = [...widget.slides]
      ..sort(
        (a, b) => (int.tryParse('${a['urutan'] ?? ''}') ?? 0).compareTo(
          int.tryParse('${b['urutan'] ?? ''}') ?? 0,
        ),
      );
    return rows.first;
  }

  int get _pageCount => _slides.isEmpty ? 1 : _slides.length;

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients || !mounted) return;
      if (_pageCount < 2) return;
      final nextPage = (_currentPage + 1) % _pageCount;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  void _openHeroLink(String link) {
    _openLandingLink(context, link);
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant _HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentPage >= _pageCount) {
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    final heroContent = _heroContent;
    final heroTitle = '${heroContent?['judul'] ?? 'Selamat Datang di'}';
    final heroShortName = '${heroContent?['nama_singkat'] ?? ''}'.trim().isEmpty
        ? 'SMAK'
        : '${heroContent?['nama_singkat']}'.trim();
    final heroLongName = '${heroContent?['nama_panjang'] ?? ''}'.trim().isEmpty
        ? 'Sekolah Menengah Atas Katolik'
        : '${heroContent?['nama_panjang']}'.trim();
    final heroSubtitle =
        '${heroContent?['subjudul'] ?? 'Membentuk generasi unggul, berkarakter, beriman, dan berwawasan global.'}';
    final button1Text = '${heroContent?['teks_tombol_1'] ?? 'Profil Sekolah'}';
    final button1Link = '${heroContent?['link_tombol_1'] ?? '/profil'}';
    final button2Text = '${heroContent?['teks_tombol_2'] ?? 'PPDB Online'}';
    final button2Link = '${heroContent?['link_tombol_2'] ?? '/ppdb'}';
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 700;
    final heroHeight = compact
        ? 500.0
        : (screenWidth * .43).clamp(455.0, 650.0);
    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pageCount,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) => _SchoolIllustration(
              image: index < slides.length
                  ? '${slides[index]['gambar'] ?? ''}'
                  : '',
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF073C82),
                  Color(0xFF073C82),
                  Color(0xB2073C82),
                  Color(0x55073C82),
                  Color(0x00073C82),
                ],
                stops: [0, .30, .52, .75, 1],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 20 : 48),
            child: Align(
              alignment: compact ? Alignment.topLeft : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: compact ? 117 : 0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        heroTitle,
                        style: TextStyle(
                          color: Color(0xFFFFD429),
                          fontSize: compact ? 15 : 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: compact ? 7 : 10),
                      Text(
                        heroShortName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 46 : 74,
                          fontWeight: FontWeight.w900,
                          height: .95,
                        ),
                      ),
                      SizedBox(height: compact ? 7 : 9),
                      Text(
                        heroLongName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 18 : 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: compact ? 12 : 18),
                      Text(
                        heroSubtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 14 : 16,
                          height: compact ? 1.55 : 1.85,
                        ),
                      ),
                      SizedBox(height: compact ? 18 : 25),
                      Wrap(
                        spacing: 14,
                        runSpacing: 12,
                        children: [
                          _HeroButton(
                            label: button1Text,
                            icon: Icons.school_rounded,
                            filled: true,
                            onPressed: () => _openHeroLink(button1Link),
                          ),
                          _HeroButton(
                            label: button2Text,
                            icon: Icons.group_rounded,
                            onPressed: () => _openHeroLink(button2Link),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, .86),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                _pageCount,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: index == _currentPage ? 11 : 9,
                  height: index == _currentPage ? 11 : 9,
                  decoration: BoxDecoration(
                    color: index == _currentPage
                        ? Colors.white
                        : Colors.white.withOpacity(.38),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(.72),
                      width: 1,
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

class _SchoolIllustration extends StatelessWidget {
  const _SchoolIllustration({required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final source = image.trim();
        final bannerImage = websiteContentImage(source, fit: BoxFit.cover);
        return Container(
          color: const Color(0xFF0A437F),
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: compact ? 1 : .78,
            heightFactor: 1,
            child: bannerImage,
          ),
        );
      },
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({required this.width});
  final double width;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: 26,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.64),
      borderRadius: BorderRadius.circular(40),
    ),
  );
}

class _Tree extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(width: 11, height: 60, color: const Color(0xFF64452A)),
      Container(
        width: 85,
        height: 92,
        decoration: const BoxDecoration(
          color: Color(0xFF2B703B),
          shape: BoxShape.circle,
        ),
      ),
    ],
  );
}

class _Building extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 650,
      height: 275,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 640,
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F9),
              border: Border.all(color: const Color(0xFF2B5E9A), width: 5),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 160,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F4),
                border: Border.all(color: const Color(0xFF2B5E9A), width: 5),
              ),
            ),
          ),
          Positioned(
            bottom: 220,
            child: Container(
              width: 0,
              height: 0,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF9B6B46), width: 28),
                  left: BorderSide(color: Colors.transparent, width: 106),
                  right: BorderSide(color: Colors.transparent, width: 106),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 34,
            child: Container(
              width: 104,
              height: 80,
              color: const Color(0xFF163D69),
            ),
          ),
          ...List.generate(
            11,
            (index) => Positioned(
              left: 25 + (index % 7) * 85.0,
              bottom: 80 + (index ~/ 7) * 62.0,
              child: Container(
                width: 48,
                height: 32,
                color: const Color(0xFF2D6FAA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.label,
    required this.icon,
    this.filled = false,
    this.onPressed,
  });
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    return FilledButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: compact ? 18 : 20),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: filled ? const Color(0xFF1263E5) : Colors.white,
        foregroundColor: filled ? Colors.white : const Color(0xFF092B5A),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 18,
          vertical: compact ? 13 : 17,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
    );
  }
}

class _FeatureStrip extends StatelessWidget {
  const _FeatureStrip();

  IconData _icon(String value) => switch (value) {
    'book' => Icons.menu_book_rounded,
    'groups' => Icons.groups_rounded,
    'emoji_events' => Icons.emoji_events_rounded,
    'church' => Icons.church_rounded,
    _ => Icons.auto_awesome_rounded,
  };

  Color _color(String value) {
    final parsed = int.tryParse(value.replaceFirst('#', ''), radix: 16);
    return parsed == null
        ? const Color(0xFF0756C8)
        : Color(0xFF000000 | parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1270),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: const SmakApi().getTable('beranda_keunggulan', limit: 12),
          builder: (context, snapshot) {
            final rows =
                snapshot.data
                    ?.where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
                    .toList() ??
                const <Map<String, dynamic>>[];
            final items = rows
                .map(
                  (row) => _Feature(
                    icon: _icon('${row['icon'] ?? ''}'),
                    title: '${row['judul'] ?? ''}',
                    description: '${row['deskripsi'] ?? ''}',
                    color: _color('${row['warna'] ?? ''}'),
                  ),
                )
                .toList();
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width < 600 ? 16 : 22,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18072F69),
                    blurRadius: 28,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const fallback = [
                    _Feature(
                      icon: Icons.menu_book_rounded,
                      title: 'Akademik',
                      description:
                          'Kurikulum berkualitas untuk prestasi terbaik',
                      color: Color(0xFF0756C8),
                    ),
                    _Feature(
                      icon: Icons.groups_rounded,
                      title: 'Kesiswaan',
                      description: 'Pengembangan minat dan bakat siswa',
                      color: Color(0xFF28B56C),
                    ),
                    _Feature(
                      icon: Icons.emoji_events_rounded,
                      title: 'Prestasi',
                      description:
                          'Berprestasi di tingkat nasional & internasional',
                      color: Color(0xFFF2AD0C),
                    ),
                    _Feature(
                      icon: Icons.church_rounded,
                      title: 'Beriman',
                      description:
                          'Pembentukan karakter dan nilai-nilai Katolik',
                      color: Color(0xFF7D55D9),
                    ),
                  ];

                  final features = items.isEmpty ? fallback : items;
                  if (constraints.maxWidth < 680) {
                    return Column(
                      children: [
                        for (
                          var index = 0;
                          index < features.length;
                          index++
                        ) ...[
                          _FeatureRowItem(child: features[index]),
                          if (index < features.length - 1)
                            const Divider(height: 28),
                        ],
                      ],
                    );
                  }

                  return Wrap(
                    alignment: WrapAlignment.spaceAround,
                    runAlignment: WrapAlignment.center,
                    spacing: 18,
                    runSpacing: 24,
                    children: features,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureRowItem extends StatelessWidget {
  const _FeatureRowItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Align(alignment: Alignment.centerLeft, child: child);
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
  final IconData icon;
  final String title, description;
  final Color color;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 260),
    child: Row(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 31),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0B1D40),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.55,
                  color: Color(0xFF253858),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      _AboutSmakSection(),
      _PrincipalWelcomeSection(),
      _ProgramsSection(),
      _StudentLifeSection(),
      _LandingSection(child: _LandingShowcaseSection()),
      _AchievementSection(),
      _PpdbCampaignSection(),
      _VisitSection(),
    ],
  );
}

class _AboutSmakSection extends StatelessWidget {
  const _AboutSmakSection();

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: const SmakApi().getTable('beranda_tentang', limit: 1),
        builder: (context, snapshot) {
          final rows =
              snapshot.data
                  ?.where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
                  .toList() ??
              const <Map<String, dynamic>>[];
          final data = rows.isEmpty ? const <String, dynamic>{} : rows.first;
          final storedImage = '${data['gambar'] ?? ''}'.trim();
          final image = _LandingAssetImage(
            path: storedImage,
            height: 410,
            badge: 'Sejak\n1983',
          );
          final content = _AboutText(data: data);
          return _LandingSection(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 850;
                return compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [image, const SizedBox(height: 28), content],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 5, child: image),
                          const SizedBox(width: 52),
                          Expanded(flex: 6, child: content),
                        ],
                      );
              },
            ),
          );
        },
      );
}

class _AboutText extends StatelessWidget {
  const _AboutText({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionEyebrow(
          '${data['label'] ?? 'MENGENAL LEBIH DEKAT'}'.toUpperCase(),
        ),
        const SizedBox(height: 10),
        Text(
          '${data['judul'] ?? 'Pendidikan yang Bertumbuh dalam Iman dan Ilmu'}',
          style: TextStyle(
            color: Color(0xFF082E65),
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          '${data['deskripsi'] ?? 'SMAK Mgr. Soegijapranata adalah sekolah menengah atas Katolik yang berkomitmen membentuk generasi muda yang unggul secara akademik, berkarakter kuat, beriman, serta berwawasan global.'}',
          style: TextStyle(color: Color(0xFF52647C), fontSize: 14, height: 1.7),
        ),
        const SizedBox(height: 24),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MiniFact(Icons.verified_rounded, 'Akreditasi', 'A'),
            _MiniFact(Icons.groups_rounded, 'Tenaga Pendidik', '40+'),
            _MiniFact(Icons.star_rounded, 'Ekstrakurikuler', '15+'),
            _MiniFact(Icons.calendar_month_rounded, 'Berdiri Sejak', '1983'),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => _openLandingLink(context, _landingText(context, 'link_tombol_tentang', PublicRoutes.profileIdentity)),
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: Text(_landingText(context, 'teks_tombol_tentang', 'Selengkapnya')),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrincipalWelcomeSection extends StatelessWidget {
  const _PrincipalWelcomeSection();

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: const SmakApi().getTable('sambutan_kepala_sekolah', limit: 1),
        builder: (context, snapshot) {
          final rows =
              snapshot.data
                  ?.where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
                  .toList() ??
              const <Map<String, dynamic>>[];
          if (rows.isEmpty) return const SizedBox.shrink();
          final data = rows.first;
          final image = '${data['gambar'] ?? ''}'.trim();
          return _LandingSection(
            background: const Color(0xFFF0F6FD),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F1FD),
                borderRadius: BorderRadius.circular(22),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 760;
                  final portrait = ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      width: compact ? double.infinity : 245,
                      height: compact ? 300 : 310,
                      child: websiteContentImage(
                        image,
                        fit: BoxFit.cover,
                        width: compact ? double.infinity : 245,
                        height: compact ? 300 : 310,
                      ),
                    ),
                  );
                  final text = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SectionEyebrow(
                        '${data['judul'] ?? 'Sambutan Kepala Sekolah'}'
                            .toUpperCase(),
                      ),
                      const SizedBox(height: 12),
                      const Icon(
                        Icons.format_quote_rounded,
                        size: 44,
                        color: Color(0xFF73A7E9),
                      ),
                      Text(
                        '${data['isi'] ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF375270),
                          fontSize: 15,
                          height: 1.75,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '${data['nama_kepala'] ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF082E65),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${data['jabatan'] ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF65758B),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: () => _openLandingLink(context, _landingText(context, 'link_tombol_sambutan', PublicRoutes.profileWelcome)),
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                        label: Text(_landingText(context, 'teks_tombol_sambutan', 'Baca Sambutan')),
                      ),
                    ],
                  );
                  return compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            portrait,
                            const SizedBox(height: 26),
                            text,
                          ],
                        )
                      : Row(
                          children: [
                            portrait,
                            const SizedBox(width: 40),
                            Expanded(child: text),
                          ],
                        );
                },
              ),
            ),
          );
        },
      );
}

class _ProgramsSection extends StatelessWidget {
  const _ProgramsSection();

  IconData _icon(String value) => switch (value) {
    'church' => Icons.church_rounded,
    'emoji_events' => Icons.emoji_events_rounded,
    'computer' => Icons.computer_rounded,
    'developer_board' => Icons.developer_board_rounded,
    _ => Icons.auto_awesome_rounded,
  };

  Color _color(String value) {
    final hex = int.tryParse(value.replaceFirst('#', ''), radix: 16);
    return hex == null ? const Color(0xFF0756C8) : Color(0xFF000000 | hex);
  }

  @override
  Widget build(
    BuildContext context,
  ) => FutureBuilder<List<Map<String, dynamic>>>(
    future: const SmakApi().getTable('beranda_program', limit: 12),
    builder: (context, snapshot) {
      final rows =
          snapshot.data
              ?.where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
              .toList() ??
          const <Map<String, dynamic>>[];
      final programs = rows
          .map(
            (row) => _ProgramData(
              '${row['judul'] ?? ''}',
              '${row['deskripsi'] ?? ''}',
              _icon('${row['icon'] ?? ''}'),
              _color('${row['warna'] ?? ''}'),
              '${row['gambar'] ?? ''}',
            ),
          )
          .toList();
      return _LandingSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LandingHeading(
              title: _landingText(context, 'judul_program', 'Program Unggulan'),
              subtitle: _landingText(context, 'subjudul_program', 'Program terpilih yang dirancang untuk mendukung perkembangan akademik, karakter, dan minat siswa.'),
            ),
            const SizedBox(height: 26),
            LayoutBuilder(
              builder: (context, constraints) {
                final count = constraints.maxWidth >= 1050
                    ? 4
                    : constraints.maxWidth >= 600
                    ? 2
                    : 1;
                return GridView.count(
                  crossAxisCount: count,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: count == 1 ? 1.55 : .78,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: programs.isEmpty
                      ? const [
                          Center(child: Text('Belum ada program unggulan.')),
                        ]
                      : programs.map((item) => _ProgramCard(item)).toList(),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

class _StudentLifeSection extends StatelessWidget {
  const _StudentLifeSection();

  @override
  Widget build(
    BuildContext context,
  ) => FutureBuilder<List<Map<String, dynamic>>>(
    future: const SmakApi().getTable('beranda_kehidupan', limit: 12),
    builder: (context, snapshot) {
      final rows =
          snapshot.data
              ?.where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
              .toList() ??
          const <Map<String, dynamic>>[];
      return _LandingSection(
        background: const Color(0xFFF3F7FC),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 850;
            final intro = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LandingHeading(
                  title: _landingText(context, 'judul_kehidupan', 'Kehidupan di SMAK'),
                  subtitle: _landingText(context, 'subjudul_kehidupan', 'Belajar, beriman, berkreasi, dan berkolaborasi dalam lingkungan yang hangat dan mendukung.'),
                ),
                SizedBox(height: 22),
                _KesiswaanButton(),
              ],
            );
            final collage = _LifeCollage(items: rows);
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, SizedBox(height: 28), collage],
              );
            }
            return Row(
              children: [
                Expanded(flex: 4, child: intro),
                SizedBox(width: 42),
                Expanded(flex: 7, child: collage),
              ],
            );
          },
        ),
      );
    },
  );
}

class _AchievementSection extends StatelessWidget {
  const _AchievementSection();

  IconData _icon(String value, int index) => switch (value) {
    'emoji_events' => Icons.emoji_events_rounded,
    'star' => Icons.star_rounded,
    'groups' => Icons.groups_rounded,
    'verified' => Icons.verified_rounded,
    _ => const [
      Icons.verified_rounded,
      Icons.emoji_events_rounded,
      Icons.star_rounded,
      Icons.groups_rounded,
    ][index % 4],
  };

  @override
  Widget build(BuildContext context) {
    return _LandingSection(
      background: const Color(0xFFEAF3FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LandingHeading(
            title: _landingText(context, 'judul_prestasi', 'Prestasi & Jejak Kami'),
            subtitle: _landingText(context, 'subjudul_prestasi', 'Tumbuh bersama dalam prestasi, karakter, dan pelayanan.'),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final stats = FutureBuilder<List<Map<String, dynamic>>>(
                future: const SmakApi().getTable(
                  'beranda_statistik',
                  limit: 12,
                ),
                builder: (context, snapshot) {
                  final rows =
                      snapshot.data
                          ?.where(
                            (row) => '${row['status'] ?? 'aktif'}' == 'aktif',
                          )
                          .toList() ??
                      const <Map<String, dynamic>>[];
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: rows.isEmpty
                        ? const [
                            _AchievementStat(
                              Icons.verified_rounded,
                              'A',
                              'Akreditasi',
                            ),
                          ]
                        : [
                            for (var index = 0; index < rows.length; index++)
                              _AchievementStat(
                                _icon('${rows[index]['icon'] ?? ''}', index),
                                '${rows[index]['nilai'] ?? ''}',
                                '${rows[index]['judul'] ?? ''}',
                              ),
                          ],
                  );
                },
              );
              final testimonials = FutureBuilder<List<Map<String, dynamic>>>(
                future: const SmakApi().getTable('beranda_testimoni', limit: 8),
                builder: (context, snapshot) {
                  final rows =
                      snapshot.data
                          ?.where(
                            (row) => '${row['status'] ?? 'aktif'}' == 'aktif',
                          )
                          .toList() ??
                      const <Map<String, dynamic>>[];
                  return Column(
                    children: [
                      for (var index = 0; index < rows.length; index++) ...[
                        _TestimonialCard(
                          name: '${rows[index]['judul'] ?? ''}',
                          role: '${rows[index]['peran'] ?? ''}',
                          text: '${rows[index]['deskripsi'] ?? ''}',
                        ),
                        if (index < rows.length - 1) const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
              );

              if (compact) {
                return Column(
                  children: [stats, SizedBox(height: 20), testimonials],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: stats),
                  SizedBox(width: 24),
                  Expanded(flex: 6, child: testimonials),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PpdbCampaignSection extends StatelessWidget {
  const _PpdbCampaignSection();

  @override
  Widget build(
    BuildContext context,
  ) => FutureBuilder<List<Map<String, dynamic>>>(
    future: const SmakApi().getTable('beranda_ppdb', limit: 1),
    builder: (context, snapshot) {
      final rows =
          snapshot.data
              ?.where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
              .toList() ??
          const <Map<String, dynamic>>[];
      if (rows.isEmpty) return const SizedBox.shrink();
      final data = rows.first;
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 330),
        decoration: const BoxDecoration(color: Color(0xFF082E65)),
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Color(0xFF164D8D))),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF082E65),
                      Color(0xF2082E65),
                      Color(0xB8082E65),
                      Color(0x55082E65),
                    ],
                    stops: [0, .45, .72, 1],
                  ),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1270),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 52,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD32A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${data['label'] ?? ''}',
                              style: TextStyle(
                                color: Color(0xFF082E65),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          Text(
                            '${data['judul'] ?? ''}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${data['deskripsi'] ?? ''}',
                            style: TextStyle(
                              color: Color(0xFFE8F1FD),
                              height: 1.65,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              FilledButton.icon(
                                onPressed: () => _openLandingLink(
                                  context,
                                  '${data['link_tombol_1'] ?? '/ppdb'}',
                                ),
                                iconAlignment: IconAlignment.end,
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: Text(
                                  '${data['teks_tombol_1'] ?? 'Daftar Sekarang'}',
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF0756C8),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => _openLandingLink(
                                  context,
                                  '${data['link_tombol_2'] ?? '/ppdb'}',
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                child: Text(
                                  '${data['teks_tombol_2'] ?? 'Informasi PPDB'}',
                                ),
                              ),
                            ],
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
    },
  );
}

class _VisitSection extends StatelessWidget {
  const _VisitSection();

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: const SmakApi().getTable('beranda_kontak', limit: 8),
        builder: (context, snapshot) {
          final rows =
              snapshot.data
                  ?.where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
                  .toList() ??
              const <Map<String, dynamic>>[];
          if (rows.isEmpty) return const SizedBox.shrink();
          final locationRow = rows.firstWhere(
            (row) => '${row['icon'] ?? ''}'.contains('location') &&
                '${row['link'] ?? ''}'.trim().isNotEmpty,
            orElse: () => rows.firstWhere(
              (row) => '${row['link'] ?? ''}'.trim().isNotEmpty,
              orElse: () => const <String, dynamic>{},
            ),
          );
          return _LandingSection(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14082E65),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.center,
                spacing: 22,
                runSpacing: 20,
                children: [
                  ...rows.map((row) {
                    final icon = switch ('${row['icon'] ?? ''}') {
                      'phone' => Icons.phone_rounded,
                      'schedule' => Icons.schedule_rounded,
                      _ => Icons.location_on_rounded,
                    };
                    return _VisitItem(
                      icon,
                      '${row['judul'] ?? ''}',
                      '${row['deskripsi'] ?? ''}',
                      link: '${row['link'] ?? ''}',
                    );
                  }),
                  _LocationButton(
                    link: '${locationRow['link'] ?? ''}',
                  ),
                  if (false) ...[
                    _VisitItem(
                      Icons.location_on_rounded,
                      'Kunjungi SMAK',
                      'Jl. Diponegoro No. 63, Lumajang',
                    ),
                    _VisitItem(
                      Icons.phone_rounded,
                      'Hubungi Kami',
                      '(0334) 890123',
                    ),
                    _VisitItem(
                      Icons.schedule_rounded,
                      'Jam Operasional',
                      'Senin–Jumat, 07.00–15.00 WIB',
                    ),
                    _LocationButton(link: ''),
                  ],
                ],
              ),
            ),
          );
        },
      );
}

class _LandingSection extends StatelessWidget {
  const _LandingSection({required this.child, this.background = Colors.white});

  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.symmetric(
        horizontal: width < 600 ? 18 : 24,
        vertical: width < 700 ? 52 : 76,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1270),
          child: child,
        ),
      ),
    );
  }
}

class _LandingAssetImage extends StatelessWidget {
  const _LandingAssetImage({
    required this.path,
    required this.height,
    this.badge,
    this.networkImage,
  });

  final String path;
  final double height;
  final String? badge;
  final String? networkImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: networkImage != null
                  ? Image.network(
                      networkImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          websiteContentImage(path, fit: BoxFit.cover),
                    )
                  : websiteContentImage(path, fit: BoxFit.cover),
            ),
          ),
          if (badge != null)
            Positioned(
              left: -12,
              top: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0756C8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Color(0x24000000), blurRadius: 12),
                  ],
                ),
                child: Text(
                  badge!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  const _SectionEyebrow(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF0756C8),
      fontSize: 12,
      letterSpacing: .7,
      fontWeight: FontWeight.w900,
    ),
  );
}

class _LandingHeading extends StatelessWidget {
  const _LandingHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF082E65),
            fontSize: compact ? 24 : 29,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: TextStyle(
            color: const Color(0xFF617187),
            height: 1.55,
            fontSize: compact ? 12.5 : 13,
          ),
        ),
      ],
    );
  }
}

class _MiniFact extends StatelessWidget {
  const _MiniFact(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    width: 130,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2EAF4)),
    ),
    child: Column(
      children: [
        Icon(icon, color: const Color(0xFF0756C8), size: 22),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF082E65),
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF718096), fontSize: 9.5),
        ),
      ],
    ),
  );
}

class _ProgramData {
  const _ProgramData(
    this.title,
    this.description,
    this.icon,
    this.color,
    this.image,
  );
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String image;
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard(this.data);
  final _ProgramData data;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: const Color(0xFFE2EAF4)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F082E65),
          blurRadius: 18,
          offset: Offset(0, 7),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: websiteContentImage(data.image, fit: BoxFit.cover),
              ),
              Positioned(
                left: 16,
                bottom: -21,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 23),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF082E65),
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    data.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF65758A),
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF0756C8),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _KesiswaanButton extends StatelessWidget {
  const _KesiswaanButton();

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: () => _openLandingLink(context, _landingText(context, 'link_tombol_kesiswaan', PublicRoutes.extracurricular)),
    iconAlignment: IconAlignment.end,
    icon: const Icon(Icons.arrow_forward_rounded),
    label: Text(_landingText(context, 'teks_tombol_kesiswaan', 'Jelajahi Kesiswaan')),
  );
}

class _LifeCollage extends StatelessWidget {
  const _LifeCollage({required this.items});
  final List<Map<String, dynamic>> items;

  _LifeTile _tile(int index, String fallbackTitle, IconData fallbackIcon) {
    if (index >= items.length)
      return _LifeTile(fallbackTitle, '', fallbackIcon);
    final row = items[index];
    return _LifeTile(
      '${row['judul'] ?? fallbackTitle}',
      '${row['gambar'] ?? ''}',
      fallbackIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _tile(0, 'Akademik', Icons.menu_book_rounded),
                ),
                SizedBox(width: 10),
                Expanded(child: _tile(1, 'Ibadah', Icons.church_rounded)),
                SizedBox(width: 10),
                Expanded(
                  child: _tile(2, 'Olahraga', Icons.sports_basketball_rounded),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _tile(3, 'Seni & Budaya', Icons.palette_rounded),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _tile(4, 'Organisasi Siswa', Icons.groups_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LifeTile extends StatelessWidget {
  const _LifeTile(this.title, this.image, this.icon);
  final String title;
  final String image;
  final IconData icon;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(13),
    child: Stack(
      fit: StackFit.expand,
      children: [
        websiteContentImage(image, fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xB0001738)],
            ),
          ),
        ),
        Positioned(
          left: 13,
          bottom: 12,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    ),
  );
}

class _AchievementStat extends StatelessWidget {
  const _AchievementStat(this.icon, this.value, this.label);
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    width: 125,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Icon(icon, color: const Color(0xFF0756C8), size: 28),
        const SizedBox(height: 9),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF082E65),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF697A90), fontSize: 10),
        ),
      ],
    ),
  );
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({
    required this.name,
    required this.role,
    required this.text,
  });
  final String name;
  final String role;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFDCEBFC),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_rounded, color: Color(0xFF0756C8)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.format_quote_rounded,
                color: Color(0xFF9ABBE8),
                size: 27,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF52647C),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF082E65),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              Text(
                role,
                style: const TextStyle(color: Color(0xFF77869A), fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _VisitItem extends StatelessWidget {
  const _VisitItem(this.icon, this.title, this.detail, {this.link = ''});
  final IconData icon;
  final String title;
  final String detail;
  final String link;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: link.trim().isEmpty ? null : () => _openLandingLink(context, link),
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      width: 245,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0756C8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF082E65),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    color: Color(0xFF65758A),
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
  );
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({required this.link});
  final String link;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () => openMapLink(link.trim().isEmpty
        ? globalWebsiteText(context, 'link_maps', 'https://www.google.com/maps/search/?api=1&query=SMAK+Mgr.+Soegijapranata+Lumajang')
        : link),
    icon: const Icon(Icons.map_rounded),
    label: Text(_landingText(context, 'teks_tombol_lokasi', 'Lihat Lokasi')),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );
}

class _LandingShowcaseSection extends StatelessWidget {
  const _LandingShowcaseSection();

  void _openNews(BuildContext context) {
    publicRootNavigator(context).pushNamed(PublicRoutes.news);
  }

  void _openGallery(BuildContext context) {
    publicRootNavigator(context).pushNamed(PublicRoutes.gallery);
  }

  @override
  Widget build(BuildContext context) {
    final api = const SmakApi();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1270),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            api.getTable('berita', limit: 4),
            api.getTable('galeri', limit: 6),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 72),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final data = snapshot.data ?? const <dynamic>[];
            final news = data.isNotEmpty
                ? (data[0] as List).cast<Map<String, dynamic>>()
                : const <Map<String, dynamic>>[];
            final gallery = data.length > 1
                ? (data[1] as List).cast<Map<String, dynamic>>()
                : const <Map<String, dynamic>>[];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LandingNewsColumn(
                  items: news,
                  onOpenAll: () => _openNews(context),
                ),
                const SizedBox(height: 62),
                _LandingGalleryColumn(
                  items: gallery,
                  onOpenAll: () => _openGallery(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LandingNewsColumn extends StatelessWidget {
  const _LandingNewsColumn({required this.items, required this.onOpenAll});

  final List<Map<String, dynamic>> items;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    final rows = items.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _landingText(context, 'judul_berita', 'Berita & Pengumuman'),
          style: TextStyle(
            color: Color(0xFF0B2D60),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        if (rows.isEmpty)
          const Text(
            'Belum ada berita dari database.',
            style: TextStyle(color: Color(0xFF526178)),
          )
        else
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _LandingNewsCard(
                tag: '${row['kategori'] ?? 'Berita'}'.toUpperCase(),
                title: '${row['judul'] ?? ''}',
                text: '${row['deskripsi'] ?? ''}',
                onTap: onOpenAll,
              ),
            ),
          ),
      ],
    );
  }
}

class _LandingNewsCard extends StatelessWidget {
  const _LandingNewsCard({
    required this.tag,
    required this.title,
    required this.text,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140F172A),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 148,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A79A2), Color(0xFF18355E)],
                  ),
                ),
                child: const Icon(
                  Icons.article_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Color(0xFF1361D8),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF092753),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF63758D),
                          fontSize: 12.5,
                          height: 1.45,
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
}

class _LandingGalleryColumn extends StatelessWidget {
  const _LandingGalleryColumn({required this.items, required this.onOpenAll});

  final List<Map<String, dynamic>> items;
  final VoidCallback onOpenAll;

  String _imageUrl(Map<String, dynamic> row) {
    final storedImage = '${row['gambar'] ?? row['foto'] ?? ''}'.trim();
    return storedImage;
  }

  @override
  Widget build(BuildContext context) {
    final topItems = items.take(3).toList();
    final bottomItems = items.skip(3).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _landingText(context, 'judul_galeri', 'Galeri Kegiatan'),
          style: TextStyle(
            color: Color(0xFF0B2D60),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;
            return Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topItems.isEmpty ? 3 : topItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: compact ? 1 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: compact ? 2.15 : 1.72,
                  ),
                  itemBuilder: (context, index) {
                    final row = topItems.isEmpty ? null : topItems[index];
                    return _LandingGalleryTile(
                      title: row == null
                          ? 'Galeri Sekolah'
                          : '${row['judul'] ?? ''}',
                      imageUrl: row == null ? '' : _imageUrl(row),
                      onTap: onOpenAll,
                      compactTitle: true,
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (compact)
                  Column(
                    children: [
                      const _LandingLogoTile(),
                      const SizedBox(height: 10),
                      ...bottomItems.map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _LandingGalleryTile(
                            title: '${row['judul'] ?? ''}',
                            imageUrl: _imageUrl(row),
                            onTap: onOpenAll,
                            large: true,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      const Expanded(child: _LandingLogoTile()),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LandingGalleryTile(
                          title: bottomItems.isNotEmpty
                              ? '${bottomItems[0]['judul'] ?? ''}'
                              : 'Basket',
                          imageUrl: bottomItems.isNotEmpty
                              ? _imageUrl(bottomItems[0])
                              : '',
                          onTap: onOpenAll,
                          large: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LandingGalleryTile(
                          title: bottomItems.length > 1
                              ? '${bottomItems[1]['judul'] ?? ''}'
                              : 'Lab IPA',
                          imageUrl: bottomItems.length > 1
                              ? _imageUrl(bottomItems[1])
                              : '',
                          onTap: onOpenAll,
                          large: true,
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _LandingGalleryTile extends StatelessWidget {
  const _LandingGalleryTile({
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.large = false,
    this.compactTitle = false,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final bool large;
  final bool compactTitle;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: large ? 160 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6B99AB), Color(0xFF4F7D9E)],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Positioned.fill(
                  child: websiteContentImage(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.12),
                          Colors.black.withOpacity(.4),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Text(
                    title.isEmpty ? 'Galeri Sekolah' : title,
                    maxLines: compactTitle ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compactTitle ? 12.5 : 14,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(
                          color: Color(0x80000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LandingLogoTile extends StatelessWidget {
  const _LandingLogoTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: ValueListenableBuilder<WebsiteIdentity>(
          valueListenable: websiteIdentityController,
          builder: (context, identity, _) => websiteIdentityImage(
            identity.logo,
            width: 148,
            height: 148,
            fallbackColor: const Color(0xFF9E7A1D),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showAction = constraints.maxWidth >= 310;
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onSeeAll,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF082E65),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            if (showAction)
              TextButton.icon(
                onPressed: onSeeAll,
                iconAlignment: IconAlignment.end,
                label: Text(_landingText(context, 'teks_lihat_semua', 'Lihat Semua')),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              ),
          ],
        );
      },
    );
  }
}

class _NewsSection extends StatelessWidget {
  const _NewsSection();

  void _openNews(BuildContext context) {
    publicRootNavigator(context).pushNamed(PublicRoutes.news);
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: const SmakApi().getTable('berita', limit: 3),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                _SectionTitle(
                  _landingText(context, 'judul_berita', 'Berita & Pengumuman'),
                  onSeeAll: () => _openNews(context),
                ),
                const SizedBox(height: 18),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return Column(
            children: [
              _SectionTitle(
                _landingText(context, 'judul_berita', 'Berita & Pengumuman'),
                onSeeAll: () => _openNews(context),
              ),
              const SizedBox(height: 10),
              if (rows.isEmpty)
                const Text(
                  'Belum ada berita dari database.',
                  style: TextStyle(color: Color(0xFF526178)),
                )
              else
                ...rows.map(
                  (row) => _NewsRow(
                    tag: '${row['kategori'] ?? 'BERITA'}'.toUpperCase(),
                    title: '${row['judul'] ?? ''}',
                    text: '${row['deskripsi'] ?? ''}',
                    icon: Icons.article_rounded,
                    onTap: () => _openNews(context),
                  ),
                ),
            ],
          );
        },
      );
}

class _NewsRow extends StatelessWidget {
  const _NewsRow({
    required this.tag,
    required this.title,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final String tag, title, text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = constraints.maxWidth < 360 ? 105.0 : 145.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: imageWidth,
                    height: 83,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4078A7), Color(0xFF1B355E)],
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white.withOpacity(.92),
                      size: 37,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                            color: const Color(0xFFE1EEFF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF0862D5),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF091D43),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            height: 1.35,
                            color: Color(0xFF526178),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection();

  void _openGallery(BuildContext context) {
    publicRootNavigator(context).pushNamed(PublicRoutes.gallery);
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: const SmakApi().getTable('galeri', limit: 6),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                _SectionTitle(
                  _landingText(context, 'judul_galeri', 'Galeri Kegiatan'),
                  onSeeAll: () => _openGallery(context),
                ),
                const SizedBox(height: 18),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return Column(
            children: [
              _SectionTitle(
                _landingText(context, 'judul_galeri', 'Galeri Kegiatan'),
                onSeeAll: () => _openGallery(context),
              ),
              const SizedBox(height: 10),
              if (rows.isEmpty)
                const Text(
                  'Belum ada galeri dari database.',
                  style: TextStyle(color: Color(0xFF526178)),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rows.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 9,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    final storedImage = '${row['gambar'] ?? row['foto'] ?? ''}'
                        .trim();
                    return GestureDetector(
                      onTap: () => _openGallery(context),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3B756E), Color(0xFF547EAE)],
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: websiteContentImage(
                                storedImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              left: 8,
                              right: 8,
                              bottom: 8,
                              child: Text(
                                '${row['judul'] ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      );
}

class SmakFooter extends StatelessWidget {
  const SmakFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    return ValueListenableBuilder<WebsiteIdentity>(
      valueListenable: websiteIdentityController,
      builder: (context, identity, _) => Container(
        color: identity.navigationColor,
        padding: EdgeInsets.fromLTRB(
          compact ? 28 : 52,
          36,
          compact ? 28 : 52,
          22,
        ),
        child: Column(
          children: [
            if (compact)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FooterBrand(),
                  SizedBox(height: 32),
                  _FooterLinks(),
                  SizedBox(height: 32),
                  _FooterContact(),
                  SizedBox(height: 32),
                  _FooterHours(),
                ],
              )
            else
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _FooterBrand()),
                  SizedBox(width: 42),
                  Expanded(flex: 4, child: _FooterLinks()),
                  SizedBox(width: 42),
                  Expanded(flex: 6, child: _FooterContact()),
                  SizedBox(width: 42),
                  Expanded(flex: 4, child: _FooterHours()),
                ],
              ),
            const SizedBox(height: 30),
            Container(height: 1, color: const Color(0xFF54708E)),
            const SizedBox(height: 20),
            ValueListenableBuilder<WebsiteIdentity>(
              valueListenable: websiteIdentityController,
              builder: (context, identity, _) => Text(
                'Copyright ${identity.copyrightYear} ${identity.name}. All rights reserved.',
                style: const TextStyle(color: Color(0xFFE5EEF7), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          ValueListenableBuilder<WebsiteIdentity>(
            valueListenable: websiteIdentityController,
            builder: (context, identity, _) => websiteIdentityImage(
              identity.logo,
              width: 42,
              height: 46,
              fallbackColor: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<WebsiteIdentity>(
                valueListenable: websiteIdentityController,
                builder: (context, identity, _) => Text(
                  identity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 3),
              Text(
                globalWebsiteText(
                  context,
                  'slogan',
                  'Beriman • Berilmu • Berkarakter',
                ),
                style: TextStyle(color: Color(0xFFD5E2F0), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 18),
      Text(
        globalWebsiteText(
          context,
          'deskripsi',
          'Membentuk generasi muda yang cerdas,\nberiman, dan siap berkarya bagi\nmasyarakat.',
        ),
        style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          _SocialIcon(
            Icons.chat_rounded,
            imageUrl: 'https://img.icons8.com/color/48/whatsapp--v1.png',
            onTap: () => openMapLink(globalWhatsappUrl(context)),
          ),
          const SizedBox(width: 12),
          _SocialIcon(
            Icons.camera_alt_rounded,
            imageUrl: 'https://img.icons8.com/color/48/instagram-new--v1.png',
            onTap: () => openMapLink(
              globalWebsiteText(
                context,
                'instagram',
                'https://www.instagram.com/soegijapranata_lmj/',
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();
  @override
  Widget build(BuildContext context) => const _FooterColumn(
    title: 'Tautan Cepat',
    children: [
      'Beranda',
      'Profil',
      'Akademik',
      'Kesiswaan',
      'Berita',
      'Galeri',
      'PPDB',
      'Kontak',
    ],
  );
}

class _FooterContact extends StatelessWidget {
  const _FooterContact();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Kontak Kami',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 18),
      _FooterContactRow(
        Icons.location_on_rounded,
        globalWebsiteText(
          context,
          'alamat',
          'V68H+JGC, Jogoyudan, Kec. Lumajang,\nKabupaten Lumajang, Jawa Timur 67315',
        ),
        onTap: () => openMapLink(
          globalWebsiteText(
            context,
            'link_maps',
            'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA',
          ),
        ),
      ),
      const SizedBox(height: 14),
      _FooterContactRow(
        Icons.phone_rounded,
        globalWebsiteText(context, 'telepon', '0815-5099-445'),
        onTap: () => openMapLink(globalWhatsappUrl(context)),
      ),
      const SizedBox(height: 14),
      _FooterContactRow(
        Icons.flag_rounded,
        globalWebsiteText(context, 'provinsi', 'Jawa Timur'),
      ),
    ],
  );
}

class _FooterHours extends StatelessWidget {
  const _FooterHours();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Jam Operasional',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      SizedBox(height: 18),
      _FooterContactRow(
        Icons.schedule_rounded,
        '${globalWebsiteText(context, 'hari_operasional', 'Senin – Jumat')}\n${globalWebsiteText(context, 'jam_operasional', '07.00 – 15.00 WIB')}',
      ),
      SizedBox(height: 24),
      Text(
        '“${globalWebsiteText(context, 'motto', 'Ora et Labora')}\n(${globalWebsiteText(context, 'arti_motto', 'Berdoa dan Bekerja')})”',
        style: TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
          height: 1.6,
        ),
      ),
    ],
  );
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.children});
  final String title;
  final List<String> children;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 14),
      ...children.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            item,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    ],
  );
}

class _FooterContactRow extends StatelessWidget {
  const _FooterContactRow(this.icon, this.text, {this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon(this.icon, {required this.onTap, this.imageUrl});
  final IconData icon;
  final VoidCallback onTap;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: imageUrl == null
            ? Icon(icon, color: const Color(0xFF102D4D), size: 16)
            : Image.network(
                imageUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(icon, color: const Color(0xFF102D4D), size: 16),
              ),
      ),
    ),
  );
}
