part of '../admin_dashboard_page.dart';

/// CRUD konten untuk setiap subhalaman Profil.
/// Komponen CRUD bersama untuk tabel konten Profil yang memiliki struktur sama.
class AdminProfileContentPage extends StatefulWidget {
  const AdminProfileContentPage({
    super.key,
    required this.api,
    required this.section,
    required this.table,
  });

  final SmakApi api;
  final String section;
  final String table;

  @override
  State<AdminProfileContentPage> createState() =>
      _AdminProfileContentPageState();
}

class _AdminProfileContentPageState extends State<AdminProfileContentPage> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadItems();
  }

  @override
  void didUpdateWidget(covariant AdminProfileContentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section != widget.section) _refresh();
  }

  Future<List<Map<String, dynamic>>> _loadItems() async {
    return widget.api.getTable(widget.table, limit: 100);
  }

  void _refresh() => setState(() => _itemsFuture = _loadItems());

  Future<void> _openEditor([Map<String, dynamic>? row]) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => _ProfileContentEditor(
        api: widget.api,
        section: widget.section,
        table: widget.table,
        row: row,
      ),
    );
    if (changed == true) _refresh();
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus konten?'),
        content: Text('"${row['judul'] ?? 'Konten ini'}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    try {
      await widget.api.delete(widget.table, id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konten berhasil dihapus.')),
      );
      _refresh();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus konten: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.section,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Kelola informasi yang ditampilkan pada halaman profil sekolah.',
                    style: TextStyle(color: _muted),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openEditor(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Konten'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _itemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 260,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return _ProfileContentEmpty(
                icon: Icons.storage_outlined,
                title: 'Tabel profil belum siap',
                description:
                    'Tabel profil sekolah belum dapat diakses. Muat ulang halaman ini.',
                onRefresh: _refresh,
              );
            }
            final items = snapshot.data ?? const [];
            if (items.isEmpty) {
              return _ProfileContentEmpty(
                icon: Icons.article_outlined,
                title: 'Belum ada konten',
                description:
                    'Tambahkan konten pertama untuk ${widget.section}.',
                onRefresh: () => _openEditor(),
              );
            }
            return Column(
              children: items
                  .map(
                    (row) => _ProfileContentCard(
                      row: row,
                      onEdit: () => _openEditor(row),
                      onDelete: () => _delete(row),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ProfileContentCard extends StatelessWidget {
  const _ProfileContentCard({
    required this.row,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final active = '${row['status'] ?? 'aktif'}' == 'aktif';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.article_rounded, color: _blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${row['judul'] ?? 'Tanpa judul'}',
                  style: const TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${row['isi'] ?? ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, height: 1.45),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFE8F8EF)
                        : const Color(0xFFF0F3F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    active ? 'Aktif' : 'Draft',
                    style: TextStyle(
                      color: active ? const Color(0xFF169B53) : _muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: _blue),
          ),
          IconButton(
            tooltip: 'Hapus',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class _ProfileContentEmpty extends StatelessWidget {
  const _ProfileContentEmpty({
    required this.icon,
    required this.title,
    required this.description,
    required this.onRefresh,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(42),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Column(
      children: [
        Icon(icon, color: _blue, size: 42),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(color: _text, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(description, textAlign: TextAlign.center, style: const TextStyle(color: _muted)),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Coba Lagi'),
        ),
      ],
    ),
  );
}

class _ProfileContentEditor extends StatefulWidget {
  const _ProfileContentEditor({
    required this.api,
    required this.section,
    required this.table,
    this.row,
  });

  final SmakApi api;
  final String section;
  final String table;
  final Map<String, dynamic>? row;

  @override
  State<_ProfileContentEditor> createState() => _ProfileContentEditorState();
}

class _ProfileContentEditorState extends State<_ProfileContentEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _content;
  late String _status;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: '${widget.row?['judul'] ?? ''}');
    _content = TextEditingController(text: '${widget.row?['isi'] ?? ''}');
    _status = '${widget.row?['status'] ?? 'aktif'}' == 'aktif'
        ? 'aktif'
        : 'draft';
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      await widget.api.save(
        widget.table,
        {
          'judul': _title.text.trim(),
          'isi': _content.text.trim(),
          'status': _status == 'aktif' ? 'aktif' : 'nonaktif',
        },
        id: int.tryParse('${widget.row?['id'] ?? ''}'),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.row == null ? 'Tambah ${widget.section}' : 'Edit Konten'),
    content: SizedBox(
      width: 560,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AdminContentFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
              validator: (value) => value == null || value.trim().isEmpty ? 'Judul wajib diisi.' : null,
            ),
            const SizedBox(height: 14),
            AdminContentFormField(
              controller: _content,
              minLines: 5,
              maxLines: 8,
              decoration: const InputDecoration(labelText: 'Isi konten', alignLabelWithHint: true, border: OutlineInputBorder()),
              validator: (value) => value == null || value.trim().isEmpty ? 'Isi konten wajib diisi.' : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'aktif', child: Text('Aktif')),
                DropdownMenuItem(value: 'draft', child: Text('Draft')),
              ],
              onChanged: (value) => setState(() => _status = value ?? 'draft'),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Batal')),
      FilledButton.icon(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.save_outlined),
        label: const Text('Simpan'),
      ),
    ],
  );
}
