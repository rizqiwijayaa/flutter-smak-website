part of '../admin_dashboard_page.dart';

class AdminOsisPage extends StatefulWidget {
  const AdminOsisPage({super.key, required this.api, required this.module});
  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminOsisPage> createState() => _AdminOsisPageState();
}

class _AdminOsisPageState extends State<AdminOsisPage> {
  final _heroTitle = TextEditingController(
    text: 'Organisasi Siswa\nIntra Sekolah',
  );
  final _heroSubtitle = TextEditingController(
    text:
        'Wadah siswa untuk belajar memimpin, melayani, dan bertumbuh bersama.',
  );
  final _heroImage = TextEditingController(text: 'assets/images/1030.JPG');

  final _introTitle = TextEditingController(text: 'Mengenal OSIS SMAK');
  final _intro1 = TextEditingController(
    text:
        'OSIS SMAK Mgr. Soegijapranata adalah organisasi siswa yang hangat dan kompak. Kami berkomitmen menjadi sahabat bagi seluruh siswa dan berkontribusi positif bagi sekolah dan lingkungan sekitar.',
  );
  final _intro2 = TextEditingController(
    text:
        'Melalui kebersamaan, kami belajar memimpin, berkarya, dan melayani dengan hati.',
  );

  final _identityName = TextEditingController(text: 'OSIS SMAK');
  final _identitySchool = TextEditingController(text: 'Mgr. Soegijapranata');
  final _period = TextEditingController(text: 'Masa Bakti 2026/2027');
  final _motto = TextEditingController(
    text: 'Berkarya • Melayani • Menginspirasi',
  );
  final _logo = TextEditingController(text: 'assets/images/logo_sekolah.png');

  final _statMembers = TextEditingController(text: '8');
  final _statDivisions = TextEditingController(text: '4');
  final _statPrograms = TextEditingController(text: '6');
  final _statPeriod = TextEditingController(text: '1');

  final _vision = TextEditingController(
    text:
        'Menjadi OSIS yang berkarakter, peduli, dan berkontribusi positif demi terwujudnya lingkungan sekolah yang nyaman dan bermakna.',
  );

  final _programImage = TextEditingController();
  final _quote = TextEditingController(
    text:
        '“OSIS mengajarkan saya arti tanggung jawab, kerja sama, dan pelayanan. Di sini saya belajar memimpin dengan hati dan menghadirkan perubahan kecil yang berdampak besar.”',
  );
  final _quoteAuthor = TextEditingController(text: '– Siswa SMAK');
  final _quotePhoto = TextEditingController();

  final _joinTitle = TextEditingController(
    text: 'Ingin Menjadi Bagian dari OSIS?',
  );
  final _joinContact = TextEditingController(
    text: 'https://wa.me/628155099445',
  );
  final _joinButton = TextEditingController(text: 'Hubungi Pembina OSIS');

  final List<Map<String, String>> _pillars = [
    {
      'title': 'Kepemimpinan',
      'desc':
          'Mengembangkan jiwa kepemimpinan serta tanggung jawab dalam diri setiap siswa.',
    },
    {
      'title': 'Kepedulian',
      'desc':
          'Menumbuhkan kepedulian sosial dan semangat melayani kepada sesama.',
    },
    {
      'title': 'Kerja Sama',
      'desc': 'Membangun kerja sama yang baik dalam setiap kegiatan OSIS.',
    },
  ];

  final List<Map<String, String>> _members = [
    {
      'role': 'Ketua OSIS',
      'name': 'Nama Ketua',
      'grade': 'Kelas XI',
      'photo': '',
    },
    {
      'role': 'Wakil Ketua',
      'name': 'Nama Wakil',
      'grade': 'Kelas XI',
      'photo': '',
    },
    {
      'role': 'Sekretaris',
      'name': 'Nama Sekretaris',
      'grade': 'Kelas X',
      'photo': '',
    },
    {
      'role': 'Bendahara',
      'name': 'Nama Bendahara',
      'grade': 'Kelas X',
      'photo': '',
    },
    {
      'role': 'Koordinator Kegiatan',
      'name': 'Nama Koordinator',
      'grade': 'Kelas XI',
      'photo': '',
    },
  ];

