part of '../admin_dashboard_page.dart';

class AdminEkstrakurikulerPage extends StatefulWidget {
  const AdminEkstrakurikulerPage({
    super.key,
    required this.api,
    required this.module,
  });
  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminEkstrakurikulerPage> createState() =>
      _AdminEkstrakurikulerPageState();
}

class _AdminEkstrakurikulerPageState extends State<AdminEkstrakurikulerPage> {
  int? _contentId;
  bool _loading = true;
  bool _saving = false;
  final _heroTitle = TextEditingController(text: 'Ekstrakurikuler');
  final _heroSubtitle = TextEditingController(
    text: 'Ruang untuk bertumbuh, berkarya, dan menemukan potensi terbaikmu.',
  );
  final _heroImage = TextEditingController();

  final _introTitle = TextEditingController(text: 'Temukan Minat dan Bakatmu');
  final _intro1 = TextEditingController(
    text:
        'Melalui kegiatan ekstrakurikuler, siswa dapat mengembangkan minat, belajar bekerja sama, berani tampil, dan bertumbuh menjadi pribadi yang berkarakter.',
  );
  final _intro2 = TextEditingController(
    text:
        'Pilih kegiatan yang sesuai dengan minatmu dan nikmati prosesnya bersama teman serta pembina yang mendukung.',
  );

  final List<Map<String, String>> _introPoints = [
    {
      'title': 'Pilihan Kegiatan',
      'desc': 'Beragam kegiatan yang sesuai dengan minat dan bakat siswa.',
    },
    {
      'title': 'Pembinaan Terarah',
      'desc': 'Didampingi pembina yang peduli dan berpengalaman.',
    },
    {
      'title': 'Pengembangan Karakter',
      'desc': 'Membentuk sikap positif, disiplin, dan bertanggung jawab.',
    },
  ];

  final List<Map<String, String>> _activities = [
    {
      'name': 'Basket',
      'category': 'Olahraga',
      'description':
          'Mengembangkan kerja sama, strategi, sportivitas, dan keterampilan bermain di lapangan.',
      'schedule': 'Selasa & Kamis, 15.30 WIB',
      'location': 'Lapangan sekolah',
      'mentor': 'Bapak Andi (data dummy)',
      'participants': 'Siswa kelas X–XII',
      'image': 'assets/images/ekstrakurikuler/basket.jpg',
    },
    {
      'name': 'Voli',
      'category': 'Olahraga',
      'description':
          'Melatih kekompakan, teknik dasar, ketangkasan, dan semangat tim.',
      'schedule': 'Senin & Rabu, 15.30 WIB',
      'location': 'Lapangan sekolah',
      'mentor': 'Ibu Maria (data dummy)',
      'participants': 'Siswa kelas X–XII',
      'image': 'assets/images/ekstrakurikuler/voli.jpg',
    },
    {
      'name': 'Band Sekolah',
      'category': 'Seni',
      'description':
          'Ruang untuk menyalurkan kreativitas musik dan belajar tampil percaya diri.',
      'schedule': 'Rabu, 15.30 WIB',
      'location': 'Ruang musik',
      'mentor': 'Bapak Rudi (data dummy)',
      'participants': 'Siswa kelas X–XII',
      'image': 'assets/images/ekstrakurikuler/band_sekolah.jpg',
    },
    {
      'name': 'Paduan Suara',
      'category': 'Seni',
      'description':
          'Melatih olah vokal, harmoni, kedisiplinan, dan kebersamaan.',
      'schedule': 'Kamis, 15.30 WIB',
      'location': 'Aula sekolah',
      'mentor': 'Ibu Agatha (data dummy)',
      'participants': 'Siswa kelas X–XII',
      'image': 'assets/images/ekstrakurikuler/paduan_suara.jpg',
    },
    {
      'name': 'Pramuka',
      'category': 'Kepramukaan',
      'description':
          'Membentuk pribadi mandiri, peduli, disiplin, dan siap bekerja sama.',
      'schedule': 'Sabtu, 07.30 WIB',
      'location': 'Halaman sekolah',
      'mentor': 'Kak Dimas (data dummy)',
      'participants': 'Siswa kelas X–XII',
      'image': 'assets/images/ekstrakurikuler/pramuka.jpg',
    },
  ];

