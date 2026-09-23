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
import '../identitas_sekolah/identitas_sekolah_page.dart';
import '../sambutan_kepala_sekolah/sambutan_kepala_sekolah_page.dart';
import '../sejarah_sekolah/sejarah_sekolah_page.dart';
import '../struktur_organisasi/struktur_organisasi_page.dart';
import '../visi_misi/visi_misi_page.dart';

const _facilityBlue = Color(0xFF0B57D0);
const _facilityNavy = Color(0xFF0A2F66);
const _facilityText = Color(0xFF123A73);
const _facilityMuted = Color(0xFF5F718A);
const _facilityBg = Color(0xFFF5F8FD);
const _facilityLine = Color(0xFFE2EAF4);

class SaranaPrasaranaPage extends StatefulWidget {
  const SaranaPrasaranaPage({super.key});

  @override
  State<SaranaPrasaranaPage> createState() => _SaranaPrasaranaPageState();
}

class _SaranaPrasaranaPageState extends State<SaranaPrasaranaPage> {
  final _api = const SmakApi();
  late Future<_SarprasData> _future = _load();

  Future<_SarprasData> _load() async {
    final result = await Future.wait([
      _api.getTable('sarana_utama', limit: 1),
      _api.getTable('sarana_bagian', limit: 20),
      _api.getTable('sarana_poin_intro', limit: 100),
      _api.getTable('sarana_fasilitas_utama', limit: 100),
      _api.getTable('sarana_penunjang', limit: 100),
      _api.getTable('sarana_keagamaan', limit: 100),
      _api.getTable('sarana_keamanan', limit: 100),
      _api.getTable('sarana_galeri', limit: 100),
      _api.getTable('sarana_perawatan', limit: 100),
      _api.getTable('sarana_kutipan', limit: 1),
      _api.getTable('sarana_cta', limit: 1),
    ]);

    List<Map<String, dynamic>> active(List<Map<String, dynamic>> rows) {
      final values = rows
          .where(
            (row) => '${row['status'] ?? 'aktif'}'.toLowerCase() == 'aktif',
          )
          .toList();
      values.sort((a, b) {
        final ao = int.tryParse('${a['urutan'] ?? 0}') ?? 0;
        final bo = int.tryParse('${b['urutan'] ?? 0}') ?? 0;
        return ao.compareTo(bo);
      });
      return values;
    }

    final utama = active(result[0]);
    final quote = active(result[9]);
    final cta = active(result[10]);

    return _SarprasData(
      utama: utama.isEmpty ? null : utama.first,
      bagian: active(result[1]),
      intro: _mergeSarprasRows(_introFallback, active(result[2])),
      fasilitas: _mergeSarprasRows(_fasilitasFallback, active(result[3])),
      penunjang: _mergeSarprasRows(_penunjangFallback, active(result[4])),
      keagamaan: _mergeSarprasRows(_keagamaanFallback, active(result[5])),
      keamanan: _mergeSarprasRows(_keamananFallback, active(result[6])),
      galeri: _mergeSarprasRows(_galeriFallback, active(result[7])),
      perawatan: _mergeSarprasRows(_perawatanFallback, active(result[8])),
      quote: quote.isEmpty ? null : quote.first,
      cta: cta.isEmpty ? null : cta.first,
    );
  }

  Map<String, Widget> get _profilePages => {
    'identitas': const IdentitasSekolahPage(),
    'sambutan': const SambutanKepalaSekolahPage(),
    'sejarah': const SejarahSekolahPage(),
    'visi': const VisiMisiPage(),
    'struktur': const StrukturOrganisasiPage(),
    'sarana': const SaranaPrasaranaPage(),
  };

  Map<String, Widget> get _academicPages => {
    'kurikulum': const KurikulumPage(),
    'kalender': const KalenderAkademikPage(),
    'jadwal': const JadwalPelajaranPage(),
    'prestasi': const PrestasiAkademikPage(),
  };

