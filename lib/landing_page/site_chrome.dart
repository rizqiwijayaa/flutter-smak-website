import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;

import '../services/website_identity.dart';
import '../services/smak_api.dart';
import '../routing/public_routes.dart';

import 'akademik/jadwal_pelajaran/jadwal_pelajaran_page.dart';
import 'akademik/kalender_akademik/kalender_akademik_page.dart';
import 'akademik/kurikulum/kurikulum_page.dart';
import 'akademik/prestasi_akademik/prestasi_akademik_page.dart';
import 'kesiswaan/ekstrakurikuler/ekstrakurikuler_page.dart';
import 'kesiswaan/osis/osis_page.dart';
import 'kesiswaan/prestasi_siswa/prestasi_siswa_page.dart';
import 'kesiswaan/tata_tertib/tata_tertib_page.dart';
import 'profil/sambutan_kepala_sekolah/sambutan_kepala_sekolah_page.dart';
import 'profil/sarana_prasarana/sarana_prasarana_page.dart';
import 'profil/sejarah_sekolah/sejarah_sekolah_page.dart';
import 'profil/struktur_organisasi/struktur_organisasi_page.dart';
import 'profil/visi_misi/visi_misi_page.dart';

void openSharedLink(String url) => html.window.open(url, '_blank');

Map<String, Widget> sharedProfilePages() => {
  'sambutan': const SambutanKepalaSekolahPage(),
  'sejarah': const SejarahSekolahPage(),
  'visi': const VisiMisiPage(),
  'struktur': const StrukturOrganisasiPage(),
  'sarana': const SaranaPrasaranaPage(),
};

Map<String, Widget> sharedAcademicPages() => {
  'kurikulum': const KurikulumPage(),
  'kalender': const KalenderAkademikPage(),
  'jadwal': const JadwalPelajaranPage(),
  'prestasi': const PrestasiAkademikPage(),
};

Map<String, Widget> sharedStudentPages() => {
  'osis': const OsisPage(),
  'ekstra': const EkstrakurikulerPage(),
  'prestasi': const PrestasiSiswaPage(),
  'tata': const TataTertibPage(),
};

class SmakTopInfoBar extends StatelessWidget {
  const SmakTopInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 700;
    final medium = width < 1040;

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );

    return ValueListenableBuilder<WebsiteIdentity>(
      valueListenable: websiteIdentityController,
      builder: (context, identity, _) => Container(
        width: double.infinity,
        height: compact ? 38 : 36,
        color: identity.navigationColor,
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (compact)
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tel. ${globalWebsiteText(context, 'contact_telepon', '(0334) 890123')}',
                        style: textStyle,
                      ),
                      const SizedBox(width: 18),
                      const Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        globalWebsiteText(
                          context,
                          'email',
                          'info@smaklumajang.sch.id',
                        ),
                        style: textStyle,
                      ),
                      const SizedBox(width: 18),
                      InkWell(
                        onTap: () => openSharedLink(globalWhatsappUrl(context)),
                        borderRadius: BorderRadius.circular(4),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => openSharedLink(
                          globalWebsiteText(
                            context,
                            'instagram',
                            'https://www.instagram.com/soegijapranata_lmj/',
                          ),
                        ),
                        borderRadius: BorderRadius.circular(4),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.instagram,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tel. ${globalWebsiteText(context, 'contact_telepon', '(0334) 890123')}',
                        style: textStyle,
                      ),
                      const SizedBox(width: 22),
                      const Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        globalWebsiteText(
                          context,
                          'email',
                          'info@smaklumajang.sch.id',
                        ),
                        style: textStyle,
                      ),
                      if (!medium) ...[
                        const SizedBox(width: 22),
                        InkWell(
                          onTap: () =>
                              openSharedLink(globalWhatsappUrl(context)),
                          borderRadius: BorderRadius.circular(4),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text('Whatsapp', style: textStyle),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        InkWell(
                          onTap: () => openSharedLink(
                            globalWebsiteText(
                              context,
                              'instagram',
                              'https://www.instagram.com/soegijapranata_lmj/',
                            ),
                          ),
                          borderRadius: BorderRadius.circular(4),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text('Instagram', style: textStyle),
                            ],
                          ),
                        ),
                      ],
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