  final _guidanceImage = TextEditingController();
  final List<Map<String, String>> _guidance = [
    {
      'title': 'Pendampingan Pembina',
      'desc': 'Setiap kegiatan didampingi pembina yang siap membimbing.',
    },
    {
      'title': 'Jadwal Teratur',
      'desc': 'Kegiatan dilaksanakan rutin agar siswa berkembang maksimal.',
    },
    {
      'title': 'Kebersamaan',
      'desc': 'Belajar dan berkarya bersama untuk membangun kekompakan.',
    },
    {
      'title': 'Kesempatan Berkarya',
      'desc': 'Siswa memperoleh ruang untuk tampil dan mengembangkan diri.',
    },
  ];

  final List<Map<String, String>> _gallery = [
    {'title': 'Basket', 'image': 'assets/images/ekstrakurikuler/basket.jpg'},
    {'title': 'Voli', 'image': 'assets/images/ekstrakurikuler/voli.jpg'},
    {
      'title': 'Band Sekolah',
      'image': 'assets/images/ekstrakurikuler/band_sekolah.jpg',
    },
    {
      'title': 'Paduan Suara',
      'image': 'assets/images/ekstrakurikuler/paduan_suara.jpg',
    },
  ];

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Apakah siswa wajib mengikuti ekstrakurikuler?',
      'answer':
          'Untuk sementara gunakan jawaban dummy: siswa dianjurkan mengikuti minimal satu kegiatan untuk membantu mengembangkan minat, bakat, dan karakter positif.',
    },
    {
      'question': 'Bagaimana cara memilih kegiatan?',
      'answer':
          'Siswa dapat menyesuaikan pilihan dengan minat, jadwal, serta arahan dari wali kelas dan pembina.',
    },
    {
      'question': 'Apakah boleh berganti ekstrakurikuler?',
      'answer':
          'Pergantian dapat dibicarakan terlebih dahulu bersama pembina dan pihak sekolah.',
    },
    {
      'question': 'Apakah ada biaya tambahan?',
      'answer':
          'Informasi biaya menyesuaikan kebijakan masing-masing kegiatan dan dapat ditanyakan langsung kepada sekolah.',
    },
  ];

  final _ctaTitle = TextEditingController(
    text: 'Ayo Temukan Kegiatan yang Kamu Sukai',
  );
  final _ctaSubtitle = TextEditingController(
    text:
        'Informasi ekstrakurikuler dapat ditanyakan langsung kepada pihak sekolah.',
  );
  final _ctaButton = TextEditingController(text: 'Tanya Sekolah');
  final _ctaLink = TextEditingController(text: 'https://wa.me/628155099445');

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  String _value(dynamic value) => '${value ?? ''}'.trim();
  int _id(Map<String, String> row) => int.tryParse(row['id'] ?? '') ?? 0;

  Future<void> _loadDatabase() async {
    try {
      final data = await Future.wait([
        widget.api.getTable('ekstrakulikuler_konten', limit: 1),
        widget.api.getTable('ekstrakulikuler_kegiatan', limit: 100),
      ]).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      if (data[0].isNotEmpty) {
        final row = data[0].first;
        _contentId = int.tryParse(_value(row['id']));
        final controllers = <String, TextEditingController>{
          'hero_judul': _heroTitle,
          'hero_subjudul': _heroSubtitle,
          'hero_gambar': _heroImage,
          'intro_judul': _introTitle,
          'intro_teks_1': _intro1,
          'intro_teks_2': _intro2,
          'gambar_pembinaan': _guidanceImage,
          'cta_judul': _ctaTitle,
          'cta_deskripsi': _ctaSubtitle,
          'cta_tombol': _ctaButton,
          'cta_link': _ctaLink,
        };
        for (final entry in controllers.entries) {
          if (_value(row[entry.key]).isNotEmpty)
            entry.value.text = _value(row[entry.key]);
        }
        final extra = jsonDecode(
          _value(row['frontend_json']).isEmpty
              ? '{}'
              : _value(row['frontend_json']),
        );
        if (extra is Map) {
          void restore(String key, List<Map<String, String>> target) {
            final values = extra[key];
            if (values is List && values.isNotEmpty) {
              target
                ..clear()
                ..addAll(
                  values.whereType<Map>().map(
                    (item) =>
                        item.map((key, value) => MapEntry('$key', '$value')),
                  ),
                );
            }
          }

          restore('introPoints', _introPoints);
          restore('guidance', _guidance);
          restore('gallery', _gallery);
          restore('faqs', _faqs);
        }
      }
      if (data[1].isNotEmpty) {
        _activities
          ..clear()
          ..addAll(
            data[1].map(
              (row) => {
                'id': _value(row['id']),
                'name': _value(row['nama']),
                'category': _value(row['kategori']),
                'description': _value(row['deskripsi']),
                'schedule': _value(row['jadwal']),
                'location': _value(row['lokasi']),
                'mentor': _value(row['pembina']),
                'participants': _value(row['peserta']),
                'image': _value(row['gambar']),
              },
            ),
          );
      }
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Database ekstrakulikuler belum dapat dimuat: $error',
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.api.save('ekstrakulikuler_konten', {
        'hero_judul': _heroTitle.text.trim(),
        'hero_subjudul': _heroSubtitle.text.trim(),
        'hero_gambar': _heroImage.text.trim(),
        'intro_judul': _introTitle.text.trim(),
        'intro_teks_1': _intro1.text.trim(),
        'intro_teks_2': _intro2.text.trim(),
        'gambar_pembinaan': _guidanceImage.text.trim(),
        'cta_judul': _ctaTitle.text.trim(),
        'cta_deskripsi': _ctaSubtitle.text.trim(),
        'cta_tombol': _ctaButton.text.trim(),
        'cta_link': _ctaLink.text.trim(),
        'frontend_json': jsonEncode({
          'introPoints': _introPoints,
          'guidance': _guidance,
          'gallery': _gallery,
          'faqs': _faqs,
        }),
        'status': 'aktif',
      }, id: _contentId);
      final existing = await widget.api.getTable(
        'ekstrakulikuler_kegiatan',
        limit: 100,
      );
      final retained = <int>{};
      for (var index = 0; index < _activities.length; index++) {
        final row = _activities[index];
        final id = _id(row);
        if (id > 0) retained.add(id);
        await widget.api.save('ekstrakulikuler_kegiatan', {
          'nama': row['name'] ?? '',
          'kategori': row['category'] ?? '',
          'deskripsi': row['description'] ?? '',
          'jadwal': row['schedule'] ?? '',
          'lokasi': row['location'] ?? '',
          'pembina': row['mentor'] ?? '',
          'peserta': row['participants'] ?? '',
          'gambar': row['image'] ?? '',
          'urutan': '$index',
          'status': 'aktif',
        }, id: id == 0 ? null : id);
      }
      for (final row in existing) {
        final id = int.tryParse(_value(row['id'])) ?? 0;
        if (id > 0 && !retained.contains(id))
          await widget.api.delete('ekstrakulikuler_kegiatan', id);
      }
      await _loadDatabase();
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Perubahan ekstrakulikuler berhasil disimpan ke database.',
            ),
          ),
        );
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan ekstrakulikuler: $error')),
        );
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
      final filename = await widget.api.uploadFile(
        'ekstrakulikuler_konten',
        input.files!.first,
      );
      if (mounted) setState(() => controller.text = filename);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar: $error')),
        );
      }
    }
  }

  Widget _image(String value, {IconData icon = Icons.image_outlined}) {
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 24, 28, 54),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 24),
        _section(1, 'Banner / Hero Ekstrakurikuler', _hero()),
        _section(2, 'Pengantar & Keunggulan Ekstrakurikuler', _introduction()),
        _section(3, 'Pilihan Ekstrakurikuler', _activitiesEditor()),
        _section(4, 'Jadwal Kegiatan Mingguan', _schedulePreview()),
        _section(5, 'Pembinaan Ekstrakurikuler', _guidanceEditor()),
        _section(6, 'Suasana Kegiatan', _galleryEditor()),
        _section(7, 'Pertanyaan yang Sering Diajukan', _faqEditor()),
        _section(8, 'Call to Action', _ctaEditor()),
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
              'Ekstrakurikuler',
              style: TextStyle(
                color: _text,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Kelola kegiatan, jadwal, pembina, galeri, FAQ, dan informasi ekstrakurikuler.',
              style: TextStyle(color: _muted),
            ),
          ],
        ),
      ),
      OutlinedButton.icon(
        onPressed: () =>
            _openAdminPreview(context, sharedStudentPages()['ekstra']!),
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
                        Color(0xFA083A7C),
                        Color(0xD9083A7C),
                        Color(0x52083A7C),
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
      final intro = Column(
        children: [
          _field('Judul Pengantar', _introTitle),
          const SizedBox(height: 12),
          _field('Paragraf 1', _intro1, lines: 4),
          const SizedBox(height: 12),
          _field('Paragraf 2', _intro2, lines: 4),
        ],
      );
      final points = Column(
        children: [
          ..._introPoints.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _contentCard(
                Icons.check_circle_outline_rounded,
                e.value['title'] ?? '',
                e.value['desc'] ?? '',
                [
                  IconButton(
                    onPressed: () =>
                        _editPair(_introPoints, e.key, 'Keunggulan'),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () =>
                        setState(() => _introPoints.removeAt(e.key)),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _editPair(_introPoints, null, 'Keunggulan'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Keunggulan'),
            ),
          ),
        ],
      );
      return c.maxWidth < 800
          ? Column(children: [intro, const SizedBox(height: 18), points])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: intro),
                const SizedBox(width: 22),
                Expanded(child: points),
              ],
            );
    },
  );

  Widget _activitiesEditor() => LayoutBuilder(
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
              ..._activities.asMap().entries.map((e) {
                final a = e.value;
                return SizedBox(
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
                          child: _image(
                            a['image'] ?? '',
                            icon: Icons.sports_rounded,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3CA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            a['category'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFF8A6200),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          a['name'] ?? '',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          a['description'] ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _muted,
                            height: 1.4,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _miniInfo(
                          Icons.calendar_month_rounded,
                          a['schedule'] ?? '',
                        ),
                        _miniInfo(
                          Icons.location_on_outlined,
                          a['location'] ?? '',
                        ),
                        _miniInfo(
                          Icons.person_outline_rounded,
                          a['mentor'] ?? '',
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => _editActivity(e.key),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => _activities.removeAt(e.key)),
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
              onPressed: () => _editActivity(null),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Ekstrakurikuler'),
            ),
          ),
        ],
      );
    },
  );

  Widget _miniInfo(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        Icon(icon, size: 15, color: _blue),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ),
      ],
    ),
  );

  Widget _schedulePreview() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Jadwal ini otomatis mengikuti data pada “Pilihan Ekstrakurikuler”. Edit jadwal, lokasi, atau nama kegiatan pada kartu ekskul di atas.',
        style: TextStyle(color: _muted, height: 1.5),
      ),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(14),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF082F63)),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
            columns: const [
              DataColumn(label: SizedBox(width: 170, child: Text('Kegiatan'))),
              DataColumn(label: SizedBox(width: 170, child: Text('Hari'))),
              DataColumn(label: SizedBox(width: 150, child: Text('Waktu'))),
              DataColumn(label: SizedBox(width: 200, child: Text('Lokasi'))),
            ],
            rows: _activities.map((a) {
              final parts = (a['schedule'] ?? '').split(',');
              return DataRow(
                cells: [
                  DataCell(Text(a['name'] ?? '-')),
                  DataCell(Text(parts.isNotEmpty ? parts.first : '-')),
                  DataCell(Text(parts.length > 1 ? parts.last.trim() : '-')),
                  DataCell(Text(a['location'] ?? '-')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );

  Widget _guidanceEditor() => LayoutBuilder(
    builder: (_, c) {
      final preview = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _line),
            ),
            child: _image(_guidanceImage.text, icon: Icons.groups_rounded),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickImage(_guidanceImage),
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Ganti Foto'),
              ),
              TextButton.icon(
                onPressed: () => setState(_guidanceImage.clear),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ],
      );
      final points = Column(
        children: [
          ..._guidance.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _contentCard(
                Icons.auto_awesome_rounded,
                e.value['title'] ?? '',
                e.value['desc'] ?? '',
                [
                  IconButton(
                    onPressed: () =>
                        _editPair(_guidance, e.key, 'Poin Pembinaan'),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _guidance.removeAt(e.key)),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => _editPair(_guidance, null, 'Poin Pembinaan'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Poin'),
            ),
          ),
        ],
      );
      return c.maxWidth < 800
          ? Column(children: [preview, const SizedBox(height: 18), points])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: preview),
                const SizedBox(width: 22),
                Expanded(child: points),
              ],
            );
    },
  );

  Widget _galleryEditor() => LayoutBuilder(
    builder: (_, c) {
      final columns = c.maxWidth < 650
          ? 1
          : c.maxWidth < 900
          ? 2
          : 4;
      final width = (c.maxWidth - (columns - 1) * 14) / columns;
      return Column(
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              ..._gallery.asMap().entries.map(
                (e) => SizedBox(
                  width: width,
                  child: Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FBFE),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 155,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: _image(e.value['image'] ?? ''),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          e.value['title'] ?? '',
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => _editGallery(e.key),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => _gallery.removeAt(e.key)),
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
              onPressed: () => _editGallery(null),
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Tambah Foto'),
            ),
          ),
        ],
      );
    },
  );

  Widget _faqEditor() => Column(
    children: [
      ..._faqs.asMap().entries.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _contentCard(
            Icons.help_outline_rounded,
            e.value['question'] ?? '',
            e.value['answer'] ?? '',
            [
              IconButton(
                onPressed: () => _editFaq(e.key),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => setState(() => _faqs.removeAt(e.key)),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editFaq(null),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah FAQ'),
        ),
      ),
    ],
  );

  Widget _ctaEditor() => Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF083A7C), Color(0xFF0756C8)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.chat_rounded, color: Colors.white, size: 42),
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
            OutlinedButton(
              onPressed: () {
                final link = Uri.tryParse(_ctaLink.text.trim());
                if (link == null ||
                    !const {'http', 'https'}.contains(link.scheme) ||
                    link.host.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Isi link WhatsApp / Kontak HTTP atau HTTPS yang valid.',
                      ),
                    ),
                  );
                  return;
                }
                html.window.open(link.toString(), '_blank');
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _blue,
                side: BorderSide.none,
              ),
              child: Text(_ctaButton.text),
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
          Expanded(
            child: _field(
              'Teks Tombol',
              _ctaButton,
              changed: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _field('Link WhatsApp / Kontak', _ctaLink)),
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
        final value = {'title': title.text.trim(), 'desc': desc.text.trim()};
        if (index == null)
          list.add(value);
        else
          list[index] = value;
      });
    }
    title.dispose();
    desc.dispose();
  }

  Future<void> _editActivity(int? index) async {
    final old = index == null ? null : _activities[index];
    final name = TextEditingController(text: old?['name'] ?? '');
    final category = TextEditingController(text: old?['category'] ?? '');
    final description = TextEditingController(text: old?['description'] ?? '');
    final schedule = TextEditingController(text: old?['schedule'] ?? '');
    final location = TextEditingController(text: old?['location'] ?? '');
    final mentor = TextEditingController(text: old?['mentor'] ?? '');
    final participants = TextEditingController(
      text: old?['participants'] ?? 'Siswa kelas X–XII',
    );
    final image = TextEditingController(text: old?['image'] ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (_, modalSetState) => AlertDialog(
          title: Text(
            index == null ? 'Tambah Ekstrakurikuler' : 'Edit Ekstrakurikuler',
          ),
          content: SizedBox(
            width: 620,
            child: SingleChildScrollView(
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
                    child: _image(image.text, icon: Icons.sports_rounded),
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
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Ekstrakurikuler',
                    ),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: category,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: description,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: schedule,
                    decoration: const InputDecoration(
                      labelText: 'Jadwal (contoh: Selasa & Kamis, 15.30 WIB)',
                    ),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: location,
                    decoration: const InputDecoration(labelText: 'Lokasi'),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: mentor,
                    decoration: const InputDecoration(labelText: 'Pembina'),
                  ),
                  const SizedBox(height: 9),
                  AdminContentTextField(
                    controller: participants,
                    decoration: const InputDecoration(labelText: 'Peserta'),
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

    if (ok == true && name.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {
          if (old?['id'] != null) 'id': old!['id']!,
          'name': name.text.trim(),
          'category': category.text.trim(),
          'description': description.text.trim(),
          'schedule': schedule.text.trim(),
          'location': location.text.trim(),
          'mentor': mentor.text.trim(),
          'participants': participants.text.trim(),
          'image': image.text,
        };
        if (index == null)
          _activities.add(value);
        else
          _activities[index] = value;
      });
    }

    name.dispose();
    category.dispose();
    description.dispose();
    schedule.dispose();
    location.dispose();
    mentor.dispose();
    participants.dispose();
    image.dispose();
  }

  Future<void> _editGallery(int? index) async {
    final old = index == null ? null : _gallery[index];
    final title = TextEditingController(text: old?['title'] ?? '');
    final image = TextEditingController(text: old?['image'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (_, modalSetState) => AlertDialog(
          title: Text(
            index == null ? 'Tambah Foto Kegiatan' : 'Edit Foto Kegiatan',
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
                    labelText: 'Judul / Nama Kegiatan',
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
          'title': title.text.trim().isEmpty ? 'Kegiatan' : title.text.trim(),
          'image': image.text,
        };
        if (index == null)
          _gallery.add(value);
        else
          _gallery[index] = value;
      });
    }
    title.dispose();
    image.dispose();
  }

  Future<void> _editFaq(int? index) async {
    final old = index == null ? null : _faqs[index];
    final question = TextEditingController(text: old?['question'] ?? '');
    final answer = TextEditingController(text: old?['answer'] ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(index == null ? 'Tambah FAQ' : 'Edit FAQ'),
        content: SizedBox(
          width: 580,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminContentTextField(
                controller: question,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Pertanyaan'),
              ),
              const SizedBox(height: 10),
              AdminContentTextField(
                controller: answer,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Jawaban'),
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
    if (ok == true && question.text.trim().isNotEmpty && mounted) {
      setState(() {
        final value = {
          'question': question.text.trim(),
          'answer': answer.text.trim(),
        };
        if (index == null)
          _faqs.add(value);
        else
          _faqs[index] = value;
      });
    }
    question.dispose();
    answer.dispose();
  }
}
