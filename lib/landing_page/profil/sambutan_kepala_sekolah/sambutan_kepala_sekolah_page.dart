import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../../routing/public_routes.dart';

import '../../akademik/jadwal_pelajaran/jadwal_pelajaran_page.dart';
import '../../akademik/kalender_akademik/kalender_akademik_page.dart';
import '../../akademik/kurikulum/kurikulum_page.dart';
import '../../akademik/prestasi_akademik/prestasi_akademik_page.dart';
import '../../kesiswaan/ekstrakurikuler/ekstrakurikuler_page.dart';
import '../../kesiswaan/osis/osis_page.dart';
import '../../kesiswaan/prestasi_siswa/prestasi_siswa_page.dart';
import '../../kesiswaan/tata_tertib/tata_tertib_page.dart';
import '../../site_chrome.dart';
import '../sarana_prasarana/sarana_prasarana_page.dart';
import '../sejarah_sekolah/sejarah_sekolah_page.dart';
import '../struktur_organisasi/struktur_organisasi_page.dart';
import '../visi_misi/visi_misi_page.dart';

const _welcomeBlue = Color(0xFF0B57D0);
const _welcomeNavy = Color(0xFF0A2F66);
const _welcomeText = Color(0xFF123A73);
const _welcomeMuted = Color(0xFF5F718A);
const _welcomeBg = Color(0xFFF5F8FD);
const _welcomeLine = Color(0xFFE2EAF4);
const _welcomeGold = Color(0xFFE0AC21);

List<dynamic> _sambutanJsonList(dynamic raw) {
  try {
    final value = jsonDecode('${raw ?? ''}');
    return value is List ? value : const [];
  } catch (_) {
    return const [];
  }
}

