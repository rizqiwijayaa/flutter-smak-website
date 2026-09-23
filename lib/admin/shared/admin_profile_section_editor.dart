part of '../admin_dashboard_page.dart';

/// Editors for the existing auxiliary Sejarah/Struktur content tables.
class AdminProfileSectionEditor extends StatefulWidget {
  const AdminProfileSectionEditor({
    super.key,
    required this.api,
    required this.table,
    required this.title,
    required this.fields,
    this.singleton = false,
  });
  final SmakApi api;
  final String table;
  final String title;
  final Map<String, String> fields;
  final bool singleton;
  @override
  State<AdminProfileSectionEditor> createState() =>
      _AdminProfileSectionEditorState();
}

class _AdminProfileSectionEditorState extends State<AdminProfileSectionEditor> {
  late Future<List<Map<String, dynamic>>> _rows;
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _rows = widget.api.getTable(widget.table, limit: 100);
  }

  Future<void> _edit(Map<String, dynamic>? row) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => _ProfileSectionDialog(
        api: widget.api,
        table: widget.table,
        title: widget.title,
        fields: widget.fields,
        row: row,
      ),
    );
    if (changed == true && mounted) setState(_refresh);
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id']}');
    if (id == null || id <= 0) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus konten?'),
        content: Text('${row[widget.fields.keys.first] ?? ''}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await widget.api.delete(widget.table, id);
      if (mounted) setState(_refresh);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Konten gagal dihapus.')));
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 14),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _line),
    ),
    child: FutureBuilder<List<Map<String, dynamic>>>(
      future: _rows,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return TextButton(
            onPressed: () => setState(_refresh),
            child: const Text('Coba Lagi'),
          );
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final rows = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!widget.singleton || rows.isEmpty)
                  TextButton.icon(
                    onPressed: () => _edit(null),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
              ],
            ),
            for (final row in rows)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${row[widget.fields.keys.first] ?? ''}'),
                subtitle: Text(
                  '${row['deskripsi'] ?? row['nilai'] ?? row['peran'] ?? ''}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit ${widget.title}',
                      onPressed: () => _edit(row),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    if (!widget.singleton)
                      IconButton(
                        tooltip: 'Hapus ${widget.title}',
                        onPressed: () => _delete(row),
                        icon: const Icon(Icons.delete_outline),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    ),
  );
}

class _ProfileSectionDialog extends StatefulWidget {
  const _ProfileSectionDialog({
    required this.api,
    required this.table,
    required this.title,
    required this.fields,
    this.row,
  });
  final SmakApi api;
  final String table, title;
  final Map<String, String> fields;
  final Map<String, dynamic>? row;
  @override
  State<_ProfileSectionDialog> createState() => _ProfileSectionDialogState();
}

class _ProfileSectionDialogState extends State<_ProfileSectionDialog> {
  late final Map<String, TextEditingController> _fields;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _fields = {
      for (final key in widget.fields.keys)
        key: TextEditingController(text: '${widget.row?[key] ?? ''}'),
    };
  }

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _upload() async {
    final input = html.FileUploadInputElement()
      ..accept = 'image/jpeg,image/png,image/webp';
    input.click();
    await input.onChange.first;
    if (input.files?.isEmpty ?? true) return;
    setState(() => _busy = true);
    try {
      final filename = await widget.api.uploadFile(
        widget.table,
        input.files!.first,
      );
      if (mounted) _fields['gambar']!.text = filename;
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gambar gagal diunggah.')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    final id = int.tryParse('${widget.row?['id'] ?? ''}');
    if (widget.row != null && (id == null || id <= 0)) return;
    final data = <String, dynamic>{
      for (final entry in _fields.entries) entry.key: entry.value.text.trim(),
    };
    if ('${data[widget.fields.keys.first]}'.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi judul atau nama.')),
      );
      return;
    }
    for (final key in ['urutan', 'rata_tengah']) {
      if (data.containsKey(key)) {
        final value = int.tryParse('${data[key]}');
        if (value == null && '${data[key]}'.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Isikan angka yang valid.')),
          );
          return;
        }
        data[key] = value ?? 0;
      }
    }
    setState(() => _busy = true);
    try {
      // Update only the explicitly edited columns, preserving other existing data.
      await widget.api.save(widget.table, {
        ...data,
        if (widget.row == null) 'status': 'aktif',
      }, id: id);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Konten gagal disimpan.')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in widget.fields.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AdminContentTextField(
                  controller: _fields[entry.key],
                  maxLines: entry.key == 'deskripsi' ? 4 : 1,
                  decoration: InputDecoration(
                    labelText: entry.value,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            if (_fields.containsKey('gambar'))
              OutlinedButton.icon(
                onPressed: _busy ? null : _upload,
                icon: const Icon(Icons.upload),
                label: const Text('Pilih Gambar'),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _busy ? null : () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: _busy ? null : _save,
        child: Text(_busy ? 'Menyimpan...' : 'Simpan'),
      ),
    ],
  );
}
