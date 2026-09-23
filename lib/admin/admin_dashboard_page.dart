import 'dart:convert';
import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/smak_api.dart';
import '../services/website_identity.dart';
import '../routing/public_routes.dart';
import '../landing_page/landing_page.dart';
import '../landing_page/berita/berita_page.dart';
import '../landing_page/galeri/galeri_page.dart';
import '../landing_page/kontak_page.dart';
import '../landing_page/ppdb/ppdb_page.dart';
import '../landing_page/profil/identitas_sekolah/identitas_sekolah_page.dart';
import '../landing_page/site_chrome.dart'
    show sharedProfilePages, sharedAcademicPages, sharedStudentPages;

part 'shared/admin_sidebar.dart';
part 'shared/admin_topbar.dart';
part 'shared/admin_module.dart';
part 'shared/content_constraints.dart';
part 'dashboard/dashboard_page.dart';
part 'dashboard/beranda_website_page.dart';
part 'galeri/galeri_page.dart';
part 'shared/admin_module_page.dart';
part 'profil/profil_identitas_page.dart';
part 'profil/profil_content_page.dart';
part 'profil/identitas_sekolah_page.dart';
part 'profil/sambutan_kepala_sekolah_page.dart';
part 'profil/sejarah_sekolah_page.dart';
part 'profil/visi_misi_page.dart';
part 'profil/struktur_organisasi_page.dart';
part 'profil/sarana_prasarana_page.dart';
part 'shared/admin_editor_dialog.dart';
part 'shared/admin_media_upload_panel.dart';
part 'shared/admin_profile_section_editor.dart';
part 'berita/berita_page.dart';
part 'akademik/prestasi_akademik_page.dart';
part 'akademik/kurikulum_page.dart';
part 'akademik/kalender_akademik_page.dart';
part 'akademik/jadwal_pelajaran_page.dart';
part 'kesiswaan/tata_tertib_page.dart';
part 'kesiswaan/osis_page.dart';
part 'kesiswaan/prestasi_siswa_page.dart';
part 'kesiswaan/ekstrakurikuler_page.dart';
part 'ppdb/ppdb_page.dart';
part 'kontak/kontak_page.dart';
part 'pengguna/pengguna_page.dart';
part 'web_editor/web_editor_page.dart';
part 'pengaturan_website/pengaturan_website_page.dart';
part 'pengaturan_website/identitas_tab.dart';
part 'pengaturan_website/tampilan_tab.dart';
part 'pengaturan_website/footer_tab.dart';
part 'pengaturan_website/seo_tab.dart';
part 'pengaturan_website/status_website_tab.dart';
part 'pengaturan_website/login_tab.dart';
part 'pengaturan_website/keamanan_aktivitas_tab.dart';

const Color _navy = Color(0xFF082F63);
const Color _navyDark = Color(0xFF05244D);
const Color _blue = Color(0xFF1463E8);
const Color _text = Color(0xFF082E65);
const Color _muted = Color(0xFF60718A);
const Color _background = Color(0xFFF6F8FC);
const Color _line = Color(0xFFE8EEF6);

