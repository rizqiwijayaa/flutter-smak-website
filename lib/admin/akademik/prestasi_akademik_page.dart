part of '../admin_dashboard_page.dart';

class AdminPrestasiAkademikPage extends StatefulWidget {
  const AdminPrestasiAkademikPage({
    super.key,
    required this.api,
    required this.module,
  });

  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminPrestasiAkademikPage> createState() =>
      _AdminPrestasiAkademikPageState();
}

class _AdminPrestasiAkademikPageState extends State<AdminPrestasiAkademikPage> {
  final _heroTitle = TextEditingController(text: 'Prestasi Akademik');
  final _heroSubtitle = TextEditingController(
    text:
        'Mengukir prestasi melalui semangat belajar, disiplin, dan kerja keras.',
  );
  final _heroImage = TextEditingController();

  final _introTitle = TextEditingController(text: 'Prestasi yang Membanggakan');
  final _introSubtitle = TextEditingController(
    text:
        'Berbagai capaian akademik menjadi bukti semangat belajar, dedikasi siswa, dan pendampingan guru.',
  );

  final _mentoringTitle = TextEditingController(
    text: 'Pembinaan Prestasi Berkelanjutan',
  );
  final _mentoringText = TextEditingController(
    text:
        'Prestasi lahir dari proses yang terarah, dukungan yang konsisten, dan keberanian untuk terus belajar.',
  );
  final _mentoringImage = TextEditingController();

  final _quote = TextEditingController(
    text:
        'Belajar dengan sungguh-sungguh, disiplin, dan tidak mudah menyerah adalah kunci untuk meraih prestasi.',
  );
  final _quoteName = TextEditingController(text: 'Clara Angelina');
  final _quoteClass = TextEditingController(text: 'XI IPA 2');
  final _quoteImage = TextEditingController();

  final _ctaTitle = TextEditingController(text: 'Bersama Meraih Prestasi');
  final _ctaText = TextEditingController(
    text: 'Mari terus belajar, menginspirasi, dan membawa nama baik SMAK.',
  );
  final _ctaWhatsapp = TextEditingController(text: '628155099445');
  final _featuredTitle = TextEditingController(text: 'Prestasi Unggulan');
  final _latestTitle = TextEditingController(text: 'Capaian Prestasi Terbaru');
  final _fieldsTitle = TextEditingController(text: 'Bidang Prestasi');
  final _journeyTitle = TextEditingController(text: 'Perjalanan Prestasi');
  final _ctaButton = TextEditingController(text: 'Hubungi Sekolah');