  Map<String, Widget> get _studentPages => {
    'osis': const OsisPage(),
    'ekstra': const EkstrakurikulerPage(),
    'prestasi': const PrestasiSiswaPage(),
    'tata': const TataTertibPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _facilityBg,
      body: FutureBuilder<_SarprasData>(
        future: _future,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SharedSmakNavigationBar(
                  profilePages: _profilePages,
                  academicPages: _academicPages,
                  studentPages: _studentPages,
                  initialActive: 'Profil',
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.all(80),
                    child: CircularProgressIndicator(),
                  )
                else if (snapshot.hasError)
                  _SarprasLoadError(
                    onRetry: () => setState(() => _future = _load()),
                  )
                else if (snapshot.data != null) ...[
                  _FacilityHero(data: snapshot.data!.utama),
                  _FacilityBody(data: snapshot.data!),
                ],
                SharedSmakFooter(
                  profilePages: _profilePages,
                  academicPages: _academicPages,
                  studentPages: _studentPages,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SarprasData {
  const _SarprasData({
    required this.utama,
    required this.bagian,
    required this.intro,
    required this.fasilitas,
    required this.penunjang,
    required this.keagamaan,
    required this.keamanan,
    required this.galeri,
    required this.perawatan,
    required this.quote,
    required this.cta,
  });

  final Map<String, dynamic>? utama;
  final Map<String, dynamic>? quote;
  final Map<String, dynamic>? cta;
  final List<Map<String, dynamic>> bagian;
  final List<Map<String, dynamic>> intro;
  final List<Map<String, dynamic>> fasilitas;
  final List<Map<String, dynamic>> penunjang;
  final List<Map<String, dynamic>> keagamaan;
  final List<Map<String, dynamic>> keamanan;
  final List<Map<String, dynamic>> galeri;
  final List<Map<String, dynamic>> perawatan;

  Map<String, dynamic>? section(String code) {
    for (final row in bagian) {
      if ('${row['kode'] ?? ''}' == code) return row;
    }
    return null;
  }
}

String _dbText(Map<String, dynamic>? row, String key, [String fallback = '']) {
  final value = '${row?[key] ?? ''}'.trim();
  return value.isEmpty ? fallback : value;
}

// Database may contain only part of this page. Keep existing UI content and
// replace only the matching entries supplied by the admin dashboard.
List<Map<String, dynamic>> _mergeSarprasRows(
  List<Map<String, String>> fallback,
  List<Map<String, dynamic>> databaseRows,
) {
  if (databaseRows.isNotEmpty) {
    return databaseRows.map(Map<String, dynamic>.from).toList();
  }
  final merged = <Map<String, dynamic>>[
    for (var index = 0; index < fallback.length; index++)
      <String, dynamic>{...fallback[index], 'urutan': '${index + 1}'},
  ];

  return merged;
}

const _introFallback = [
  {'judul': 'Ruang Pembelajaran', 'icon': 'class'},
  {'judul': 'Fasilitas Dasar', 'icon': 'science'},
  {'judul': 'Lingkungan Aman', 'icon': 'apartment'},
  {'judul': 'Digunakan Bersama', 'icon': 'groups'},
];

const _fasilitasFallback = [
  {
    'judul': 'Ruang Kelas',
    'deskripsi': 'Ruang belajar utama untuk kegiatan pembelajaran setiap hari.',
    'kategori': 'Akademik',
  },
  {
    'judul': 'Perpustakaan Sekolah',
    'deskripsi':
        'Koleksi buku pelajaran dan referensi untuk mendukung kegiatan belajar.',
    'kategori': 'Akademik',
  },
  {
    'judul': 'Ruang Komputer Sederhana',
    'deskripsi': 'Komputer dasar untuk pembelajaran TIK sesuai kebutuhan.',
    'kategori': 'Pendukung',
  },
  {
    'judul': 'Ruang Praktik IPA',
    'deskripsi':
        'Ruang praktik dengan peralatan dasar IPA dan media pembelajaran.',
    'kategori': 'Akademik',
  },
  {
    'judul': 'Halaman/Lapangan Sekolah',
    'deskripsi':
        'Digunakan untuk olahraga, upacara, dan kegiatan luar ruang lainnya.',
    'kategori': 'Pengembangan Diri',
  },
  {
    'judul': 'Ruang Pertemuan',
    'deskripsi': 'Digunakan untuk pertemuan, diskusi, dan kegiatan sekolah.',
    'kategori': 'Rohani',
  },
];

const _penunjangFallback = [
  {
    'judul': 'Proyektor Bersama',
    'deskripsi': 'Digunakan bersama sesuai jadwal dan kebutuhan kelas.',
    'icon': 'desktop_windows',
  },
  {
    'judul': 'Papan Tulis',
    'deskripsi': 'Tersedia di setiap ruang kelas untuk mendukung pembelajaran.',
    'icon': 'edit',
  },
  {
    'judul': 'Alat Praktik Dasar',
    'deskripsi':
        'Peralatan praktik sederhana untuk kegiatan belajar IPA dan lain-lain.',
    'icon': 'science',
  },
  {
    'judul': 'Koneksi Internet Terbatas',
    'deskripsi':
        'Akses internet digunakan seperlunya untuk pembelajaran dan administrasi.',
    'icon': 'wifi',
  },
];

const _keagamaanFallback = [
  {
    'judul': 'Ruang Doa/Kapel Sederhana',
    'deskripsi':
        'Tempat berdoa bersama dan perayaan Ekaristi pada waktu tertentu.',
    'icon': 'church',
  },
  {
    'judul': 'Kegiatan Kerohanian',
    'deskripsi':
        'Pembinaan iman, retret, dan kegiatan rohani bersama secara berkala.',
    'icon': 'groups',
  },
];

const _keamananFallback = [
  {
    'judul': 'UKS Sederhana',
    'deskripsi': 'Pertolongan pertama untuk kesehatan siswa.',
    'icon': 'medical_services',
  },
  {
    'judul': 'Kantin',
    'deskripsi': 'Kantin sederhana dengan menu bergizi.',
    'icon': 'storefront',
  },
  {
    'judul': 'Toilet',
    'deskripsi': 'Toilet bersih dan terawat untuk siswa dan guru.',
    'icon': 'wc',
  },
  {
    'judul': 'Tempat Parkir',
    'deskripsi': 'Area parkir untuk kendaraan siswa, guru, dan tamu.',
    'icon': 'local_parking',
  },
  {
    'judul': 'Kebersihan Lingkungan',
    'deskripsi': 'Kebersihan sekolah dijaga bersama-sama.',
    'icon': 'clean_hands',
  },
];

const _galeriFallback = [
  {'judul': 'Ruang Kelas'},
  {'judul': 'Perpustakaan Sekolah'},
  {'judul': 'Ruang Komputer Sederhana'},
  {'judul': 'Ruang Praktik IPA'},
  {'judul': 'Halaman/Lapangan Sekolah'},
  {'judul': 'Ruang Pertemuan'},
];

const _perawatanFallback = [
  {
    'judul': 'Pengecekan Rutin',
    'deskripsi': 'Fasilitas dicek secara berkala agar tetap aman digunakan.',
  },
  {
    'judul': 'Kebersihan Harian',
    'deskripsi': 'Menjaga kebersihan ruang dan lingkungan setiap hari.',
  },
  {
    'judul': 'Perawatan Bertahap',
    'deskripsi': 'Perbaikan dilakukan sesuai prioritas dan kemampuan sekolah.',
  },
  {
    'judul': 'Penggunaan Bertanggung Jawab',
    'deskripsi': 'Siswa diajak merawat fasilitas bersama-sama.',
  },
];

class _FacilityHero extends StatelessWidget {
  const _FacilityHero({required this.data});

  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: compact ? 340 : 300),
      color: _facilityNavy,
      child: Stack(
        children: [
          Positioned.fill(
            child: compact
                ? _DbFacilityImage(
                    path: _dbText(data, 'banner'),
                    label: 'Foto Gedung Sekolah',
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 44,
                        child: ColoredBox(color: _facilityNavy),
                      ),
                      Expanded(
                        flex: 56,
                        child: _DbFacilityImage(
                          path: _dbText(data, 'banner'),
                          label: 'Foto Gedung Sekolah',
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
                          _facilityNavy.withOpacity(.92),
                          _facilityNavy.withOpacity(.8),
                          _facilityNavy.withOpacity(.34),
                        ]
                      : [
                          _facilityNavy,
                          _facilityNavy,
                          _facilityNavy.withOpacity(.74),
                          _facilityNavy.withOpacity(.18),
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
                          _dbText(data, 'judul', 'Sarana & Prasarana'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          _dbText(
                            data,
                            'breadcrumb',
                            'Beranda   >   Profil   >   Sarana & Prasarana',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          _dbText(
                            data,
                            'deskripsi',
                            'Fasilitas di SMA Katolik Mgr. Soegijapranata Lumajang kami sediakan secara sederhana dan bertahap untuk mendukung proses belajar serta pembentukan karakter peserta didik.',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.75,
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

class _FacilityBody extends StatefulWidget {
  const _FacilityBody({required this.data});

  final _SarprasData data;

  @override
  State<_FacilityBody> createState() => _FacilityBodyState();
}

class _FacilityBodyState extends State<_FacilityBody> {
  String _selectedCategory = 'Semua Fasilitas';

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final bodyWidth = viewportWidth > 1264 ? 1220.0 : viewportWidth;

    return Center(
      child: SizedBox(
        width: bodyWidth,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Column(
            children: [
              _FacilityIntroSection(
                data: widget.data,
                selectedCategory: _selectedCategory,
                onCategorySelected: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 28),
              _MainFacilitiesSection(
                data: widget.data,
                selectedCategory: _selectedCategory,
              ),
              const SizedBox(height: 28),
              _SupportFacilitiesSection(data: widget.data),
              const SizedBox(height: 28),
              _CharacterFacilitiesSection(data: widget.data),
              const SizedBox(height: 28),
              _SafetyFacilitiesSection(data: widget.data),
              const SizedBox(height: 28),
              _FacilityGallerySection(data: widget.data),
              const SizedBox(height: 28),
              _MaintenanceSection(data: widget.data),
              const SizedBox(height: 28),
              _FacilityBottomCta(data: widget.data),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacilityIntroSection extends StatelessWidget {
  const _FacilityIntroSection({
    required this.data,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final _SarprasData data;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return compact
        ? Column(
            children: [
              _LogoCirclePlaceholder(section: data.section('intro')),
              const SizedBox(height: 18),
              _FacilityIntroText(
                data: data,
                selectedCategory: selectedCategory,
                onCategorySelected: onCategorySelected,
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LogoCirclePlaceholder(section: data.section('intro')),
              const SizedBox(width: 28),
              Expanded(
                child: _FacilityIntroText(
                  data: data,
                  selectedCategory: selectedCategory,
                  onCategorySelected: onCategorySelected,
                ),
              ),
            ],
          );
  }
}

class _LogoCirclePlaceholder extends StatelessWidget {
  const _LogoCirclePlaceholder({required this.section});

  final Map<String, dynamic>? section;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: _facilityLine),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120A2F66),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: websiteContentImage(
          _dbText(section, 'gambar'),
          fit: BoxFit.contain,
          width: 142,
          height: 142,
        ),
      ),
    );
  }
}

class _FacilityIntroText extends StatelessWidget {
  const _FacilityIntroText({
    required this.data,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final _SarprasData data;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final introRows = data.intro;
    final chips = introRows.isNotEmpty
        ? introRows
              .map(
                (row) => _IntroChip(
                  _facilityIcon(_dbText(row, 'icon')),
                  _dbText(row, 'judul'),
                ),
              )
              .toList()
        : const [
            _IntroChip(Icons.class_rounded, 'Ruang Pembelajaran'),
            _IntroChip(Icons.science_rounded, 'Fasilitas Dasar'),
            _IntroChip(Icons.apartment_rounded, 'Lingkungan Aman'),
            _IntroChip(Icons.groups_rounded, 'Digunakan Bersama'),
          ];

    final categories = data.fasilitas
        .map((row) => _dbText(row, 'kategori'))
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dbText(
            data.section('intro'),
            'judul',
            'Lingkungan Belajar yang Mendukung',
          ),
          style: TextStyle(
            color: _facilityText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _dbText(
            data.section('intro'),
            'deskripsi',
            'Kami berkomitmen menyediakan fasilitas dasar yang aman, nyaman, dan dirawat bertahap sesuai kemampuan sekolah serta menyesuaikan kebutuhan pembelajaran.',
          ),
          style: TextStyle(color: _facilityMuted, fontSize: 14.5, height: 1.7),
        ),
        const SizedBox(height: 22),
        Wrap(spacing: 12, runSpacing: 12, children: chips),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _FilterPill(
              'Semua Fasilitas',
              active: selectedCategory == 'Semua Fasilitas',
              onTap: () => onCategorySelected('Semua Fasilitas'),
            ),
            ...categories.map(
              (value) => _FilterPill(
                value,
                active: selectedCategory == value,
                onTap: () => onCategorySelected(value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IntroChip extends StatelessWidget {
  const _IntroChip(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _facilityLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _facilityBlue, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: _facilityText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill(this.label, {this.active = false, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? _facilityBlue : const Color(0xFFF1F5FB),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : _facilityText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MainFacilitiesSection extends StatelessWidget {
  const _MainFacilitiesSection({
    required this.data,
    required this.selectedCategory,
  });

  final _SarprasData data;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final items = data.fasilitas;
    final visibleItems = selectedCategory == 'Semua Fasilitas'
        ? items
        : items
              .where((item) => _dbText(item, 'kategori') == selectedCategory)
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fasilitas Utama',
          style: TextStyle(
            color: _facilityText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 1000
                ? 3
                : constraints.maxWidth >= 640
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: constraints.maxWidth >= 1000
                  ? 1.18
                  : count == 1
                  ? 2.05
                  : .9,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: visibleItems
                  .map((item) => _FacilityCard(item))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard(this.data);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _facilityLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DbFacilityImage(
            path: _dbText(data, 'gambar'),
            label: _dbText(data, 'judul'),
            height: 155,
            topRounded: true,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.meeting_room_rounded,
                      color: _facilityBlue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _dbText(data, 'judul'),
                        style: const TextStyle(
                          color: _facilityText,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _dbText(data, 'deskripsi'),
                  style: const TextStyle(
                    color: _facilityMuted,
                    fontSize: 12.8,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F8EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _dbText(data, 'kategori'),
                    style: TextStyle(
                      color: _dbText(data, 'kategori') == 'Rohani'
                          ? const Color(0xFF8A5B00)
                          : _dbText(data, 'kategori') == 'Pengembangan Diri'
                          ? const Color(0xFF0B57D0)
                          : const Color(0xFF3C8E4C),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

class _SupportFacilitiesSection extends StatelessWidget {
  const _SupportFacilitiesSection({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
                _DbFacilityImage(
                  path: _dbText(data.section('penunjang'), 'gambar'),
                  label: 'Foto fasilitas penunjang',
                  height: 240,
                ),
                SizedBox(height: 18),
                _SupportTextSection(data: data),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _DbFacilityImage(
                    path: _dbText(data.section('penunjang'), 'gambar'),
                    label: 'Foto fasilitas penunjang',
                    height: 250,
                  ),
                ),
                SizedBox(width: 22),
                Expanded(flex: 5, child: _SupportTextSection(data: data)),
              ],
            ),
    );
  }
}

class _SupportTextSection extends StatelessWidget {
  const _SupportTextSection({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final items = data.penunjang;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dbText(
            data.section('penunjang'),
            'judul',
            'Fasilitas Penunjang Pembelajaran',
          ),
          style: TextStyle(
            color: _facilityText,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        ...items.map((item) => _SupportLine(item)),
      ],
    );
  }
}

class _SupportLine extends StatelessWidget {
  const _SupportLine(this.item);

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: _facilityBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _facilityIcon(_dbText(item, 'icon')),
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dbText(item, 'judul'),
                  style: const TextStyle(
                    color: _facilityText,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dbText(item, 'deskripsi'),
                  style: const TextStyle(
                    color: _facilityMuted,
                    fontSize: 13,
                    height: 1.5,
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

class _CharacterFacilitiesSection extends StatelessWidget {
  const _CharacterFacilitiesSection({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _facilityNavy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: compact
          ? Column(
              children: [
                _DbFacilityImage(
                  path: _dbText(data.section('keagamaan'), 'gambar'),
                  label: 'Foto kegiatan keagamaan',
                  height: 220,
                  dark: true,
                ),
                SizedBox(height: 20),
                _CharacterTextSection(data: data),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _DbFacilityImage(
                    path: _dbText(data.section('keagamaan'), 'gambar'),
                    label: 'Foto kegiatan keagamaan',
                    height: 240,
                    dark: true,
                  ),
                ),
                SizedBox(width: 22),
                Expanded(flex: 5, child: _CharacterTextSection(data: data)),
              ],
            ),
    );
  }
}

class _CharacterTextSection extends StatelessWidget {
  const _CharacterTextSection({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final section = data.section('keagamaan');
    final items = data.keagamaan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dbText(
            section,
            'judul',
            'Fasilitas Keagamaan & Pembentukan Karakter',
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _dbText(
            section,
            'deskripsi',
            'Kami mendukung pembentukan karakter melalui kegiatan kerohanian dan pembiasaan nilai-nilai Kristiani.',
          ),
          style: const TextStyle(
            color: Color(0xFFDDE7FA),
            fontSize: 14.5,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 14,
          runSpacing: 16,
          children: items
              .map(
                (row) => SizedBox(
                  width: 300,
                  child: _DarkInfoCard(
                    icon: _facilityIcon(_dbText(row, 'icon')),
                    title: _dbText(row, 'judul'),
                    text: _dbText(row, 'deskripsi'),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DarkInfoCard extends StatelessWidget {
  const _DarkInfoCard({
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
        Icon(icon, color: Colors.white, size: 34),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFFDDE7FA),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SafetyFacilitiesSection extends StatelessWidget {
  const _SafetyFacilitiesSection({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final items = data.keamanan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dbText(data.section('keamanan'), 'judul', 'Kenyamanan dan Keamanan'),
          style: TextStyle(
            color: _facilityText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 1000
                ? 5
                : constraints.maxWidth >= 640
                ? 3
                : 1;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: constraints.maxWidth >= 1000
                  ? 1.45
                  : count == 1
                  ? 3
                  : 1.25,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items.map((item) => _MiniFacilityCard(item)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _MiniFacilityCard extends StatelessWidget {
  const _MiniFacilityCard(this.item);

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _facilityLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _facilityIcon(_dbText(item, 'icon')),
            color: _facilityBlue,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            _dbText(item, 'judul'),
            style: const TextStyle(
              color: _facilityText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _dbText(item, 'deskripsi'),
            style: const TextStyle(
              color: _facilityMuted,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityGallerySection extends StatelessWidget {
  const _FacilityGallerySection({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final section = data.section('galeri');
    final items = data.galeri;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dbText(section, 'judul', 'Galeri Sarana & Prasarana'),
          style: const TextStyle(
            color: _facilityText,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 1000
                ? 6
                : constraints.maxWidth >= 640
                ? 3
                : 2;
            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: constraints.maxWidth >= 1000
                  ? 1.20
                  : count == 2
                  ? 1.05
                  : .88,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: items
                  .map(
                    (row) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _DbFacilityImage(
                            path: _dbText(row, 'gambar'),
                            label: _dbText(row, 'judul'),
                            height: 120,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            _dbText(row, 'judul'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _facilityText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 14),
        Center(
          child: FilledButton(
            onPressed: () => publicRootNavigator(
              context,
            ).pushNamed(PublicRoutes.gallery),
            style: FilledButton.styleFrom(
              backgroundColor: _facilityBlue,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text(
              'Lihat Semua Galeri',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _MaintenanceSection extends StatelessWidget {
  const _MaintenanceSection({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 980;
    final card = _MaintenanceCard(data: data);
    final quote = _MaintenanceQuote(data: data);
    return compact
        ? Column(children: [card, const SizedBox(height: 18), quote])
        : IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 5, child: card),
                const SizedBox(width: 18),
                Expanded(flex: 4, child: quote),
              ],
            ),
          );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    final section = data.section('perawatan');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _facilityLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _dbText(section, 'judul', 'Upaya Perawatan Fasilitas'),
            style: const TextStyle(
              color: _facilityText,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          ...data.perawatan.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _facilityBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_dbText(row, 'judul').isNotEmpty)
                          Text(
                            _dbText(row, 'judul'),
                            style: const TextStyle(
                              color: _facilityText,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        if (_dbText(row, 'deskripsi').isNotEmpty)
                          Text(
                            _dbText(row, 'deskripsi'),
                            style: const TextStyle(
                              color: _facilityMuted,
                              fontSize: 13,
                              height: 1.55,
                            ),
                          ),
                      ],
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

class _MaintenanceQuote extends StatelessWidget {
  const _MaintenanceQuote({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3F7FF), Color(0xFFEAF2FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: _facilityBlue,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            _dbText(
              data.quote,
              'kutipan',
              'Fasilitas kami mungkin sederhana, tetapi kami merawatnya bersama agar menjadi sarana belajar yang aman dan bermanfaat.',
            ),
            style: const TextStyle(
              color: _facilityText,
              fontSize: 24,
              height: 1.65,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— ${_dbText(data.quote, 'sumber', 'Siswa SMAK')}',
              style: const TextStyle(
                color: _facilityText,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityBottomCta extends StatelessWidget {
  const _FacilityBottomCta({required this.data});

  final _SarprasData data;

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
                _FacilityBottomText(data: data),
                const SizedBox(height: 18),
                _FacilityBottomButtons(compact: compact, data: data),
              ],
            )
          : Row(
              children: [
                Expanded(child: _FacilityBottomText(data: data)),
                const SizedBox(width: 22),
                _FacilityBottomButtons(compact: compact, data: data),
              ],
            ),
    );
  }
}

class _FacilityBottomText extends StatelessWidget {
  const _FacilityBottomText({required this.data});

  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 34,
          backgroundColor: Color(0x1FFFFFFF),
          child: Icon(Icons.shield_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _dbText(
                  data.cta,
                  'judul',
                  'Belajar dan Bertumbuh Bersama SMAK',
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _dbText(
                  data.cta,
                  'deskripsi',
                  'Fasilitas dasar, dirawat bertahap, menyesuaikan kebutuhan pembelajaran.',
                ),
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

class _FacilityBottomButtons extends StatelessWidget {
  const _FacilityBottomButtons({required this.compact, required this.data});

  final bool compact;
  final _SarprasData data;

  @override
  Widget build(BuildContext context) {
    String value(String key, String fallback) {
      final text = _dbText(data.cta, key);
      return text.isEmpty ? fallback : text;
    }
    void open(String link) {
      if (link.startsWith('/')) {
        publicRootNavigator(context).pushNamed(link);
      } else {
        openSharedLink(link);
      }
    }
    final galleryButton = FilledButton(
      onPressed: () => open(value('link_tombol_1', PublicRoutes.gallery)),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _facilityBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        value('teks_tombol_1', 'Lihat Galeri Sekolah'),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );

    final contactButton = FilledButton(
      onPressed: () => open(value('link_tombol_2', globalWhatsappUrl(context))),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _facilityNavy,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        value('teks_tombol_2', 'Hubungi Kami'),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );

    return SizedBox(
      width: compact ? double.infinity : 360,
      child: compact
          ? Column(
              children: [
                SizedBox(width: double.infinity, child: galleryButton),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: contactButton),
              ],
            )
          : Row(
              children: [
                Expanded(child: galleryButton),
                const SizedBox(width: 12),
                Expanded(child: contactButton),
              ],
            ),
    );
  }
}

class _DbFacilityImage extends StatelessWidget {
  const _DbFacilityImage({
    required this.path,
    required this.label,
    this.height,
    this.topRounded = false,
    this.dark = false,
    this.contain = false,
  });

  final String path;
  final String label;
  final double? height;
  final bool topRounded;
  final bool dark;
  final bool contain;

  @override
  Widget build(BuildContext context) {
    final radius = topRounded
        ? const BorderRadius.vertical(top: Radius.circular(16))
        : BorderRadius.circular(16);

    Widget fallback() => ClipRRect(
      borderRadius: radius,
      child: websiteFallbackImage(
        fit: contain ? BoxFit.contain : BoxFit.cover,
        width: double.infinity,
        height: height,
      ),
    );

    if (path.trim().isEmpty || websiteUsesFallbackImage(path)) {
      return fallback();
    }

    final fit = contain ? BoxFit.contain : BoxFit.cover;
    final image = path.startsWith('assets/')
        ? Image.asset(
            path,
            fit: fit,
            width: double.infinity,
            height: height,
            errorBuilder: (_, _, _) => fallback(),
          )
        : Image.network(
            const SmakApi().getFileUrl(path),
            fit: fit,
            width: double.infinity,
            height: height,
            errorBuilder: (_, _, _) => fallback(),
          );

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(height: height, width: double.infinity, child: image),
    );
  }
}

class _SarprasLoadError extends StatelessWidget {
  const _SarprasLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(70),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: _facilityMuted),
          const SizedBox(height: 12),
          const Text('Data sarana dan prasarana belum dapat dimuat.'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }
}

IconData _facilityIcon(String name) => switch (name.trim()) {
  'class' => Icons.class_rounded,
  'science' => Icons.science_rounded,
  'apartment' => Icons.apartment_rounded,
  'groups' => Icons.groups_rounded,
  'desktop_windows' => Icons.desktop_windows_rounded,
  'edit' => Icons.edit_rounded,
  'wifi' => Icons.wifi_rounded,
  'church' => Icons.church_rounded,
  'medical_services' => Icons.medical_services_rounded,
  'storefront' => Icons.storefront_rounded,
  'wc' => Icons.wc_rounded,
  'local_parking' => Icons.local_parking_rounded,
  'clean_hands' => Icons.clean_hands_rounded,
  _ => Icons.meeting_room_rounded,
};

class _RectImagePlaceholder extends StatelessWidget {
  const _RectImagePlaceholder({
    required this.height,
    this.topRounded = false,
    this.dark = false,
  });

  final double height;
  final bool topRounded;
  final bool dark;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: topRounded
        ? const BorderRadius.vertical(top: Radius.circular(16))
        : BorderRadius.circular(16),
    child: websiteFallbackImage(
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
    ),
  );
}

class _FacilityPlaceholderImage extends StatelessWidget {
  const _FacilityPlaceholderImage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => websiteFallbackImage(
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );
}
