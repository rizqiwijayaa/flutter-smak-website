import 'package:flutter/material.dart';

import '../landing_page/akademik/jadwal_pelajaran/jadwal_pelajaran_page.dart';
import '../landing_page/akademik/kalender_akademik/kalender_akademik_page.dart';
import '../landing_page/akademik/kurikulum/kurikulum_page.dart';
import '../landing_page/akademik/prestasi_akademik/prestasi_akademik_page.dart';
import '../landing_page/berita/berita_page.dart';
import '../landing_page/galeri/galeri_page.dart';
import '../landing_page/kesiswaan/ekstrakurikuler/ekstrakurikuler_page.dart';
import '../landing_page/kesiswaan/osis/osis_page.dart';
import '../landing_page/kesiswaan/prestasi_siswa/prestasi_siswa_page.dart';
import '../landing_page/kesiswaan/tata_tertib/tata_tertib_page.dart';
import '../landing_page/kontak_page.dart';
import '../landing_page/landing_page.dart';
import '../landing_page/login/login_page.dart';
import '../landing_page/ppdb/ppdb_page.dart';
import '../landing_page/profil/identitas_sekolah/identitas_sekolah_page.dart';
import '../landing_page/profil/sambutan_kepala_sekolah/sambutan_kepala_sekolah_page.dart';
import '../landing_page/profil/sarana_prasarana/sarana_prasarana_page.dart';
import '../landing_page/profil/sejarah_sekolah/sejarah_sekolah_page.dart';
import '../landing_page/profil/struktur_organisasi/struktur_organisasi_page.dart';
import '../landing_page/profil/visi_misi/visi_misi_page.dart';

NavigatorState publicRootNavigator(BuildContext context) =>
    Navigator.of(context, rootNavigator: true);

abstract final class PublicRoutes {
  static const home = '/';
  static const login = '/login';

  static const profileIdentity = '/profil/identitas-sekolah';
  static const profileWelcome = '/profil/sambutan-kepala-sekolah';
  static const profileHistory = '/profil/sejarah-sekolah';
  static const profileVisionMission = '/profil/visi-misi';
  static const profileOrganization = '/profil/struktur-organisasi';
  static const profileFacilities = '/profil/sarana-prasarana';

  static const academicCurriculum = '/akademik/kurikulum';
  static const academicCalendar = '/akademik/kalender-akademik';
  static const academicSchedule = '/akademik/jadwal-pelajaran';
  static const academicAchievements = '/akademik/prestasi-akademik';

  static const studentCouncil = '/kesiswaan/osis';
  static const extracurricular = '/kesiswaan/ekstrakurikuler';
  static const studentAchievements = '/kesiswaan/prestasi-siswa';
  static const studentRules = '/kesiswaan/tata-tertib';

  static const news = '/berita';
  static const gallery = '/galeri';
  static const admissions = '/ppdb';
  static const contact = '/kontak';

  static String normalize(String? routeName) {
    final uri = Uri.tryParse(routeName ?? home);
    var path = uri?.path.trim() ?? home;
    if (path.isEmpty) path = home;
    if (!path.startsWith('/')) path = '/$path';
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  static Widget? pageFor(String routeName) {
    return switch (normalize(routeName)) {
      home => const LandingPage(),
      login => const LoginPage(),
      profileIdentity => const IdentitasSekolahPage(),
      profileWelcome => const SambutanKepalaSekolahPage(),
      profileHistory => const SejarahSekolahPage(),
      profileVisionMission => const VisiMisiPage(),
      profileOrganization => const StrukturOrganisasiPage(),
      profileFacilities => const SaranaPrasaranaPage(),
      academicCurriculum => const KurikulumPage(),
      academicCalendar => const KalenderAkademikPage(),
      academicSchedule => const JadwalPelajaranPage(),
      academicAchievements => const PrestasiAkademikPage(),
      studentCouncil => const OsisPage(),
      extracurricular => const EkstrakurikulerPage(),
      studentAchievements => const PrestasiSiswaPage(),
      studentRules => const TataTertibPage(),
      news => const BeritaPage(),
      gallery => const GaleriPage(),
      admissions => const PpdbPage(),
      contact => const KontakPage(),
      _ => null,
    };
  }
}