class SambutanKepalaSekolahPage extends StatelessWidget {
  const SambutanKepalaSekolahPage({super.key});

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: const SmakApi().getTable('sambutan_kepala_sekolah', limit: 1),
        builder: (context, snapshot) => _buildPage(
          context,
          (snapshot.data?.isNotEmpty ?? false)
              ? snapshot.data!.first
              : const {},
        ),
      );

  Widget _buildPage(BuildContext context, Map<String, dynamic> data) {
    return Scaffold(
      backgroundColor: _welcomeBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SharedSmakNavigationBar(
              profilePages: {
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
            _WelcomeHero(data: data),
            _WelcomeBody(data: data),
            SharedSmakFooter(
              profilePages: {
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

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: compact ? 340 : 300),
      color: _welcomeNavy,
      child: Stack(
        children: [
          Positioned.fill(
            child: compact
                ? _WelcomePlaceholderImage(
                    label: 'Foto Kepala Sekolah & Siswa',
                    source: '${data['banner'] ?? ''}',
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 48,
                        child: ColoredBox(color: _welcomeNavy),
                      ),
                      Expanded(
                        flex: 52,
                        child: _WelcomePlaceholderImage(
                          label: 'Foto Kepala Sekolah & Siswa',
                          source: '${data['banner'] ?? ''}',
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
                          _welcomeNavy.withOpacity(.92),
                          _welcomeNavy.withOpacity(.8),
                          _welcomeNavy.withOpacity(.35),
                        ]
                      : [
                          _welcomeNavy,
                          _welcomeNavy,
                          _welcomeNavy.withOpacity(.72),
                          _welcomeNavy.withOpacity(.18),
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
                        SizedBox(
                          width: 72,
                          child: Divider(
                            color: _welcomeGold,
                            thickness: 3,
                            height: 3,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          '${data['judul'] ?? 'Sambutan Kepala Sekolah'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Beranda   >   Profil   >   Sambutan Kepala Sekolah',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${data['subtitle'] ?? 'Pesan dan harapan untuk seluruh keluarga besar SMAK.'}',
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

class _WelcomeBody extends StatelessWidget {
  const _WelcomeBody({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1220),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(0, -44),
                child: _PrincipalProfileCard(data: data),
              ),
              _GreetingSection(data: data),
              SizedBox(height: 28),
              _LeadershipCommitmentSection(data: data),
              SizedBox(height: 28),
              _HopeSection(data: data),
              SizedBox(height: 28),
              _CommunitySection(),
              SizedBox(height: 28),
              _BlueQuoteBanner(data: data),
              SizedBox(height: 28),
              _PriorityProgramsSection(data: data),
              SizedBox(height: 28),
              _PrincipalActivitiesSection(data: data),
              SizedBox(height: 28),
              _ClosingLetterCard(data: data),
              SizedBox(height: 28),
              _WelcomeBottomCta(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrincipalProfileCard extends StatelessWidget {
  const _PrincipalProfileCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _welcomeLine),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: compact
          ? Column(
              children: [
                _PrincipalPortrait(source: '${data['gambar'] ?? ''}'),
                const SizedBox(height: 18),
                _PrincipalIdentity(data: data),
                const SizedBox(height: 18),
                _PrincipalContacts(data: data),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PrincipalPortrait(source: '${data['gambar'] ?? ''}'),
                const SizedBox(width: 22),
                Expanded(flex: 5, child: _PrincipalIdentity(data: data)),
                const SizedBox(width: 22),
                Expanded(flex: 4, child: _PrincipalContacts(data: data)),
              ],
            ),
    );
  }
}

class _PrincipalPortrait extends StatelessWidget {
  const _PrincipalPortrait({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: websiteContentImage(
          source,
          fit: BoxFit.cover,
          width: 160,
          height: 190,
        ),
      ),
    );
  }
}

class _PrincipalIdentity extends StatelessWidget {
  const _PrincipalIdentity({required this.data});
  final Map<String, dynamic> data;

  String _v(String key, String fallback) {
    final value = '${data[key] ?? ''}'.trim();
    return value.isEmpty ? fallback : value;
  }

  @override
  Widget build(BuildContext context) {
    final name = _v('nama_kepala', 'Drs. Andreas Prasetyo');
    final role = _v('jabatan', 'Kepala SMAK Mgr. Soegijapranata');
    final period = _v('masa_jabatan', '2023-Sekarang');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: _welcomeText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          role,
          style: const TextStyle(
            color: _welcomeGold,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: _welcomeNavy,
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              'Masa Jabatan $period',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          width: 110,
          child: Divider(color: _welcomeText, thickness: 2, height: 2),
        ),
      ],
    );
  }
}

class _PrincipalContacts extends StatelessWidget {
  const _PrincipalContacts({required this.data});
  final Map<String, dynamic> data;

  String _v(String key, String fallback) {
    final value = '${data[key] ?? ''}'.trim();
    return value.isEmpty ? fallback : value;
  }

  @override
  Widget build(BuildContext context) {
    final socials = _sambutanJsonList(data['sosial_json']);
    const icons = [
      Icons.facebook_rounded,
      Icons.camera_alt_rounded,
      Icons.play_arrow_rounded,
      Icons.music_note_rounded,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactLine(Icons.call_rounded, _v('telepon', '(024) 831-6521')),
        const SizedBox(height: 12),
        _ContactLine(
          Icons.mail_rounded,
          _v('email', 'kepsek@smaksoegijapranata.sch.id'),
        ),
        const SizedBox(height: 12),
        _ContactLine(
          Icons.location_on_rounded,
          _v('alamat', 'Jl. Poyudan Luhur IV/1, Semarang, Jawa Tengah'),
        ),
        if (socials.isNotEmpty) ...[
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              socials.length,
              (i) => _SocialCircle(icon: icons[i % icons.length]),
            ),
          ),
        ],
      ],
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _welcomeText, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _welcomeMuted,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: _welcomeNavy,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.data});
  final Map<String, dynamic> data;

  String _v(String key, String fallback) {
    final value = '${data[key] ?? ''}'.trim();
    return value.isEmpty ? fallback : value;
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    final side = Column(
      children: [
        _SideInfoCard(
          title: 'Pesan Kepala Sekolah',
          icon: Icons.forum_rounded,
          text: _v(
            'pesan',
            'Percayalah pada proses, hiduplah dalam disiplin, dan belajarlah untuk mengasihi. Tuhan kunci menjadi pribadi yang utuh dan bermakna.',
          ),
          accent: _welcomeGold,
        ),
        const SizedBox(height: 14),
        _SideInfoCard(
          title: 'Motto Sekolah',
          icon: Icons.shield_rounded,
          text: _v('motto', 'Veritas in Caritate\n(Kebenaran dalam Kasih)'),
          accent: _welcomeBlue,
        ),
      ],
    );
    return compact
        ? Column(
            children: [
              _GreetingTextCard(data: data),
              const SizedBox(height: 18),
              side,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _GreetingTextCard(data: data)),
              const SizedBox(width: 18),
              Expanded(flex: 3, child: side),
            ],
          );
  }
}

class _GreetingTextCard extends StatelessWidget {
  const _GreetingTextCard({required this.data});
  final Map<String, dynamic> data;

  String _v(String key, String fallback) {
    final value = '${data[key] ?? ''}'.trim();
    return value.isEmpty ? fallback : value;
  }

  @override
  Widget build(BuildContext context) {
    final quote = _v(
      'kutipan',
      '“Tuhan adalah sumber hikmat, dari-Nya datang terang yang menerangi jalan hidup kita.”',
    );
    final source = _v('sumber_kutipan', 'Amsal 2:6');
    final body = _v(
      'isi',
      'Salam sejahtera bagi kita semua,\n\nPuji syukur kita haturkan ke hadirat Tuhan Yang Maha Esa atas segala berkat dan penyertaan-Nya, sehingga kita semua dapat berkarya dan melayani di dalam komunitas pendidikan SMAK Mgr. Soegijapranata yang kita cintai.\n\nSebagai Kepala Sekolah, saya merasa terhormat dan bersyukur dapat memimpin sekolah ini bersama Bapak/Ibu Guru, Tenaga Kependidikan, Peserta Didik, dan seluruh orang tua dalam semangat pelayanan dan kasih.\n\nSMAK Mgr. Soegijapranata bukan hanya tempat belajar, tetapi juga rumah untuk bertumbuh dalam iman, ilmu, karakter, dan kepedulian terhadap sesama. Kita berkomitmen untuk menghadirkan pendidikan berkualitas yang utuh, seimbang, dan berorientasi pada masa depan.\n\nMari kita terus berjalan bersama, saling mendukung, dan berkolaborasi untuk mewujudkan sekolah yang unggul, berkarakter, dan berjiwa pelayanan.\n\nTuhan memberkati langkah dan karya kita semua.\n\nSalam kasih,',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Salam dan Sambutan',
          style: TextStyle(
            color: _welcomeText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const SizedBox(
          width: 62,
          child: Divider(color: _welcomeGold, thickness: 3, height: 3),
        ),
        const SizedBox(height: 16),
        Text(
          quote,
          style: const TextStyle(
            color: _welcomeText,
            fontSize: 20,
            height: 1.6,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '— $source —',
          style: const TextStyle(
            color: _welcomeGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          body,
          style: const TextStyle(
            color: _welcomeMuted,
            fontSize: 14.5,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

class _SideInfoCard extends StatelessWidget {
  const _SideInfoCard({
    required this.title,
    required this.icon,
    required this.text,
    required this.accent,
  });

  final String title;
  final IconData icon;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: accent,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              color: _welcomeMuted,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadershipCommitmentSection extends StatelessWidget {
  const _LeadershipCommitmentSection({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    const fallback = [
      _CommitmentItem(
        Icons.school_rounded,
        'Pendidikan Berkualitas',
        'Menyediakan proses belajar mengajar yang inovatif, relevan, dan berorientasi pada pencapaian kompetensi abad 21.',
      ),
      _CommitmentItem(
        Icons.favorite_rounded,
        'Pembentukan Karakter',
        'Menumbuhkan nilai-nilai Kristiani, disiplin, integritas, tanggung jawab, dan kepedulian dalam kehidupan sehari-hari.',
      ),
      _CommitmentItem(
        Icons.star_rounded,
        'Pengembangan Potensi',
        'Menggali dan mengembangkan bakat serta minat peserta didik melalui kegiatan akademik maupun non-akademik.',
      ),
      _CommitmentItem(
        Icons.groups_rounded,
        'Pelayanan Penuh Kasih',
        'Menghadirkan pelayanan yang manusiawi, menghargai setiap pribadi, dan membangun komunitas sekolah yang harmonis.',
      ),
    ];
    final decoded = _sambutanJsonList(data['komitmen_json']);
    const icons = [
      Icons.school_rounded,
      Icons.favorite_rounded,
      Icons.star_rounded,
      Icons.groups_rounded,
    ];
    final items = data.containsKey('komitmen_json')
        ? List.generate(decoded.length, (i) {
            final item = decoded[i];
            if (item is Map) {
              final map = Map<String, dynamic>.from(item);
              return _CommitmentItem(
                icons[i % icons.length],
                '${map['judul'] ?? map['title'] ?? 'Komitmen ${i + 1}'}',
                '${map['teks'] ?? map['text'] ?? ''}',
              );
            }
            return _CommitmentItem(
              icons[i % icons.length],
              'Komitmen ${i + 1}',
              '$item',
            );
          })
        : fallback;

    return Column(
      children: [
        const _CenteredWelcomeTitle('Komitmen Kepemimpinan'),
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
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 1 ? 2.5 : 1.05,
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

class _CommitmentItem {
  const _CommitmentItem(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

class _CommitmentCard extends StatelessWidget {
  const _CommitmentCard(this.item);

  final _CommitmentItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _welcomeLine),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: _welcomeBlue, size: 38),
          const SizedBox(height: 14),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _welcomeText,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _welcomeMuted,
              fontSize: 12.8,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _HopeSection extends StatelessWidget {
  const _HopeSection({required this.data});
  final Map<String, dynamic> data;

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
                const _HopeImagePlaceholder(),
                const SizedBox(height: 18),
                _HopeText(data: data),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 4, child: _HopeImagePlaceholder()),
                const SizedBox(width: 22),
                Expanded(flex: 6, child: _HopeText(data: data)),
              ],
            ),
    );
  }
}

class _HopeImagePlaceholder extends StatelessWidget {
  const _HopeImagePlaceholder();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: SizedBox(
      height: 250,
      width: double.infinity,
      child: websiteFallbackImage(
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      ),
    ),
  );
}

class _HopeText extends StatelessWidget {
  const _HopeText({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    const fallback = [
      _HopeItem(
        '01',
        'Prestasi yang Bertumbuh',
        'Mendorong pencapaian akademik dan non-akademik yang berkelanjutan sehingga setiap siswa dapat menjadi versi terbaik dirinya.',
      ),
      _HopeItem(
        '02',
        'Karakter yang Kuat',
        'Membentuk pribadi yang berintegritas, beriman, disiplin, dan peduli terhadap sesama serta lingkungan.',
      ),
      _HopeItem(
        '03',
        'Kolaborasi yang Harmonis',
        'Membangun kemitraan yang erat antara sekolah, orang tua, dan masyarakat demi kebaikan bersama.',
      ),
    ];
    final decoded = _sambutanJsonList(data['harapan_json']);
    final items = data.containsKey('harapan_json')
        ? List.generate(decoded.length, (i) {
            final item = decoded[i];
            final number = '${i + 1}'.padLeft(2, '0');
            if (item is Map) {
              final map = Map<String, dynamic>.from(item);
              return _HopeItem(
                number,
                '${map['judul'] ?? map['title'] ?? 'Harapan ${i + 1}'}',
                '${map['teks'] ?? map['text'] ?? ''}',
              );
            }
            return _HopeItem(number, 'Harapan ${i + 1}', '$item');
          })
        : fallback;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Arah dan Harapan',
          style: TextStyle(
            color: _welcomeText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        ...items.map((item) => _HopeLine(item)),
      ],
    );
  }
}

class _HopeItem {
  const _HopeItem(this.number, this.title, this.text);

  final String number;
  final String title;
  final String text;
}

class _HopeLine extends StatelessWidget {
  const _HopeLine(this.item);

  final _HopeItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: _welcomeBlue,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              item.number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _welcomeText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.text,
                  style: const TextStyle(
                    color: _welcomeMuted,
                    fontSize: 13,
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

class _CommunitySection extends StatelessWidget {
  const _CommunitySection();

  @override
  Widget build(BuildContext context) {
    const items = [
      _CommunityItem(
        Icons.groups_rounded,
        'Peserta Didik',
        'Jadilah pelajar yang beriman, berilmu, berkarakter, dan berani bermimpi besar.',
      ),
      _CommunityItem(
        Icons.family_restroom_rounded,
        'Orang Tua',
        'Terima kasih atas kepercayaan dan kerja samanya. Mari kita mendampingi anak-anak dengan cinta, doa, dan teladan.',
      ),
      _CommunityItem(
        Icons.person_rounded,
        'Guru & Tenaga Kependidikan',
        'Terima kasih atas dedikasi dan pelayanan tanpa lelah. SMAK akan menjadi rumah belajar yang bermakna bagi setiap anak.',
      ),
    ];

    return Column(
      children: [
        const _CenteredWelcomeTitle('Bersama Membangun SMAK'),
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
              childAspectRatio: count == 1 ? 2.4 : 1.15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => _CommunityCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _CommunityItem {
  const _CommunityItem(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard(this.item);

  final _CommunityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _welcomeLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: _welcomeBlue, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _welcomeText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.text,
                  style: const TextStyle(
                    color: _welcomeMuted,
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

class _BlueQuoteBanner extends StatelessWidget {
  const _BlueQuoteBanner({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final motto = '${data['motto'] ?? ''}'.trim();
    final displayText = motto.isEmpty
        ? 'Sekolah bukan hanya tempat menimba ilmu,\ntetapi rumah untuk bertumbuh dalam iman, karakter, dan kepedulian.'
        : motto;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
      decoration: BoxDecoration(
        color: _welcomeNavy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded, color: _welcomeGold, size: 50),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              'Sekolah bukan hanya tempat menimba ilmu,\ntetapi rumah untuk bertumbuh dalam iman, karakter, dan kepedulian.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                height: 1.55,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityProgramsSection extends StatelessWidget {
  const _PriorityProgramsSection({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final fallback = [
      _ProgramItem(
        Icons.menu_book_rounded,
        'Penguatan Akademik',
        'Meningkatkan kualitas pembelajaran dan asesmen untuk hasil belajar yang optimal dan relevan.',
      ),
      _ProgramItem(
        Icons.computer_rounded,
        'Digitalisasi Pembelajaran',
        'Memanfaatkan teknologi untuk proses belajar yang efektif, kreatif, dan berdaya saing.',
      ),
      _ProgramItem(
        Icons.groups_rounded,
        'Sekolah Ramah Anak',
        'Mewujudkan lingkungan sekolah yang aman, nyaman, inklusif, dan mendukung perkembangan anak.',
      ),
      _ProgramItem(
        Icons.star_rounded,
        'Pengembangan Talenta',
        'Mendukung pengembangan minat dan bakat siswa melalui berbagai program dan layanan.',
      ),
      _ProgramItem(
        Icons.auto_stories_rounded,
        'Budaya Literasi',
        'Menumbuhkan budaya membaca, menulis, dan berpikir kritis dalam kehidupan sehari-hari.',
      ),
      _ProgramItem(
        Icons.handshake_rounded,
        'Kemitraan & Alumni',
        'Memperkuat jaringan kemitraan dan peran alumni untuk kemajuan sekolah dan siswa.',
      ),
    ];
    final decoded = _sambutanJsonList(data['program_prioritas_json']);
    final icons = [
      Icons.menu_book_rounded,
      Icons.computer_rounded,
      Icons.groups_rounded,
      Icons.star_rounded,
      Icons.auto_stories_rounded,
      Icons.handshake_rounded,
    ];
    final items = decoded.isEmpty
        ? fallback
        : List.generate(decoded.length, (index) {
            final item = decoded[index];
            final map = item is Map
                ? Map<String, dynamic>.from(item)
                : <String, dynamic>{};
            return _ProgramItem(
              icons[index % icons.length],
              '${map['title'] ?? item}',
              '${map['text'] ?? ''}',
            );
          });

    return Column(
      children: [
        const _CenteredWelcomeTitle('Program Prioritas Kepala Sekolah'),
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
              childAspectRatio: count == 1 ? 2.6 : 1.45,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => _ProgramCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ProgramItem {
  const _ProgramItem(this.icon, this.title, this.text);

  final IconData icon;
  final String title;
  final String text;
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard(this.item);

  final _ProgramItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _welcomeLine),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: _welcomeBlue, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _welcomeText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.text,
                  style: const TextStyle(
                    color: _welcomeMuted,
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

class _PrincipalActivitiesSection extends StatelessWidget {
  const _PrincipalActivitiesSection({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final fallback = [
      'Pendampingan Siswa',
      'Rapat Bersama Guru',
      'Kunjungan Orang Tua',
      'Pelayanan Masyarakat',
    ];
    final decoded = _sambutanJsonList(data['kegiatan_kepala_json']);
    final items = decoded.isEmpty
        ? fallback
        : decoded.map((item) => '$item').toList();

    return Column(
      children: [
        const _CenteredWelcomeTitle('Jejak Kegiatan Kepala Sekolah'),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 980
                ? 4
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: count == 1 ? 2 : .95,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items
                  .map(
                    (item) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: websiteFallbackImage(
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item,
                          style: const TextStyle(
                            color: _welcomeText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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

class _ClosingLetterCard extends StatelessWidget {
  const _ClosingLetterCard({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _welcomeLine),
      ),
      child: compact
          ? Column(
              children: [
                _ClosingPortrait(source: '${data['gambar'] ?? ''}'),
                SizedBox(height: 18),
                _ClosingText(data: data),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ClosingPortrait(source: '${data['gambar'] ?? ''}'),
                SizedBox(width: 22),
                Expanded(child: _ClosingText(data: data)),
              ],
            ),
    );
  }
}

class _ClosingPortrait extends StatelessWidget {
  const _ClosingPortrait({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: websiteContentImage(
          source,
          fit: BoxFit.cover,
          width: 150,
          height: 190,
        ),
      ),
    );
  }
}

class _ClosingText extends StatelessWidget {
  const _ClosingText({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${data['penutup'] ?? ''}',
          style: const TextStyle(
            color: _welcomeMuted,
            fontSize: 14.5,
            height: 1.8,
          ),
        ),
        SizedBox(height: 18),
        SizedBox(
          width: 120,
          child: Divider(color: _welcomeText, thickness: 2, height: 2),
        ),
        SizedBox(height: 12),
        Text(
          '${data['nama_kepala'] ?? ''}',
          style: const TextStyle(
            color: _welcomeText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${data['jabatan'] ?? ''}',
          style: const TextStyle(
            color: _welcomeMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WelcomeBottomCta extends StatelessWidget {
  const _WelcomeBottomCta();

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
                const _BottomWelcomeText(),
                const SizedBox(height: 18),
                _BottomWelcomeButtons(compact: compact),
              ],
            )
          : Row(
              children: [
                const Expanded(child: _BottomWelcomeText()),
                const SizedBox(width: 22),
                _BottomWelcomeButtons(compact: compact),
              ],
            ),
    );
  }
}

class _BottomWelcomeText extends StatelessWidget {
  const _BottomWelcomeText();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.menu_book_rounded, color: Colors.white, size: 46),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mari Bertumbuh Bersama SMAK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Bersama kita mewujudkan sekolah yang unggul, berkarakter, dan berjiwa pelayanan.',
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

class _BottomWelcomeButtons extends StatelessWidget {
  const _BottomWelcomeButtons({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final profileButton = FilledButton(
      onPressed: () => publicRootNavigator(
        context,
      ).pushNamed(PublicRoutes.profileIdentity),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _welcomeBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Lihat Profil Sekolah',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );

    final contactButton = FilledButton(
      onPressed: () => openSharedLink(globalWhatsappUrl(context)),
      style: FilledButton.styleFrom(
        backgroundColor: _welcomeGold,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Hubungi Sekolah',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );

    return SizedBox(
      width: compact ? double.infinity : 360,
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

class _CenteredWelcomeTitle extends StatelessWidget {
  const _CenteredWelcomeTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _welcomeText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(
          width: 62,
          child: Divider(color: _welcomeGold, thickness: 3, height: 3),
        ),
      ],
    );
  }
}

class _WelcomePlaceholderImage extends StatelessWidget {
  const _WelcomePlaceholderImage({required this.label, required this.source});

  final String label;
  final String source;

  @override
  Widget build(BuildContext context) => websiteContentImage(
    source,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );
}
