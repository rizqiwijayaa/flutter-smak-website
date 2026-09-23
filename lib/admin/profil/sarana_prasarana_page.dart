part of '../admin_dashboard_page.dart';

class AdminSaranaPrasaranaPage extends StatefulWidget {
  const AdminSaranaPrasaranaPage({super.key, required this.api});
  final SmakApi api;

  @override
  State<AdminSaranaPrasaranaPage> createState() =>
      _AdminSaranaPrasaranaPageState();
}

class _AdminSaranaPrasaranaPageState extends State<AdminSaranaPrasaranaPage> {
  SmakApi get _api => widget.api;

  final _heroTitle = TextEditingController(text: 'Sarana & Prasarana');
  final _heroDesc = TextEditingController(
    text:
        'Fasilitas di SMA Katolik Mgr. Soegijapranata Lumajang kami sediakan secara sederhana dan bertahap untuk mendukung proses belajar serta pembentukan karakter peserta didik.',
  );
  final _introTitle = TextEditingController(
    text: 'Lingkungan Belajar yang Mendukung',
  );
  final _introDesc = TextEditingController(
    text:
        'Kami berkomitmen menyediakan fasilitas dasar yang aman, nyaman, dan dirawat bertahap sesuai kemampuan sekolah serta menyesuaikan kebutuhan pembelajaran.',
  );
  final _religionTitle = TextEditingController(
    text: 'Fasilitas Keagamaan & Pembentukan Karakter',
  );
  final _religionDesc = TextEditingController(
    text:
        'Kami mendukung pembentukan karakter melalui kegiatan kerohanian dan pembiasaan nilai-nilai Kristiani.',
  );
  final _quote = TextEditingController(
    text:
        'Fasilitas kami mungkin sederhana, tetapi kami merawatnya bersama agar menjadi sarana belajar yang aman dan bermanfaat.',
  );
  final _quoteBy = TextEditingController(text: 'Siswa SMAK');
  final _ctaTitle = TextEditingController(
    text: 'Belajar dan Bertumbuh Bersama SMAK',
  );
  final _ctaDesc = TextEditingController(
    text:
        'Fasilitas dasar, dirawat bertahap, menyesuaikan kebutuhan pembelajaran.',
  );
  final _ctaButton1 = TextEditingController(text: 'Lihat Galeri Sekolah');
  final _ctaLink1 = TextEditingController(text: '/galeri');
  final _ctaButton2 = TextEditingController(text: 'Hubungi Kami');
  final _ctaLink2 = TextEditingController(text: 'https://wa.me/628155099445');

  String _banner = '';
  String _supportImage = '';
  String _religionImage = '';
  int? _utamaId;
  bool _loading = true;
  bool _saving = false;

  final List<_SarprasItem> _introItems = [
    _SarprasItem('Ruang Pembelajaran', '', icon: Icons.class_rounded),
    _SarprasItem('Fasilitas Dasar', '', icon: Icons.science_rounded),
    _SarprasItem('Lingkungan Aman', '', icon: Icons.apartment_rounded),
    _SarprasItem('Digunakan Bersama', '', icon: Icons.groups_rounded),
  ];

  final List<_SarprasItem> _mainFacilities = [
    _SarprasItem(
      'Ruang Kelas',
      'Ruang belajar utama untuk kegiatan pembelajaran setiap hari.',
      category: 'Akademik',
    ),
    _SarprasItem(
      'Perpustakaan Sekolah',
      'Koleksi buku pelajaran dan referensi untuk mendukung kegiatan belajar.',
      category: 'Akademik',
    ),
    _SarprasItem(
      'Ruang Komputer Sederhana',
      'Komputer dasar untuk pembelajaran TIK sesuai kebutuhan.',
      category: 'Pendukung',
    ),
    _SarprasItem(
      'Ruang Praktik IPA',
      'Ruang praktik dengan peralatan dasar IPA dan media pembelajaran.',
      category: 'Akademik',
    ),
    _SarprasItem(
      'Halaman/Lapangan Sekolah',
      'Digunakan untuk olahraga, upacara, dan kegiatan luar ruang lainnya.',
      category: 'Pengembangan Diri',
    ),
    _SarprasItem(
      'Ruang Pertemuan',
      'Digunakan untuk pertemuan, diskusi, dan kegiatan sekolah.',
      category: 'Rohani',
    ),
  ];

