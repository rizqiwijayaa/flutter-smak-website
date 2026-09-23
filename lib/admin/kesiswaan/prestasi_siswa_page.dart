part of '../admin_dashboard_page.dart';

class AdminPrestasiSiswaPage extends StatefulWidget {
  const AdminPrestasiSiswaPage({
    super.key,
    required this.api,
    required this.module,
  });
  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminPrestasiSiswaPage> createState() => _AdminPrestasiSiswaPageState();
}

class _AdminPrestasiSiswaPageState extends State<AdminPrestasiSiswaPage> {
  int? _contentId;
  bool _loading = true;
  bool _saving = false;
  final _heroTitle = TextEditingController(text: 'Prestasi Siswa');
  final _heroSubtitle = TextEditingController(
    text:
        'Apresiasi atas bakat, kerja keras, dan pencapaian siswa di berbagai bidang.',
  );
  final _heroImage = TextEditingController();

  final _introTitle = TextEditingController(text: 'Setiap Siswa Punya Potensi');
  final _intro = TextEditingController(
    text:
        'SMAK mendampingi siswa mengembangkan kemampuan olahraga, seni dan budaya, kepemimpinan, serta kerohanian dan sosial. Setiap pencapaian adalah hasil latihan, pembinaan, dan dukungan seluruh komunitas sekolah.',
  );
  final _schoolName = TextEditingController(text: 'SMAK Mgr. Soegijapranata');
  final _schoolMotto = TextEditingController(
    text: 'Beriman • Berilmu • Berkarakter',
  );
  final _logo = TextEditingController(text: 'assets/images/logo_sekolah.png');

  final _statTotal = TextEditingController(text: '12');
  final _statSport = TextEditingController(text: '5');
  final _statArt = TextEditingController(text: '4');
  final _statSocial = TextEditingController(text: '3');

  final List<Map<String, String>> _featured = [
    {
      'title': 'Juara II Basket Tingkat Kabupaten',
      'category': 'Olahraga',
      'date': 'Mei 2026',
      'level': 'Kabupaten Lumajang',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/basket.jpg',
    },
    {
      'title': 'Juara III Solo Vokal',
      'category': 'Seni & Budaya',
      'date': 'April 2026',
      'level': 'Kabupaten Lumajang',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/solo_vokal.jpg',
    },
    {
      'title': 'Penghargaan Paskibra',
      'category': 'Organisasi',
      'date': 'Agustus 2026',
      'level': 'Kabupaten Lumajang',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/paskibra.jpg',
    },
  ];

  final List<Map<String, String>> _achievements = [
    {
      'title': 'Juara I Futsal Putra',
      'category': 'Olahraga',
      'date': 'Maret 2026',
      'level': 'Kabupaten',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/futsal.jpg',
    },
    {
      'title': 'Juara II Tenis Meja',
      'category': 'Olahraga',
      'date': 'Juni 2026',
      'level': 'Kabupaten',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/tenis_meja.jpg',
    },
    {
      'title': 'Juara Harapan I Tari',
      'category': 'Seni & Budaya',
      'date': 'Mei 2026',
      'level': 'Kabupaten',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/tari.jpg',
    },
    {
      'title': 'Juara II Band Pelajar',
      'category': 'Seni & Budaya',
      'date': 'Juni 2026',
      'level': 'Kabupaten',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/band.jpg',
    },
    {
      'title': 'Juara II Lomba PMR',
      'category': 'Organisasi',
      'date': 'April 2026',
      'level': 'Kabupaten',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/pmr.jpg',
    },
    {
      'title': 'Juara I Paduan Suara Rohani',
      'category': 'Kerohanian & Sosial',
      'date': 'Maret 2026',
      'level': 'Kabupaten',
      'student': 'Nama Siswa',
      'image': 'assets/images/prestasi_siswa/paduan_suara.jpg',
    },
  ];

