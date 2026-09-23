part of '../admin_dashboard_page.dart';

class AdminSambutanKepalaSekolahPage extends StatefulWidget {
  const AdminSambutanKepalaSekolahPage({super.key, required this.api});
  final SmakApi api;

  @override
  State<AdminSambutanKepalaSekolahPage> createState() =>
      _AdminSambutanKepalaSekolahPageState();
}

class _AdminSambutanKepalaSekolahPageState
    extends State<AdminSambutanKepalaSekolahPage> {
  late Future<Map<String, dynamic>?> _future;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>?> _load() async {
    final rows = await widget.api.getTable('sambutan_kepala_sekolah', limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  void _reload() => setState(() => _future = _load());

  Future<void> _save(Map<String, TextEditingController> fields, int? id) async {
    setState(() => _saving = true);
    try {
      await widget.api.save('sambutan_kepala_sekolah', {
        for (final item in fields.entries) item.key: item.value.text.trim(),
        'status': 'aktif',
      }, id: id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sambutan Kepala Sekolah berhasil disimpan.'),
        ),
      );
      _reload();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>?>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(
          child: OutlinedButton.icon(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        );
      }
      return _SambutanEditor(
        api: widget.api,
        row: snapshot.data,
        saving: _saving,
        onSave: _save,
      );
    },
  );
}

class _SambutanEditor extends StatefulWidget {
  const _SambutanEditor({
    required this.api,
    required this.row,
    required this.saving,
    required this.onSave,
  });

  final SmakApi api;
  final Map<String, dynamic>? row;
  final bool saving;
  final Future<void> Function(Map<String, TextEditingController>, int?) onSave;

  @override
  State<_SambutanEditor> createState() => _SambutanEditorState();
}

class _SambutanEditorState extends State<_SambutanEditor> {
  static const _specs = <({String key, String label, int lines})>[
    (key: 'judul', label: 'Judul', lines: 1),
    (key: 'subtitle', label: 'Subtitle', lines: 1),
    (key: 'banner', label: 'Gambar Banner (nama file)', lines: 1),
    (key: 'gambar', label: 'Foto Kepala Sekolah (nama file)', lines: 1),
    (key: 'nama_kepala', label: 'Nama Kepala Sekolah', lines: 1),
    (key: 'jabatan', label: 'Jabatan', lines: 1),
    (key: 'masa_jabatan', label: 'Masa Jabatan', lines: 1),
    (key: 'telepon', label: 'Telepon', lines: 1),
    (key: 'email', label: 'Email', lines: 1),
    (key: 'alamat', label: 'Alamat', lines: 2),
    (key: 'pesan', label: 'Pesan Kepala Sekolah', lines: 3),
    (key: 'motto', label: 'Motto Sekolah', lines: 2),
    (key: 'kutipan', label: 'Kutipan / Ayat', lines: 3),
    (key: 'sumber_kutipan', label: 'Sumber Kutipan', lines: 1),
    (key: 'isi', label: 'Isi Sambutan', lines: 8),
    (key: 'komitmen_json', label: 'Komitmen', lines: 4),
    (key: 'harapan_json', label: 'Arah & Harapan', lines: 4),
    (key: 'sosial_json', label: 'Sosial Media', lines: 4),
    (key: 'program_prioritas_json', label: 'Program Prioritas', lines: 7),
    (key: 'kegiatan_kepala_json', label: 'Jejak Kegiatan', lines: 4),
    (key: 'penutup', label: 'Teks Penutup', lines: 7),
  ];

  late final Map<String, TextEditingController> _fields;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _fields = {
      for (final s in _specs)
        s.key: TextEditingController(text: '${widget.row?[s.key] ?? ''}'),
    };
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      hintText: label,
      alignLabelWithHint: true,
      prefixIcon: icon == null ? null : Icon(icon, size: 18, color: _text),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _blue, width: 1.4),
      ),
    );
  }

  Widget _field(String key, {IconData? icon, int? lines}) {
    final spec = _specs.firstWhere((item) => item.key == key);
    final count = lines ?? spec.lines;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          spec.label,
          style: const TextStyle(
            color: _text,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        AdminContentTextField(
          controller: _fields[key],
          constraint: key == 'isi' || key == 'penutup'
              ? AdminContentConstraint.longContent
              : adminConstraintFor(spec.label, maxLines: count),
          minLines: count,
          maxLines: count,
          decoration: _inputDecoration(
            'Masukkan ${spec.label.toLowerCase()}',
            icon: icon,
          ),
        ),
      ],
    );
  }

  List<String> _decodeListField(String key) {
    final raw = _fields[key]?.text.trim() ?? '';
    if (raw.isEmpty) return <String>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map((e) {
              if (e is Map) {
                return '${e['judul'] ?? e['nama'] ?? e['label'] ?? e['teks'] ?? e['kegiatan'] ?? ''}';
              }
              return '$e';
            })
            .where((e) => e.trim().isNotEmpty)
            .toList();
      }
    } catch (_) {}
    return raw
        .split(RegExp(r'[\n,;]+'))
        .map(
          (e) =>
              e.replaceAll(RegExp(r'^[\s\[\]{}"]+|[\s\[\]{}"]+$'), '').trim(),
        )
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _writeListField(String key, List<String> values) {
    _fields[key]?.text = jsonEncode(values);
    setState(() {});
  }

  Future<void> _showListItemDialog({
    required String key,
    required String itemLabel,
    int? index,
  }) async {
    final items = _decodeListField(key);
    final controller = TextEditingController(
      text: index == null ? '' : items[index],
    );
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${index == null ? 'Tambah' : 'Edit'} $itemLabel'),
        content: AdminContentTextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: itemLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) Navigator.pop(context, text);
            },
            child: Text(index == null ? 'Tambah' : 'Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null) return;
    if (index == null) {
      items.add(value);
    } else {
      items[index] = value;
    }
    _writeListField(key, items);
  }

  Widget _listEditor({
    required String key,
    required String itemLabel,
    required IconData icon,
  }) {
    final items = _decodeListField(key);
    return Column(
      children: [
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _line),
            ),
            child: Text(
              'Belum ada $itemLabel.',
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          )
        else
          ...List.generate(
            items.length,
            (index) => Container(
              margin: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: _line),
              ),
              child: Row(
                children: [
                  Icon(icon, color: _blue, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      items[index],
                      style: const TextStyle(
                        color: _text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _showListItemDialog(
                      key: key,
                      itemLabel: itemLabel,
                      index: index,
                    ),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: _blue,
                      size: 18,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Hapus',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      final next = _decodeListField(key)..removeAt(index);
                      _writeListField(key, next);
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD92D20),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () =>
                _showListItemDialog(key: key, itemLabel: itemLabel),
            style: FilledButton.styleFrom(backgroundColor: _blue),
            icon: const Icon(Icons.add_rounded, size: 17),
            label: Text('Tambah $itemLabel'),
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
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
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _mediaPreview({
    required String field,
    required IconData icon,
    required String emptyText,
    double height = 145,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _fields[field]!,
      builder: (context, value, _) {
        final filename = value.text.trim();
        return Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F6FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _line),
          ),
          alignment: Alignment.center,
          child: filename.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 38, color: _blue),
                    const SizedBox(height: 8),
                    Text(
                      emptyText,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: websiteContentImage(
                    filename,
                    width: double.infinity,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
    );
  }

  Widget _mediaActions({required String field, required String changeLabel}) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _fields[field]!,
      builder: (context, value, _) {
        final hasMedia = value.text.trim().isNotEmpty;
        return Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: widget.saving || _uploading
                    ? null
                    : () => _uploadImage(field),
                style: FilledButton.styleFrom(
                  backgroundColor: _blue,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.upload_rounded, size: 18),
                label: Text(changeLabel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: hasMedia && !widget.saving && !_uploading
                    ? () => setState(() => _fields[field]!.clear())
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD92D20),
                  side: BorderSide(
                    color: hasMedia
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFFE2E8F0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Hapus'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage(String field) async {
    final picker = html.FileUploadInputElement()
      ..accept = 'image/jpeg,image/png,image/webp';
    picker.click();
    await picker.onChange.first;
    final files = picker.files;
    if (files == null || files.isEmpty) return;

    setState(() => _uploading = true);
    try {
      final filename = await widget.api.uploadFile(
        'sambutan_kepala_sekolah',
        files.first,
      );
      if (!mounted) return;
      setState(() => _fields[field]!.text = filename);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gambar berhasil diunggah. Tekan Simpan Perubahan.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $error')),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _showMediaFilenameDialog({
    required String field,
    required String title,
  }) async {
    final controller = TextEditingController(text: _fields[field]!.text);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: AdminContentTextField(
          constraint: AdminContentConstraint.url,
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nama file gambar',
            hintText: 'contoh: banner-sekolah.jpg',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final filename = controller.text.trim();
              if (filename.isNotEmpty) {
                Navigator.pop(dialogContext, filename);
              }
            },
            child: const Text('Gunakan'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && mounted) {
      setState(() => _fields[field]!.text = result);
    }
  }

  Widget _jsonNotice(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE6A500),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: _muted, fontSize: 11, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 14);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width > 1050;
    final id = int.tryParse('${widget.row?['id'] ?? ''}');

    Widget two(Widget a, Widget b, {double gap = 14}) {
      if (!wide) {
        return Column(
          children: [
            a,
            SizedBox(height: gap),
            b,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: a),
          SizedBox(width: gap),
          Expanded(child: b),
        ],
      );
    }

    final hero = _sectionCard(
      number: '1',
      title: 'Banner / Hero',
      subtitle: 'Atur tampilan bagian pembuka halaman.',
      icon: Icons.image_outlined,
      child: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 820;
          final preview = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Banner / Gambar Hero', style: _smallLabel),
              const SizedBox(height: 6),
              _mediaPreview(
                field: 'banner',
                icon: Icons.panorama_outlined,
                emptyText: 'Belum ada gambar banner',
                height: 150,
              ),
              const SizedBox(height: 10),
              _mediaActions(field: 'banner', changeLabel: 'Ganti Foto'),
            ],
          );
          final fields = Column(
            children: [
              _field('judul'),
              const SizedBox(height: 12),
              _field('subtitle', lines: 3),
            ],
          );
          if (compact) {
            return Column(
              children: [preview, const SizedBox(height: 14), fields],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 34, child: preview),
              const SizedBox(width: 18),
              Expanded(flex: 50, child: fields),
            ],
          );
        },
      ),
    );

    final profile = _sectionCard(
      number: '2',
      title: 'Profil Kepala Sekolah',
      subtitle: 'Atur informasi profil kepala sekolah.',
      icon: Icons.person_outline_rounded,
      child: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 850;
          final photo = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Foto Kepala Sekolah', style: _smallLabel),
              const SizedBox(height: 6),
              SizedBox(
                width: 190,
                child: _mediaPreview(
                  field: 'gambar',
                  icon: Icons.person_rounded,
                  emptyText: 'Belum ada foto',
                  height: 190,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 190,
                child: _mediaActions(
                  field: 'gambar',
                  changeLabel: 'Ganti Foto',
                ),
              ),
            ],
          );
          final identity = Column(
            children: [
              _field('nama_kepala'),
              const SizedBox(height: 12),
              _field('jabatan'),
              const SizedBox(height: 12),
              _field('masa_jabatan'),
            ],
          );
          final contact = Column(
            children: [
              _field('telepon', icon: Icons.phone_outlined),
              const SizedBox(height: 10),
              _field('email', icon: Icons.email_outlined),
              const SizedBox(height: 10),
              _field('alamat', icon: Icons.location_on_outlined, lines: 1),
              const SizedBox(height: 10),
              _listEditor(
                key: 'sosial_json',
                itemLabel: 'Sosial Media',
                icon: Icons.share_outlined,
              ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                photo,
                const SizedBox(height: 14),
                identity,
                const SizedBox(height: 14),
                contact,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 210, child: photo),
              const SizedBox(width: 18),
              Expanded(child: identity),
              const SizedBox(width: 18),
              Expanded(child: contact),
            ],
          );
        },
      ),
    );

    final greeting = _sectionCard(
      number: '3',
      title: 'Sambutan Kepala Sekolah',
      subtitle: 'Kelola kutipan, isi sambutan, dan pesan utama.',
      icon: Icons.format_quote_rounded,
      child: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 800;
          final quote = Column(
            children: [
              _field('kutipan', lines: 4),
              const SizedBox(height: 12),
              _field('sumber_kutipan'),
            ],
          );
          final body = Column(
            children: [
              _field('isi', lines: 5),
              const SizedBox(height: 12),
              _field('pesan', lines: 3),
            ],
          );
          if (compact)
            return Column(children: [quote, const SizedBox(height: 14), body]);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 32, child: quote),
              const SizedBox(width: 18),
              Expanded(flex: 68, child: body),
            ],
          );
        },
      ),
    );

    final motto = _sectionCard(
      number: '4',
      title: 'Motto Sekolah',
      subtitle: 'Atur motto atau semboyan sekolah.',
      icon: Icons.shield_outlined,
      child: _field('motto', lines: 2),
    );

    final commitment = _sectionCard(
      number: '5',
      title: 'Komitmen Kepemimpinan',
      subtitle: 'Tuliskan komitmen kepala sekolah dalam memimpin sekolah.',
      icon: Icons.fact_check_outlined,
      child: _listEditor(
        key: 'komitmen_json',
        itemLabel: 'Komitmen',
        icon: Icons.check_circle_rounded,
      ),
    );

    final hope = _sectionCard(
      number: '6',
      title: 'Arah & Harapan',
      subtitle: 'Sampaikan arah dan harapan ke depan untuk sekolah.',
      icon: Icons.auto_awesome_outlined,
      child: _listEditor(
        key: 'harapan_json',
        itemLabel: 'Harapan',
        icon: Icons.auto_awesome_rounded,
      ),
    );

    final documentation = _sectionCard(
      number: '7',
      title: 'Dokumentasi (Opsional)',
      subtitle: 'Tambahkan dokumentasi kegiatan kepala sekolah.',
      icon: Icons.photo_library_outlined,
      child: _listEditor(
        key: 'kegiatan_kepala_json',
        itemLabel: 'Kegiatan',
        icon: Icons.photo_outlined,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            const heading = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sambutan Kepala Sekolah',
                  style: TextStyle(
                    color: _text,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Kelola konten sambutan kepala sekolah yang ditampilkan di website.',
                  style: TextStyle(color: _muted),
                ),
              ],
            );
            final actions = Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openAdminPreview(context, sharedProfilePages()['sambutan']!),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Preview Halaman'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _blue,
                    side: const BorderSide(color: _line),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: widget.saving
                      ? null
                      : () => widget.onSave(_fields, id),
                  icon: widget.saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined, size: 18),
                  label: Text(
                    widget.saving ? 'Menyimpan...' : 'Simpan Perubahan',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),
                  ),
                ),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [heading, const SizedBox(height: 14), actions],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: heading),
                const SizedBox(width: 18),
                actions,
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        hero,
        const SizedBox(height: 14),
        profile,
        const SizedBox(height: 14),
        greeting,
        const SizedBox(height: 14),
        motto,
        const SizedBox(height: 14),
        commitment,
        const SizedBox(height: 14),
        hope,
        const SizedBox(height: 14),
        documentation,
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _line),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: _blue, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pastikan semua data sudah sesuai sebelum menyimpan perubahan.',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

const TextStyle _smallLabel = TextStyle(
  color: _text,
  fontSize: 11,
  fontWeight: FontWeight.w700,
);