class SharedSmakNavigationBar extends StatefulWidget {
  const SharedSmakNavigationBar({
    super.key,
    required this.profilePages,
    required this.academicPages,
    required this.studentPages,
    this.galleryPage,
    this.initialActive = 'Profil',
  });

  final Map<String, Widget> profilePages;
  final Map<String, Widget> academicPages;
  final Map<String, Widget> studentPages;
  final Widget? galleryPage;
  final String initialActive;

  @override
  State<SharedSmakNavigationBar> createState() =>
      _SharedSmakNavigationBarState();
}

class _SharedSmakNavigationBarState extends State<SharedSmakNavigationBar> {
  late String active;

  @override
  void initState() {
    super.initState();
    active = widget.initialActive;
  }

  @override
  void didUpdateWidget(covariant SharedSmakNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialActive != widget.initialActive &&
        active != widget.initialActive) {
      active = widget.initialActive;
    }
  }

  void select(String value) => setState(() => active = value);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 1180;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SmakTopInfoBar(),
        Container(
          height: 82,
          padding: EdgeInsets.symmetric(horizontal: width < 600 ? 18 : 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0F0F172A),
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => _goHome(context),
                child: _SharedBrand(compact: width < 520),
              ),
              const Spacer(),
              if (compact)
                IconButton(
                  onPressed: () => _showMobileMenu(context),
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFF062C64),
                  ),
                )
              else
                Row(
                  children: [
                    _SharedNavText(
                      'Beranda',
                      selected: active == 'Beranda',
                      onTap: () => _goHome(context),
                    ),
                    _SharedProfileMenu(
                      selected: active == 'Profil',
                      onTap: () => _openProfile(context, 'identitas'),
                      onSelect: (value) => _openProfile(context, value),
                    ),
                    _SharedSectionMenu(
                      label: 'Akademik',
                      selected: active == 'Akademik',
                      width: 210,
                      onTap: () => _openAcademic(context, 'prestasi'),
                      items: const [
                        _SharedMenu('kurikulum', 'Kurikulum'),
                        _SharedMenu('kalender', 'Kalender Akademik'),
                        _SharedMenu('jadwal', 'Jadwal Pelajaran'),
                      ],
                      onSelect: (value) => _openAcademic(context, value),
                    ),
                    _SharedSectionMenu(
                      label: 'Kesiswaan',
                      selected: active == 'Kesiswaan',
                      width: 200,
                      onTap: () => _openStudent(context, 'tata'),
                      items: const [
                        _SharedMenu('osis', 'OSIS'),
                        _SharedMenu('ekstra', 'Ekstrakurikuler'),
                        _SharedMenu('prestasi', 'Prestasi Siswa'),
                      ],
                      onSelect: (value) => _openStudent(context, value),
                    ),
                    _SharedNavText(
                      'Berita',
                      selected: active == 'Berita',
                      onTap: () => _openBerita(context),
                    ),
                    _SharedNavText(
                      'Galeri',
                      selected: active == 'Galeri',
                      onTap: () => _openGallery(context),
                    ),
                    _SharedNavText(
                      'PPDB',
                      selected: active == 'PPDB',
                      onTap: () => _openPpdb(context),
                    ),
                    _SharedNavText(
                      'Kontak',
                      selected: active == 'Kontak',
                      onTap: () => _openContact(context),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () => _openLogin(context),
                      icon: const Icon(Icons.person_outline_rounded, size: 17),
                      label: const Text('Login'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _goHome(BuildContext context) {
    select('Beranda');
    publicRootNavigator(context).pushNamedAndRemoveUntil(
      PublicRoutes.home,
      (route) => false,
    );
  }

  void _openPpdb(BuildContext context) {
    select('PPDB');
    publicRootNavigator(context).pushNamed(PublicRoutes.admissions);
  }

  void _openContact(BuildContext context) {
    select('Kontak');
    publicRootNavigator(context).pushNamed(PublicRoutes.contact);
  }

  void _openBerita(BuildContext context) {
    select('Berita');
    publicRootNavigator(context).pushNamed(PublicRoutes.news);
  }

  void _openGallery(BuildContext context) {
    select('Galeri');
    publicRootNavigator(context).pushNamed(PublicRoutes.gallery);
  }

  void _openLogin(BuildContext context) {
    publicRootNavigator(context).pushNamed(PublicRoutes.login);
  }

  void _openProfile(BuildContext context, String value) {
    select('Profil');
    final route = switch (value) {
      'identitas' => PublicRoutes.profileIdentity,
      'sambutan' => PublicRoutes.profileWelcome,
      'sejarah' => PublicRoutes.profileHistory,
      'visi' => PublicRoutes.profileVisionMission,
      'struktur' => PublicRoutes.profileOrganization,
      'sarana' => PublicRoutes.profileFacilities,
      _ => null,
    };
    if (route != null) publicRootNavigator(context).pushNamed(route);
  }

  void _openAcademic(BuildContext context, String value) {
    select('Akademik');
    final route = switch (value) {
      'kurikulum' => PublicRoutes.academicCurriculum,
      'kalender' => PublicRoutes.academicCalendar,
      'jadwal' => PublicRoutes.academicSchedule,
      'prestasi' => PublicRoutes.academicAchievements,
      _ => null,
    };
    if (route != null) publicRootNavigator(context).pushNamed(route);
  }

  void _openStudent(BuildContext context, String value) {
    select('Kesiswaan');
    final route = switch (value) {
      'osis' => PublicRoutes.studentCouncil,
      'ekstra' => PublicRoutes.extracurricular,
      'prestasi' => PublicRoutes.studentAchievements,
      'tata' => PublicRoutes.studentRules,
      _ => null,
    };
    if (route != null) publicRootNavigator(context).pushNamed(route);
  }

  void _showMobileMenu(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup menu navigasi',
      barrierColor: const Color(0x33000000),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _SharedMobileNavigation(
          onHome: () {
            Navigator.pop(dialogContext);
            _goHome(context);
          },
          onProfile: (value) {
            Navigator.pop(dialogContext);
            _openProfile(context, value);
          },
          onAcademic: (value) {
            Navigator.pop(dialogContext);
            _openAcademic(context, value);
          },
          onStudent: (value) {
            Navigator.pop(dialogContext);
            _openStudent(context, value);
          },
          onBerita: () {
            Navigator.pop(dialogContext);
            _openBerita(context);
          },
          onGallery: () {
            Navigator.pop(dialogContext);
            _openGallery(context);
          },
          onPpdb: () {
            Navigator.pop(dialogContext);
            _openPpdb(context);
          },
          onContact: () {
            Navigator.pop(dialogContext);
            _openContact(context);
          },
          onLogin: () {
            Navigator.pop(dialogContext);
            _openLogin(context);
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

class _SharedMobileNavigation extends StatefulWidget {
  const _SharedMobileNavigation({
    required this.onHome,
    required this.onProfile,
    required this.onAcademic,
    required this.onStudent,
    required this.onBerita,
    required this.onGallery,
    required this.onPpdb,
    required this.onContact,
    required this.onLogin,
  });

  final VoidCallback onHome;
  final ValueChanged<String> onProfile;
  final ValueChanged<String> onAcademic;
  final ValueChanged<String> onStudent;
  final VoidCallback onBerita;
  final VoidCallback onGallery;
  final VoidCallback onPpdb;
  final VoidCallback onContact;
  final VoidCallback onLogin;

  @override
  State<_SharedMobileNavigation> createState() =>
      _SharedMobileNavigationState();
}

class _SharedMobileNavigationState extends State<_SharedMobileNavigation> {
  String? expanded;

  void _toggle(String value) {
    setState(() => expanded = expanded == value ? null : value);
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF062C64);
    const blue = Color(0xFF0756C8);

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 82,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F0F172A),
                    blurRadius: 12,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(child: _SharedBrand(compact: true)),
                  IconButton(
                    tooltip: 'Tutup menu',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: navy,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FullMobileItem(label: 'Beranda', onTap: widget.onHome),
                    _FullMobileGroup(
                      label: 'Profil',
                      expanded: expanded == 'profil',
                      onTap: () => widget.onProfile('identitas'),
                      onToggle: () => _toggle('profil'),
                      children: [
                        _FullMobileSubItem(
                          'Sambutan Kepala Sekolah',
                          () => widget.onProfile('sambutan'),
                        ),
                        _FullMobileSubItem(
                          'Sejarah Sekolah',
                          () => widget.onProfile('sejarah'),
                        ),
                        _FullMobileSubItem(
                          'Visi & Misi',
                          () => widget.onProfile('visi'),
                        ),
                        _FullMobileSubItem(
                          'Struktur Organisasi',
                          () => widget.onProfile('struktur'),
                        ),
                        _FullMobileSubItem(
                          'Sarana & Prasarana',
                          () => widget.onProfile('sarana'),
                        ),
                      ],
                    ),
                    _FullMobileGroup(
                      label: 'Akademik',
                      expanded: expanded == 'akademik',
                      onTap: () => widget.onAcademic('prestasi'),
                      onToggle: () => _toggle('akademik'),
                      children: [
                        _FullMobileSubItem(
                          'Kurikulum',
                          () => widget.onAcademic('kurikulum'),
                        ),
                        _FullMobileSubItem(
                          'Kalender Akademik',
                          () => widget.onAcademic('kalender'),
                        ),
                        _FullMobileSubItem(
                          'Jadwal Pelajaran',
                          () => widget.onAcademic('jadwal'),
                        ),
                      ],
                    ),
                    _FullMobileGroup(
                      label: 'Kesiswaan',
                      expanded: expanded == 'kesiswaan',
                      onTap: () => widget.onStudent('tata'),
                      onToggle: () => _toggle('kesiswaan'),
                      children: [
                        _FullMobileSubItem(
                          'OSIS',
                          () => widget.onStudent('osis'),
                        ),
                        _FullMobileSubItem(
                          'Ekstrakurikuler',
                          () => widget.onStudent('ekstra'),
                        ),
                        _FullMobileSubItem(
                          'Prestasi Siswa',
                          () => widget.onStudent('prestasi'),
                        ),
                      ],
                    ),
                    _FullMobileItem(label: 'Berita', onTap: widget.onBerita),
                    _FullMobileItem(label: 'Galeri', onTap: widget.onGallery),
                    _FullMobileItem(label: 'PPDB', onTap: widget.onPpdb),
                    _FullMobileItem(label: 'Kontak', onTap: widget.onContact),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: widget.onLogin,
                        icon: const Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                        ),
                        label: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
    );
  }
}

class _FullMobileItem extends StatelessWidget {
  const _FullMobileItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF082751),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _FullMobileGroup extends StatelessWidget {
  const _FullMobileGroup({
    required this.label,
    required this.expanded,
    required this.onTap,
    required this.onToggle,
    required this.children,
  });

  final String label;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF082751),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onToggle,
            icon: AnimatedRotation(
              turns: expanded ? .5 : 0,
              duration: const Duration(milliseconds: 160),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF082751),
              ),
            ),
          ),
        ],
      ),
      AnimatedCrossFade(
        firstChild: const SizedBox(width: double.infinity),
        secondChild: Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 6),
          child: Column(children: children),
        ),
        crossFadeState: expanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 160),
      ),
    ],
  );
}