  final List<Map<String, String>> _divisions = [
    {
      'title': 'Kerohanian & Karakter',
      'desc': 'Menguatkan nilai iman, karakter, dan kedisiplinan siswa.',
    },
    {
      'title': 'Akademik & Kreativitas',
      'desc': 'Mendukung kegiatan belajar dan mengembangkan kreativitas siswa.',
    },
    {
      'title': 'Olahraga & Kebersamaan',
      'desc': 'Mendorong gaya hidup sehat dan mempererat kebersamaan siswa.',
    },
    {
      'title': 'Sosial & Lingkungan',
      'desc': 'Menumbuhkan kepedulian sosial dan menjaga lingkungan sekolah.',
    },
  ];

  final List<Map<String, String>> _programs = [
    {
      'title': 'Masa Pengenalan Siswa',
      'desc':
          'Menyambut siswa baru agar cepat beradaptasi dengan lingkungan sekolah.',
    },
    {
      'title': 'Perayaan Hari Besar Sekolah',
      'desc':
          'Memperingati hari besar untuk menumbuhkan nilai kebersamaan dan iman.',
    },
    {
      'title': 'Class Meeting',
      'desc':
          'Kegiatan olahraga dan lomba untuk menyalurkan bakat dan sportivitas.',
    },
    {
      'title': 'Bakti Sosial',
      'desc': 'Berbagi dan melayani sebagai wujud kepedulian terhadap sesama.',
    },
  ];

  final List<Map<String, String>> _agenda = [
    {'month': 'Agustus', 'activity': 'Pelantikan Pengurus'},
    {'month': 'Desember', 'activity': 'Class Meeting'},
    {'month': 'Februari', 'activity': 'Bakti Sosial'},
    {'month': 'Juni', 'activity': 'Evaluasi & Regenerasi'},
  ];

  final List<Map<String, String>> _documentation = [
    {'title': 'Dokumentasi 1', 'image': ''},
    {'title': 'Dokumentasi 2', 'image': ''},
    {'title': 'Dokumentasi 3', 'image': ''},
  ];

  final List<Map<String, String>> _joinSteps = [
    {
      'title': 'Sampaikan Minat',
      'desc': 'Tunjukkan minatmu untuk bergabung dan berkontribusi di OSIS.',
    },
    {
      'title': 'Berdiskusi dengan Pembina',
      'desc':
          'Berdiskusilah dengan pembina untuk mengetahui informasi lebih lanjut.',
    },
  ];