  final List<_SarprasItem> _supportItems = [
    _SarprasItem(
      'Proyektor Bersama',
      'Digunakan bersama sesuai jadwal dan kebutuhan kelas.',
      icon: Icons.desktop_windows_rounded,
    ),
    _SarprasItem(
      'Papan Tulis',
      'Tersedia di setiap ruang kelas untuk mendukung pembelajaran.',
      icon: Icons.edit_rounded,
    ),
    _SarprasItem(
      'Alat Praktik Dasar',
      'Peralatan praktik sederhana untuk kegiatan belajar IPA dan lain-lain.',
      icon: Icons.science_rounded,
    ),
    _SarprasItem(
      'Koneksi Internet Terbatas',
      'Akses internet digunakan seperlunya untuk pembelajaran dan administrasi.',
      icon: Icons.wifi_rounded,
    ),
  ];

  final List<_SarprasItem> _religionItems = [
    _SarprasItem(
      'Ruang Doa/Kapel Sederhana',
      'Tempat berdoa bersama dan perayaan Ekaristi pada waktu tertentu.',
      icon: Icons.church_rounded,
    ),
    _SarprasItem(
      'Kegiatan Kerohanian',
      'Pembinaan iman, retret, dan kegiatan rohani bersama secara berkala.',
      icon: Icons.groups_rounded,
    ),
  ];

  final List<_SarprasItem> _safetyItems = [
    _SarprasItem(
      'UKS Sederhana',
      'Pertolongan pertama untuk kesehatan siswa.',
      icon: Icons.medical_services_rounded,
    ),
    _SarprasItem(
      'Kantin',
      'Kantin sederhana dengan menu bergizi.',
      icon: Icons.storefront_rounded,
    ),
    _SarprasItem(
      'Toilet',
      'Toilet bersih dan terawat untuk siswa dan guru.',
      icon: Icons.wc_rounded,
    ),
    _SarprasItem(
      'Tempat Parkir',
      'Area parkir untuk kendaraan siswa, guru, dan tamu.',
      icon: Icons.local_parking_rounded,
    ),
    _SarprasItem(
      'Kebersihan Lingkungan',
      'Kebersihan sekolah dijaga bersama-sama.',
      icon: Icons.clean_hands_rounded,
    ),
  ];

  final List<_SarprasItem> _gallery = [
    _SarprasItem('Ruang Kelas', ''),
    _SarprasItem('Perpustakaan Sekolah', ''),
    _SarprasItem('Ruang Komputer Sederhana', ''),
    _SarprasItem('Ruang Praktik IPA', ''),
    _SarprasItem('Halaman/Lapangan Sekolah', ''),
    _SarprasItem('Ruang Pertemuan', ''),
  ];