  late List<Map<String, dynamic>> _achievements;
  late List<Map<String, dynamic>> _fields;
  late List<Map<String, dynamic>> _mentoringItems;
  late List<Map<String, dynamic>> _journey;
  int? _heroId;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _seedFrontendData();
    _loadDatabase();
  }

  @override
  void dispose() {
    for (final c in [
      _heroTitle,
      _heroSubtitle,
      _heroImage,
      _introTitle,
      _introSubtitle,
      _mentoringTitle,
      _mentoringText,
      _mentoringImage,
      _quote,
      _quoteName,
      _quoteClass,
      _quoteImage,
      _ctaTitle,
      _ctaText,
      _ctaWhatsapp,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _seedFrontendData() {
    _achievements = [
      {
        'judul': 'Juara I Debat Bahasa Indonesia',
        'peserta': 'Tim Debat SMAK',
        'tingkat': 'NASIONAL',
        'event': 'Kompetisi Debat Bahasa Indonesia Tingkat Nasional',
        'tanggal': '20 April 2026',
        'tahun': '2026',
        'unggulan': true,
        'urutan_unggulan': 1,
        'gambar': '',
      },
      {
        'judul': 'Olimpiade Sains',
        'peserta': 'Tim OSN SMAK Lumajang',
        'tingkat': 'NASIONAL',
        'event': 'Olimpiade Sains Nasional',
        'tanggal': '2026',
        'tahun': '2026',
        'unggulan': true,
        'urutan_unggulan': 2,
        'gambar': '',
      },
      {
        'judul': 'Lomba Karya Tulis Ilmiah',
        'peserta': 'Tim KTI SMAK Lumajang',
        'tingkat': 'PROVINSI',
        'event': 'LKTI Pelajar Jawa Timur',
        'tanggal': '2026',
        'tahun': '2026',
        'unggulan': true,
        'urutan_unggulan': 3,
        'gambar': '',
      },
      {
        'judul': 'Medali Perak Olimpiade Matematika',
        'peserta': 'Andreas Wijaya',
        'tingkat': 'NASIONAL',
        'event': 'Kompetisi Akademik SMA',
        'tanggal': '15 Maret 2025',
        'tahun': '2025',
        'unggulan': false,
        'urutan_unggulan': 0,
        'gambar': '',
      },
      {
        'judul': 'Juara II Karya Tulis Ilmiah',
        'peserta': 'Tim KTI SMAK',
        'tingkat': 'PROVINSI',
        'event': 'Kompetisi Akademik SMA',
        'tanggal': '10 Februari 2024',
        'tahun': '2024',
        'unggulan': false,
        'urutan_unggulan': 0,
        'gambar': '',
      },
      {
        'judul': 'Finalis Olimpiade Biologi',
        'peserta': 'Clara Angelina',
        'tingkat': 'PROVINSI',
        'event': 'Kompetisi Akademik SMA',
        'tanggal': '5 Februari 2025',
        'tahun': '2025',
        'unggulan': false,
        'urutan_unggulan': 0,
        'gambar': '',
      },
      {
        'judul': 'Juara III Cerdas Cermat',
        'peserta': 'Tim Cerdas Cermat',
        'tingkat': 'KABUPATEN',
        'event': 'Kompetisi Akademik SMA',
        'tanggal': '28 Januari 2024',
        'tahun': '2024',
        'unggulan': false,
        'urutan_unggulan': 0,
        'gambar': '',
      },
      {
        'judul': 'Best Presentation',
        'peserta': 'Gabriel Santoso',
        'tingkat': 'NASIONAL',
        'event': 'Kompetisi Akademik SMA',
        'tanggal': '18 Januari 2026',
        'tahun': '2026',
        'unggulan': false,
        'urutan_unggulan': 0,
        'gambar': '',
      },
    ];

    _fields = [
      {
        'judul': 'Sains & Matematika',
        'deskripsi': 'Olimpiade, penelitian, dan kompetisi sains.',
      },
      {
        'judul': 'Bahasa & Literasi',
        'deskripsi': 'Debat, karya tulis, pidato, dan literasi.',
      },
      {
        'judul': 'Teknologi & Inovasi',
        'deskripsi': 'Robotika, coding, dan inovasi digital.',
      },
      {
        'judul': 'Seni & Kreativitas',
        'deskripsi': 'Seni rupa, musik, dan kreativitas siswa.',
      },
    ];

    _mentoringItems = [
      {
        'judul': 'Pendampingan Guru',
        'deskripsi': 'Guru pembimbing mendampingi siswa secara intensif.',
      },
      {
        'judul': 'Program Latihan',
        'deskripsi':
            'Jadwal latihan rutin dan terstruktur sesuai bidang lomba.',
      },
      {
        'judul': 'Evaluasi Berkala',
        'deskripsi': 'Monitoring untuk meningkatkan kualitas dan hasil.',
      },
      {
        'judul': 'Dukungan Sekolah',
        'deskripsi': 'Fasilitas dan dukungan moral untuk setiap peserta.',
      },
    ];

    _journey = [
      {'tahun': '2023', 'jumlah': '15'},
      {'tahun': '2024', 'jumlah': '18'},
      {'tahun': '2025', 'jumlah': '21'},
      {'tahun': '2026', 'jumlah': '24'},
    ];
  }

  String _s(dynamic value) => '${value ?? ''}'.trim();

  int get _total => _achievements.length;

  int _countLevel(String level) => _achievements
      .where((e) => _s(e['tingkat']).toUpperCase() == level)
      .length;

  List<Map<String, dynamic>> get _featured {
    final rows = _achievements.where((e) => e['unggulan'] == true).toList();
    rows.sort(
      (a, b) => (a['urutan_unggulan'] as int? ?? 99).compareTo(
        b['urutan_unggulan'] as int? ?? 99,
      ),
    );
    return rows.take(3).toList();
  }

  String _pick(
    Map<String, dynamic> row,
    List<String> keys, [
    String fallback = '',
  ]) {
    for (final key in keys) {
      final value = _s(row[key]);
      if (value.isNotEmpty) return value;
    }
    return fallback;
  }

  bool _bool(dynamic value) {
    if (value is bool) return value;
    final s = _s(value).toLowerCase();
    return s == '1' || s == 'true' || s == 'aktif' || s == 'ya';
  }

  int _int(dynamic value, [int fallback = 0]) =>
      int.tryParse(_s(value)) ?? fallback;

  Future<void> _loadDatabase() async {
    try {
      final result = await Future.wait([
        widget.api.getTable('akademik_hero', limit: 1),
        widget.api.getTable('akademik_prestasi', limit: 100),
        widget.api.getTable('akademik_bidang_prestasi', limit: 50),
        widget.api.getTable('akademik_pembinaan_prestasi', limit: 50),
      ]);

      final heroRows = result[0];
      final achievementRows = result[1];
      final fieldRows = result[2];
      final mentoringRows = result[3];

      if (heroRows.isNotEmpty) {
        final row = heroRows.first;
        _heroId = _int(row['id']);
        _heroTitle.text = _pick(row, ['judul', 'hero_judul'], _heroTitle.text);
        _heroSubtitle.text = _pick(row, [
          'subjudul',
          'subtitle',
          'hero_subtitle',
        ], _heroSubtitle.text);
        _heroImage.text = _pick(row, [
          'gambar',
          'banner',
          'hero_gambar',
        ], _heroImage.text);
        _introTitle.text = _pick(row, [
          'intro_judul',
          'judul_intro',
        ], _introTitle.text);
        _introSubtitle.text = _pick(row, [
          'intro_deskripsi',
          'deskripsi_intro',
        ], _introSubtitle.text);
        _mentoringTitle.text = _pick(row, [
          'pembinaan_judul',
          'mentoring_judul',
        ], _mentoringTitle.text);
        _mentoringText.text = _pick(row, [
          'pembinaan_deskripsi',
          'mentoring_deskripsi',
        ], _mentoringText.text);
        _mentoringImage.text = _pick(row, [
          'pembinaan_gambar',
          'mentoring_gambar',
        ], _mentoringImage.text);
        _quote.text = _pick(row, ['kutipan', 'quote'], _quote.text);
        _quoteName.text = _pick(row, [
          'kutipan_nama',
          'quote_nama',
        ], _quoteName.text);
        _quoteClass.text = _pick(row, [
          'kutipan_kelas',
          'quote_kelas',
        ], _quoteClass.text);
        _quoteImage.text = _pick(row, [
          'kutipan_foto',
          'quote_foto',
        ], _quoteImage.text);
        _ctaTitle.text = _pick(row, ['cta_judul'], _ctaTitle.text);
        _ctaText.text = _pick(row, [
          'cta_deskripsi',
          'cta_teks',
        ], _ctaText.text);
        _ctaWhatsapp.text = _pick(row, [
          'cta_whatsapp',
          'whatsapp',
        ], _ctaWhatsapp.text);
        _featuredTitle.text = _pick(row, ['judul_unggulan'], _featuredTitle.text);
        _latestTitle.text = _pick(row, ['judul_terbaru'], _latestTitle.text);
        _fieldsTitle.text = _pick(row, ['judul_bidang'], _fieldsTitle.text);
        _journeyTitle.text = _pick(row, ['judul_perjalanan'], _journeyTitle.text);
        _ctaButton.text = _pick(row, ['cta_teks_tombol'], _ctaButton.text);
      }

      final savedAchievements = achievementRows
          .where((row) => _s(row['peserta']).isNotEmpty)
          .toList();
      if (savedAchievements.isNotEmpty) {
        _achievements = savedAchievements.map((raw) {
          final row = Map<String, dynamic>.from(raw);
          row['unggulan'] = _bool(row['unggulan']);
          row['urutan_unggulan'] = _int(row['urutan_unggulan']);
          row['tahun'] = _pick(
            row,
            ['tahun'],
            _pick(row, ['tanggal']).isNotEmpty
                ? _pick(row, ['tanggal']).split('-').first
                : '',
          );
          return row;
        }).toList();
      }

      final savedFields = fieldRows
          .where((row) => _s(row['deskripsi']).isNotEmpty)
          .toList();
      if (savedFields.isNotEmpty) {
        _fields = savedFields.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      final savedMentoring = mentoringRows
          .where((row) => _s(row['deskripsi']).isNotEmpty)
          .toList();
      if (savedMentoring.isNotEmpty) {
        _mentoringItems = savedMentoring
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      _rebuildJourney();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Database belum dapat dimuat: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _rebuildJourney() {
    final counts = <String, int>{};
    for (final row in _achievements) {
      final year = _s(row['tahun']);
      if (year.isEmpty) continue;
      counts[year] = (counts[year] ?? 0) + 1;
    }
    final years = counts.keys.toList()..sort();
    _journey = [
      for (final year in years) {'tahun': year, 'jumlah': '${counts[year]}'},
    ];
  }

  Map<String, dynamic> _heroPayload() => {
    'judul': _heroTitle.text.trim(),
    'subjudul': _heroSubtitle.text.trim(),
    'gambar': _heroImage.text.trim(),
    'intro_judul': _introTitle.text.trim(),
    'intro_deskripsi': _introSubtitle.text.trim(),
    'pembinaan_judul': _mentoringTitle.text.trim(),
    'pembinaan_deskripsi': _mentoringText.text.trim(),
    'pembinaan_gambar': _mentoringImage.text.trim(),
    'kutipan': _quote.text.trim(),
    'kutipan_nama': _quoteName.text.trim(),
    'kutipan_kelas': _quoteClass.text.trim(),
    'kutipan_foto': _quoteImage.text.trim(),
    'cta_judul': _ctaTitle.text.trim(),
    'cta_deskripsi': _ctaText.text.trim(),
    'cta_whatsapp': _ctaWhatsapp.text.trim(),
    'judul_unggulan': _featuredTitle.text.trim(),
    'judul_terbaru': _latestTitle.text.trim(),
    'judul_bidang': _fieldsTitle.text.trim(),
    'judul_perjalanan': _journeyTitle.text.trim(),
    'cta_teks_tombol': _ctaButton.text.trim(),
    'status': 'aktif',
  };

  Future<void> _savePageSettings() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.api.save(
        'akademik_hero',
        _heroPayload(),
        id: _heroId == 0 ? null : _heroId,
      );
      final rows = await widget.api.getTable('akademik_hero', limit: 1);
      if (rows.isNotEmpty) _heroId = _int(rows.first['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perubahan Prestasi Akademik berhasil disimpan.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan perubahan: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveAchievementRow(Map<String, dynamic> row) async {
    final id = _int(row['id']);
    await widget.api.save('akademik_prestasi', {
      'bagian': 'item',
      'judul': _s(row['judul']),
      'peserta': _s(row['peserta']),
      'event': _s(row['event']),
      'tingkat': _s(row['tingkat']),
      'tanggal': _s(row['tanggal']),
      'tahun': _s(row['tahun']),
      'gambar': _s(row['gambar']),
      'unggulan': row['unggulan'] == true ? 1 : 0,
      'urutan_unggulan': _int(row['urutan_unggulan']),
      'data_json': jsonEncode(row),
      'status': 'aktif',
    }, id: id == 0 ? null : id);
  }

  Future<void> _deleteAchievementRow(Map<String, dynamic> row) async {
    final id = _int(row['id']);
    if (id > 0) await widget.api.delete('akademik_prestasi', id);
    setState(() {
      _achievements.remove(row);
      _rebuildJourney();
    });
  }

  Future<void> _saveSimpleDb(
    String table,
    Map<String, dynamic> row,
    List<String> fields,
  ) async {
    final id = _int(row['id']);
    await widget.api.save(table, {
      'bagian': 'item',
      for (final field in fields) field: _s(row[field]),
      'data_json': jsonEncode(row),
      'status': 'aktif',
    }, id: id == 0 ? null : id);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pageHeader(),
          const SizedBox(height: 22),
          _section(
            '1',
            'Hero Prestasi Akademik',
            'Konten banner paling atas pada halaman Prestasi Akademik.',
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 420,
                  child: _imageEditor(
                    controller: _heroImage,
                    label: 'Banner / Gambar Hero',
                    uploadTable: 'akademik_hero',
                    height: 170,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _field(_heroTitle, 'Judul Hero'),
                      const SizedBox(height: 12),
                      _field(_heroSubtitle, 'Deskripsi Hero', maxLines: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _gap(),
          _section(
            '2',
            'Ringkasan Prestasi',
            'Statistik dihitung otomatis dari seluruh data prestasi.',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(_introTitle, 'Judul Section'),
                const SizedBox(height: 12),
                _field(_introSubtitle, 'Deskripsi Section', maxLines: 3),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 900 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.45,
                      children: [
                        _stat(
                          'Total Prestasi',
                          '$_total',
                          Icons.emoji_events_rounded,
                        ),
                        _stat(
                          'Tingkat Nasional',
                          '${_countLevel('NASIONAL')}',
                          Icons.workspace_premium_rounded,
                        ),
                        _stat(
                          'Tingkat Provinsi',
                          '${_countLevel('PROVINSI')}',
                          Icons.star_rounded,
                        ),
                        _stat(
                          'Tingkat Kabupaten',
                          '${_countLevel('KABUPATEN')}',
                          Icons.account_balance_rounded,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          _gap(),
          _section(
            '3',
            'Prestasi Unggulan',
            'Tiga prestasi yang ditandai unggulan akan tampil sebagai kartu utama frontend.',
            _featuredEditor(),
          ),
          _gap(),
          _section(
            '4',
            'Data Prestasi',
            'Satu sumber data untuk daftar prestasi, filter tahun, statistik, dan prestasi unggulan.',
            _achievementEditor(),
          ),
          _gap(),
          _section(
            '5',
            'Bidang Prestasi',
            'Kelola kategori bidang prestasi yang diperkenalkan pada frontend.',
            _simpleList('Bidang Prestasi', _fields, const [
              'judul',
              'deskripsi',
            ]),
          ),
          _gap(),
          _section(
            '6',
            'Pembinaan Prestasi Berkelanjutan',
            'Judul, deskripsi, gambar, dan poin program pembinaan.',
            Column(
              children: [
                _field(_mentoringTitle, 'Judul'),
                const SizedBox(height: 12),
                _field(_mentoringText, 'Deskripsi', maxLines: 3),
                const SizedBox(height: 12),
                _imageEditor(
                  controller: _mentoringImage,
                  label: 'Gambar Pembinaan',
                  uploadTable: 'akademik_pembinaan_prestasi',
                  height: 210,
                ),
                const SizedBox(height: 16),
                _simpleList('Program Pembinaan', _mentoringItems, const [
                  'judul',
                  'deskripsi',
                ]),
              ],
            ),
          ),
          _gap(),
          _section(
            '7',
            'Quote Siswa',
            'Kutipan siswa yang ditampilkan pada frontend.',
            Column(
              children: [
                _field(_quote, 'Kutipan', maxLines: 4),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _field(_quoteName, 'Nama Siswa')),
                    const SizedBox(width: 12),
                    Expanded(child: _field(_quoteClass, 'Kelas')),
                  ],
                ),
                const SizedBox(height: 12),
                _imageEditor(
                  controller: _quoteImage,
                  label: 'Foto Siswa',
                  uploadTable: 'akademik_kutipan_siswa',
                  height: 190,
                ),
              ],
            ),
          ),
          _gap(),
          _section(
            '8',
            'Perjalanan Prestasi',
            'Timeline jumlah prestasi per tahun.',
            _journeyCards(),
          ),
          _gap(),
          _section(
            '9',
            'CTA Penutup',
            'Ajakan pada bagian paling bawah halaman Prestasi Akademik.',
            Column(
              children: [
                _field(_ctaTitle, 'Judul CTA'),
                const SizedBox(height: 12),
                _field(_ctaText, 'Deskripsi CTA', maxLines: 3),
                const SizedBox(height: 12),
                _field(_ctaWhatsapp, 'Nomor WhatsApp'),
                const SizedBox(height: 12),
                _field(_featuredTitle, 'Judul Section Unggulan'),
                const SizedBox(height: 12),
                _field(_latestTitle, 'Judul Section Terbaru'),
                const SizedBox(height: 12),
                _field(_fieldsTitle, 'Judul Section Bidang'),
                const SizedBox(height: 12),
                _field(_journeyTitle, 'Judul Section Perjalanan'),
                const SizedBox(height: 12),
                _field(_ctaButton, 'Teks Tombol CTA'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _bottomInfo(),
        ],
      ),
    );
  }

  Widget _pageHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prestasi Akademik',
              style: TextStyle(
                color: _text,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Kelola konten dan capaian akademik yang ditampilkan di website.',
              style: TextStyle(color: _muted),
            ),
          ],
        ),
      ),
      OutlinedButton.icon(
        onPressed: () => _openAdminPreview(context, sharedAcademicPages()['prestasi']!),
        icon: const Icon(Icons.visibility_outlined, size: 18),
        label: const Text('Preview Halaman'),
        style: OutlinedButton.styleFrom(
          foregroundColor: _blue,
          side: const BorderSide(color: _line),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        ),
      ),
      const SizedBox(width: 10),
      FilledButton.icon(
        onPressed: _saving ? null : _savePageSettings,
        icon: _saving
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save_outlined, size: 18),
        label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
        style: FilledButton.styleFrom(
          backgroundColor: _blue,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        ),
      ),
    ],
  );

  Widget _section(String number, String title, String note, Widget child) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x09000000),
              blurRadius: 18,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        note,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      );

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) => AdminContentTextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFBFCFE),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _blue, width: 1.4),
      ),
    ),
  );

  String _imageUrl(String value) {
    final raw = value.trim();
    if (raw.isEmpty ||
        raw.startsWith('assets/') ||
        raw.startsWith('http://') ||
        raw.startsWith('https://'))
      return raw;
    return widget.api.getFileUrl(raw);
  }

  Widget _previewImage(String value, {double height = 200}) {
    final raw = value.trim();
    if (raw.isEmpty)
      return Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _line),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, color: _muted, size: 42),
            SizedBox(height: 8),
            Text('Belum ada gambar', style: TextStyle(color: _muted)),
          ],
        ),
      );
    final image = websiteContentImage(
      raw,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
    );
    return ClipRRect(borderRadius: BorderRadius.circular(12), child: image);
  }

  Widget _imageError(double height) => Container(
    height: height,
    width: double.infinity,
    color: const Color(0xFFF4F7FB),
    alignment: Alignment.center,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image_outlined, color: _muted, size: 38),
        SizedBox(height: 6),
        Text(
          'Preview gambar tidak tersedia',
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      ],
    ),
  );

  Future<void> _pickAndUploadImage({
    required TextEditingController controller,
    required String table,
    VoidCallback? refresh,
  }) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    try {
      final filename = await widget.api.uploadFile(table, input.files!.first);
      controller.text = filename;
      if (!mounted) return;
      setState(() {});
      refresh?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gambar berhasil diupload.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload gambar gagal: $e')));
    }
  }

  Widget _imageEditor({
    required TextEditingController controller,
    required String label,
    required String uploadTable,
    double height = 200,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _text,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 9),
      _previewImage(controller.text, height: height),
      const SizedBox(height: 10),
      Row(
        children: [
          FilledButton.icon(
            onPressed: () =>
                _pickAndUploadImage(controller: controller, table: uploadTable),
            style: FilledButton.styleFrom(backgroundColor: _blue),
            icon: const Icon(Icons.upload_rounded),
            label: Text(
              controller.text.trim().isEmpty ? 'Upload Gambar' : 'Ganti Gambar',
            ),
          ),
          if (controller.text.trim().isNotEmpty) ...[
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () => setState(() => controller.clear()),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Hapus Gambar'),
            ),
          ],
        ],
      ),
    ],
  );

  Widget _dialogImageEditor({
    required TextEditingController controller,
    required String label,
    required String uploadTable,
    required StateSetter setDialogState,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _text,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 9),
      _previewImage(controller.text, height: 190),
      const SizedBox(height: 10),
      Row(
        children: [
          FilledButton.icon(
            onPressed: () => _pickAndUploadImage(
              controller: controller,
              table: uploadTable,
              refresh: () => setDialogState(() {}),
            ),
            icon: const Icon(Icons.upload_rounded),
            label: Text(
              controller.text.trim().isEmpty ? 'Upload Gambar' : 'Ganti Gambar',
            ),
          ),
          if (controller.text.trim().isNotEmpty) ...[
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                controller.clear();
                setDialogState(() {});
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Hapus'),
            ),
          ],
        ],
      ),
    ],
  );

  Widget _stat(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFBFCFE),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Row(
      children: [
        Icon(icon, color: _blue, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: _text,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: _muted, fontSize: 11.5),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _featuredEditor() {
    final rows = _achievements.where((e) => e['unggulan'] == true).toList()
      ..sort(
        (a, b) =>
            _int(a['urutan_unggulan']).compareTo(_int(b['urutan_unggulan'])),
      );

    if (rows.isEmpty) {
      return _emptyVisualState(
        'Belum ada prestasi unggulan',
        'Tandai prestasi sebagai unggulan dari editor Data Prestasi.',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1050
            ? 3
            : constraints.maxWidth >= 700
            ? 2
            : 1;
        final width = (constraints.maxWidth - ((columns - 1) * 14)) / columns;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (final row in rows)
              SizedBox(
                width: width,
                child: _achievementVisualCard(
                  row,
                  featured: true,
                  onEdit: () => _editAchievement(row),
                  onDelete: () async {
                    row['unggulan'] = false;
                    row['urutan_unggulan'] = 0;
                    try {
                      await _saveAchievementRow(row);
                      if (mounted) setState(() {});
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengubah unggulan: $e')),
                      );
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _achievementEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _editAchievement(null),
            style: FilledButton.styleFrom(backgroundColor: _blue),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Prestasi'),
          ),
        ),
        const SizedBox(height: 14),
        if (_achievements.isEmpty)
          _emptyVisualState(
            'Belum ada data prestasi',
            'Tambahkan prestasi untuk mulai menampilkan capaian akademik.',
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1050
                  ? 3
                  : constraints.maxWidth >= 700
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - ((columns - 1) * 14)) / columns;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  for (final row in _achievements)
                    SizedBox(
                      width: width,
                      child: _achievementVisualCard(
                        row,
                        onEdit: () => _editAchievement(row),
                        onDelete: () => _deleteAchievementRow(row),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _achievementVisualCard(
    Map<String, dynamic> row, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    bool featured = false,
  }) {
    final image = _s(row['gambar']);
    final title = _s(row['judul']).isEmpty
        ? 'Prestasi Akademik'
        : _s(row['judul']);
    final participant = _s(row['peserta']).isEmpty
        ? 'Peserta belum diisi'
        : _s(row['peserta']);
    final level = _s(row['tingkat']).toUpperCase();
    final date = _s(row['tanggal']);
    final year = _s(row['tahun']);
    final isFeatured = row['unggulan'] == true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 165,
            width: double.infinity,
            child: _cardImage(image),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (level.isNotEmpty) _miniBadge(level),
                    if (isFeatured)
                      _miniBadge(
                        featured
                            ? 'UNGGULAN #${_int(row['urutan_unggulan'])}'
                            : 'UNGGULAN',
                        blue: true,
                      ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  participant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 11.5),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: _muted,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        date.isNotEmpty ? date : year,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 10.5),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      visualDensity: VisualDensity.compact,
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: _blue,
                        size: 19,
                      ),
                    ),
                    IconButton(
                      tooltip: featured ? 'Hapus dari unggulan' : 'Hapus',
                      visualDensity: VisualDensity.compact,
                      onPressed: onDelete,
                      icon: Icon(
                        featured
                            ? Icons.star_border_rounded
                            : Icons.delete_outline_rounded,
                        color: featured ? _blue : Colors.redAccent,
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
  }

  Widget _cardImage(String value) {
    final raw = value.trim();
    if (raw.isEmpty) {
      return Container(
        color: const Color(0xFFF1F5FB),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_outlined,
          color: Color(0xFF6C7F99),
          size: 38,
        ),
      );
    }

    return websiteContentImage(raw, fit: BoxFit.cover);
  }

  Widget _miniBadge(String text, {bool blue = false}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: blue ? _blue.withOpacity(.09) : const Color(0xFFF3F6FA),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: blue ? _blue.withOpacity(.20) : _line),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: blue ? _blue : _muted,
        fontSize: 9.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  Widget _emptyVisualState(String title, String subtitle) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFD),
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        const Icon(Icons.image_outlined, color: _muted, size: 38),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, fontSize: 11.5),
        ),
      ],
    ),
  );

  Widget _simpleList(
    String name,
    List<Map<String, dynamic>> list,
    List<String> fields, {
    bool numbered = false,
  }) => Column(
    children: [
      for (var i = 0; i < list.length; i++) ...[
        _dataRow(
          title: '${numbered ? '${i + 1}. ' : ''}${_s(list[i][fields.first])}',
          subtitle: fields.length > 1 ? _s(list[i][fields[1]]) : '',
          onEdit: () => _editSimple(name, list, fields, row: list[i]),
          onDelete: () async {
            final table = name == 'Bidang Prestasi'
                ? 'akademik_bidang_prestasi'
                : name == 'Program Pembinaan'
                ? 'akademik_pembinaan_prestasi'
                : '';
            final id = _int(list[i]['id']);
            if (table.isNotEmpty && id > 0) await widget.api.delete(table, id);
            if (mounted) setState(() => list.removeAt(i));
          },
        ),
        const SizedBox(height: 9),
      ],
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editSimple(name, list, fields),
          icon: const Icon(Icons.add_rounded),
          label: Text('Tambah $name'),
        ),
      ),
    ],
  );

  Widget _dataRow({
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    IconData deleteIcon = Icons.delete_outline_rounded,
    String deleteTooltip = 'Hapus',
  }) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFBFCFE),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _line),
    ),
    child: Row(
      children: [
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
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          tooltip: 'Edit',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, color: _blue),
        ),
        IconButton(
          tooltip: deleteTooltip,
          onPressed: onDelete,
          icon: Icon(deleteIcon, color: Colors.redAccent),
        ),
      ],
    ),
  );

  Future<void> _editAchievement(Map<String, dynamic>? source) async {
    final isNew = source == null;
    final row = source == null
        ? <String, dynamic>{
            'judul': '',
            'peserta': '',
            'tingkat': 'KABUPATEN',
            'event': '',
            'tanggal': '',
            'tahun': DateTime.now().year.toString(),
            'unggulan': false,
            'urutan_unggulan': 0,
            'gambar': '',
          }
        : Map<String, dynamic>.from(source);

    final title = TextEditingController(text: _s(row['judul']));
    final person = TextEditingController(text: _s(row['peserta']));
    final event = TextEditingController(text: _s(row['event']));
    final date = TextEditingController(text: _s(row['tanggal']));
    final year = TextEditingController(text: _s(row['tahun']));
    final image = TextEditingController(text: _s(row['gambar']));
    String level = _s(row['tingkat']).isEmpty
        ? 'KABUPATEN'
        : _s(row['tingkat']);
    bool featured = row['unggulan'] == true;
    int featuredOrder = row['urutan_unggulan'] as int? ?? 0;

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isNew ? 'Tambah Prestasi' : 'Edit Prestasi'),
          content: SizedBox(
            width: 610,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _dialogField(title, 'Judul Prestasi'),
                  const SizedBox(height: 12),
                  _dialogField(person, 'Nama Siswa / Tim'),
                  const SizedBox(height: 12),
                  _dialogField(event, 'Nama Kompetisi / Event'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value:
                              [
                                'NASIONAL',
                                'PROVINSI',
                                'KABUPATEN',
                              ].contains(level)
                              ? level
                              : 'KABUPATEN',
                          decoration: const InputDecoration(
                            labelText: 'Tingkat',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'NASIONAL',
                              child: Text('Nasional'),
                            ),
                            DropdownMenuItem(
                              value: 'PROVINSI',
                              child: Text('Provinsi'),
                            ),
                            DropdownMenuItem(
                              value: 'KABUPATEN',
                              child: Text('Kabupaten'),
                            ),
                          ],
                          onChanged: (v) =>
                              setDialogState(() => level = v ?? level),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _dialogField(year, 'Tahun')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _dialogField(date, 'Tanggal / Teks Tanggal'),
                  const SizedBox(height: 12),
                  _dialogImageEditor(
                    controller: image,
                    label: 'Foto Prestasi',
                    uploadTable: 'akademik_prestasi',
                    setDialogState: setDialogState,
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tampilkan sebagai Prestasi Unggulan'),
                    subtitle: const Text(
                      'Maksimal tiga item digunakan frontend.',
                    ),
                    value: featured,
                    onChanged: (v) => setDialogState(() => featured = v),
                  ),
                  if (featured)
                    DropdownButtonFormField<int>(
                      value: featuredOrder >= 1 && featuredOrder <= 3
                          ? featuredOrder
                          : 1,
                      decoration: const InputDecoration(
                        labelText: 'Posisi Unggulan',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 - Utama')),
                        DropdownMenuItem(value: 2, child: Text('2')),
                        DropdownMenuItem(value: 3, child: Text('3')),
                      ],
                      onChanged: (v) =>
                          setDialogState(() => featuredOrder = v ?? 1),
                    ),
                ],
              ),
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
      ),
    );

    if (ok == true) {
      row
        ..['judul'] = title.text.trim()
        ..['peserta'] = person.text.trim()
        ..['event'] = event.text.trim()
        ..['tingkat'] = level
        ..['tanggal'] = date.text.trim()
        ..['tahun'] = year.text.trim()
        ..['gambar'] = image.text.trim()
        ..['unggulan'] = featured
        ..['urutan_unggulan'] = featured
            ? (featuredOrder == 0 ? 1 : featuredOrder)
            : 0;

      final displaced = <Map<String, dynamic>>[];
      if (featured) {
        for (final item in _achievements) {
          if (!identical(item, source) &&
              item['unggulan'] == true &&
              item['urutan_unggulan'] == row['urutan_unggulan']) {
            item['unggulan'] = false;
            item['urutan_unggulan'] = 0;
            displaced.add(item);
          }
        }
      }

      try {
        for (final item in displaced) {
          await _saveAchievementRow(item);
        }
        await _saveAchievementRow(row);
        final fresh = await widget.api.getTable(
          'akademik_prestasi',
          limit: 100,
        );
        if (mounted) {
          setState(() {
            _achievements = fresh.map((e) {
              final item = Map<String, dynamic>.from(e);
              item['unggulan'] = _bool(item['unggulan']);
              item['urutan_unggulan'] = _int(item['urutan_unggulan']);
              return item;
            }).toList();
            _rebuildJourney();
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan prestasi: $e')),
          );
        }
      }
    }

    title.dispose();
    person.dispose();
    event.dispose();
    date.dispose();
    year.dispose();
    image.dispose();
  }

  Future<void> _editSimple(
    String name,
    List<Map<String, dynamic>> list,
    List<String> fields, {
    Map<String, dynamic>? row,
  }) async {
    final item = row == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(row);
    final controllers = {
      for (final field in fields)
        field: TextEditingController(text: _s(item[field])),
    };

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(row == null ? 'Tambah $name' : 'Edit $name'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < fields.length; i++) ...[
                  _dialogField(
                    controllers[fields[i]]!,
                    _simpleLabel(fields[i]),
                    maxLines: fields[i] == 'deskripsi' ? 4 : 1,
                  ),
                  if (i != fields.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
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

    if (ok == true) {
      for (final field in fields) {
        item[field] = controllers[field]!.text.trim();
      }

      final table = name == 'Bidang Prestasi'
          ? 'akademik_bidang_prestasi'
          : name == 'Program Pembinaan'
          ? 'akademik_pembinaan_prestasi'
          : '';

      try {
        if (table.isNotEmpty) {
          await _saveSimpleDb(table, item, fields);
          final fresh = await widget.api.getTable(table, limit: 50);
          if (mounted) {
            setState(() {
              list
                ..clear()
                ..addAll(fresh.map((e) => Map<String, dynamic>.from(e)));
            });
          }
        } else {
          setState(() {
            if (row == null) {
              list.add(item);
            } else {
              final index = list.indexOf(row);
              if (index >= 0) list[index] = item;
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menyimpan $name: $e')));
        }
      }
    }

    for (final controller in controllers.values) {
      controller.dispose();
    }
  }

  Widget _dialogField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) => AdminContentTextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );

  String _simpleLabel(String key) {
    const labels = {
      'judul': 'Judul',
      'deskripsi': 'Deskripsi',
      'tahun': 'Tahun',
      'jumlah': 'Jumlah Prestasi',
    };
    return labels[key] ?? key;
  }

  Widget _journeyCards() => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      for (final item in _journey)
        Container(
          width: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFCFE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _s(item['tahun']),
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${_s(item['jumlah'])} prestasi',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
        ),
    ],
  );

  Widget _bottomInfo() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _line),
    ),
    child: const Row(
      children: [
        Icon(Icons.info_outline_rounded, color: _blue),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Dashboard mengikuti struktur frontend Prestasi Akademik. Konten utama, prestasi, bidang prestasi, dan program pembinaan tersambung ke database.',
            style: TextStyle(color: _muted, fontSize: 13),
          ),
        ),
      ],
    ),
  );

  Widget _gap() => const SizedBox(height: 18);
}