class _FullMobileSubItem extends StatelessWidget {
  const _FullMobileSubItem(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF526178),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

class _SharedNavText extends StatelessWidget {
  const _SharedNavText(this.label, {this.selected = false, this.onTap});
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: selected
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF082751),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
  );
}

class _SharedBrand extends StatelessWidget {
  const _SharedBrand({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<WebsiteIdentity>(
    valueListenable: websiteIdentityController,
    builder: (context, identity, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        websiteIdentityImage(
          identity.logo,
          width: compact ? 42 : 50,
          height: compact ? 48 : 58,
        ),
        SizedBox(width: compact ? 8 : 10),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: compact ? 170 : 310),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                identity.name,
                maxLines: 1,
                overflow: compact
                    ? TextOverflow.ellipsis
                    : TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  color: const Color(0xFF062C64),
                  fontSize: compact ? 19 : 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .4,
                ),
              ),
              Text(
                identity.brandSubtitle,
                style: TextStyle(
                  color: const Color(0xFF314562),
                  fontSize: compact ? 9.5 : 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SharedProfileMenu extends StatelessWidget {
  const _SharedProfileMenu({
    required this.selected,
    required this.onTap,
    required this.onSelect,
  });

  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SharedNavText('Profil', selected: selected, onTap: onTap),
        _SharedDropdown(
          '',
          selected: selected,
          width: 235,
          items: const [
            _SharedMenu('sambutan', 'Sambutan Kepala Sekolah'),
            _SharedMenu('sejarah', 'Sejarah Sekolah'),
            _SharedMenu('visi', 'Visi & Misi'),
            _SharedMenu('struktur', 'Struktur Organisasi'),
            _SharedMenu('sarana', 'Sarana & Prasarana'),
          ],
          onSelect: onSelect,
          showLabel: false,
        ),
      ],
    );
  }
}

class _SharedSectionMenu extends StatelessWidget {
  const _SharedSectionMenu({
    required this.label,
    required this.selected,
    required this.width,
    required this.onTap,
    required this.items,
    required this.onSelect,
  });

