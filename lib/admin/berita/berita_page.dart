part of '../admin_dashboard_page.dart';

class AdminBeritaPage extends StatefulWidget {
  const AdminBeritaPage({super.key, required this.api, required this.module});

  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminBeritaPage> createState() => _AdminBeritaPageState();
}

class _AdminBeritaPageState extends State<AdminBeritaPage> {
  SmakApi get _api => widget.api;

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _rows = [];

  String _search = '';
  String _category = 'Semua';
  String _status = 'Semua';

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _s(dynamic value) => '${value ?? ''}'.trim();

  int? _id(Map<String, dynamic> row) => int.tryParse(_s(row['id']));

  bool _active(Map<String, dynamic> row) {
    final s = _s(row['status']).toLowerCase();
    return s == 'publikasi' || s == 'published' || s == 'aktif' || s == '1';
  }

  String _categoryOf(Map<String, dynamic> row) {
    final value = _s(row['kategori']);
    return value.isEmpty ? 'berita' : value.toLowerCase();
  }

  DateTime _dateOf(Map<String, dynamic> row) {
    return DateTime.tryParse(
          _s(row['tanggal_publikasi']).replaceFirst(' ', 'T'),
        ) ??
        DateTime.tryParse(_s(row['created_at']).replaceFirst(' ', 'T')) ??
        DateTime(2000);
  }

  String _imageOf(Map<String, dynamic> row) {
    for (final key in ['thumbnail', 'gambar', 'foto']) {
      final v = _s(row[key]);
      if (v.isNotEmpty) return v;
    }
    return '';
  }

  String _excerptOf(Map<String, dynamic> row) {
    final explicit = _s(row['ringkasan']);
    if (explicit.isNotEmpty) return _plain(explicit);

    final body = _plain(_s(row['isi']));
    if (body.length <= 150) return body;
    return '${body.substring(0, 150).trim()}...';
  }