  final Map<String, List<int>> _tableIds = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Map<String, dynamic> _rowData(Map<String, dynamic> row) {
    final raw = '${row['data_json'] ?? ''}'.trim();
    Map<String, dynamic> data = {};
    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) data = Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    for (final key in ['judul', 'deskripsi', 'gambar', 'urutan', 'status']) {
      if (row[key] != null) data[key] = row[key];
    }
    data['_id'] = '${row['id'] ?? ''}';
    return data;
  }

  void _setText(TextEditingController controller, dynamic value) {
    if (value != null) controller.text = '$value';
  }

  List<Map<String, String>> _items(
    List<Map<String, dynamic>> rows,
    Map<String, String> Function(Map<String, dynamic> row) mapper,
  ) => rows.map(mapper).toList();

  Future<void> _loadDatabase() async {
    const tables = [
      'osis_hero',
      'osis_pengenalan',
      'osis_statistik',
      'osis_visi_misi',
      'osis_pengurus',
      'osis_bidang',
      'osis_program',
      'osis_agenda',
      'osis_galeri',
      'osis_kutipan',
      'osis_cta',
    ];
    try {
      final results = await Future.wait(
        tables.map((table) => widget.api.getTable(table, limit: 100)),
      );
      if (!mounted) return;
      final data = <String, List<Map<String, dynamic>>>{
        for (var index = 0; index < tables.length; index++)
          tables[index]: results[index].map(_rowData).toList(),
      };
      setState(() {
        for (final table in tables) {
          _tableIds[table] = data[table]!
              .map((row) => int.tryParse('${row['_id']}'))
              .whereType<int>()
              .toList();
        }
        final hero = data['osis_hero']!;
        if (hero.isNotEmpty) {
          _setText(_heroTitle, hero.first['judul']);
          _setText(_heroSubtitle, hero.first['deskripsi']);
          _setText(_heroImage, hero.first['gambar']);
        }
        final intro = data['osis_pengenalan']!;
        if (intro.isNotEmpty) {
          final row = intro.first;
          _setText(_introTitle, row['judul']);
          _setText(_intro1, row['deskripsi']);
          _setText(_intro2, row['lanjutan']);
          _setText(_identityName, row['nama']);
          _setText(_identitySchool, row['sekolah']);
          _setText(_period, row['masa_bakti']);
          _setText(_motto, row['motto']);
          _setText(_logo, row['logo']);
        }
        final stats = data['osis_statistik']!;
        final statControllers = [_statMembers, _statDivisions, _statPrograms, _statPeriod];
        for (var index = 0; index < stats.length && index < statControllers.length; index++) {
          _setText(statControllers[index], stats[index]['nilai']);
        }
        final visionMission = data['osis_visi_misi']!;
        if (visionMission.isNotEmpty) {
          _setText(_vision, visionMission.first['deskripsi']);
          _pillars
            ..clear()
            ..addAll(_items(visionMission.skip(1).toList(), (row) => {
              'title': '${row['judul'] ?? ''}',
              'desc': '${row['deskripsi'] ?? ''}',
              '_id': '${row['_id'] ?? ''}',
            }));
        }
        void replaceList(String table, List<Map<String, String>> target, Map<String, String> Function(Map<String, dynamic>) mapper) {
          final rows = data[table]!;
          if (rows.isNotEmpty) target..clear()..addAll(_items(rows, mapper));
        }
        replaceList('osis_pengurus', _members, (row) => {
          'role': '${row['judul'] ?? ''}', 'name': '${row['nama'] ?? ''}',
          'grade': '${row['kelas'] ?? ''}', 'photo': '${row['gambar'] ?? ''}',
          '_id': '${row['_id'] ?? ''}',
        });
        replaceList('osis_bidang', _divisions, (row) => {
          'title': '${row['judul'] ?? ''}', 'desc': '${row['deskripsi'] ?? ''}',
          '_id': '${row['_id'] ?? ''}',
        });
        replaceList('osis_program', _programs, (row) => {
          'title': '${row['judul'] ?? ''}', 'desc': '${row['deskripsi'] ?? ''}',
          'image': '${row['gambar'] ?? ''}', '_id': '${row['_id'] ?? ''}',
        });
        if (_programs.isNotEmpty) _setText(_programImage, _programs.first['image']);
        replaceList('osis_agenda', _agenda, (row) => {
          'month': '${row['judul'] ?? ''}', 'activity': '${row['kegiatan'] ?? ''}',
          '_id': '${row['_id'] ?? ''}',
        });
        replaceList('osis_galeri', _documentation, (row) => {
          'title': '${row['judul'] ?? ''}', 'image': '${row['gambar'] ?? ''}',
          '_id': '${row['_id'] ?? ''}',
        });
        final quote = data['osis_kutipan']!;
        if (quote.isNotEmpty) {
          _setText(_quote, quote.first['deskripsi']);
          _setText(_quoteAuthor, quote.first['penulis']);
          _setText(_quotePhoto, quote.first['gambar']);
        }
        final cta = data['osis_cta']!;
        if (cta.isNotEmpty) {
          final row = cta.first;
          _setText(_joinTitle, row['judul']);
          _setText(_joinContact, row['kontak']);
          _setText(_joinButton, row['teks_tombol']);
          final steps = row['langkah'];
          if (steps is List && steps.isNotEmpty) {
            _joinSteps
              ..clear()
              ..addAll(steps.whereType<Map>().map((step) => {
                'title': '${step['judul'] ?? ''}',
                'desc': '${step['deskripsi'] ?? ''}',
              }));
          }
        }
      });
    } catch (_) {
      // Keep the existing editor defaults when the API is not available.
    }
  }

  Future<void> _saveRows(String table, Iterable<Map> sourceRows) async {
    final rows = sourceRows
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
    final existingIds = _tableIds[table] ?? const <int>[];
    final previousIds = {...existingIds};
    final retainedIds = <int>{};
    final explicitIds = rows
        .map((row) => int.tryParse('${row['_id'] ?? ''}'))
        .whereType<int>()
        .toSet();
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      final positionalId = index < existingIds.length ? existingIds[index] : null;
      final id = int.tryParse('${row['_id'] ?? ''}') ??
          (positionalId != null &&
                  !explicitIds.contains(positionalId) &&
                  !retainedIds.contains(positionalId)
              ? positionalId
              : null);
      if (id != null) retainedIds.add(id);
      await widget.api.save(table, {
        'judul': '${row['judul'] ?? ''}',
        'deskripsi': '${row['deskripsi'] ?? ''}',
        'gambar': '${row['gambar'] ?? ''}',
        'data_json': jsonEncode(row..remove('_id')),
        'urutan': index,
        'status': 'aktif',
      }, id: id);
    }
    for (final id in previousIds.difference(retainedIds)) {
      await widget.api.delete(table, id);
    }
  }

  Future<void> _saveDatabase() async {
    setState(() => _saving = true);
    try {
      await _saveRows('osis_hero', [{
        'judul': _heroTitle.text.trim(), 'deskripsi': _heroSubtitle.text.trim(),
        'gambar': _heroImage.text.trim(),
      }]);
      await _saveRows('osis_pengenalan', [{
        'judul': _introTitle.text.trim(), 'deskripsi': _intro1.text.trim(),
        'lanjutan': _intro2.text.trim(), 'nama': _identityName.text.trim(),
        'sekolah': _identitySchool.text.trim(), 'masa_bakti': _period.text.trim(),
        'motto': _motto.text.trim(), 'logo': _logo.text.trim(),
      }]);
      await _saveRows('osis_statistik', [
        {'judul': 'Pengurus', 'nilai': _statMembers.text.trim()},
        {'judul': 'Bidang', 'nilai': _statDivisions.text.trim()},
        {'judul': 'Program Kerja', 'nilai': _statPrograms.text.trim()},
        {'judul': 'Tahun Masa Bakti', 'nilai': _statPeriod.text.trim()},
      ]);
      await _saveRows('osis_visi_misi', [
        {'judul': 'Visi OSIS', 'deskripsi': _vision.text.trim()},
        ..._pillars.map((item) => {
          'judul': item['title'] ?? '', 'deskripsi': item['desc'] ?? '',
          '_id': item['_id'] ?? '',
        }),
      ]);
      await _saveRows('osis_pengurus', _members.map((item) => {
        'judul': item['role'] ?? '', 'nama': item['name'] ?? '',
        'kelas': item['grade'] ?? '', 'gambar': item['photo'] ?? '',
        '_id': item['_id'] ?? '',
      }).toList());
      await _saveRows('osis_bidang', _divisions.map((item) => {
        'judul': item['title'] ?? '', 'deskripsi': item['desc'] ?? '',
        '_id': item['_id'] ?? '',
      }).toList());
      await _saveRows('osis_program', [
        for (var index = 0; index < _programs.length; index++) {
          'judul': _programs[index]['title'] ?? '',
          'deskripsi': _programs[index]['desc'] ?? '',
          'gambar': index == 0 ? _programImage.text.trim() : (_programs[index]['image'] ?? ''),
          '_id': _programs[index]['_id'] ?? '',
        },
      ]);
      await _saveRows('osis_agenda', _agenda.map((item) => {
        'judul': item['month'] ?? '', 'kegiatan': item['activity'] ?? '',
        '_id': item['_id'] ?? '',
      }).toList());
      await _saveRows('osis_galeri', _documentation.map((item) => {
        'judul': item['title'] ?? '', 'gambar': item['image'] ?? '',
        '_id': item['_id'] ?? '',
      }).toList());
      await _saveRows('osis_kutipan', [{
        'judul': 'Kutipan Siswa', 'deskripsi': _quote.text.trim(),
        'penulis': _quoteAuthor.text.trim(), 'gambar': _quotePhoto.text.trim(),
      }]);
      await _saveRows('osis_cta', [{
        'judul': _joinTitle.text.trim(), 'kontak': _joinContact.text.trim(), 'teks_tombol': _joinButton.text.trim(),
        'langkah': _joinSteps.map((item) => {
          'judul': item['title'] ?? '', 'deskripsi': item['desc'] ?? '',
        }).toList(),
      }]);
      await _loadDatabase();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan OSIS berhasil disimpan.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan OSIS gagal disimpan.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickImage(TextEditingController controller) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    try {
      final filename = await widget.api.uploadFile('osis_galeri', input.files!.first);
      if (mounted) setState(() => controller.text = filename);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload gambar gagal.')),
        );
      }
    }
  }

  Widget _imagePreview(String value, {IconData icon = Icons.image_outlined}) {
    if (value.trim().isEmpty) {
      return ColoredBox(
        color: const Color(0xFFF0F3F7),
        child: Center(
          child: Icon(icon, size: 48, color: const Color(0xFF9AA9BC)),
        ),
      );
    }
    return websiteContentImage(value, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 54),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),
            _section(1, 'Banner / Hero OSIS', _heroEditor()),
            _section(2, 'Pengenalan & Identitas OSIS', _introIdentity()),
            _section(3, 'Statistik OSIS', _statsEditor()),
            _section(4, 'Visi dan Misi OSIS', _visionMissionEditor()),
            _section(5, 'Pengurus Inti OSIS', _membersEditor()),
            _section(
              6,
              'Bidang OSIS',
              _simpleCards(_divisions, 'Tambah Bidang'),
            ),
            _section(7, 'Program Unggulan', _programEditor()),
            _section(8, 'Agenda OSIS', _agendaEditor()),
            _section(9, 'Dokumentasi Kegiatan', _documentationEditor()),
            _section(10, 'Quote Siswa', _quoteEditor()),
            _section(11, 'Bergabung dengan OSIS', _joinEditor()),
          ],
      ),
    );
  }

  Widget _header() => Row(
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OSIS',
              style: TextStyle(
                color: _text,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Kelola organisasi, pengurus, program, agenda, dan dokumentasi OSIS.',
              style: TextStyle(color: _muted),
            ),
          ],
        ),
      ),
      OutlinedButton.icon(
        onPressed: () => _openAdminPreview(context, sharedStudentPages()['osis']!),
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('Preview Halaman'),
      ),
      const SizedBox(width: 10),
      FilledButton.icon(
        onPressed: _saving ? null : _saveDatabase,
        icon: const Icon(Icons.save_rounded),
        label: const Text('Simpan Perubahan'),
      ),
    ],
  );

  Widget _section(int number, String title, Widget child) => Padding(
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
                  '$number',
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

  Widget _heroEditor() => LayoutBuilder(
    builder: (context, c) {
      final preview = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 235,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _line),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _imagePreview(_heroImage.text),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xF5073979),
                        Color(0xA8073979),
                        Color(0x33073979),
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
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _heroSubtitle.text,
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.4,
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
          _field(
            'Judul Hero',
            _heroTitle,
            lines: 2,
            changed: (_) => setState(() {}),
          ),
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

  Widget _introIdentity() => LayoutBuilder(
    builder: (context, c) {
      final intro = Column(
        children: [
          _field('Judul Pengenalan', _introTitle),
          const SizedBox(height: 12),
          _field('Paragraf 1', _intro1, lines: 4),
          const SizedBox(height: 12),
          _field('Paragraf 2', _intro2, lines: 3),
        ],
      );
      final identity = Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FBFE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _line),
        ),
        child: Column(
          children: [
            Container(
              height: 115,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _imagePreview(_logo.text, icon: Icons.school_rounded),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _pickImage(_logo),
              icon: const Icon(Icons.upload_rounded),
              label: const Text('Ganti Logo'),
            ),
            const SizedBox(height: 14),
            _field('Nama Organisasi', _identityName),
            const SizedBox(height: 10),
            _field('Nama Sekolah', _identitySchool),
            const SizedBox(height: 10),
            _field('Masa Bakti', _period),
            const SizedBox(height: 10),
            _field('Motto', _motto),
          ],
        ),
      );
      return c.maxWidth < 850
          ? Column(children: [intro, const SizedBox(height: 18), identity])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: intro),
                const SizedBox(width: 20),
                Expanded(child: identity),
              ],
            );
    },
  );

  Widget _statsEditor() => LayoutBuilder(
    builder: (context, c) {
      final width = c.maxWidth < 650 ? c.maxWidth : (c.maxWidth - 36) / 4;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: width,
            child: _field('Jumlah Pengurus', _statMembers),
          ),
          SizedBox(
            width: width,
            child: _field('Jumlah Bidang', _statDivisions),
          ),
          SizedBox(width: width, child: _field('Program Kerja', _statPrograms)),
          SizedBox(
            width: width,
            child: _field('Tahun Masa Bakti', _statPeriod),
          ),
        ],
      );
    },
  );

  Widget _visionMissionEditor() => Column(
    children: [
      _field('Visi OSIS', _vision, lines: 4),
      const SizedBox(height: 16),
      ..._pillars.asMap().entries.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _contentCard(
            Icons.auto_awesome_rounded,
            e.value['title']!,
            e.value['desc']!,
            [
              IconButton(
                onPressed: () => _editPair(_pillars, e.key, 'Pilar Misi'),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => setState(() => _pillars.removeAt(e.key)),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editPair(_pillars, null, 'Pilar Misi'),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Pilar'),
        ),
      ),
    ],
  );

  Widget _membersEditor() => LayoutBuilder(
    builder: (context, c) {
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
              ..._members.asMap().entries.map((e) {
                final m = e.value;
                return SizedBox(
                  width: width,
                  child: Container(
                    padding: const EdgeInsets.all(14),
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
                          child: _imagePreview(
                            m['photo'] ?? '',
                            icon: Icons.person_rounded,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          m['role']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _blue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          m['grade']!,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () => _editMember(e.key),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => _members.removeAt(e.key)),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _editMember(null),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Tambah Pengurus'),
            ),
          ),
        ],
      );
    },
  );

  Widget _simpleCards(List<Map<String, String>> data, String addLabel) =>
      Column(
        children: [
          ...data.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _contentCard(
                Icons.dashboard_customize_outlined,
                e.value['title']!,
                e.value['desc']!,
                [
                  IconButton(
                    onPressed: () => _editPair(data, e.key, addLabel),
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
              onPressed: () => _editPair(data, null, addLabel),
              icon: const Icon(Icons.add_rounded),
              label: Text(addLabel),
            ),
          ),
        ],
      );

  Widget _programEditor() => Column(
    children: [
      LayoutBuilder(
        builder: (context, c) {
          final preview = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _line),
                ),
                child: _imagePreview(
                  _programImage.text,
                  icon: Icons.photo_library_rounded,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pickImage(_programImage),
                    icon: const Icon(Icons.upload_rounded),
                    label: const Text('Ganti Foto'),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(_programImage.clear),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Hapus'),
                  ),
                ],
              ),
            ],
          );
          final list = _simpleCards(_programs, 'Tambah Program');
          return c.maxWidth < 850
              ? Column(children: [preview, const SizedBox(height: 18), list])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: preview),
                    const SizedBox(width: 22),
                    Expanded(child: list),
                  ],
                );
        },
      ),
    ],
  );

  Widget _agendaEditor() => Column(
    children: [
      ..._agenda.asMap().entries.map(
        (e) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _contentCard(
                Icons.calendar_month_rounded,
                e.value['month']!,
                e.value['activity']!,
                [
                  IconButton(
                    onPressed: () => _editAgenda(e.key),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _agenda.removeAt(e.key)),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editAgenda(null),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Agenda'),
        ),
      ),
    ],
  );

  Widget _documentationEditor() => LayoutBuilder(
    builder: (context, c) {
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
                          height: 160,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F3F7),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: _imagePreview(
                            e.value['image'] ?? '',
                            icon: Icons.image_rounded,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => _editDocumentation(e.key),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
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

  Widget _quoteEditor() => LayoutBuilder(
    builder: (context, c) {
      final preview = Container(
        height: 180,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _line),
        ),
        child: _imagePreview(_quotePhoto.text, icon: Icons.person_rounded),
      );
      final fields = Column(
        children: [
          _field('Quote Siswa', _quote, lines: 5),
          const SizedBox(height: 12),
          _field('Nama / Keterangan', _quoteAuthor),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickImage(_quotePhoto),
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Ganti Foto'),
              ),
              TextButton.icon(
                onPressed: () => setState(_quotePhoto.clear),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ],
      );
      return c.maxWidth < 760
          ? Column(children: [preview, const SizedBox(height: 16), fields])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 230, child: preview),
                const SizedBox(width: 20),
                Expanded(child: fields),
              ],
            );
    },
  );

  Widget _joinEditor() => Column(
    children: [
      _field('Judul Bagian', _joinTitle),
      const SizedBox(height: 14),
      ..._joinSteps.asMap().entries.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _contentCard(
            Icons.looks_one_rounded,
            '${e.key + 1}. ${e.value['title']!}',
            e.value['desc']!,
            [
              IconButton(
                onPressed: () =>
                    _editPair(_joinSteps, e.key, 'Langkah Bergabung'),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => setState(() => _joinSteps.removeAt(e.key)),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editPair(_joinSteps, null, 'Langkah Bergabung'),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Langkah'),
        ),
      ),
      const SizedBox(height: 16),
      _field('Link Kontak Pembina / WhatsApp', _joinContact),
      const SizedBox(height: 14),
      _field('Teks Tombol', _joinButton),
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
    String title,
  ) async {
    final current = index == null ? null : list[index];
    final a = TextEditingController(text: current?['title'] ?? '');
    final b = TextEditingController(text: current?['desc'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(index == null ? title : 'Edit $title'),
        content: SizedBox(
          width: 540,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminContentTextField(
                controller: a,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              const SizedBox(height: 12),
              AdminContentTextField(
                controller: b,
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
    if (ok == true && a.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {...?current, 'title': a.text.trim(), 'desc': b.text.trim()};
        if (index == null)
          list.add(value);
        else
          list[index] = value;
      });
    }
    a.dispose();
    b.dispose();
  }

  Future<void> _editMember(int? index) async {
    final m = index == null ? null : _members[index];
    final role = TextEditingController(text: m?['role'] ?? '');
    final name = TextEditingController(text: m?['name'] ?? '');
    final grade = TextEditingController(text: m?['grade'] ?? '');
    final photo = TextEditingController(text: m?['photo'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(index == null ? 'Tambah Pengurus' : 'Edit Pengurus'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imagePreview(photo.text, icon: Icons.person_rounded),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    await _pickImage(photo);
                  },
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text('Pilih Foto'),
                ),
                const SizedBox(height: 12),
                AdminContentTextField(
                  controller: role,
                  decoration: const InputDecoration(labelText: 'Jabatan'),
                ),
                const SizedBox(height: 10),
                AdminContentTextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                const SizedBox(height: 10),
                AdminContentTextField(
                  controller: grade,
                  decoration: const InputDecoration(labelText: 'Kelas'),
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
    );
    if (ok == true && role.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {
          ...?m,
          'role': role.text.trim(),
          'name': name.text.trim(),
          'grade': grade.text.trim(),
          'photo': photo.text,
        };
        if (index == null)
          _members.add(value);
        else
          _members[index] = value;
      });
    }
    role.dispose();
    name.dispose();
    grade.dispose();
    photo.dispose();
  }

  Future<void> _editAgenda(int? index) async {
    final a = index == null ? null : _agenda[index];
    final month = TextEditingController(text: a?['month'] ?? '');
    final activity = TextEditingController(text: a?['activity'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(index == null ? 'Tambah Agenda' : 'Edit Agenda'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminContentTextField(
                controller: month,
                decoration: const InputDecoration(labelText: 'Bulan'),
              ),
              const SizedBox(height: 10),
              AdminContentTextField(
                controller: activity,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Kegiatan'),
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
    if (ok == true && month.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {
          if (index != null) ..._agenda[index],
          'month': month.text.trim(),
          'activity': activity.text.trim(),
        };
        if (index == null)
          _agenda.add(value);
        else
          _agenda[index] = value;
      });
    }
    month.dispose();
    activity.dispose();
  }

  Future<void> _editDocumentation(int? index) async {
    final item = index == null ? null : _documentation[index];
    final title = TextEditingController(text: item?['title'] ?? '');
    final image = TextEditingController(text: item?['image'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (context, modalSetState) => AlertDialog(
          title: Text(
            index == null ? 'Tambah Dokumentasi' : 'Edit Dokumentasi',
          ),
          content: SizedBox(
            width: 560,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 190,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imagePreview(image.text),
                ),
                const SizedBox(height: 10),
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
          ...?item,
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