  final List<Map<String, String>> _fields = [
    {'title': 'Olahraga', 'desc': 'Sportivitas dan semangat juang'},
    {'title': 'Seni & Budaya', 'desc': 'Kreativitas dan pelestarian budaya'},
    {
      'title': 'Kepemimpinan',
      'desc': 'Karakter pemimpin yang bertanggung jawab',
    },
    {
      'title': 'Kerohanian & Sosial',
      'desc': 'Iman dan kepedulian kepada sesama',
    },
  ];

  final _storyTitle = TextEditingController(text: 'Cerita Siswa Berprestasi');
  final _storyQuote = TextEditingController(
    text:
        'Prestasi bukan hanya tentang menang, tetapi tentang proses, disiplin, dan tidak mudah menyerah.',
  );
  final _storyStudent = TextEditingController(text: 'Nama Siswa • Kelas XI');
  final _storyAchievement = TextEditingController(
    text: 'Juara II Basket Tingkat Kabupaten',
  );
  final _storyImage = TextEditingController();

  final List<Map<String, String>> _coaching = [
    {
      'title': 'Pendampingan Guru',
      'desc': 'Guru membimbing dan mengarahkan potensi siswa.',
    },
    {
      'title': 'Latihan Terarah',
      'desc': 'Latihan rutin sesuai minat dan kemampuan.',
    },
    {
      'title': 'Mengikuti Kegiatan',
      'desc': 'Siswa didorong mengikuti lomba dan kompetisi.',
    },
    {
      'title': 'Apresiasi Sekolah',
      'desc': 'Sekolah memberikan penghargaan dan dukungan.',
    },
  ];

  final List<Map<String, String>> _journey = [
    {'year': '2023', 'count': '5'},
    {'year': '2024', 'count': '7'},
    {'year': '2025', 'count': '9'},
    {'year': '2026', 'count': '12'},
  ];

  final List<Map<String, String>> _documentation = [
    {
      'title': 'Latihan Basket',
      'image': 'assets/images/prestasi_siswa/dokumentasi_basket.jpg',
    },
    {
      'title': 'Lomba Paduan Suara',
      'image': 'assets/images/prestasi_siswa/dokumentasi_paduan_suara.jpg',
    },
    {
      'title': 'Kegiatan Paskibra',
      'image': 'assets/images/prestasi_siswa/dokumentasi_paskibra.jpg',
    },
  ];

