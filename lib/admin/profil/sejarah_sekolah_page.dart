part of '../admin_dashboard_page.dart';

class AdminSejarahSekolahPage extends StatefulWidget {
  const AdminSejarahSekolahPage({super.key, required this.api});
  final SmakApi api;

  @override
  State<AdminSejarahSekolahPage> createState() =>
      _AdminSejarahSekolahPageState();
}

class _AdminSejarahSekolahPageState extends State<AdminSejarahSekolahPage> {
  late Future<void> _future;
  bool _saving = false;
  int? _utamaId;

  final _judul = TextEditingController();
  final _subtitle = TextEditingController();
  final _banner = TextEditingController();
  final _judulPerjalanan = TextEditingController();
  final _isi = TextEditingController();
  final _gambar = TextEditingController();
  final _kutipan = TextEditingController();
  final _sumberKutipan = TextEditingController();

  List<Map<String, dynamic>> _timeline = [];
  List<Map<String, dynamic>> _era = [];
  List<Map<String, dynamic>> _nilai = [];
  List<Map<String, dynamic>> _statistik = [];
  List<Map<String, dynamic>> _galeri = [];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  List<Map<String, dynamic>> _sort(List<Map<String, dynamic>> rows) {
    final result = rows
        .where((e) => '${e['status'] ?? 'aktif'}' != 'nonaktif')
        .toList();
    result.sort(
      (a, b) => (int.tryParse('${a['urutan'] ?? 0}') ?? 0).compareTo(
        int.tryParse('${b['urutan'] ?? 0}') ?? 0,
      ),
    );
    return result;
  }

  Future<void> _load() async {
    final data = await Future.wait([
      widget.api.getTable('sejarah_utama', limit: 1),
      widget.api.getTable('sejarah_timeline', limit: 100),
      widget.api.getTable('sejarah_era', limit: 100),
      widget.api.getTable('sejarah_nilai', limit: 100),
      widget.api.getTable('sejarah_statistik', limit: 100),
      widget.api.getTable('sejarah_galeri', limit: 100),
    ]);

    final utama = data[0];
    if (utama.isNotEmpty) {
      final row = utama.first;
      _utamaId = int.tryParse('${row['id'] ?? ''}');
      _judul.text = '${row['judul'] ?? 'Sejarah Sekolah'}';
      _subtitle.text = '${row['subtitle'] ?? row['subjudul'] ?? ''}';
      _banner.text = '${row['banner'] ?? ''}';
      _judulPerjalanan.text =
          '${row['judul_perjalanan'] ?? row['judul_awal'] ?? 'Awal Berdiri'}';
      _isi.text = '${row['isi'] ?? row['deskripsi'] ?? ''}';
      _gambar.text = '${row['gambar'] ?? row['foto'] ?? ''}';
      _kutipan.text = '${row['kutipan'] ?? row['pendiri'] ?? ''}';
      _sumberKutipan.text =
          '${row['sumber_kutipan'] ?? row['lokasi_awal'] ?? ''}';
    }

    _timeline = _sort(data[1]);
    _era = _sort(data[2]);
    _nilai = _sort(data[3]);
    _statistik = _sort(data[4]);
    _galeri = _sort(data[5]);
  }

  void _reload() => setState(() => _future = _load());

  Future<void> _saveUtama() async {
    setState(() => _saving = true);
    try {
      await widget.api.save('sejarah_utama', {
        'judul': _judul.text.trim(),
        'subtitle': _subtitle.text.trim(),
        'subjudul': _subtitle.text.trim(),
        'banner': _banner.text.trim(),
        'judul_perjalanan': _judulPerjalanan.text.trim(),
        'judul_awal': _judulPerjalanan.text.trim(),
        'isi': _isi.text.trim(),
        'deskripsi': _isi.text.trim(),
        'gambar': _gambar.text.trim(),
        'foto': _gambar.text.trim(),
        'kutipan': _kutipan.text.trim(),
        'pendiri': _kutipan.text.trim(),
        'sumber_kutipan': _sumberKutipan.text.trim(),
        'lokasi_awal': _sumberKutipan.text.trim(),
        'status': 'aktif',
      }, id: _utamaId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sejarah Sekolah berhasil disimpan.')),
      );
      _reload();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete(String table, Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) return;
    await widget.api.delete(table, id);
    _reload();
  }

  Future<void> _editItem(
    String table, {
    Map<String, dynamic>? row,
    String? defaultYear,
  }) async {
    final title = TextEditingController(
      text: '${row?['judul'] ?? row?['nama'] ?? ''}',
    );
    final desc = TextEditingController(
      text: '${row?['deskripsi'] ?? row?['isi'] ?? row?['caption'] ?? ''}',
    );
    final extra = TextEditingController(
      text:
          '${row?['tahun'] ?? row?['periode'] ?? row?['angka'] ?? defaultYear ?? ''}',
    );
    final image = TextEditingController(
      text: '${row?['gambar'] ?? row?['foto'] ?? ''}',
    );

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, modalSetState) => AlertDialog(
          title: Text(row == null ? 'Tambah Data' : 'Edit Data'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdminContentTextField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: 'Judul / Nama',
                    ),
                  ),
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: extra,
                    decoration: const InputDecoration(
                      labelText: 'Tahun / Periode / Angka',
                    ),
                  ),
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: desc,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi / Keterangan',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _itemImagePicker(image, table, modalSetState),
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