Future<void> _openAdminPreview(BuildContext context, Widget page) {
  return showDialog<void>(
    context: context,
    useSafeArea: false,
    builder: (dialogContext) => Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preview Halaman'),
          leading: IconButton(
            tooltip: 'Kembali ke Admin',
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ),
        // The initial page stays isolated; public links explicitly use the
        // root Navigator so browser history and clean URLs remain synchronized.
        body: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => page),
        ),
      ),
    ),
  );
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final SmakApi api = const SmakApi();
  String activePage = 'Dashboard';
  bool menuOpen = false;
  String _settingsInitialTab = 'Identitas';
  String _currentAdminName = 'Administrator';
  String _currentAdminPhoto = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentAdmin();
  }

  Future<void> _loadCurrentAdmin() async {
    try {
      final data = await api.getSecurityDashboard(widget.sessionToken);
      final sessions = (data['sessions'] as List? ?? const []);

      Map<dynamic, dynamic>? currentSession;
      for (final item in sessions) {
        if (item is Map && item['current'] == true) {
          currentSession = item;
          break;
        }
      }
      if (currentSession == null) return;

      final name = '${currentSession['nama'] ?? ''}'.trim();
      final currentUserId = int.tryParse('${currentSession['user_id'] ?? ''}');

      String photo = '';
      if (currentUserId != null) {
        final users = await api.getTable('users');
        for (final user in users) {
          if (int.tryParse('${user['id'] ?? ''}') == currentUserId) {
            photo = '${user['foto'] ?? ''}'.trim();
            break;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        if (name.isNotEmpty) _currentAdminName = name;
        _currentAdminPhoto = photo;
      });
    } catch (_) {
      // Pertahankan fallback nama dan ikon jika data akun tidak dapat dimuat.
    }
  }

  Future<void> _logout() async {
    try {
      await api.logout(widget.sessionToken);
    } catch (_) {
      // Sesi lokal tetap dibersihkan jika server sudah tidak dapat dijangkau.
    }
    html.window.localStorage.remove('smak_admin_session');
    html.window.sessionStorage.remove('smak_admin_session');
    if (!mounted) return;
    publicRootNavigator(context).pushNamedAndRemoveUntil(
      PublicRoutes.login,
      (route) => false,
    );
  }

  static const modules = <AdminModule>[
    AdminModule(
      'Profil Sekolah',
      'Kelola data resmi dan informasi profil sekolah',
      Icons.account_balance_rounded,
      'profil_identitas',
    ),
    AdminModule(
      'Akademik',
      'Kelola kurikulum, jadwal, kalender, dan prestasi akademik',
      Icons.menu_book_rounded,
      'akademik',
    ),
    AdminModule(
      'Kesiswaan',
      'Kelola OSIS, kegiatan, tata tertib, dan prestasi siswa',
      Icons.groups_rounded,
      'kesiswaan',
    ),
    AdminModule(
      'Berita',
      'Kelola berita dan pengumuman',
      Icons.article_rounded,
      'berita',
    ),
    AdminModule(
      'Galeri',
      'Kelola kegiatan dan dokumentasi sekolah',
      Icons.photo_library_rounded,
      'galeri',
    ),
    AdminModule(
      'PPDB',
      'Kelola informasi penerimaan peserta didik baru',
      Icons.how_to_reg_rounded,
      'ppdb',
    ),
    AdminModule(
      'Kontak',
      'Kelola alamat, telepon, jam operasional, dan media sosial',
      Icons.contact_phone_rounded,
      'kontak',
    ),
    AdminModule(
      'Web Editor',
      'Ubah teks, gambar, banner, dan warna halaman publik',
      Icons.web_rounded,
      'web_content',
    ),
    AdminModule(
      'Pengguna',
      'Kelola akun administrator',
      Icons.manage_accounts_rounded,
      'users',
    ),
    AdminModule(
      'Pengaturan Website',
      'Kelola pengaturan umum dan identitas website',
      Icons.settings_rounded,
      'beranda_slider',
    ),
  ];

  void _openPage(String page) {
    setState(() {
      _settingsInitialTab = page == 'Keamanan & Aktivitas'
          ? 'Keamanan & Aktivitas'
          : 'Identitas';
      activePage = page == 'Keamanan & Aktivitas' ? 'Pengaturan Website' : page;
      if (MediaQuery.sizeOf(context).width < 980) {
        menuOpen = false;
      }
    });
  }

  AdminModule _moduleByTitle(String title) => modules.firstWhere(
    (item) => item.title == title,
    orElse: () => modules.first,
  );

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;

    final Widget content;
    if (activePage == 'Dashboard') {
      content = AdminOverview(
        api: api,
        sessionToken: widget.sessionToken,
        onModuleTap: _openPage,
      );
    } else if (activePage == 'Beranda Website') {
      content = AdminBerandaWebsitePage(api: api);
    } else if (activePage == 'Profil' ||
        activePage == 'Profil Sekolah' ||
        activePage == 'Identitas Sekolah') {
      content = AdminIdentitasSekolahCrudPage(api: api);
    } else if (activePage == 'Sambutan Kepala Sekolah') {
      content = AdminSambutanKepalaSekolahPage(api: api);
    } else if (activePage == 'Sejarah Sekolah') {
      content = AdminSejarahSekolahPage(api: api);
    } else if (activePage == 'Visi & Misi') {
      content = AdminVisiMisiPage(api: api);
    } else if (activePage == 'Struktur Organisasi') {
      content = AdminStrukturOrganisasiPage(api: api);
    } else if (activePage == 'Sarana & Prasarana') {
      content = AdminSaranaPrasaranaPage(api: api);
    } else if (activePage == 'Galeri') {
      content = AdminGalleryPage(api: api);
    } else if (activePage == 'Berita') {
      content = AdminBeritaPage(api: api, module: _moduleByTitle('Berita'));
    } else if (activePage == 'Akademik' || activePage == 'Prestasi Akademik') {
      content = AdminPrestasiAkademikPage(
        api: api,
        module: _moduleByTitle('Akademik'),
      );
    } else if (activePage == 'Kurikulum') {
      content = AdminKurikulumPage(
        api: api,
        module: _moduleByTitle('Akademik'),
      );
    } else if (activePage == 'Kalender Akademik') {
      content = AdminKalenderAkademikPage(
        api: api,
        module: _moduleByTitle('Akademik'),
      );
    } else if (activePage == 'Jadwal Pelajaran') {
      content = AdminJadwalPelajaranPage(
        api: api,
        module: _moduleByTitle('Akademik'),
      );
    } else if (activePage == 'Kesiswaan' || activePage == 'Tata Tertib') {
      content = AdminTataTertibPage(
        api: api,
        module: _moduleByTitle('Kesiswaan'),
      );
    } else if (activePage == 'OSIS') {
      content = AdminOsisPage(api: api, module: _moduleByTitle('Kesiswaan'));
    } else if (activePage == 'Prestasi Siswa') {
      content = AdminPrestasiSiswaPage(
        api: api,
        module: _moduleByTitle('Kesiswaan'),
      );
    } else if (activePage == 'Ekstrakurikuler') {
      content = AdminEkstrakurikulerPage(
        api: api,
        module: _moduleByTitle('Kesiswaan'),
      );
    } else if (activePage == 'PPDB') {
      content = AdminPpdbPage(api: api, module: _moduleByTitle('PPDB'));
    } else if (activePage == 'Kontak') {
      content = AdminKontakPage(api: api, module: _moduleByTitle('Kontak'));
    } else if (activePage == 'Web Editor') {
      content = AdminBerandaWebsitePage(api: api);
    } else if (activePage == 'Pengguna') {
      content = AdminPenggunaPage(api: api, module: _moduleByTitle('Pengguna'));
    } else if (activePage == 'Pengaturan Website') {
      content = AdminPengaturanWebsitePage(
        api: api,
        module: _moduleByTitle('Pengaturan Website'),
        sessionToken: widget.sessionToken,
        initialTab: _settingsInitialTab,
      );
    } else {
      content = AdminModulePage(api: api, module: _moduleByTitle(activePage));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          AdminTopBar(
            showMenuButton: compact,
            onMenu: () => setState(() => menuOpen = !menuOpen),
            adminName: _currentAdminName,
            adminPhotoUrl: _currentAdminPhoto.isEmpty
                ? ''
                : api.getFileUrl(_currentAdminPhoto),
          ),
          Expanded(
            child: Stack(
              children: [
                Row(
                  children: [
                    if (!compact)
                      AdminSidebar(
                        activePage: activePage,
                        onSelect: _openPage,
                        onLogout: _logout,
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          compact ? 16 : 24,
                          compact ? 18 : 22,
                          compact ? 16 : 24,
                          24,
                        ),
                        child: KeyedSubtree(
                          key: ValueKey(activePage),
                          child: content,
                        ),
                      ),
                    ),
                  ],
                ),
                if (compact && menuOpen) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => setState(() => menuOpen = false),
                      child: Container(color: Colors.black.withOpacity(.28)),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: AdminSidebar(
                      activePage: activePage,
                      onSelect: _openPage,
                      onLogout: _logout,
                      width: 250,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