  final _ctaTitle = TextEditingController(
    text: 'Terus Berkarya dan Menginspirasi',
  );
  final _ctaSubtitle = TextEditingController(
    text: 'Mari mengembangkan potensi dan membawa nama baik SMAK.',
  );
  final _ctaButton1 = TextEditingController(text: 'Lihat Kegiatan Siswa');
  final _ctaButton2 = TextEditingController(text: 'Hubungi Sekolah');

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  @override
  void dispose() {
    for (final controller in [
      _heroTitle,
      _heroSubtitle,
      _heroImage,
      _introTitle,
      _intro,
      _schoolName,
      _schoolMotto,
      _logo,
      _statTotal,
      _statSport,
      _statArt,
      _statSocial,
      _storyTitle,
      _storyQuote,
      _storyStudent,
      _storyAchievement,
      _storyImage,
      _ctaTitle,
      _ctaSubtitle,
      _ctaButton1,
      _ctaButton2,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String _textOf(dynamic value) => '${value ?? ''}'.trim();

  int _idOf(Map<String, String> row) => int.tryParse(row['id'] ?? '') ?? 0;

  Map<String, String> _row(Map<String, dynamic> source, List<String> keys) => {
    'id': _textOf(source['id']),
    for (final key in keys) key: _textOf(source[key]),
  };

  Future<void> _loadDatabase() async {
    try {
      final data = await Future.wait([
        widget.api.getTable('prestasisiswa_konten', limit: 1),
        widget.api.getTable('prestasisiswa_prestasi', limit: 100),
        widget.api.getTable('prestasisiswa_bidang', limit: 50),
        widget.api.getTable('prestasisiswa_pembinaan', limit: 50),
        widget.api.getTable('prestasisiswa_perjalanan', limit: 50),
        widget.api.getTable('prestasisiswa_dokumentasi', limit: 50),
      ]).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      if (data[0].isNotEmpty) {
        final row = data[0].first;
        _contentId = int.tryParse(_textOf(row['id']));
        _heroTitle.text = _textOf(row['hero_judul']).isEmpty
            ? _heroTitle.text
            : _textOf(row['hero_judul']);
        _heroSubtitle.text = _textOf(row['hero_subjudul']).isEmpty
            ? _heroSubtitle.text
            : _textOf(row['hero_subjudul']);
        _heroImage.text = _textOf(row['hero_gambar']).isEmpty
            ? _heroImage.text
            : _textOf(row['hero_gambar']);
        _introTitle.text = _textOf(row['intro_judul']).isEmpty
            ? _introTitle.text
            : _textOf(row['intro_judul']);
        _intro.text = _textOf(row['intro_deskripsi']).isEmpty
            ? _intro.text
            : _textOf(row['intro_deskripsi']);
        _schoolName.text = _textOf(row['nama_sekolah']).isEmpty
            ? _schoolName.text
            : _textOf(row['nama_sekolah']);
        _schoolMotto.text = _textOf(row['motto_sekolah']).isEmpty
            ? _schoolMotto.text
            : _textOf(row['motto_sekolah']);
        _logo.text = _textOf(row['logo']).isEmpty
            ? _logo.text
            : _textOf(row['logo']);
        _statTotal.text = _textOf(row['statistik_total']).isEmpty
            ? _statTotal.text
            : _textOf(row['statistik_total']);
        _statSport.text = _textOf(row['statistik_olahraga']).isEmpty
            ? _statSport.text
            : _textOf(row['statistik_olahraga']);
        _statArt.text = _textOf(row['statistik_seni']).isEmpty
            ? _statArt.text
            : _textOf(row['statistik_seni']);
        _statSocial.text = _textOf(row['statistik_sosial']).isEmpty
            ? _statSocial.text
            : _textOf(row['statistik_sosial']);
        _storyTitle.text = _textOf(row['cerita_judul']).isEmpty
            ? _storyTitle.text
            : _textOf(row['cerita_judul']);
        _storyQuote.text = _textOf(row['cerita_kutipan']).isEmpty
            ? _storyQuote.text
            : _textOf(row['cerita_kutipan']);
        _storyStudent.text = _textOf(row['cerita_siswa']).isEmpty
            ? _storyStudent.text
            : _textOf(row['cerita_siswa']);
        _storyAchievement.text = _textOf(row['cerita_prestasi']).isEmpty
            ? _storyAchievement.text
            : _textOf(row['cerita_prestasi']);
        _storyImage.text = _textOf(row['cerita_gambar']).isEmpty
            ? _storyImage.text
            : _textOf(row['cerita_gambar']);
        _ctaTitle.text = _textOf(row['cta_judul']).isEmpty
            ? _ctaTitle.text
            : _textOf(row['cta_judul']);
        _ctaSubtitle.text = _textOf(row['cta_deskripsi']).isEmpty
            ? _ctaSubtitle.text
            : _textOf(row['cta_deskripsi']);
        _ctaButton1.text = _textOf(row['cta_tombol_1']).isEmpty
            ? _ctaButton1.text
            : _textOf(row['cta_tombol_1']);
        _ctaButton2.text = _textOf(row['cta_tombol_2']).isEmpty
            ? _ctaButton2.text
            : _textOf(row['cta_tombol_2']);
      }
      if (data[1].isNotEmpty) {
        _featured
          ..clear()
          ..addAll(
            data[1]
                .where((row) => _textOf(row['unggulan']) == '1')
                .map(
                  (row) =>
                      _row(row, [
                        'title',
                        'student',
                        'category',
                        'date',
                        'level',
                        'image',
                      ])..addAll({
                        'title': _textOf(row['judul']),
                        'student': _textOf(row['siswa']),
                        'category': _textOf(row['kategori']),
                        'date': _textOf(row['tanggal']),
                        'level': _textOf(row['tingkat']),
                        'image': _textOf(row['gambar']),
                      }),
                ),
          );
        _achievements
          ..clear()
          ..addAll(
            data[1]
                .where((row) => _textOf(row['unggulan']) != '1')
                .map(
                  (row) =>
                      _row(row, [
                        'title',
                        'student',
                        'category',
                        'date',
                        'level',
                        'image',
                      ])..addAll({
                        'title': _textOf(row['judul']),
                        'student': _textOf(row['siswa']),
                        'category': _textOf(row['kategori']),
                        'date': _textOf(row['tanggal']),
                        'level': _textOf(row['tingkat']),
                        'image': _textOf(row['gambar']),
                      }),
                ),
          );
      }
      void loadPairs(
        List<Map<String, String>> target,
        List<Map<String, dynamic>> rows,
      ) {
        if (rows.isEmpty) return;
        target
          ..clear()
          ..addAll(
            rows.map(
              (row) => {
                'id': _textOf(row['id']),
                'title': _textOf(row['judul']),
                'desc': _textOf(row['deskripsi']),
              },
            ),
          );
      }

      loadPairs(_fields, data[2]);
      loadPairs(_coaching, data[3]);
      if (data[4].isNotEmpty) {
        _journey
          ..clear()
          ..addAll(
            data[4].map(
              (row) => {
                'id': _textOf(row['id']),
                'year': _textOf(row['tahun']),
                'count': _textOf(row['jumlah']),
              },
            ),
          );
      }
      if (data[5].isNotEmpty) {
        _documentation
          ..clear()
          ..addAll(
            data[5].map(
              (row) => {
                'id': _textOf(row['id']),
                'title': _textOf(row['judul']),
                'image': _textOf(row['gambar']),
              },
            ),
          );
      }
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database prestasi siswa belum dapat dimuat: $error'),
          ),
        );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _syncRows(
    String table,
    List<Map<String, String>> rows,
    Map<String, String> Function(Map<String, String>, int) payload,
  ) async {
    final existing = await widget.api.getTable(table, limit: 100);
    final retainedIds = <int>{};
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      final id = _idOf(row);
      if (id > 0) retainedIds.add(id);
      await widget.api.save(
        table,
        payload(row, index),
        id: id == 0 ? null : id,
      );
    }
    for (final row in existing) {
      final id = int.tryParse(_textOf(row['id'])) ?? 0;
      if (id > 0 && !retainedIds.contains(id))
        await widget.api.delete(table, id);
    }
  }

  Future<void> _saveChanges() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.api.save('prestasisiswa_konten', {
        'hero_judul': _heroTitle.text.trim(),
        'hero_subjudul': _heroSubtitle.text.trim(),
        'hero_gambar': _heroImage.text.trim(),
        'intro_judul': _introTitle.text.trim(),
        'intro_deskripsi': _intro.text.trim(),
        'nama_sekolah': _schoolName.text.trim(),
        'motto_sekolah': _schoolMotto.text.trim(),
        'logo': _logo.text.trim(),
        'statistik_total': _statTotal.text.trim(),
        'statistik_olahraga': _statSport.text.trim(),
        'statistik_seni': _statArt.text.trim(),
        'statistik_sosial': _statSocial.text.trim(),
        'cerita_judul': _storyTitle.text.trim(),
        'cerita_kutipan': _storyQuote.text.trim(),
        'cerita_siswa': _storyStudent.text.trim(),
        'cerita_prestasi': _storyAchievement.text.trim(),
        'cerita_gambar': _storyImage.text.trim(),
        'cta_judul': _ctaTitle.text.trim(),
        'cta_deskripsi': _ctaSubtitle.text.trim(),
        'cta_tombol_1': _ctaButton1.text.trim(),
        'cta_tombol_2': _ctaButton2.text.trim(),
        'status': 'aktif',
      }, id: _contentId);
      await _syncRows(
        'prestasisiswa_prestasi',
        [..._featured, ..._achievements],
        (row, index) => {
          'judul': row['title'] ?? '',
          'siswa': row['student'] ?? '',
          'kategori': row['category'] ?? '',
          'tanggal': row['date'] ?? '',
          'tingkat': row['level'] ?? '',
          'gambar': row['image'] ?? '',
          'unggulan': index < _featured.length ? '1' : '0',
          'urutan': '$index',
          'status': 'aktif',
        },
      );
      await _syncRows(
        'prestasisiswa_bidang',
        _fields,
        (row, index) => {
          'judul': row['title'] ?? '',
          'deskripsi': row['desc'] ?? '',
          'urutan': '$index',
          'status': 'aktif',
        },
      );
      await _syncRows(
        'prestasisiswa_pembinaan',
        _coaching,
        (row, index) => {
          'judul': row['title'] ?? '',
          'deskripsi': row['desc'] ?? '',
          'urutan': '$index',
          'status': 'aktif',
        },
      );
      await _syncRows(
        'prestasisiswa_perjalanan',
        _journey,
        (row, index) => {
          'tahun': row['year'] ?? '',
          'jumlah': row['count'] ?? '',
          'urutan': '$index',
          'status': 'aktif',
        },
      );
      await _syncRows(
        'prestasisiswa_dokumentasi',
        _documentation,
        (row, index) => {
          'judul': row['title'] ?? '',
          'gambar': row['image'] ?? '',
          'urutan': '$index',
          'status': 'aktif',
        },
      );
      await _loadDatabase();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Perubahan Prestasi Siswa berhasil disimpan ke database.',
            ),
          ),
        );
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan prestasi siswa: $error')),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickImage(
    TextEditingController controller, {
    String table = 'prestasisiswa_konten',
  }) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    try {
      final filename = await widget.api.uploadFile(table, input.files!.first);
      if (mounted) setState(() => controller.text = filename);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar: $error')),
        );
    }
  }

  Widget _image(String value, {IconData icon = Icons.image_outlined}) {
    if (value.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFF0F3F7),
        child: Center(
          child: Icon(icon, color: const Color(0xFF9AA9BC), size: 48),
        ),
      );
    }
    return websiteContentImage(value, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 24, 28, 54),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 24),
        _section(1, 'Banner / Hero Prestasi Siswa', _hero()),
        _section(2, 'Pengantar & Identitas Sekolah', _introduction()),
        _section(3, 'Statistik Prestasi', _stats()),
        _section(
          4,
          'Prestasi Pilihan',
          _achievementCards(_featured, featured: true),
        ),
        _section(
          5,
          'Daftar Prestasi Siswa & Kategori',
          _achievementCards(_achievements),
        ),
        _section(
          6,
          'Bidang Prestasi',
          _simpleCards(_fields, 'Bidang Prestasi'),
        ),
        _section(7, 'Cerita Siswa Berprestasi', _story()),
        _section(
          8,
          'Pembinaan Bakat Siswa',
          _simpleCards(_coaching, 'Pembinaan Bakat'),
        ),
        _section(9, 'Perjalanan Prestasi', _journeyEditor()),
        _section(10, 'Dokumentasi Kegiatan', _documentationEditor()),
        _section(11, 'Call to Action', _cta()),
      ],
    ),
  );

  Widget _header() => Row(
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prestasi Siswa',
              style: TextStyle(
                color: _text,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Kelola prestasi, pembinaan, perjalanan pencapaian, dan dokumentasi siswa.',
              style: TextStyle(color: _muted),
            ),
          ],
        ),
      ),
      OutlinedButton.icon(
        onPressed: () =>
            _openAdminPreview(context, sharedStudentPages()['prestasi']!),
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('Preview Halaman'),
      ),
      const SizedBox(width: 10),
      FilledButton.icon(
        onPressed: _saving ? null : _saveChanges,
        icon: const Icon(Icons.save_rounded),
        label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
      ),
    ],
  );

  Widget _section(int no, String title, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09082E65),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$no',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    ),
  );

  Widget _hero() => LayoutBuilder(
    builder: (_, c) {
      final preview = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 235,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _line),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _image(_heroImage.text),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xF2083A7C),
                        Color(0xB0083A7C),
                        Color(0x28083A7C),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _heroTitle.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _heroSubtitle.text,
                          style: const TextStyle(
                            color: Colors.white,
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
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickImage(_heroImage),
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Ganti Foto'),
              ),
              TextButton.icon(
                onPressed: () => setState(_heroImage.clear),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ],
      );
      final fields = Column(
        children: [
          _field('Judul Hero', _heroTitle, changed: (_) => setState(() {})),
          const SizedBox(height: 12),
          _field(
            'Subtitle Hero',
            _heroSubtitle,
            lines: 3,
            changed: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          _field(
            'Sumber / Nama File Banner',
            _heroImage,
            changed: (_) => setState(() {}),
          ),
        ],
      );
      return c.maxWidth < 900
          ? Column(children: [preview, const SizedBox(height: 18), fields])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: preview),
                const SizedBox(width: 22),
                Expanded(flex: 6, child: fields),
              ],
            );
    },
  );

  Widget _introduction() => LayoutBuilder(
    builder: (_, c) {
      final brand = Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FBFE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _line),
        ),
        child: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _image(_logo.text, icon: Icons.school_rounded),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _pickImage(_logo),
              icon: const Icon(Icons.upload_rounded),
              label: const Text('Ganti Logo'),
            ),
            const SizedBox(height: 12),
            _field('Nama Sekolah', _schoolName),
            const SizedBox(height: 10),
            _field('Motto Sekolah', _schoolMotto),
          ],
        ),
      );
      final copy = Column(
        children: [
          _field('Judul Pengantar', _introTitle),
          const SizedBox(height: 12),
          _field('Deskripsi', _intro, lines: 6),
        ],
      );
      return c.maxWidth < 800
          ? Column(children: [brand, const SizedBox(height: 18), copy])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 300, child: brand),
                const SizedBox(width: 22),
                Expanded(child: copy),
              ],
            );
    },
  );

  Widget _stats() => LayoutBuilder(
    builder: (_, c) {
      final width = c.maxWidth < 650 ? c.maxWidth : (c.maxWidth - 36) / 4;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(width: width, child: _field('Total Prestasi', _statTotal)),
          SizedBox(width: width, child: _field('Olahraga', _statSport)),
          SizedBox(width: width, child: _field('Seni & Budaya', _statArt)),
          SizedBox(
            width: width,
            child: _field('Organisasi & Sosial', _statSocial),
          ),
        ],
      );
    },
  );

  Widget _achievementCards(
    List<Map<String, String>> data, {
    bool featured = false,
  }) => LayoutBuilder(
    builder: (_, c) {
      final columns = c.maxWidth < 650
          ? 1
          : c.maxWidth < 1000
          ? 2
          : 3;
      final width = (c.maxWidth - (columns - 1) * 14) / columns;
      return Column(
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              ...data.asMap().entries.map(
                (e) => SizedBox(
                  width: width,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FBFE),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: featured ? 165 : 145,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: _image(e.value['image'] ?? ''),
                        ),
                        const SizedBox(height: 11),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF2FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            e.value['category']!,
                            style: const TextStyle(
                              color: _blue,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          e.value['title']!,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          e.value['student'] ?? 'Nama Siswa',
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                        Text(
                          '${e.value['date']} • ${e.value['level']}',
                          style: const TextStyle(color: _muted, fontSize: 11),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => _editAchievement(data, e.key),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => data.removeAt(e.key)),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _editAchievement(data, null),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                featured ? 'Tambah Prestasi Pilihan' : 'Tambah Prestasi',
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _simpleCards(List<Map<String, String>> data, String label) => Column(
    children: [
      ...data.asMap().entries.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _contentCard(
            Icons.auto_awesome_rounded,
            e.value['title']!,
            e.value['desc']!,
            [
              IconButton(
                onPressed: () => _editPair(data, e.key, label),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => setState(() => data.removeAt(e.key)),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editPair(data, null, label),
          icon: const Icon(Icons.add_rounded),
          label: Text('Tambah $label'),
        ),
      ),
    ],
  );

  Widget _story() => LayoutBuilder(
    builder: (_, c) {
      final preview = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 245,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _line),
            ),
            child: _image(_storyImage.text, icon: Icons.person_rounded),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickImage(_storyImage),
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Ganti Foto'),
              ),
              TextButton.icon(
                onPressed: () => setState(_storyImage.clear),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ],
      );
      final fields = Column(
        children: [
          _field('Judul Bagian', _storyTitle),
          const SizedBox(height: 10),
          _field('Quote / Cerita', _storyQuote, lines: 5),
          const SizedBox(height: 10),
          _field('Nama Siswa & Kelas', _storyStudent),
          const SizedBox(height: 10),
          _field('Prestasi Siswa', _storyAchievement),
        ],
      );
      return c.maxWidth < 800
          ? Column(children: [preview, const SizedBox(height: 18), fields])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: preview),
                const SizedBox(width: 22),
                Expanded(child: fields),
              ],
            );
    },
  );

  Widget _journeyEditor() => Column(
    children: [
      ..._journey.asMap().entries.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _contentCard(
            Icons.timeline_rounded,
            e.value['year']!,
            '${e.value['count']} Prestasi',
            [
              IconButton(
                onPressed: () => _editJourney(e.key),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => setState(() => _journey.removeAt(e.key)),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editJourney(null),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Tahun'),
        ),
      ),
    ],
  );

  Widget _documentationEditor() => LayoutBuilder(
    builder: (_, c) {
      final columns = c.maxWidth < 650 ? 1 : 3;
      final width = (c.maxWidth - (columns - 1) * 14) / columns;
      return Column(
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              ..._documentation.asMap().entries.map(
                (e) => SizedBox(
                  width: width,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FBFE),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 165,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: _image(e.value['image'] ?? ''),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          e.value['title']!,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => _editDocumentation(e.key),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                            IconButton(
                              onPressed: () => setState(
                                () => _documentation.removeAt(e.key),
                              ),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _editDocumentation(null),
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Tambah Dokumentasi'),
            ),
          ),
        ],
      );
    },
  );

  Widget _cta() => Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF083A7C), Color(0xFF0756C8)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.school_rounded, color: Colors.white, size: 46),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _ctaTitle.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _ctaSubtitle.text,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _field('Judul CTA', _ctaTitle, changed: (_) => setState(() {})),
      const SizedBox(height: 10),
      _field(
        'Deskripsi CTA',
        _ctaSubtitle,
        lines: 2,
        changed: (_) => setState(() {}),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _field('Teks Tombol 1', _ctaButton1)),
          const SizedBox(width: 12),
          Expanded(child: _field('Teks Tombol 2', _ctaButton2)),
        ],
      ),
    ],
  );

  Widget _contentCard(
    IconData icon,
    String title,
    String subtitle,
    List<Widget> actions,
  ) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FBFE),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: _line),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: _blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, height: 1.4),
              ),
            ],
          ),
        ),
        ...actions,
      ],
    ),
  );

  Widget _field(
    String label,
    TextEditingController controller, {
    int lines = 1,
    ValueChanged<String>? changed,
  }) => AdminContentTextField(
    controller: controller,
    maxLines: lines,
    onChanged: changed,
    decoration: InputDecoration(
      labelText: label,
      alignLabelWithHint: lines > 1,
      filled: true,
      fillColor: const Color(0xFFFBFCFE),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _line),
      ),
    ),
  );

  Future<void> _editPair(
    List<Map<String, String>> list,
    int? index,
    String label,
  ) async {
    final old = index == null ? null : list[index];
    final title = TextEditingController(text: old?['title'] ?? '');
    final desc = TextEditingController(text: old?['desc'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(index == null ? 'Tambah $label' : 'Edit $label'),
        content: SizedBox(
          width: 540,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminContentTextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              const SizedBox(height: 10),
              AdminContentTextField(
                controller: desc,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true && title.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {
          if (old?['id'] != null) 'id': old!['id']!,
          'title': title.text.trim(),
          'desc': desc.text.trim(),
        };
        if (index == null)
          list.add(value);
        else
          list[index] = value;
      });
    }
    title.dispose();
    desc.dispose();
  }

  Future<void> _editAchievement(
    List<Map<String, String>> list,
    int? index,
  ) async {
    final old = index == null ? null : list[index];
    final title = TextEditingController(text: old?['title'] ?? '');
    final category = TextEditingController(
      text: old?['category'] ?? 'Olahraga',
    );
    final date = TextEditingController(text: old?['date'] ?? '');
    final level = TextEditingController(text: old?['level'] ?? '');
    final student = TextEditingController(
      text: old?['student'] ?? 'Nama Siswa',
    );
    final image = TextEditingController(text: old?['image'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (_, modalSetState) => AlertDialog(
          title: Text(index == null ? 'Tambah Prestasi' : 'Edit Prestasi'),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image(image.text),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _pickImage(image);
                      modalSetState(() {});
                    },
                    icon: const Icon(Icons.upload_rounded),
                    label: const Text('Pilih Foto'),
                  ),
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: 'Nama Prestasi',
                    ),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: student,
                    decoration: const InputDecoration(labelText: 'Nama Siswa'),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: category,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: date,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal / Bulan',
                    ),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: level,
                    decoration: const InputDecoration(
                      labelText: 'Tingkat / Lokasi',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(d, true),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    if (ok == true && title.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {
          if (old?['id'] != null) 'id': old!['id']!,
          'title': title.text.trim(),
          'student': student.text.trim(),
          'category': category.text.trim(),
          'date': date.text.trim(),
          'level': level.text.trim(),
          'image': image.text,
        };
        if (index == null)
          list.add(value);
        else
          list[index] = value;
      });
    }
    title.dispose();
    category.dispose();
    date.dispose();
    level.dispose();
    student.dispose();
    image.dispose();
  }

  Future<void> _editJourney(int? index) async {
    final old = index == null ? null : _journey[index];
    final year = TextEditingController(text: old?['year'] ?? '');
    final count = TextEditingController(text: old?['count'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(
          index == null ? 'Tambah Tahun' : 'Edit Perjalanan Prestasi',
        ),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminContentTextField(
                controller: year,
                decoration: const InputDecoration(labelText: 'Tahun'),
              ),
              const SizedBox(height: 10),
              AdminContentTextField(
                controller: count,
                decoration: const InputDecoration(labelText: 'Jumlah Prestasi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true && year.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {
          if (old?['id'] != null) 'id': old!['id']!,
          'year': year.text.trim(),
          'count': count.text.trim(),
        };
        if (index == null)
          _journey.add(value);
        else
          _journey[index] = value;
      });
    }
    year.dispose();
    count.dispose();
  }

  Future<void> _editDocumentation(int? index) async {
    final old = index == null ? null : _documentation[index];
    final title = TextEditingController(text: old?['title'] ?? '');
    final image = TextEditingController(text: old?['image'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (_, modalSetState) => AlertDialog(
          title: Text(
            index == null ? 'Tambah Dokumentasi' : 'Edit Dokumentasi',
          ),
          content: SizedBox(
            width: 560,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 185,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image(image.text),
                ),
                const SizedBox(height: 9),
                OutlinedButton.icon(
                  onPressed: () async {
                    await _pickImage(image);
                    modalSetState(() {});
                  },
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text('Pilih Foto'),
                ),
                const SizedBox(height: 11),
                AdminContentTextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Judul / Keterangan',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(d, true),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    if (ok == true && mounted) {
      setState(() {
        final value = {
          if (old?['id'] != null) 'id': old!['id']!,
          'title': title.text.trim().isEmpty
              ? 'Dokumentasi'
              : title.text.trim(),
          'image': image.text,
        };
        if (index == null)
          _documentation.add(value);
        else
          _documentation[index] = value;
      });
    }
    title.dispose();
    image.dispose();
  }
}