  final String label;
  final bool selected;
  final double width;
  final VoidCallback onTap;
  final List<_SharedMenu> items;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SharedNavText(label, selected: selected, onTap: onTap),
        _SharedDropdown(
          '',
          selected: selected,
          width: width,
          items: items,
          onSelect: onSelect,
          showLabel: false,
        ),
      ],
    );
  }
}

class _SharedDropdown extends StatelessWidget {
  const _SharedDropdown(
    this.label, {
    required this.selected,
    required this.width,
    required this.items,
    required this.onSelect,
    this.showLabel = true,
  });
  final String label;
  final bool selected;
  final double width;
  final List<_SharedMenu> items;
  final ValueChanged<String> onSelect;
  final bool showLabel;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    position: PopupMenuPosition.under,
    offset: const Offset(0, 6),
    constraints: BoxConstraints(minWidth: width),
    onSelected: onSelect,
    itemBuilder: (context) => [
      for (final item in items)
        PopupMenuItem<String>(value: item.value, child: Text(item.label)),
    ],
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: selected
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            if (showLabel)
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFF082751),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF082751),
              size: 16,
            ),
          ],
        ),
      ),
    ),
  );
}

class _SharedMenu {
  const _SharedMenu(this.value, this.label);
  final String value;
  final String label;
}