  final List<_SarprasItem> _maintenance = [
    _SarprasItem(
      'Pengecekan Rutin',
      'Fasilitas dicek secara berkala agar tetap aman digunakan.',
    ),
    _SarprasItem(
      'Kebersihan Harian',
      'Menjaga kebersihan ruang dan lingkungan setiap hari.',
    ),
    _SarprasItem(
      'Perawatan Bertahap',
      'Perbaikan dilakukan sesuai prioritas dan kemampuan sekolah.',
    ),
    _SarprasItem(
      'Penggunaan Bertanggung Jawab',
      'Siswa diajak merawat fasilitas bersama-sama.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _heroTitle,
      _heroDesc,
      _introTitle,
      _introDesc,
      _religionTitle,
      _religionDesc,
      _quote,
      _quoteBy,
      _ctaTitle,
      _ctaDesc,
      _ctaButton1,
      _ctaLink1,
      _ctaButton2,
      _ctaLink2,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final all = await Future.wait([
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
      final rows = all[0];
      if (rows.isNotEmpty) {
        final r = rows.first;
        _utamaId = int.tryParse('${r['id'] ?? ''}');
        _heroTitle.text = '${r['judul'] ?? _heroTitle.text}';
        _heroDesc.text = '${r['deskripsi'] ?? _heroDesc.text}';
        _banner = '${r['banner'] ?? ''}';
      }
      Map<String, dynamic> section(String key) => all[1].firstWhere(
        (row) => '${row['kode']}' == key,
        orElse: () => <String, dynamic>{},
      );
      final intro = section('intro');
      final religion = section('keagamaan');
      _introTitle.text = '${intro['judul'] ?? _introTitle.text}';
      _introDesc.text = '${intro['deskripsi'] ?? _introDesc.text}';
      _religionTitle.text = '${religion['judul'] ?? _religionTitle.text}';
      _religionDesc.text = '${religion['deskripsi'] ?? _religionDesc.text}';
      _supportImage = '${section('penunjang')['gambar'] ?? ''}';
      _religionImage = '${religion['gambar'] ?? ''}';
      _replace(_introItems, all[2]);
      _replace(_mainFacilities, all[3], category: true);
      _replace(_supportItems, all[4]);
      _replace(_religionItems, all[5]);
      _replace(_safetyItems, all[6]);
      _replace(_gallery, all[7], photo: true);
      _replace(_maintenance, all[8]);
      if (all[9].isNotEmpty) {
        _quote.text = '${all[9].first['kutipan'] ?? _quote.text}';
        _quoteBy.text = '${all[9].first['sumber'] ?? _quoteBy.text}';
      }
      if (all[10].isNotEmpty) {
        _ctaTitle.text = '${all[10].first['judul'] ?? _ctaTitle.text}';
        _ctaDesc.text = '${all[10].first['deskripsi'] ?? _ctaDesc.text}';
        _ctaButton1.text = '${all[10].first['teks_tombol_1'] ?? _ctaButton1.text}';
        _ctaLink1.text = '${all[10].first['link_tombol_1'] ?? _ctaLink1.text}';
        _ctaButton2.text = '${all[10].first['teks_tombol_2'] ?? _ctaButton2.text}';
        _ctaLink2.text = '${all[10].first['link_tombol_2'] ?? _ctaLink2.text}';
      }
    } catch (_) {
      // Tetap tampil dengan data UI awal jika API/tabel belum lengkap.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _replace(
    List<_SarprasItem> target,
    List<Map<String, dynamic>> rows, {
    bool category = false,
    bool photo = false,
  }) {
    for (final row in rows) {
      final title = '${row['judul'] ?? ''}'.trim();
      final order = int.tryParse('${row['urutan'] ?? ''}') ?? 0;
      var index = target.indexWhere((item) => item.title == title);
      if (index < 0 && order > 0 && order <= target.length) index = order - 1;

      final item = index < 0
          ? _SarprasItem('', '')
          : target[index];
      item
        ..id = int.tryParse('${row['id'] ?? ''}')
        ..order = order;
      if (title.isNotEmpty) item.title = title;
      final description = '${row['deskripsi'] ?? ''}';
      if (description.trim().isNotEmpty) item.description = description;
      final image = '${row['gambar'] ?? ''}';
      if (image.trim().isNotEmpty) item.image = image;
      if (category) {
        final itemCategory = '${row['kategori'] ?? ''}';
        if (itemCategory.trim().isNotEmpty) item.category = itemCategory;
      }
      if (index < 0) target.add(item);
    }
  }

  Future<String?> _pickPhoto() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return null;
    return _api.uploadFile('sarana_utama', input.files!.first);
  }

  void _msg(String text) {
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _saveMain() async {
    setState(() => _saving = true);
    try {
      await _api.save('sarana_utama', {
        'judul': _heroTitle.text.trim(),
        'deskripsi': _heroDesc.text.trim(),
        'banner': _banner,
        'status': 'aktif',
      }, id: _utamaId);
      await _saveSection('intro', _introTitle.text, _introDesc.text);
      await _saveSection(
        'penunjang',
        'Fasilitas Penunjang Pembelajaran',
        '',
        image: _supportImage,
      );
      await _saveSection(
        'keagamaan',
        _religionTitle.text,
        _religionDesc.text,
        image: _religionImage,
      );
      await _saveSection('keamanan', 'Kenyamanan dan Keamanan', '');
      await _saveSection('galeri', 'Galeri Sarana & Prasarana', '');
      await _saveSection('perawatan', 'Upaya Perawatan Fasilitas', '');
      await _saveSingle('sarana_kutipan', {
        'kutipan': _quote.text.trim(),
        'sumber': _quoteBy.text.trim(),
        'status': 'aktif',
      });
      await _saveSingle('sarana_cta', {
        'judul': _ctaTitle.text.trim(),
        'deskripsi': _ctaDesc.text.trim(),
        'teks_tombol_1': _ctaButton1.text.trim(),
        'link_tombol_1': _ctaLink1.text.trim(),
        'teks_tombol_2': _ctaButton2.text.trim(),
        'link_tombol_2': _ctaLink2.text.trim(),
        'status': 'aktif',
      });
      await _load();
      _msg('Perubahan berhasil disimpan.');
    } catch (e) {
      _msg('Gagal menyimpan: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveSection(
    String code,
    String title,
    String description, {
    String image = '',
  }) async {
    final rows = await _api.getTable('sarana_bagian', limit: 20);
    Map<String, dynamic>? row;
    for (final item in rows) {
      if ('${item['kode']}' == code) {
        row = item;
        break;
      }
    }
    await _api.save('sarana_bagian', {
      'kode': code,
      'judul': title,
      'deskripsi': description,
      'gambar': image,
      'status': 'aktif',
    }, id: row == null ? null : int.tryParse('${row['id']}'));
  }

  Future<void> _saveSingle(String table, Map<String, dynamic> data) async {
    final rows = await _api.getTable(table, limit: 1);
    await _api.save(
      table,
      data,
      id: rows.isEmpty ? null : int.tryParse('${rows.first['id']}'),
    );
  }

  Future<void> _editItem(
    List<_SarprasItem> list, {
    _SarprasItem? item,
    bool photo = false,
    bool category = false,
  }) async {
    final title = TextEditingController(text: item?.title ?? '');
    final desc = TextEditingController(text: item?.description ?? '');
    String image = item?.image ?? '';
    String cat = item?.category.isNotEmpty == true
        ? item!.category
        : 'Akademik';

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, ss) => AlertDialog(
          title: Text(item == null ? 'Tambah Data' : 'Edit Data'),
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (photo) ...[
                    _imageBox(image, height: 150),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final v = await _pickPhoto();
                        if (v != null) ss(() => image = v);
                      },
                      icon: const Icon(Icons.upload_rounded),
                      label: Text(image.isEmpty ? 'Pilih Foto' : 'Ganti Foto'),
                    ),
                    const SizedBox(height: 14),
                  ],
                  AdminContentTextField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: 'Nama / Judul',
                    ),
                  ),
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: desc,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                  if (category) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: cat,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Akademik',
                          child: Text('Akademik'),
                        ),
                        DropdownMenuItem(
                          value: 'Pendukung',
                          child: Text('Pendukung'),
                        ),
                        DropdownMenuItem(
                          value: 'Pengembangan Diri',
                          child: Text('Pengembangan Diri'),
                        ),
                        DropdownMenuItem(
                          value: 'Rohani',
                          child: Text('Rohani'),
                        ),
                      ],
                      onChanged: (v) => ss(() => cat = v ?? cat),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    if (ok == true) {
      try {
        final table = _tableFor(list);
        await _api.save(table, {
          'judul': title.text.trim(),
          if (table != 'sarana_galeri') 'deskripsi': desc.text.trim(),
          if (category) 'kategori': cat,
          if (photo) 'gambar': image,
          'urutan': item?.order ?? list.length + 1,
          'status': 'aktif',
        }, id: item?.id);
        await _load();
        _msg('Data berhasil disimpan.');
      } catch (e) {
        _msg('Gagal menyimpan data: $e');
      }
    }
    title.dispose();
    desc.dispose();
  }

  Future<void> _delete(List<_SarprasItem> list, _SarprasItem item) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus data?'),
        content: Text('"${item.title}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (yes == true) {
      try {
        if (item.id != null) await _api.delete(_tableFor(list), item.id!);
        await _load();
        _msg('Data berhasil dihapus.');
      } catch (e) {
        _msg('Gagal menghapus data: $e');
      }
    }
  }

  String _tableFor(List<_SarprasItem> list) {
    if (identical(list, _introItems)) return 'sarana_poin_intro';
    if (identical(list, _mainFacilities)) return 'sarana_fasilitas_utama';
    if (identical(list, _supportItems)) return 'sarana_penunjang';
    if (identical(list, _religionItems)) return 'sarana_keagamaan';
    if (identical(list, _safetyItems)) return 'sarana_keamanan';
    if (identical(list, _gallery)) return 'sarana_galeri';
    return 'sarana_perawatan';
  }

  Widget _section(
    int no,
    String title,
    String note,
    Widget child, {
    VoidCallback? add,
    String addLabel = 'Tambah',
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
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
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$no',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      note,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (add != null)
                FilledButton.icon(
                  onPressed: add,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(addLabel),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4D64A0),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _imageBox(String image, {double height = 180}) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: image.isEmpty
          ? const Center(
              child: Icon(Icons.image_outlined, color: _blue, size: 46),
            )
          : websiteContentImage(image, fit: BoxFit.cover),
    );
  }

  Widget _rows(
    List<_SarprasItem> list, {
    bool photo = false,
    bool category = false,
  }) {
    return Column(
      children: list
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBFCFE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _line),
              ),
              child: Row(
                children: [
                  if (photo) ...[
                    SizedBox(
                      width: 120,
                      child: _imageBox(item.image, height: 72),
                    ),
                    const SizedBox(width: 14),
                  ] else ...[
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon ?? Icons.check_rounded,
                        color: _blue,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (item.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                        if (category && item.category.isNotEmpty) ...[
                          const SizedBox(height: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF2FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                color: _blue,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit',
                    onPressed: () => _editItem(
                      list,
                      item: item,
                      photo: photo,
                      category: category,
                    ),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: _blue,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Hapus',
                    onPressed: () => _delete(list, item),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _textField(TextEditingController c, String label, {int lines = 1}) =>
      AdminContentTextField(
        controller: c,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sarana & Prasarana',
                      style: TextStyle(
                        color: _text,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Kelola fasilitas dan informasi sarana prasarana yang ditampilkan di website.',
                      style: TextStyle(color: _muted),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _openAdminPreview(
                  context,
                  sharedProfilePages()['sarana']!,
                ),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Preview Halaman'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: _saving ? null : _saveMain,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Simpan Perubahan'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4D64A0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _section(
            1,
            'Banner / Hero',
            'Atur bagian pembuka halaman Sarana & Prasarana.',
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _imageBox(_banner, height: 190),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final v = await _pickPhoto();
                            if (v != null) setState(() => _banner = v);
                          },
                          icon: const Icon(Icons.upload_rounded),
                          label: Text(
                            _banner.isEmpty ? 'Pilih Banner' : 'Ganti Banner',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _textField(_heroTitle, 'Judul'),
                      const SizedBox(height: 12),
                      _textField(_heroDesc, 'Deskripsi', lines: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _section(
            2,
            'Lingkungan Belajar yang Mendukung',
            'Kelola pengantar dan poin utama fasilitas sekolah.',
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _textField(_introTitle, 'Judul')),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _textField(_introDesc, 'Deskripsi', lines: 3),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _rows(_introItems),
              ],
            ),
            add: () => _editItem(_introItems),
            addLabel: 'Tambah Poin',
          ),

          _section(
            3,
            'Fasilitas Utama',
            'Tambah, edit, hapus, foto, deskripsi, dan kategori fasilitas utama.',
            _rows(_mainFacilities, photo: true, category: true),
            add: () => _editItem(_mainFacilities, photo: true, category: true),
            addLabel: 'Tambah Fasilitas',
          ),

          _section(
            4,
            'Fasilitas Penunjang Pembelajaran',
            'Kelola foto utama dan daftar fasilitas penunjang.',
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          _imageBox(_supportImage, height: 170),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final v = await _pickPhoto();
                                if (v != null)
                                  setState(() => _supportImage = v);
                              },
                              icon: const Icon(Icons.upload_rounded),
                              label: const Text('Ganti Foto'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _rows(_supportItems)),
                  ],
                ),
              ],
            ),
            add: () => _editItem(_supportItems),
            addLabel: 'Tambah Penunjang',
          ),

          _section(
            5,
            'Fasilitas Keagamaan & Pembentukan Karakter',
            'Kelola foto, judul, deskripsi, dan fasilitas kerohanian.',
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          _imageBox(_religionImage, height: 170),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final v = await _pickPhoto();
                                if (v != null)
                                  setState(() => _religionImage = v);
                              },
                              icon: const Icon(Icons.upload_rounded),
                              label: const Text('Ganti Foto'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _textField(_religionTitle, 'Judul'),
                          const SizedBox(height: 10),
                          _textField(_religionDesc, 'Deskripsi', lines: 3),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _rows(_religionItems),
              ],
            ),
            add: () => _editItem(_religionItems),
            addLabel: 'Tambah Fasilitas',
          ),

          _section(
            6,
            'Kenyamanan dan Keamanan',
            'Kelola fasilitas pendukung kenyamanan dan keamanan sekolah.',
            _rows(_safetyItems),
            add: () => _editItem(_safetyItems),
            addLabel: 'Tambah Fasilitas',
          ),

          _section(
            7,
            'Galeri Sarana & Prasarana',
            'Upload dan kelola foto fasilitas yang tampil pada galeri halaman.',
            _rows(_gallery, photo: true),
            add: () => _editItem(_gallery, photo: true),
            addLabel: 'Tambah Foto',
          ),

          _section(
            8,
            'Upaya Perawatan & Quote',
            'Kelola daftar perawatan fasilitas serta kutipan pada halaman.',
            Column(
              children: [
                _rows(_maintenance),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _textField(_quote, 'Quote', lines: 4),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _textField(_quoteBy, 'Sumber Quote')),
                  ],
                ),
              ],
            ),
            add: () => _editItem(_maintenance),
            addLabel: 'Tambah Upaya',
          ),

          _section(
            9,
            'CTA / Penutup',
            'Kelola teks penutup halaman Sarana & Prasarana.',
            Column(children: [
              Row(children: [Expanded(child: _textField(_ctaTitle, 'Judul CTA')), const SizedBox(width: 12), Expanded(flex: 2, child: _textField(_ctaDesc, 'Deskripsi CTA', lines: 3))]),
              const SizedBox(height: 12),
              Row(children: [Expanded(child: _textField(_ctaButton1, 'Teks Tombol 1')), const SizedBox(width: 12), Expanded(child: _textField(_ctaLink1, 'Link Tombol 1'))]),
              const SizedBox(height: 12),
              Row(children: [Expanded(child: _textField(_ctaButton2, 'Teks Tombol 2')), const SizedBox(width: 12), Expanded(child: _textField(_ctaLink2, 'Link Tombol 2'))]),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SarprasItem {
  _SarprasItem(
    this.title,
    this.description, {
    this.id,
    this.order = 0,
    this.image = '',
    this.category = '',
    this.icon,
  });

  String title;
  int? id;
  int order;
  String description;
  String image;
  String category;
  IconData? icon;
}