  String _plain(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _api.getTable('berita', limit: 500);
      rows.sort((a, b) => _dateOf(b).compareTo(_dateOf(a)));
      if (!mounted) return;
      setState(() => _rows = rows);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.toLowerCase().trim();

    return _rows.where((row) {
      final cat = _categoryOf(row);
      final active = _active(row);

      if (_category != 'Semua' && cat != _category.toLowerCase()) {
        return false;
      }
      if (_status == 'Aktif' && !active) return false;
      if (_status == 'Nonaktif' && active) return false;

      if (q.isNotEmpty) {
        final haystack =
            '${_s(row['judul'])} ${_s(row['isi'])} ${_s(row['kategori'])}'
                .toLowerCase();
        if (!haystack.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  List<String> get _categories {
    final values =
        _rows.map(_categoryOf).where((e) => e.isNotEmpty).toSet().toList()
          ..sort();
    return ['Semua', ...values];
  }

  Future<String?> _pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return null;
    return _api.uploadFile('berita', input.files!.first);
  }

  Future<void> _editor([
    Map<String, dynamic>? row,
    String initialCategory = 'berita',
  ]) async {
    final title = TextEditingController(text: _s(row?['judul']));
    final body = TextEditingController(text: _plain(_s(row?['isi'])));
    final summary = TextEditingController(text: _s(row?['ringkasan']));
    String category = row == null ? initialCategory : _categoryOf(row);
    String status = row == null
        ? 'publikasi'
        : (_active(row) ? 'publikasi' : 'draft');
    String image = row == null ? '' : _imageOf(row);
    DateTime date = row == null ? DateTime.now() : _dateOf(row);

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, ss) {
          return AlertDialog(
            title: Text(
              row == null
                  ? (initialCategory == 'pengumuman'
                        ? 'Tambah Pengumuman'
                        : 'Tambah Berita')
                  : (_categoryOf(row) == 'pengumuman'
                        ? 'Edit Pengumuman'
                        : 'Edit Berita'),
            ),
            content: SizedBox(
              width: 720,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dialogImage(image),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await _pickImage();
                            if (picked != null) ss(() => image = picked);
                          },
                          icon: const Icon(Icons.upload_rounded),
                          label: Text(
                            image.isEmpty
                                ? 'Upload Thumbnail'
                                : 'Ganti Thumbnail',
                          ),
                        ),
                        if (image.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => ss(() => image = ''),
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Hapus Gambar'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (image.isEmpty)
                          const Text(
                            'Kosong = gunakan fallback website',
                            style: TextStyle(color: _muted, fontSize: 12),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AdminContentTextField(
                      controller: title,
                      constraint: AdminContentConstraint.title,
                      decoration: const InputDecoration(
                        labelText: 'Judul Berita',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: category,
                            decoration: const InputDecoration(
                              labelText: 'Kategori',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'berita',
                                child: Text('Berita'),
                              ),
                              DropdownMenuItem(
                                value: 'pengumuman',
                                child: Text('Pengumuman'),
                              ),
                            ],
                            onChanged: (v) =>
                                ss(() => category = v ?? category),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: status,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'publikasi',
                                child: Text('Aktif / Publikasi'),
                              ),
                              DropdownMenuItem(
                                value: 'draft',
                                child: Text('Nonaktif / Draft'),
                              ),
                            ],
                            onChanged: (v) => ss(() => status = v ?? status),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: date.year < 2001
                                    ? DateTime.now()
                                    : date,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) ss(() => date = picked);
                            },
                            icon: const Icon(Icons.calendar_month_outlined),
                            label: Text(_dateLabel(date)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AdminContentTextField(
                      controller: summary,
                      constraint: AdminContentConstraint.shortDescription,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Ringkasan (opsional)',
                        hintText:
                            'Jika kosong, ringkasan diambil dari isi berita.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AdminContentTextField(
                      controller: body,
                      constraint: AdminContentConstraint.longContent,
                      minLines: 7,
                      maxLines: 12,
                      decoration: const InputDecoration(
                        labelText: 'Isi Berita',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
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
              FilledButton.icon(
                onPressed: () {
                  if (title.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Judul berita belum diisi.'),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(dialogContext, true);
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );

    if (ok == true) {
      try {
        final data = <String, dynamic>{
          'judul': title.text.trim(),
          'slug': _slug(title.text),
          'isi': body.text.trim(),
          'thumbnail': image,
          'kategori': category,
          'tanggal_publikasi': _sqlDate(date),
          'status': status,
        };

        // Hanya kirim ringkasan bila field ini memang sudah digunakan.
        if (row != null && row.containsKey('ringkasan')) {
          data['ringkasan'] = summary.text.trim();
        }

        await _api.save('berita', data, id: row == null ? null : _id(row));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                row == null
                    ? (category == 'pengumuman'
                          ? 'Pengumuman berhasil ditambahkan.'
                          : 'Berita berhasil ditambahkan.')
                    : (category == 'pengumuman'
                          ? 'Pengumuman berhasil diperbarui.'
                          : 'Berita berhasil diperbarui.'),
              ),
            ),
          );
        }
        await _load();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menyimpan berita: $e')));
        }
      }
    }

    title.dispose();
    body.dispose();
    summary.dispose();
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final id = _id(row);
    if (id == null) return;

    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus berita?'),
        content: Text(
          '"${_s(row['judul'])}" akan dihapus permanen dari database.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yes != true) return;

    try {
      await _api.delete('berita', id);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berita berhasil dihapus.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus berita: $e')));
      }
    }
  }

  String _slug(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
  }

  String _sqlDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }

  String _dateLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    if (date.year < 2001) return '-';
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _dialogImage(String image) {
    return Container(
      width: double.infinity,
      height: 180,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: image.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, color: _blue, size: 42),
                  SizedBox(height: 6),
                  Text(
                    'Fallback website akan digunakan',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            )
          : websiteContentImage(image, fit: BoxFit.cover),
    );
  }

  Widget _thumb(
    Map<String, dynamic> row, {
    double? width,
    double height = 120,
  }) {
    final image = _imageOf(row);
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _line),
      ),
      child: image.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, color: _blue, size: 30),
                  SizedBox(height: 4),
                  Text(
                    'Fallback',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          : websiteContentImage(image, fit: BoxFit.cover),
    );
  }

  Widget _badge(String text, {Color? color}) {
    final c = color ?? _blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _stat(
    IconData icon,
    String label,
    String value, {
    Color color = _blue,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _featured(Map<String, dynamic> row) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _thumb(row, width: 230, height: 142),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _badge(_categoryOf(row).toUpperCase()),
                    _badge(
                      _active(row) ? 'AKTIF' : 'NONAKTIF',
                      color: _active(row) ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _s(row['judul']),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _dateLabel(_dateOf(row)),
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  _excerptOf(row),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => _editor(row),
                      icon: const Icon(Icons.edit_outlined, color: _blue),
                    ),
                    IconButton(
                      tooltip: 'Hapus',
                      onPressed: () => _delete(row),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
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

  Widget _compactFeatured(Map<String, dynamic> row, int rank) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _thumb(row, width: 105, height: 78),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: [
                    _badge('#$rank'),
                    _badge(_categoryOf(row).toUpperCase()),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _s(row['judul']),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _dateLabel(_dateOf(row)),
                  style: const TextStyle(color: _muted, fontSize: 10.5),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: () => _editor(row),
            icon: const Icon(Icons.edit_outlined, color: _blue, size: 19),
          ),
          IconButton(
            tooltip: 'Hapus',
            onPressed: () => _delete(row),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidePanel() {
    final categoryCounts = <String, int>{};
    for (final row in _rows) {
      final cat = _categoryOf(row);
      categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
    }

    final latestAnnouncement = _rows
        .where((r) => _categoryOf(r) == 'pengumuman' && _active(r))
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kategori Berita',
                style: TextStyle(color: _text, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              ...categoryCounts.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.key,
                          style: const TextStyle(color: _text, fontSize: 12.5),
                        ),
                      ),
                      _badge('${e.value}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengumuman Terbaru',
                style: TextStyle(color: _text, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              if (latestAnnouncement.isEmpty)
                const Text(
                  'Belum ada pengumuman aktif.',
                  style: TextStyle(color: _muted, fontSize: 12),
                )
              else
                ...latestAnnouncement
                    .take(3)
                    .map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF2FF),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.article_outlined,
                                color: _blue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                _s(row['judul']),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _newsRow(Map<String, dynamic> row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _thumb(row, width: 128, height: 82),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 7,
                  children: [
                    _badge(_categoryOf(row).toUpperCase()),
                    _badge(
                      _active(row) ? 'Aktif' : 'Nonaktif',
                      color: _active(row) ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  _s(row['judul']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_dateLabel(_dateOf(row))}  •  ${_excerptOf(row)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: () => _editor(row),
            icon: const Icon(Icons.edit_outlined, color: _blue),
          ),
          IconButton(
            tooltip: 'Hapus',
            onPressed: () => _delete(row),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 42,
            ),
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: _muted)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final active = _rows.where(_active).length;
    final inactive = _rows.length - active;
    final announcements = _rows
        .where((r) => _categoryOf(r) == 'pengumuman')
        .length;
    final visible = _filtered;
    final activeSorted = _rows.where(_active).toList()
      ..sort((a, b) => _dateOf(b).compareTo(_dateOf(a)));
    final top3 = activeSorted.take(3).toList();
    final top3Ids = top3.map(_id).whereType<int>().toSet();
    final listRows = visible.where((row) {
      final id = _id(row);
      return id == null || !top3Ids.contains(id);
    }).toList();
    final compact = MediaQuery.sizeOf(context).width < 1050;
    const headerTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berita & Pengumuman',
          style: TextStyle(
            color: _text,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Kelola berita dan pengumuman yang ditampilkan di website.',
          style: TextStyle(color: _muted),
        ),
      ],
    );
    final headerActions = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        OutlinedButton.icon(
          onPressed: () => _openAdminPreview(context, const BeritaPage()),
          icon: const Icon(Icons.visibility_outlined),
          label: const Text('Preview Halaman'),
        ),
        OutlinedButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh'),
        ),
        FilledButton.icon(
          onPressed: () => _editor(null, 'pengumuman'),
          icon: const Icon(Icons.campaign_outlined),
          label: const Text('Tambah Pengumuman'),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF4D64A0)),
        ),
        FilledButton.icon(
          onPressed: () => _editor(null, 'berita'),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Berita'),
          style: FilledButton.styleFrom(backgroundColor: _blue),
        ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (compact)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerTitle,
                const SizedBox(height: 14),
                headerActions,
              ],
            )
          else
            Row(
              children: [
                const Expanded(child: headerTitle),
                headerActions,
              ],
            ),
          const SizedBox(height: 18),

          if (compact)
            Column(
              children: [
                Row(children: [
                  _stat(Icons.article_outlined, 'Total Konten', '${_rows.length}'),
                  const SizedBox(width: 12),
                  _stat(Icons.check_circle_outline, 'Aktif', '$active', color: Colors.green),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  _stat(Icons.campaign_outlined, 'Pengumuman', '$announcements'),
                  const SizedBox(width: 12),
                  _stat(Icons.visibility_off_outlined, 'Nonaktif', '$inactive', color: Colors.orange),
                ]),
              ],
            )
          else Row(
            children: [
              _stat(Icons.article_outlined, 'Total Konten', '${_rows.length}'),
              const SizedBox(width: 12),
              _stat(
                Icons.check_circle_outline,
                'Aktif',
                '$active',
                color: Colors.green,
              ),
              const SizedBox(width: 12),
              _stat(Icons.campaign_outlined, 'Pengumuman', '$announcements'),
              const SizedBox(width: 12),
              _stat(
                Icons.visibility_off_outlined,
                'Nonaktif',
                '$inactive',
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (top3.isNotEmpty)
            compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview 3 Berita Terbaru',
                        style: TextStyle(
                          color: _text,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 9),
                      _featured(top3.first),
                      if (top3.length > 1) ...[
                        const SizedBox(height: 10),
                        _compactFeatured(top3[1], 2),
                      ],
                      if (top3.length > 2) ...[
                        const SizedBox(height: 10),
                        _compactFeatured(top3[2], 3),
                      ],
                      const SizedBox(height: 14),
                      _sidePanel(),
                    ],
                  )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview 3 Berita Terbaru',
                        style: TextStyle(
                          color: _text,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 9),
                      _featured(top3.first),
                      if (top3.length > 1) ...[
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _compactFeatured(top3[1], 2)),
                            if (top3.length > 2) ...[
                              const SizedBox(width: 10),
                              Expanded(child: _compactFeatured(top3[2], 3)),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(flex: 3, child: _sidePanel()),
              ],
                  )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Center(
                child: Text(
                  'Belum ada berita aktif. Tambahkan berita atau pengumuman terlebih dahulu.',
                  style: TextStyle(color: _muted),
                ),
              ),
            ),

          const SizedBox(height: 18),
          if (compact)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Semua Berita & Pengumuman',
                  style: TextStyle(color: _text, fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Cari berita...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Kategori', isDense: true, border: OutlineInputBorder()),
                    items: _categories.map((v) => DropdownMenuItem(value: v, child: Text(v == 'Semua' ? v : v.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _category = v ?? 'Semua'),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', isDense: true, border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                      DropdownMenuItem(value: 'Aktif', child: Text('Aktif')),
                      DropdownMenuItem(value: 'Nonaktif', child: Text('Nonaktif')),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? 'Semua'),
                  )),
                ]),
              ],
            )
          else Row(
            children: [
              const Expanded(
                child: Text(
                  'Semua Berita & Pengumuman',
                  style: TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Cari berita...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 175,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text(v == 'Semua' ? v : v.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? 'Semua'),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 155,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                    DropdownMenuItem(value: 'Aktif', child: Text('Aktif')),
                    DropdownMenuItem(
                      value: 'Nonaktif',
                      child: Text('Nonaktif'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'Semua'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (listRows.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Center(
                child: Text(
                  'Tidak ada berita yang cocok dengan filter.',
                  style: TextStyle(color: _muted),
                ),
              ),
            )
          else
            ...listRows.map(_newsRow),
        ],
      ),
    );
  }
}
