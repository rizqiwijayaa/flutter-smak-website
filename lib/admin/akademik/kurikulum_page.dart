part of '../admin_dashboard_page.dart';

class AdminKurikulumPage extends StatefulWidget {
  const AdminKurikulumPage({
    super.key,
    required this.api,
    required this.module,
  });

  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminKurikulumPage> createState() => _AdminKurikulumPageState();
}

class _AdminKurikulumPageState extends State<AdminKurikulumPage> {
  final _heroTitle = TextEditingController(text: 'Kurikulum');
  final _heroSubtitle = TextEditingController(
    text:
        'Pendidikan yang mengembangkan pengetahuan, karakter, iman, dan keterampilan untuk masa depan yang lebih baik.',
  );
  final _heroImage = TextEditingController();

  final _introTitle = TextEditingController(text: 'Kurikulum SMAK');
  final _introText = TextEditingController(
    text:
        'SMAK Mgr. Soegijapranata menerapkan kurikulum yang berpusat pada peserta didik dengan mengintegrasikan Kurikulum Nasional, nilai-nilai Katolik, serta program pengembangan sekolah untuk membentuk insan yang cerdas, beriman, berkarakter, dan siap menghadapi perubahan zaman.',
  );
  final _identityTitle = TextEditingController(
    text: 'Beriman • Berilmu • Berkarakter',
  );
  final _identityText = TextEditingController(
    text:
        'Kurikulum yang menumbuhkan kompetensi sekaligus membentuk kepribadian.',
  );

  final _approachTitle = TextEditingController(text: 'Pendekatan Pembelajaran');
  final _approachImage = TextEditingController();

  final _commitment = TextEditingController(
    text:
        'Kami berkomitmen menyeimbangkan prestasi akademik, iman yang mendalam, dan karakter mulia untuk melahirkan generasi yang cerdas, berkarakter, dan siap melayani.',
  );

  final _ctaTitle = TextEditingController(text: 'Siap Bertumbuh Bersama SMAK?');
  final _ctaText = TextEditingController(
    text:
        'Mari menjadi bagian dari lingkungan belajar yang beriman, berkarakter, dan unggul.',
  );
  final _ctaWhatsapp = TextEditingController(
    text: 'https://wa.me/628155099445',
  );
  final _frameworkTitle = TextEditingController(text: 'Kerangka Kurikulum');
  final _frameworkSubtitle = TextEditingController(text: 'Empat bagian yang saling terhubung dalam proses pendidikan siswa.');
  final _subjectsTitle = TextEditingController(text: 'Struktur Mata Pelajaran');
  final _programsTitle = TextEditingController(text: 'Program Unggulan Akademik');
  final _assessmentTitle = TextEditingController(text: 'Penilaian dan Evaluasi');
  final _assessmentSubtitle = TextEditingController(text: 'Proses berkelanjutan untuk mendukung perkembangan setiap peserta didik.');
  final _ctaButton1 = TextEditingController(text: 'Lihat Prestasi Akademik');
  final _ctaLink1 = TextEditingController(text: '/akademik/prestasi-akademik');
  final _ctaButton2 = TextEditingController(text: 'Informasi PPDB');