class SharedSmakFooter extends StatelessWidget {
  const SharedSmakFooter({
    super.key,
    required this.profilePages,
    required this.academicPages,
    required this.studentPages,
  });

  final Map<String, Widget> profilePages;
  final Map<String, Widget> academicPages;
  final Map<String, Widget> studentPages;

  Future<Map<String, String>> _loadFooter() async {
    const defaults = <String, String>{
      'slogan': 'Beriman • Berilmu • Berkarakter',
      'deskripsi':
          'Membentuk generasi muda yang cerdas,\nberiman, dan siap berkarya bagi\nmasyarakat.',
      'whatsapp': '628155099445',
      'instagram': 'https://www.instagram.com/soegijapranata_lmj/',
      'alamat':
          'V68H+JGC, Jogoyudan, Kec. Lumajang,\nKabupaten Lumajang, Jawa Timur 67315',
      'link_maps': 'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA',
      'telepon': '0815-5099-445',
      'provinsi': 'Jawa Timur',
      'hari_operasional': 'Senin - Jumat',
      'jam_operasional': '07.00 - 15.00 WIB',
      'motto': 'Ora et Labora',
      'arti_motto': 'Berdoa dan Bekerja',
    };
    try {
      final rows = await SmakApi().getTable('pengaturan_footer', limit: 1);
      if (rows.isEmpty) return defaults;
      final row = rows.first;
      return {
        for (final entry in defaults.entries)
          entry.key: '${row[entry.key] ?? entry.value}',
      };
    } catch (_) {
      return defaults;
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 1120;
    return FutureBuilder<Map<String, String>>(
      future: _loadFooter(),
      builder: (context, snapshot) {
        final footer = snapshot.data ?? const <String, String>{};
        return ValueListenableBuilder<WebsiteIdentity>(
          valueListenable: websiteIdentityController,
          builder: (context, identity, _) => Container(
            width: double.infinity,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SharedFooterBrand(data: footer),
                      const SizedBox(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: _SharedFooterLinks(
                              profilePages: profilePages,
                              academicPages: academicPages,
                              studentPages: studentPages,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 6,
                            child: _SharedFooterContact(data: footer),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _SharedFooterHours(data: footer),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _SharedFooterBrand(data: footer),
                      ),
                      const SizedBox(width: 42),
                      Expanded(
                        flex: 4,
                        child: _SharedFooterLinks(
                          profilePages: profilePages,
                          academicPages: academicPages,
                          studentPages: studentPages,
                        ),
                      ),
                      const SizedBox(width: 42),
                      Expanded(
                        flex: 6,
                        child: _SharedFooterContact(data: footer),
                      ),
                      const SizedBox(width: 42),
                      Expanded(
                        flex: 4,
                        child: _SharedFooterHours(data: footer),
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
                Container(height: 1, color: const Color(0xFF54708E)),
                const SizedBox(height: 20),
                Text(
                  'Copyright ${identity.copyrightYear} ${identity.name}. All rights reserved.',
                  style: const TextStyle(
                    color: Color(0xFFE5EEF7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _footerValue(Map<String, String> data, String key, String fallback) {
  final value = data[key]?.trim() ?? '';
  return value.isEmpty ? fallback : value;
}

class _SharedFooterBrand extends StatelessWidget {
  const _SharedFooterBrand({required this.data});
  final Map<String, String> data;

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
          Expanded(
            child: Column(
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
                const SizedBox(height: 3),
                Text(
                  _footerValue(
                    data,
                    'slogan',
                    'Beriman • Berilmu • Berkarakter',
                  ),
                  style: const TextStyle(
                    color: Color(0xFFD5E2F0),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      Text(
        _footerValue(
          data,
          'deskripsi',
          'Membentuk generasi muda yang cerdas,\nberiman, dan siap berkarya bagi\nmasyarakat.',
        ),
        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          _SharedSocialIcon(
            'https://img.icons8.com/color/48/whatsapp--v1.png',
            () {
              var number = _footerValue(
                data,
                'whatsapp',
                '628155099445',
              ).replaceAll(RegExp(r'[^0-9]'), '');
              if (number.startsWith('0')) number = '62${number.substring(1)}';
              openSharedLink('https://wa.me/$number');
            },
          ),
          const SizedBox(width: 12),
          _SharedSocialIcon(
            'https://img.icons8.com/color/48/instagram-new--v1.png',
            () => openSharedLink(
              _footerValue(
                data,
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

class _SharedSocialIcon extends StatelessWidget {
  const _SharedSocialIcon(this.imageUrl, this.onTap);
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    ),
  );
}

class _SharedFooterLinks extends StatelessWidget {
  const _SharedFooterLinks({
    required this.profilePages,
    required this.academicPages,
    required this.studentPages,
  });
  final Map<String, Widget> profilePages;
  final Map<String, Widget> academicPages;
  final Map<String, Widget> studentPages;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Tautan Cepat',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 14),
      _SharedFooterLink(
        'Beranda',
        () => publicRootNavigator(context).pushNamedAndRemoveUntil(
          PublicRoutes.home,
          (route) => false,
        ),
      ),
      _SharedFooterLink(
        'Profil',
        () => _openPage(context, PublicRoutes.profileIdentity),
      ),
      _SharedFooterLink(
        'Akademik',
        () => _openPage(context, PublicRoutes.academicCurriculum),
      ),
      _SharedFooterLink(
        'Kesiswaan',
        () => _openPage(context, PublicRoutes.studentRules),
      ),
      _SharedFooterLink('Berita', () => _openPage(context, PublicRoutes.news)),
      _SharedFooterLink(
        'Galeri',
        () => _openPage(context, PublicRoutes.gallery),
      ),
      _SharedFooterLink(
        'PPDB',
        () => publicRootNavigator(context).pushNamed(PublicRoutes.admissions),
      ),
      _SharedFooterLink(
        'Kontak',
        () => publicRootNavigator(context).pushNamed(PublicRoutes.contact),
      ),
    ],
  );

  void _openPage(BuildContext context, String route) =>
      publicRootNavigator(context).pushNamed(route);
}

class _SharedFooterLink extends StatelessWidget {
  const _SharedFooterLink(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    ),
  );
}

class _SharedFooterContact extends StatelessWidget {
  const _SharedFooterContact({required this.data});
  final Map<String, String> data;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Kontak Kami',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 18),
      _SharedContactRow(
        Icons.location_on_rounded,
        _footerValue(
          data,
          'alamat',
          'V68H+JGC, Jogoyudan, Kec. Lumajang,\nKabupaten Lumajang, Jawa Timur 67315',
        ),
        () => openSharedLink(
          _footerValue(
            data,
            'link_maps',
            'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA',
          ),
        ),
      ),
      const SizedBox(height: 14),
      _SharedContactRow(
        Icons.phone_rounded,
        _footerValue(data, 'telepon', '0815-5099-445'),
        () {
          var number = _footerValue(
            data,
            'whatsapp',
            '628155099445',
          ).replaceAll(RegExp(r'[^0-9]'), '');
          if (number.startsWith('0')) number = '62${number.substring(1)}';
          openSharedLink('https://wa.me/$number');
        },
      ),
      const SizedBox(height: 14),
      _SharedContactRow(
        Icons.flag_rounded,
        _footerValue(data, 'provinsi', 'Jawa Timur'),
      ),
    ],
  );
}

class _SharedContactRow extends StatelessWidget {
  const _SharedContactRow(this.icon, this.text, [this.onTap]);
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

class _SharedFooterHours extends StatelessWidget {
  const _SharedFooterHours({required this.data});
  final Map<String, String> data;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Jam Operasional',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 18),
      _SharedContactRow(
        Icons.schedule_rounded,
        '${_footerValue(data, 'hari_operasional', 'Senin - Jumat')}\n${_footerValue(data, 'jam_operasional', '07.00 - 15.00 WIB')}',
      ),
      const SizedBox(height: 24),
      Text(
        '"${_footerValue(data, 'motto', 'Ora et Labora')}"\n(${_footerValue(data, 'arti_motto', 'Berdoa dan Bekerja')})',
        style: const TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
          height: 1.6,
        ),
      ),
    ],
  );
}
