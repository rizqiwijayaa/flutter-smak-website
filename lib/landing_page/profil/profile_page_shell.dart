import 'package:flutter/material.dart';
import '../akademik/jadwal_pelajaran/jadwal_pelajaran_page.dart';
import '../akademik/kalender_akademik/kalender_akademik_page.dart';
import '../akademik/kurikulum/kurikulum_page.dart';
import '../akademik/prestasi_akademik/prestasi_akademik_page.dart';
import '../kesiswaan/ekstrakurikuler/ekstrakurikuler_page.dart';
import '../kesiswaan/osis/osis_page.dart';
import '../kesiswaan/prestasi_siswa/prestasi_siswa_page.dart';
import '../kesiswaan/tata_tertib/tata_tertib_page.dart';
import '../kontak_page.dart';
import '../ppdb_page.dart';
import 'identitas_sekolah/identitas_sekolah_page.dart';
import 'sambutan_kepala_sekolah/sambutan_kepala_sekolah_page.dart';
import 'sarana_prasarana/sarana_prasarana_page.dart';
import 'sejarah_sekolah/sejarah_sekolah_page.dart';
import 'struktur_organisasi/struktur_organisasi_page.dart';
import 'visi_misi/visi_misi_page.dart';
import '../site_chrome.dart';

class ProfilePageShell extends StatelessWidget {
  const ProfilePageShell({super.key, required this.title, required this.description, required this.icon, required this.content, this.sectionName = 'Profil SMAK'});

  final String title;
  final String description;
  final IconData icon;
  final List<Widget> content;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const SmakTopInfoBar(),
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
          ),
          Container(
            color: const Color(0xFFF7FAFE),
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(color: const Color(0xFFEAF3FF), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  CircleAvatar(radius: 32, backgroundColor: const Color(0xFF0752B9), child: Icon(icon, color: Colors.white, size: 30)),
                  const SizedBox(width: 18),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF082E65))),
                    const SizedBox(height: 8),
                    Text(description, style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF526178))),
                  ])),
                ]),
              ),
              const SizedBox(height: 28),
                  ...content,
                ]),
              ),
            ),
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
        ]),
      ),
    );
  }
}

class ProfileContentCard extends StatelessWidget {
  const ProfileContentCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE2E8F0))),
    child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF082E65))), const SizedBox(height: 12), child])),
  );
}

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter();
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, color: const Color(0xFF102D4D), padding: const EdgeInsets.fromLTRB(52, 36, 52, 20), child: Column(children: [const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 6, child: _ProfileFooterBrand()), SizedBox(width: 42), Expanded(flex: 4, child: _ProfileFooterLinks()), SizedBox(width: 42), Expanded(flex: 6, child: _ProfileFooterContact()), SizedBox(width: 42), Expanded(flex: 4, child: _ProfileFooterHours())]), const SizedBox(height: 30), Container(height: 1, color: Color(0xFF54708E)), const SizedBox(height: 18), const Text('© 2025 SMAK Mgr. Soegijapranata. All rights reserved.', style: TextStyle(color: Color(0xFFE5EEF7), fontSize: 12))]));
}

class _ProfileFooterBrand extends StatelessWidget {
  const _ProfileFooterBrand();
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Image.asset('assets/images/logo_sekolah.png', width: 46, height: 52, fit: BoxFit.contain), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('SMAK Mgr. Soegijapranata', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), SizedBox(height: 8), Text('Membentuk generasi muda yang cerdas,\nberiman, dan siap berkarya bagi masyarakat.', style: TextStyle(color: Colors.white, height: 1.5))]))]);
}

class _ProfileFooterLinks extends StatelessWidget {
  const _ProfileFooterLinks();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Tautan Cepat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), SizedBox(height: 14), Text('Beranda\nProfil\nAkademik\nKesiswaan\nBerita\nGaleri\nPPDB\nKontak', style: TextStyle(color: Colors.white, height: 1.6))]);
}

class _ProfileFooterContact extends StatelessWidget {
  const _ProfileFooterContact();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Kontak Kami', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), SizedBox(height: 14), Text('V68H+JGC, Jogoyudan, Kec. Lumajang,\nKabupaten Lumajang, Jawa Timur 67315', style: TextStyle(color: Colors.white, height: 1.5)), SizedBox(height: 12), Text('0815-5099-445', style: TextStyle(color: Colors.white)), SizedBox(height: 12), Text('Jawa Timur', style: TextStyle(color: Colors.white))]);
}

class _ProfileFooterHours extends StatelessWidget {
  const _ProfileFooterHours();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Jam Operasional', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), SizedBox(height: 14), Text('Senin - Jumat\n07.00 - 15.00 WIB', style: TextStyle(color: Colors.white, height: 1.5)), SizedBox(height: 20), Text('"Ora et Labora"\n(Berdoa dan Bekerja)', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, height: 1.5))]);
}