    if (ok != true) return;
    final id = int.tryParse('${row?['id'] ?? ''}');
    final order = int.tryParse('${row?['urutan'] ?? ''}') ?? _nextOrder(table);
    await widget.api.save(table, {
      'judul': title.text.trim(),
      'nama': title.text.trim(),
      'deskripsi': desc.text.trim(),
      'isi': desc.text.trim(),
      'caption': desc.text.trim(),
      'tahun': extra.text.trim(),
      'periode': extra.text.trim(),
      'angka': extra.text.trim(),
      'gambar': image.text.trim(),
      'foto': image.text.trim(),
      'urutan': order,
      'status': 'aktif',
    }, id: id);
    _reload();
  }

  Widget _itemImagePicker(
    TextEditingController controller,
    String table,
    void Function(void Function()) modalSetState,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 145,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _itemImage(controller.text),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: () async {
          await _pickImage(controller, table);
          modalSetState(() {});
        },
        icon: const Icon(Icons.upload_rounded),
        label: Text(
          controller.text.trim().isEmpty ? 'Pilih Gambar' : 'Ganti Gambar',
        ),
      ),
    ],
  );

  Widget _itemImage(String value) {
    final path = value.trim();
    if (path.isEmpty) {
      return const Center(
        child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF9AAAC0)),
      );
    }
    return websiteContentImage(path, fit: BoxFit.cover);
  }

  int _nextOrder(String table) {
    final rows = switch (table) {
      'sejarah_timeline' => _timeline,
      'sejarah_era' => _era,
      'sejarah_nilai' => _nilai,
      'sejarah_statistik' => _statistik,
      'sejarah_galeri' => _galeri,
      _ => <Map<String, dynamic>>[],
    };
    return rows.length + 1;
  }

  Future<void> _pickImage(
    TextEditingController controller,
    String table,
  ) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    final name = await widget.api.uploadFile(table, input.files!.first);
    if (!mounted) return;
    setState(() => controller.text = name);
  }

  @override
  void dispose() {
    for (final c in [
      _judul,
      _subtitle,
      _banner,
      _judulPerjalanan,
      _isi,
      _gambar,
      _kutipan,
      _sumberKutipan,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done)
        return const Center(child: CircularProgressIndicator());
      if (snapshot.hasError) {
        return Center(
          child: OutlinedButton.icon(
            onPressed: _reload,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        );
      }
      return _buildEditor();
    },
  );

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    alignLabelWithHint: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: _blue, width: 1.3),
    ),
  );

  Widget _field(TextEditingController c, String label, {int lines = 1}) =>
      AdminContentTextField(
        controller: c,
        minLines: lines,
        maxLines: lines,
        decoration: _dec(label),
      );

  Widget _section(
    String number,
    String title,
    String info,
    Widget child, {
    Widget? action,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    info,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (action != null) action,
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );

  Widget _imageBox(
    TextEditingController c,
    String empty, {
    double height = 150,
  }) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: c,
    builder: (_, value, __) => Container(
      width: double.infinity,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: value.text.trim().isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.image_outlined, color: _muted, size: 31),
                  const SizedBox(height: 6),
                  Text(
                    empty,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            )
          : websiteContentImage(value.text.trim(), fit: BoxFit.cover),
    ),
  );

  Widget _photoButtons(TextEditingController c, String table) => Row(
    children: [
      Expanded(
        child: FilledButton(
          onPressed: () => _pickImage(c, table),
          child: const Text('Ganti Foto'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: OutlinedButton(
          onPressed: c.text.trim().isEmpty ? null : () => setState(c.clear),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD92D20),
          ),
          child: const Text('Hapus'),
        ),
      ),
    ],
  );

  Widget _timelineRow(Map<String, dynamic> row) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: _line)),
    ),
    child: Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
        ),
        const SizedBox(width: 13),
        SizedBox(
          width: 62,
          child: Text(
            '${row['tahun'] ?? row['periode'] ?? ''}',
            style: const TextStyle(color: _text, fontWeight: FontWeight.w900),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${row['judul'] ?? row['nama'] ?? ''}',
                style: const TextStyle(
                  color: _text,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${row['deskripsi'] ?? row['isi'] ?? ''}',
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Edit',
          onPressed: () => _editItem('sejarah_timeline', row: row),
          icon: const Icon(Icons.edit_outlined, color: _blue, size: 17),
        ),
        IconButton(
          tooltip: 'Hapus',
          onPressed: () => _delete('sejarah_timeline', row),
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFD92D20),
            size: 17,
          ),
        ),
      ],
    ),
  );

  Widget _simpleRow(
    String table,
    Map<String, dynamic> row,
    IconData icon,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: _line)),
    ),
    child: Row(
      children: [
        Icon(icon, color: _blue, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${row['judul'] ?? row['nama'] ?? row['angka'] ?? ''}',
                style: const TextStyle(
                  color: _text,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${row['deskripsi'] ?? row['isi'] ?? row['label'] ?? row['periode'] ?? ''}',
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _editItem(table, row: row),
          icon: const Icon(Icons.edit_outlined, color: _blue, size: 16),
        ),
        IconButton(
          onPressed: () => _delete(table, row),
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFD92D20),
            size: 16,
          ),
        ),
      ],
    ),
  );

  Widget _buildEditor() {
    final wide = MediaQuery.sizeOf(context).width >= 980;
    final hero = _section(
      '1',
      'Banner / Hero',
      'Atur tampilan bagian pembuka halaman.',
      wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _imageBox(
                        _banner,
                        'Belum ada gambar banner',
                        height: 165,
                      ),
                      const SizedBox(height: 8),
                      _photoButtons(_banner, 'sejarah_utama'),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      _field(_judul, 'Judul Utama'),
                      const SizedBox(height: 10),
                      _field(_subtitle, 'Sub Judul'),
                      const SizedBox(height: 10),
                      _field(_isi, 'Deskripsi Singkat', lines: 3),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _imageBox(_banner, 'Belum ada gambar banner', height: 165),
                const SizedBox(height: 8),
                _photoButtons(_banner, 'sejarah_utama'),
                const SizedBox(height: 12),
                _field(_judul, 'Judul Utama'),
                const SizedBox(height: 10),
                _field(_subtitle, 'Sub Judul'),
                const SizedBox(height: 10),
                _field(_isi, 'Deskripsi Singkat', lines: 3),
              ],
            ),
    );

    final awal = _section(
      '2',
      'Awal Berdiri',
      'Atur informasi awal berdirinya sekolah.',
      wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _imageBox(_gambar, 'Belum ada foto sejarah', height: 145),
                      const SizedBox(height: 8),
                      _photoButtons(_gambar, 'sejarah_utama'),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _field(_judulPerjalanan, 'Judul / Tahun Berdiri'),
                      const SizedBox(height: 10),
                      _field(_kutipan, 'Pendiri / Yayasan'),
                      const SizedBox(height: 10),
                      _field(_sumberKutipan, 'Lokasi Awal'),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(flex: 5, child: _field(_isi, 'Deskripsi', lines: 7)),
              ],
            )
          : Column(
              children: [
                _imageBox(_gambar, 'Belum ada foto sejarah'),
                const SizedBox(height: 8),
                _photoButtons(_gambar, 'sejarah_utama'),
                const SizedBox(height: 12),
                _field(_judulPerjalanan, 'Judul / Tahun Berdiri'),
                const SizedBox(height: 10),
                _field(_kutipan, 'Pendiri / Yayasan'),
                const SizedBox(height: 10),
                _field(_sumberKutipan, 'Lokasi Awal'),
                const SizedBox(height: 10),
                _field(_isi, 'Deskripsi', lines: 5),
              ],
            ),
    );

    final timeline = _section(
      '3',
      'Perjalanan Sejarah',
      'Kelola timeline perjalanan sejarah sekolah.',
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: _timeline.isEmpty
              ? [
                  const Padding(
                    padding: EdgeInsets.all(22),
                    child: Text(
                      'Belum ada timeline sejarah.',
                      style: TextStyle(color: _muted),
                    ),
                  ),
                ]
              : _timeline.map(_timelineRow).toList(),
        ),
      ),
      action: FilledButton.icon(
        onPressed: () => _editItem('sejarah_timeline'),
        icon: const Icon(Icons.add_rounded, size: 17),
        label: const Text('Tambah Timeline'),
      ),
    );

    final perkembangan = _section(
      '4',
      'Perkembangan & Prestasi',
      'Tampilkan perkembangan sekolah dan pencapaian penting.',
      Column(
        children: [
          if (_era.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Perkembangan Sekolah',
                style: TextStyle(color: _text, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 7),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: _era
                    .map(
                      (e) => _simpleRow(
                        'sejarah_era',
                        e,
                        Icons.check_circle_outline_rounded,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (_nilai.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nilai Sejarah',
                style: TextStyle(color: _text, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 7),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: _nilai
                    .map(
                      (e) => _simpleRow(
                        'sejarah_nilai',
                        e,
                        Icons.volunteer_activism_outlined,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (_statistik.isNotEmpty) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Statistik Sejarah',
                style: TextStyle(color: _text, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 7),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: _statistik
                    .map(
                      (e) => _simpleRow(
                        'sejarah_statistik',
                        e,
                        Icons.bar_chart_rounded,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          if (_era.isEmpty && _nilai.isEmpty && _statistik.isEmpty)
            const Padding(
              padding: EdgeInsets.all(22),
              child: Text(
                'Belum ada data perkembangan & prestasi.',
                style: TextStyle(color: _muted),
              ),
            ),
        ],
      ),
      action: FilledButton.icon(
        onPressed: () => _editItem('sejarah_era'),
        icon: const Icon(Icons.add_rounded, size: 17),
        label: const Text('Tambah Perkembangan'),
      ),
    );

    final galeri = _section(
      '5',
      'Dokumentasi Sejarah',
      'Tambahkan foto dokumentasi perjalanan sekolah.',
      LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth >= 900 ? 150.0 : 125.0;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ..._galeri.map(
                (row) => SizedBox(
                  width: w,
                  child: Column(
                    children: [
                      Container(
                        height: 95,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F7FD),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _line),
                        ),
                        child: '${row['gambar'] ?? row['foto'] ?? ''}'.isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.photo_outlined,
                                  color: _muted,
                                ),
                              )
                            : websiteContentImage(
                                '${row['gambar'] ?? row['foto']}',
                                fit: BoxFit.cover,
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () =>
                                _editItem('sejarah_galeri', row: row),
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: _blue,
                              size: 17,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _delete('sejarah_galeri', row),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFD92D20),
                              size: 17,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => _editItem('sejarah_galeri'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: w,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFB9D2FF)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, color: _blue, size: 28),
                      SizedBox(height: 6),
                      Text(
                        'Tambah Foto',
                        style: TextStyle(
                          color: _blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Klik untuk menambah',
                        style: TextStyle(color: _muted, fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      action: FilledButton.icon(
        onPressed: () => _editItem('sejarah_galeri'),
        icon: const Icon(Icons.add_rounded, size: 17),
        label: const Text('Tambah Foto'),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sejarah Sekolah',
                    style: TextStyle(
                      color: _text,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Profil Sekolah  ›  Sejarah Sekolah',
                    style: TextStyle(
                      color: _blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Kelola konten sejarah sekolah yang ditampilkan di website.',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openAdminPreview(
                    context,
                    sharedProfilePages()['sejarah']!,
                  ),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview Halaman'),
                ),
                FilledButton.icon(
                  onPressed: _saving ? null : _saveUtama,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        hero,
        const SizedBox(height: 10),
        awal,
        const SizedBox(height: 10),
        timeline,
        const SizedBox(height: 10),
        perkembangan,
        const SizedBox(height: 10),
        galeri,
        const SizedBox(height: 18),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 280,
            child: FilledButton.icon(
              onPressed: _saving ? null : _saveUtama,
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Menyimpan...' : 'Simpan Semua Perubahan'),
            ),
          ),
        ),
        AdminProfileSectionEditor(
          api: widget.api,
          table: 'sejarah_tokoh',
          title: 'Tokoh Sekolah',
          singleton: false,
          fields: const {
            'nama': 'Nama',
            'peran': 'Peran / Jabatan',
            'deskripsi': 'Deskripsi',
            'gambar': 'Gambar',
            'urutan': 'Urutan',
          },
        ),
        AdminProfileSectionEditor(
          api: widget.api,
          table: 'sejarah_cta',
          title: 'CTA Sejarah',
          singleton: true,
          fields: const {
            'judul': 'Judul',
            'deskripsi': 'Deskripsi',
            'teks_tombol_1': 'Teks Tombol 1',
            'link_tombol_1': 'Link Tombol 1',
            'teks_tombol_2': 'Teks Tombol 2',
            'link_tombol_2': 'Link Tombol 2',
          },
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