  late List<Map<String, dynamic>> _principles;
  late List<Map<String, dynamic>> _framework;
  late List<Map<String, dynamic>> _subjects;
  late List<Map<String, dynamic>> _approaches;
  late List<Map<String, dynamic>> _programs;
  late List<Map<String, dynamic>> _assessments;
  int? _id;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _principles = [
      _item(
        'Kurikulum Nasional',
        'Mengacu pada kurikulum yang ditetapkan pemerintah dan kebutuhan peserta didik.',
        Icons.menu_book_rounded,
      ),
      _item(
        'Pembelajaran Aktif',
        'Mendorong siswa aktif, kritis, kreatif, dan kolaboratif dalam pembelajaran.',
        Icons.groups_rounded,
      ),
      _item(
        'Penguatan Karakter',
        'Menanamkan tanggung jawab, disiplin, kepedulian, dan keteladanan.',
        Icons.verified_user_rounded,
      ),
      _item(
        'Nilai Katolik',
        'Mengintegrasikan iman, kasih, pelayanan, dan penghargaan kepada sesama.',
        Icons.church_rounded,
      ),
    ];
    _framework = [
      _item(
        'Intrakurikuler',
        'Pembelajaran inti yang terstruktur sesuai capaian dan standar pendidikan.',
        Icons.auto_stories_rounded,
      ),
      _item(
        'Kokurikuler',
        'Kegiatan pendukung untuk memperkuat pemahaman dan penerapan materi.',
        Icons.groups_2_rounded,
      ),
      _item(
        'Ekstrakurikuler',
        'Pengembangan minat, bakat, potensi, dan prestasi dalam berbagai bidang.',
        Icons.star_rounded,
      ),
      _item(
        'Pembiasaan & Karakter',
        'Pembentukan kebiasaan positif melalui budaya dan kehidupan sekolah.',
        Icons.favorite_rounded,
      ),
    ];
    _subjects = [
      {
        'judul': 'Mata Pelajaran Umum',
        'icon': Icons.menu_book_rounded,
        'items': [
          'Pendidikan Agama dan Budi Pekerti',
          'Pendidikan Pancasila',
          'Bahasa Indonesia',
          'Matematika',
          'Bahasa Inggris',
          'Sejarah Indonesia',
          'PJOK',
          'Prakarya dan Kewirausahaan',
          'Informatika',
          'Bahasa Jawa',
        ],
      },
      {
        'judul': 'Mata Pelajaran Peminatan',
        'icon': Icons.school_rounded,
        'items': [
          'Matematika Lanjutan',
          'Fisika',
          'Kimia',
          'Biologi',
          'Sosiologi',
          'Geografi',
          'Ekonomi',
          'Bahasa dan Sastra',
          'Bahasa Asing',
        ],
      },
      {
        'judul': 'Muatan Khas Sekolah',
        'icon': Icons.church_rounded,
        'items': [
          'Pendalaman Iman Katolik',
          'Pendidikan Karakter',
          'Desain dan Teknologi',
          'Kewirausahaan',
          'Komunikasi dan Presentasi',
          'Projek Penguatan Profil Pelajar',
          'Bimbingan dan Konseling',
        ],
      },
    ];
    _approaches = [
      _item(
        'Berpusat pada Siswa',
        'Menempatkan siswa sebagai subjek aktif dalam proses pembelajaran.',
        Icons.person_search_rounded,
      ),
      _item(
        'Kontekstual',
        'Mengaitkan materi dengan kehidupan nyata agar lebih bermakna.',
        Icons.public_rounded,
      ),
      _item(
        'Kolaboratif',
        'Mendorong kerja sama, diskusi, dan saling berbagi gagasan.',
        Icons.diversity_3_rounded,
      ),
      _item(
        'Berbasis Proyek',
        'Mengembangkan keterampilan abad 21 melalui proyek nyata.',
        Icons.extension_rounded,
      ),
    ];
    _programs = [
      _item(
        'Literasi & Numerasi',
        'Penguatan kemampuan dasar melalui kegiatan yang terarah dan konsisten.',
        Icons.auto_stories_rounded,
      ),
      _item(
        'Pendampingan Belajar',
        'Bimbingan akademik untuk membantu siswa mencapai potensi terbaiknya.',
        Icons.groups_rounded,
      ),
      _item(
        'Persiapan Perguruan Tinggi',
        'Pendampingan karier, studi lanjut, dan persiapan seleksi perguruan tinggi.',
        Icons.school_rounded,
      ),
      _item(
        'Projek Penguatan Profil Pelajar',
        'Projek tematik lintas disiplin untuk menguatkan karakter dan kompetensi.',
        Icons.extension_rounded,
      ),
      _item(
        'Pembelajaran Digital',
        'Pemanfaatan teknologi dan platform digital untuk pembelajaran interaktif.',
        Icons.laptop_mac_rounded,
      ),
      _item(
        'Remedial & Pengayaan',
        'Tindak lanjut sesuai kebutuhan pemahaman dan perkembangan setiap siswa.',
        Icons.bar_chart_rounded,
      ),
    ];
    _assessments = [
      _item(
        '1. Diagnostik',
        'Mengenali kemampuan awal dan kebutuhan belajar siswa.',
        Icons.search_rounded,
      ),
      _item(
        '2. Formatif',
        'Memantau proses pembelajaran dan memberikan umpan balik.',
        Icons.assignment_rounded,
      ),
      _item(
        '3. Sumatif',
        'Mengukur ketercapaian kompetensi pada akhir periode.',
        Icons.description_rounded,
      ),
      _item(
        '4. Tindak Lanjut',
        'Menentukan remedial, pengayaan, dan pendampingan berikutnya.',
        Icons.track_changes_rounded,
      ),
    ];
    _loadDatabase();
  }

  String _s(dynamic value) => '${value ?? ''}'.trim();

  void _put(TextEditingController controller, dynamic value) {
    if (_s(value).isNotEmpty) controller.text = _s(value);
  }

  Future<void> _loadDatabase() async {
    try {
      const tables = ['kurikulum_hero', 'kurikulum_pengantar', 'kurikulum_prinsip', 'kurikulum_kerangka', 'kurikulum_mata_pelajaran', 'kurikulum_pendekatan', 'kurikulum_program', 'kurikulum_penilaian', 'kurikulum_komitmen', 'kurikulum_cta'];
      final groups = await Future.wait([for (final table in tables) widget.api.getTable(table, limit: 100)]);
      final data = <String, dynamic>{};
      for (var i = 0; i < tables.length; i++) {
        final key = tables[i].replaceFirst('kurikulum_', '');
        final values = groups[i].map((row) { try { return jsonDecode(_s(row['data_json'])); } catch (_) { return null; } }).whereType<dynamic>().toList();
        data[key] = const {'prinsip', 'kerangka', 'mata_pelajaran', 'program', 'penilaian'}.contains(key) ? values : (values.isEmpty ? null : values.first);
      }
      if (data is! Map) return;
      final hero = data['hero'] as Map? ?? const {};
      final intro = data['pengantar'] as Map? ?? const {};
      final approach = data['pendekatan'] as Map? ?? const {};
      final cta = data['cta'] as Map? ?? const {};
      _put(_heroTitle, hero['judul']); _put(_heroSubtitle, hero['deskripsi']); _put(_heroImage, hero['gambar']);
      _put(_introTitle, intro['judul']); _put(_introText, intro['deskripsi']); _put(_identityTitle, intro['tagline']); _put(_identityText, intro['tagline_deskripsi']);
      _put(_approachTitle, approach['judul']); _put(_approachImage, approach['gambar']);
      _put(_commitment, data['komitmen']); _put(_ctaTitle, cta['judul']); _put(_ctaText, cta['deskripsi']); _put(_ctaWhatsapp, cta['whatsapp']);
      _put(_frameworkTitle, cta['judul_kerangka']); _put(_frameworkSubtitle, cta['subjudul_kerangka']);
      _put(_subjectsTitle, cta['judul_mata_pelajaran']); _put(_programsTitle, cta['judul_program']);
      _put(_assessmentTitle, cta['judul_penilaian']); _put(_assessmentSubtitle, cta['subjudul_penilaian']);
      _put(_ctaButton1, cta['teks_tombol_1']); _put(_ctaLink1, cta['link_tombol_1']); _put(_ctaButton2, cta['teks_tombol_2']);
      List<Map<String, dynamic>> rowsFor(String key, List<Map<String, dynamic>> fallback) {
        final value = data[key];
        return value is List ? value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : fallback;
      }
      _principles = rowsFor('prinsip', _principles); _framework = rowsFor('kerangka', _framework); _subjects = rowsFor('mata_pelajaran', _subjects);
      _approaches = approach['items'] is List ? (approach['items'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : _approaches;
      _programs = rowsFor('program', _programs); _assessments = rowsFor('penilaian', _assessments);
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Map<String, dynamic> _payload() => {
    'hero': {'judul': _heroTitle.text.trim(), 'deskripsi': _heroSubtitle.text.trim(), 'gambar': _heroImage.text.trim()},
    'pengantar': {'judul': _introTitle.text.trim(), 'deskripsi': _introText.text.trim(), 'tagline': _identityTitle.text.trim(), 'tagline_deskripsi': _identityText.text.trim()},
    'prinsip': _principles, 'kerangka': _framework, 'mata_pelajaran': _subjects,
    'pendekatan': {'judul': _approachTitle.text.trim(), 'gambar': _approachImage.text.trim(), 'items': _approaches},
    'program': _programs, 'penilaian': _assessments, 'komitmen': _commitment.text.trim(),
    'cta': {'judul': _ctaTitle.text.trim(), 'deskripsi': _ctaText.text.trim(), 'whatsapp': _ctaWhatsapp.text.trim(), 'judul_kerangka': _frameworkTitle.text.trim(), 'subjudul_kerangka': _frameworkSubtitle.text.trim(), 'judul_mata_pelajaran': _subjectsTitle.text.trim(), 'judul_program': _programsTitle.text.trim(), 'judul_penilaian': _assessmentTitle.text.trim(), 'subjudul_penilaian': _assessmentSubtitle.text.trim(), 'teks_tombol_1': _ctaButton1.text.trim(), 'link_tombol_1': _ctaLink1.text.trim(), 'teks_tombol_2': _ctaButton2.text.trim()},
  };

  Future<void> _saveDatabase() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      // Validate/encode the whole draft before any existing rows are deleted.
      // IconData belongs to the editor; persist its numeric value as JSON.
      final payload = jsonDecode(jsonEncode(_payload(), toEncodable: (value) {
        if (value is IconData) return value.codePoint;
        throw const FormatException('Data kurikulum tidak dapat disimpan.');
      })) as Map<String, dynamic>;
      const tables = ['kurikulum_hero', 'kurikulum_pengantar', 'kurikulum_prinsip', 'kurikulum_kerangka', 'kurikulum_mata_pelajaran', 'kurikulum_pendekatan', 'kurikulum_program', 'kurikulum_penilaian', 'kurikulum_komitmen', 'kurikulum_cta'];
      for (final table in tables) {
        final key = table.replaceFirst('kurikulum_', '');
        final existing = await widget.api.getTable(table, limit: 100);
        for (final row in existing) { final id = int.tryParse(_s(row['id'])); if (id != null) await widget.api.delete(table, id); }
        final value = payload[key];
        final items = value is List ? value : [value];
        for (var i = 0; i < items.length; i++) {
          final item = items[i];
          final title = item is Map ? _s(item['judul']) : key;
          await widget.api.save(table, {'judul': title, 'data_json': jsonEncode(item), 'urutan': i, 'status': 'aktif'});
        }
      }
      await _loadDatabase();
      if (mounted) _toast('Perubahan Kurikulum berhasil disimpan.');
    } catch (e) { if (mounted) _toast('Gagal menyimpan: $e'); }
    if (mounted) setState(() => _saving = false);
  }

  Map<String, dynamic> _item(String title, String description, IconData icon) =>
      {'judul': title, 'deskripsi': description, 'icon': icon};

  @override
  void dispose() {
    for (final c in [
      _heroTitle,
      _heroSubtitle,
      _heroImage,
      _introTitle,
      _introText,
      _identityTitle,
      _identityText,
      _approachTitle,
      _approachImage,
      _commitment,
      _ctaTitle,
      _ctaText,
      _ctaWhatsapp,
      _frameworkTitle, _frameworkSubtitle, _subjectsTitle, _programsTitle,
      _assessmentTitle, _assessmentSubtitle, _ctaButton1, _ctaLink1, _ctaButton2,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(26, 24, 26, 50),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader(),
        const SizedBox(height: 22),
        _section(
          '1',
          'Hero / Banner Kurikulum',
          'Kelola tampilan pembuka halaman Kurikulum.',
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 420,
                child: _imageEditor(
                  _heroImage,
                  'Banner / Gambar Hero',
                  height: 170,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _field(_heroTitle, 'Judul Hero'),
                    const SizedBox(height: 12),
                    _field(_heroSubtitle, 'Deskripsi Hero', lines: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
        _gap(),
        _section(
          '2',
          'Pengantar Kurikulum',
          'Kelola pengantar dan identitas singkat kurikulum sekolah.',
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _field(_introTitle, 'Judul'),
                    const SizedBox(height: 12),
                    _field(_introText, 'Deskripsi', lines: 6),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _softCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.school_rounded, color: _blue, size: 38),
                          SizedBox(width: 12),
                          Text(
                            'Identitas Kurikulum',
                            style: TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _field(_identityTitle, 'Tagline'),
                      const SizedBox(height: 12),
                      _field(_identityText, 'Deskripsi', lines: 3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _gap(),
        _listSection(
          '3',
          'Prinsip Kurikulum',
          'Kelola prinsip utama yang menjadi dasar kurikulum.',
          _principles,
          'Tambah Prinsip',
        ),
        _gap(),
        _listSection(
          '4',
          'Kerangka Kurikulum',
          'Kelola bagian-bagian kerangka kurikulum.',
          _framework,
          'Tambah Kerangka',
        ),
        _gap(),
        _section(
          '5',
          'Struktur Mata Pelajaran',
          'Kelola kelompok mata pelajaran beserta daftar pelajarannya.',
          Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () => _editSubject(null),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tambah Kelompok'),
                ),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (_, c) {
                  final cols = c.maxWidth >= 1000
                      ? 3
                      : c.maxWidth >= 650
                      ? 2
                      : 1;
                  final w = (c.maxWidth - ((cols - 1) * 14)) / cols;
                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      for (final row in _subjects)
                        SizedBox(width: w, child: _subjectCard(row)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        _gap(),
        _section(
          '6',
          'Pendekatan Pembelajaran',
          'Kelola foto pembelajaran dan pendekatan yang diterapkan.',
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 390,
                child: _imageEditor(
                  _approachImage,
                  'Foto Pembelajaran',
                  height: 235,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field(_approachTitle, 'Judul Section'),
                    const SizedBox(height: 14),
                    _visualList(_approaches),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: () => _editItem(_approaches, null),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Tambah Pendekatan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _gap(),
        _listSection(
          '7',
          'Program Unggulan Akademik',
          'Kelola program unggulan akademik sekolah.',
          _programs,
          'Tambah Program',
        ),
        _gap(),
        _listSection(
          '8',
          'Penilaian dan Evaluasi',
          'Kelola tahapan penilaian dan evaluasi pembelajaran.',
          _assessments,
          'Tambah Tahap',
        ),
        _gap(),
        _section(
          '9',
          'Komitmen Sekolah',
          'Kelola pesan komitmen yang tampil pada banner biru.',
          _field(_commitment, 'Teks Komitmen', lines: 5),
        ),
        _gap(),
        _section(
          '10',
          'CTA Penutup',
          'Kelola ajakan dan tautan informasi pada bagian bawah halaman.',
          Column(
            children: [
              _field(_ctaTitle, 'Judul CTA'),
              const SizedBox(height: 12),
              _field(_ctaText, 'Deskripsi CTA', lines: 3),
              const SizedBox(height: 12),
              _field(_ctaWhatsapp, 'Link WhatsApp / Informasi PPDB'),
              const SizedBox(height: 12),
              _field(_frameworkTitle, 'Judul Section Kerangka'),
              const SizedBox(height: 12),
              _field(_frameworkSubtitle, 'Subjudul Section Kerangka', lines: 2),
              const SizedBox(height: 12),
              _field(_subjectsTitle, 'Judul Section Mata Pelajaran'),
              const SizedBox(height: 12),
              _field(_programsTitle, 'Judul Section Program'),
              const SizedBox(height: 12),
              _field(_assessmentTitle, 'Judul Section Penilaian'),
              const SizedBox(height: 12),
              _field(_assessmentSubtitle, 'Subjudul Section Penilaian', lines: 2),
              const SizedBox(height: 12),
              _field(_ctaButton1, 'Teks Tombol 1'),
              const SizedBox(height: 12),
              _field(_ctaLink1, 'Link Tombol 1'),
              const SizedBox(height: 12),
              _field(_ctaButton2, 'Teks Tombol 2'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _notice(),
      ],
    ),
  );

  Widget _pageHeader() => Row(
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kurikulum',
              style: TextStyle(
                color: _text,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Kelola seluruh konten halaman Kurikulum.',
              style: TextStyle(color: _muted),
            ),
          ],
        ),
      ),
      OutlinedButton.icon(
        onPressed: () => _openAdminPreview(context, sharedAcademicPages()['kurikulum']!),
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('Preview Halaman'),
      ),
      const SizedBox(width: 10),
      FilledButton.icon(
        onPressed: _saving ? null : _saveDatabase,
        icon: const Icon(Icons.save_outlined),
        label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
      ),
    ],
  );

  Widget _section(String number, String title, String info, Widget child) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        info,
                        style: const TextStyle(color: _muted, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      );

  Widget _listSection(
    String number,
    String title,
    String info,
    List<Map<String, dynamic>> list,
    String addLabel,
  ) => _section(
    number,
    title,
    info,
    Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _editItem(list, null),
            icon: const Icon(Icons.add_rounded),
            label: Text(addLabel),
          ),
        ),
        const SizedBox(height: 14),
        _visualList(list),
      ],
    ),
  );

  Widget _visualList(List<Map<String, dynamic>> list) => LayoutBuilder(
    builder: (_, c) {
      final cols = c.maxWidth >= 1000
          ? 3
          : c.maxWidth >= 650
          ? 2
          : 1;
      final w = (c.maxWidth - ((cols - 1) * 14)) / cols;
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          for (final row in list)
            SizedBox(
              width: w,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFCFE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F1FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        row['icon'] is IconData
                            ? row['icon'] as IconData
                            : Icons.auto_stories_rounded,
                        color: _blue,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      '${row['judul'] ?? ''}',
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${row['deskripsi'] ?? ''}',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        height: 1.45,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () => _editItem(list, row),
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: _blue,
                            size: 19,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Hapus',
                          onPressed: () => setState(() => list.remove(row)),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );

  Widget _subjectCard(Map<String, dynamic> row) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _line),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: _navy,
          child: Row(
            children: [
              Icon(
                row['icon'] is IconData
                    ? row['icon'] as IconData
                    : Icons.menu_book_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '${row['judul'] ?? ''}',
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
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final subject in (row['items'] as List? ?? const []))
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$subject',
                          style: const TextStyle(color: _muted, fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _editSubject(row),
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: _blue,
                      size: 19,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _subjects.remove(row)),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Future<void> _editItem(
    List<Map<String, dynamic>> list,
    Map<String, dynamic>? source,
  ) async {
    final title = TextEditingController(text: '${source?['judul'] ?? ''}');
    final desc = TextEditingController(text: '${source?['deskripsi'] ?? ''}');
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(source == null ? 'Tambah Data' : 'Edit Data'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(title, 'Judul'),
              const SizedBox(height: 12),
              _dialogField(desc, 'Deskripsi', lines: 4),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (result == true) {
      final row = {
        'judul': title.text.trim(),
        'deskripsi': desc.text.trim(),
        'icon': source?['icon'] ?? Icons.auto_stories_rounded,
      };
      setState(() {
        if (source == null) {
          list.add(row);
        } else {
          final i = list.indexOf(source);
          if (i >= 0) list[i] = row;
        }
      });
    }
    title.dispose();
    desc.dispose();
  }

  Future<void> _editSubject(Map<String, dynamic>? source) async {
    final title = TextEditingController(text: '${source?['judul'] ?? ''}');
    final items = TextEditingController(
      text: ((source?['items'] as List?) ?? const []).join('\n'),
    );
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          source == null ? 'Tambah Kelompok Mata Pelajaran' : 'Edit Kelompok',
        ),
        content: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(title, 'Nama Kelompok'),
              const SizedBox(height: 12),
              _dialogField(
                items,
                'Daftar Mata Pelajaran (satu per baris)',
                lines: 10,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (result == true) {
      final row = {
        'judul': title.text.trim(),
        'items': items.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'icon': source?['icon'] ?? Icons.menu_book_rounded,
      };
      setState(() {
        if (source == null) {
          _subjects.add(row);
        } else {
          final i = _subjects.indexOf(source);
          if (i >= 0) _subjects[i] = row;
        }
      });
    }
    title.dispose();
    items.dispose();
  }

  Widget _field(TextEditingController c, String label, {int lines = 1}) =>
      AdminContentTextField(
        controller: c,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFFBFCFE),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _line),
          ),
        ),
      );

  Widget _dialogField(TextEditingController c, String label, {int lines = 1}) =>
      AdminContentTextField(
        controller: c,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _imageEditor(
    TextEditingController controller,
    String label, {
    double height = 190,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _text,
          fontWeight: FontWeight.w800,
          fontSize: 12.5,
        ),
      ),
      const SizedBox(height: 8),
      _imagePreview(controller.text, height),
      const SizedBox(height: 9),
      Row(
        children: [
          FilledButton.icon(
            onPressed: () => _pickImage(controller),
            icon: const Icon(Icons.upload_rounded, size: 18),
            label: Text(
              controller.text.trim().isEmpty ? 'Upload Foto' : 'Ganti Foto',
            ),
          ),
          if (controller.text.trim().isNotEmpty) ...[
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () => setState(() => controller.clear()),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Hapus'),
            ),
          ],
        ],
      ),
    ],
  );

  Widget _imagePreview(String raw, double height) {
    if (raw.trim().isEmpty) {
      return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5FB),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _line),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: _muted, size: 42),
      );
    }
    final value = raw.trim();
    final image = websiteContentImage(
      value,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
    );
    return ClipRRect(borderRadius: BorderRadius.circular(11), child: image);
  }

  Widget _brokenImage(double height) => Container(
    width: double.infinity,
    height: height,
    color: const Color(0xFFF1F5FB),
    alignment: Alignment.center,
    child: const Icon(Icons.broken_image_outlined, color: _muted, size: 38),
  );

  Future<void> _pickImage(TextEditingController controller) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;

    // Belum dipersist ke tabel khusus Kurikulum karena skema DB belum diberikan.
    // Preview lokal tetap disediakan agar pola UI Beranda Website terjaga.
    final file = input.files!.first;
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;
    if (!mounted) return;
    setState(() => controller.text = '${reader.result ?? ''}');
  }

  Widget _softCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFF4F8FE),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _line),
    ),
    child: child,
  );

  Widget _gap() => const SizedBox(height: 16);

  Widget _notice() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF8E8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFF0D89A)),
    ),
    child: const Row(
      children: [
        Icon(Icons.info_outline_rounded, color: Color(0xFF9A6A00)),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'UI admin sudah mengikuti frontend Kurikulum dan pola Beranda Website. Penyimpanan database belum diaktifkan sampai skema tabel Kurikulum dipastikan.',
            style: TextStyle(color: Color(0xFF72520A), fontSize: 11.5),
          ),
        ),
      ],
    ),
  );

  void _toast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
