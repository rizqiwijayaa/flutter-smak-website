part of '../admin_dashboard_page.dart';

class AdminStrukturOrganisasiPage extends StatefulWidget {
  const AdminStrukturOrganisasiPage({super.key, required this.api});
  final SmakApi api;

  @override
  State<AdminStrukturOrganisasiPage> createState() =>
      _AdminStrukturOrganisasiPageState();
}

class _AdminStrukturOrganisasiPageState
    extends State<AdminStrukturOrganisasiPage> {
  SmakApi get _api => widget.api;

  final _heroTitle = TextEditingController(text: 'Struktur Organisasi');
  final _heroDescription = TextEditingController(
    text:
        'Mengenal para pendidik dan tenaga kependidikan yang melayani serta membangun SMAK.',
  );

  String _banner = '';
  int? _mainId;
  bool _loading = true;
  bool _saving = false;

  final List<_OrgNode> _nodes = [];
  final List<_OrgPerson> _leaders = [];
  final List<_OrgPerson> _teachers = [];
  final List<_OrgPerson> _employees = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _heroTitle.dispose();
    _heroDescription.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        _api.getTable('struktur_utama', limit: 1),
        _api.getTable('struktur_bagan', limit: 100),
        _api.getTable('struktur_pimpinan', limit: 100),
        _api.getTable('struktur_guru', limit: 100),
        _api.getTable('struktur_karyawan', limit: 100),
      ]);
      final main = results[0];
      if (main.isNotEmpty) {
        final row = main.first;
        _mainId = int.tryParse('${row['id'] ?? ''}');
        _heroTitle.text = '${row['judul'] ?? _heroTitle.text}';
        _heroDescription.text = '${row['deskripsi'] ?? _heroDescription.text}';
        _banner = '${row['banner'] ?? ''}';
      }
      _nodes
        ..clear()
        ..addAll(results[1].map(_OrgNode.fromRow));
      _leaders
        ..clear()
        ..addAll(results[2].map(_OrgPerson.fromLeaderRow));
      _teachers
        ..clear()
        ..addAll(results[3].map(_OrgPerson.fromTeacherRow));
      _employees
        ..clear()
        ..addAll(results[4].map(_OrgPerson.fromEmployeeRow));
    } catch (e) {
      _message('Gagal memuat data Struktur Organisasi: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<String?> _pickPhoto(String table) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return null;
    return _api.uploadFile(table, input.files!.first);
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _saveMain() async {
    setState(() => _saving = true);
    try {
      await _api.save('struktur_utama', {
        'judul': _heroTitle.text.trim(),
        'deskripsi': _heroDescription.text.trim(),
        'banner': _banner,
        'status': 'aktif',
      }, id: _mainId);
      await _load();
      _message('Perubahan berhasil disimpan.');
    } catch (e) {
      _message('Gagal menyimpan: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _confirmDelete(String text) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hapus data?'),
            content: Text('"$text" akan dihapus dari daftar.'),
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
        ) ??
        false;
  }

  Future<void> _editPerson(
    List<_OrgPerson> list, {
    _OrgPerson? person,
    bool teacher = false,
  }) async {
    final name = TextEditingController(text: person?.name ?? '');
    final role = TextEditingController(text: person?.role ?? '');
    final detail = TextEditingController(text: person?.detail ?? '');
    String group = person?.group.isNotEmpty == true
        ? person!.group
        : 'Guru Mata Pelajaran';
    String image = person?.image ?? '';

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, localSetState) => AlertDialog(
          title: Text(person == null ? 'Tambah Personel' : 'Edit Personel'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _avatar(image, 74),
                      const SizedBox(width: 14),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uploaded = await _pickPhoto(
                            teacher ? 'struktur_guru' : _personTable(list),
                          );
                          if (uploaded != null)
                            localSetState(() => image = uploaded);
                        },
                        icon: const Icon(Icons.upload_rounded),
                        label: Text(
                          image.isEmpty ? 'Pilih Foto' : 'Ganti Foto',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AdminContentTextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: role,
                    decoration: InputDecoration(
                      labelText: teacher
                          ? 'Mata Pelajaran / Jabatan'
                          : 'Jabatan',
                    ),
                  ),
                  if (!teacher) ...[
                    const SizedBox(height: 12),
                    AdminContentTextField(
                      controller: detail,
                      decoration: const InputDecoration(
                        labelText: 'Bidang / Keterangan',
                      ),
                    ),
                  ],
                  if (teacher) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: group,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Guru Mata Pelajaran',
                          child: Text('Guru Mata Pelajaran'),
                        ),
                        DropdownMenuItem(
                          value: 'Wali Kelas',
                          child: Text('Wali Kelas'),
                        ),
                        DropdownMenuItem(
                          value: 'Bimbingan Konseling',
                          child: Text('Bimbingan Konseling'),
                        ),
                      ],
                      onChanged: (v) => localSetState(() => group = v ?? group),
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

    if (ok != true || name.text.trim().isEmpty) return;
    try {
      final table = _personTable(list);
      await _api.save(table, {
        'nama': name.text.trim(),
        if (teacher) ...{
          'mata_pelajaran': role.text.trim(),
          'kategori': group,
        } else ...{
          'jabatan': role.text.trim(),
          if (table == 'struktur_pimpinan') 'keterangan': detail.text.trim(),
        },
        'gambar': image,
        'urutan': person?.order ?? list.length + 1,
        'status': 'aktif',
      }, id: person?.id);
      await _load();
      _message('Data personel berhasil disimpan.');
    } catch (e) {
      _message('Gagal menyimpan personel: $e');
    }
  }

  String _personTable(List<_OrgPerson> list) {
    if (identical(list, _leaders)) return 'struktur_pimpinan';
    if (identical(list, _teachers)) return 'struktur_guru';
    return 'struktur_karyawan';
  }

  Future<void> _deletePerson(List<_OrgPerson> list, _OrgPerson person) async {
    if (!await _confirmDelete(person.name)) return;
    try {
      if (person.id != null) await _api.delete(_personTable(list), person.id!);
      await _load();
      _message('Data personel berhasil dihapus.');
    } catch (e) {
      _message('Gagal menghapus personel: $e');
    }
  }

  Future<void> _editNode({_OrgNode? node}) async {
    final role = TextEditingController(text: node?.role ?? '');
    final name = TextEditingController(text: node?.name ?? '');
    String image = node?.image ?? '';
    int level = node?.level ?? 1;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, localSetState) => AlertDialog(
          title: Text(node == null ? 'Tambah Posisi' : 'Edit Posisi'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _avatar(image, 74),
                      const SizedBox(width: 14),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uploaded = await _pickPhoto('struktur_bagan');
                          if (uploaded != null) {
                            localSetState(() => image = uploaded);
                          }
                        },
                        icon: const Icon(Icons.upload_rounded),
                        label: Text(
                          image.isEmpty ? 'Pilih Foto' : 'Ganti Foto',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AdminContentTextField(
                    controller: role,
                    decoration: const InputDecoration(
                      labelText: 'Nama Jabatan',
                    ),
                  ),
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Personel',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: level,
                    decoration: const InputDecoration(
                      labelText: 'Tingkat Bagan',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Level 1 - Paling Atas'),
                      ),
                      DropdownMenuItem(value: 1, child: Text('Level 2')),
                      DropdownMenuItem(value: 2, child: Text('Level 3')),
                      DropdownMenuItem(value: 3, child: Text('Level 4')),
                    ],
                    onChanged: (v) => localSetState(() => level = v ?? level),
                  ),
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

    if (ok != true || role.text.trim().isEmpty) return;
    try {
      await _api.save('struktur_bagan', {
        'nama': name.text.trim(),
        'jabatan': role.text.trim(),
        'gambar': image,
        'icon': node?.icon ?? '',
        'level_bagan': level,
        'tampil_foto': image.isNotEmpty ? 1 : 0,
        'urutan': node?.order ?? _nodes.length + 1,
        'status': 'aktif',
      }, id: node?.id);
      await _load();
      _message('Data bagan berhasil disimpan.');
    } catch (e) {
      _message('Gagal menyimpan bagan: $e');
    }
  }

  Future<void> _deleteNode(_OrgNode node) async {
    if (!await _confirmDelete(node.role)) return;
    try {
      if (node.id != null) await _api.delete('struktur_bagan', node.id!);
      await _load();
      _message('Data bagan berhasil dihapus.');
    } catch (e) {
      _message('Gagal menghapus bagan: $e');
    }
  }

  /*
   * CRUD di atas memakai tabel struktur_* langsung. Blok widget di bawah
   * dipertahankan agar desain dashboard tidak berubah.
   */
  /*
    final newData = _OrgPerson(
        name: name.text.trim(),
        role: role.text.trim(),
        detail: detail.text.trim(),
        group: teacher ? group : '',
        image: image,
      );
      if (person == null) {
        list.add(newData);
      } else {
        final index = list.indexOf(person);
        if (index >= 0) list[index] = newData;
      }
    });
  }

  Future<void> _deletePerson(List<_OrgPerson> list, _OrgPerson person) async {
    if (!await _confirmDelete(person.name)) return;
    setState(() => list.remove(person));
  }

  Future<void> _editNode({_OrgNode? node}) async {
    final role = TextEditingController(text: node?.role ?? '');
    final name = TextEditingController(text: node?.name ?? '');
    String image = node?.image ?? '';
    int level = node?.level ?? 1;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, localSetState) => AlertDialog(
          title: Text(node == null ? 'Tambah Posisi' : 'Edit Posisi'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _avatar(image, 74),
                      const SizedBox(width: 14),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uploaded = await _pickPhoto(
                            'profil_struktur_organisasi',
                          );
                          if (uploaded != null)
                            localSetState(() => image = uploaded);
                        },
                        icon: const Icon(Icons.upload_rounded),
                        label: Text(
                          image.isEmpty ? 'Pilih Foto' : 'Ganti Foto',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AdminContentTextField(
                    controller: role,
                    decoration: const InputDecoration(
                      labelText: 'Nama Jabatan',
                    ),
                  ),
                  const SizedBox(height: 12),
                  AdminContentTextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Personel',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: level,
                    decoration: const InputDecoration(
                      labelText: 'Tingkat Bagan',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Level 1 — Paling Atas'),
                      ),
                      DropdownMenuItem(value: 1, child: Text('Level 2')),
                      DropdownMenuItem(value: 2, child: Text('Level 3')),
                      DropdownMenuItem(value: 3, child: Text('Level 4')),
                    ],
                    onChanged: (v) => localSetState(() => level = v ?? level),
                  ),
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

    if (ok != true || role.text.trim().isEmpty) return;
    setState(() {
      final newNode = _OrgNode(
        name: name.text.trim(),
        role: role.text.trim(),
        level: level,
        image: image,
      );
      if (node == null) {
        _nodes.add(newNode);
      } else {
        final index = _nodes.indexOf(node);
        if (index >= 0) _nodes[index] = newNode;
      }
    });
  }

  Future<void> _deleteNodeLama(_OrgNode node) async {
    if (!await _confirmDelete(node.role)) return;
    setState(() => _nodes.remove(node));
  }
  */

  Widget _section(int number, String title, String note, {Widget? action}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 27,
          height: 27,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
          child: Text(
            '$number',
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
              Text(note, style: const TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: child,
    );
  }

  Widget _avatar(String image, double size) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE7F0FC),
        border: Border.all(color: const Color(0xFFB7D2F6)),
      ),
      child: websiteContentImage(
        image,
        fit: BoxFit.cover,
        width: size,
        height: size,
      ),
    );
  }

  Widget _chartPreview() {
    final levels = <int, List<_OrgNode>>{};
    for (final node in _nodes) {
      levels.putIfAbsent(node.level, () => []).add(node);
    }
    final keys = levels.keys.toList()..sort();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          for (int i = 0; i < keys.length; i++) ...[
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: levels[keys[i]]!.map((node) {
                return Container(
                  width: node.level == 0 ? 220 : 175,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: node.level == 0 ? _blue : _line,
                      width: node.level == 0 ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (node.level < 3) ...[
                        _avatar(node.image, node.level == 0 ? 54 : 42),
                        const SizedBox(height: 7),
                      ],
                      Text(
                        node.role,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (node.name.isNotEmpty)
                        Text(
                          node.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _text, fontSize: 10),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (i < keys.length - 1)
              Container(
                width: 2,
                height: 24,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: const Color(0xFF76A9F2),
              ),
          ],
        ],
      ),
    );
  }

  Widget _nodeRow(_OrgNode node) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFF),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              'Level ${node.level + 1}',
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
          ),
          _avatar(node.image, 50),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.role,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (node.name.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    node.name,
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: () => _editNode(node: node),
            icon: const Icon(Icons.edit_outlined, color: _blue),
          ),
          IconButton(
            tooltip: 'Hapus',
            onPressed: () => _deleteNode(node),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _personRow(
    List<_OrgPerson> list,
    _OrgPerson person, {
    bool teacher = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFF),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          _avatar(person.image, 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  person.role,
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (person.detail.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    person.detail,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
                if (teacher && person.group.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    person.group,
                    style: const TextStyle(color: _muted, fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: () =>
                _editPerson(list, person: person, teacher: teacher),
            icon: const Icon(Icons.edit_outlined, color: _blue),
          ),
          IconButton(
            tooltip: 'Hapus',
            onPressed: () => _deletePerson(list, person),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _peopleSection(
    int number,
    String title,
    String note,
    List<_OrgPerson> people, {
    bool teacher = false,
    String addLabel = 'Tambah Personel',
  }) {
    return _card(
      Column(
        children: [
          _section(
            number,
            title,
            note,
            action: FilledButton.icon(
              onPressed: () => _editPerson(people, teacher: teacher),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(addLabel),
            ),
          ),
          const SizedBox(height: 6),
          for (final person in people)
            _personRow(people, person, teacher: teacher),
          if (people.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Belum ada data personel.',
                style: TextStyle(color: _muted),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String number, String label) {
    return Container(
      width: 225,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Icon(icon, color: _blue, size: 31),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final total = _leaders.length + _teachers.length + _employees.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 42),
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
                      'Struktur Organisasi',
                      style: TextStyle(
                        color: _text,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Kelola struktur organisasi dan seluruh personel sekolah.',
                      style: TextStyle(color: _muted),
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
                      sharedProfilePages()['struktur']!,
                    ),
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Preview Halaman'),
                  ),
                  FilledButton.icon(
                    onPressed: _saving ? null : _saveMain,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          _card(
            Column(
              children: [
                _section(
                  1,
                  'Banner / Hero',
                  'Kelola banner halaman Struktur Organisasi.',
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 180,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF2FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: websiteContentImage(
                              _banner,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 180,
                            ),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final file = await _pickPhoto('struktur_utama');
                                if (file != null)
                                  setState(() => _banner = file);
                              },
                              icon: const Icon(Icons.upload_rounded),
                              label: const Text('Ganti Banner'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          AdminContentTextField(
                            controller: _heroTitle,
                            decoration: const InputDecoration(
                              labelText: 'Judul',
                            ),
                          ),
                          const SizedBox(height: 12),
                          AdminContentTextField(
                            controller: _heroDescription,
                            minLines: 4,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              labelText: 'Deskripsi',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _card(
            Column(
              children: [
                _section(
                  2,
                  'Bagan Struktur Organisasi',
                  'Preview mindmap tetap terlihat. Tambah, edit, dan hapus posisi langsung di bawah preview.',
                  action: FilledButton.icon(
                    onPressed: () => _editNode(),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Tambah Posisi'),
                  ),
                ),
                const SizedBox(height: 16),
                _chartPreview(),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Data Bagan Struktur',
                    style: TextStyle(
                      color: _text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                for (final node in _nodes) _nodeRow(node),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _peopleSection(
            3,
            'Pimpinan & Koordinator',
            'Data pimpinan ditampilkan langsung dan memanjang ke bawah.',
            _leaders,
            addLabel: 'Tambah Pimpinan',
          ),
          const SizedBox(height: 14),

          _peopleSection(
            4,
            'Guru & Tenaga Pendidik',
            'Tambah, edit, hapus, dan atur foto guru langsung dari halaman ini.',
            _teachers,
            teacher: true,
            addLabel: 'Tambah Guru',
          ),
          const SizedBox(height: 14),

          _peopleSection(
            5,
            'Tenaga Kependidikan & Karyawan',
            'Kelola tenaga administrasi dan operasional sekolah.',
            _employees,
            addLabel: 'Tambah Personel',
          ),
          const SizedBox(height: 14),

          _card(
            Column(
              children: [
                _section(
                  6,
                  'Statistik Personel',
                  'Jumlah dihitung otomatis dari daftar personel di atas.',
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _stat(
                      Icons.school_rounded,
                      '${_teachers.length}',
                      'Guru & Tenaga Pendidik',
                    ),
                    _stat(
                      Icons.work_rounded,
                      '${_employees.length}',
                      'Tenaga Kependidikan',
                    ),
                    _stat(
                      Icons.workspace_premium_rounded,
                      '${_leaders.length}',
                      'Pimpinan & Koordinator',
                    ),
                    _stat(Icons.groups_rounded, '$total', 'Total Personel'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _card(
            Column(
              children: [
                _section(
                  7,
                  'Bersama Melayani dan Mendidik',
                  'Preview CTA penutup halaman.',
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_navy, Color(0xFF075ACB)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.diversity_3_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bersama Melayani dan Mendidik',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Setiap peran menjadi bagian penting dalam menciptakan lingkungan belajar yang unggul dan penuh kasih.',
                              style: TextStyle(
                                color: Color(0xFFE7F1FF),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AdminProfileSectionEditor(
            api: widget.api,
            table: 'struktur_bagian',
            title: 'Bagian Halaman',
            singleton: false,
            fields: const {
              'judul': 'Judul',
              'kode': 'Kode Bagian',
              'deskripsi': 'Deskripsi',
              'rata_tengah': 'Rata Tengah (0 / 1)',
              'urutan': 'Urutan',
            },
          ),
          AdminProfileSectionEditor(
            api: widget.api,
            table: 'struktur_kategori_guru',
            title: 'Kategori Guru',
            singleton: false,
            fields: const {'nama': 'Nama', 'urutan': 'Urutan'},
          ),
          AdminProfileSectionEditor(
            api: widget.api,
            table: 'struktur_statistik',
            title: 'Statistik Frontend',
            singleton: false,
            fields: const {
              'label': 'Label',
              'nilai': 'Nilai',
              'icon': 'Icon',
              'warna': 'Warna (blue / gold)',
              'urutan': 'Urutan',
            },
          ),
          AdminProfileSectionEditor(
            api: widget.api,
            table: 'struktur_cta',
            title: 'CTA Struktur',
            singleton: true,
            fields: const {
              'judul': 'Judul',
              'deskripsi': 'Deskripsi',
              'teks_tombol': 'Teks Tombol',
            },
          ),
        ],
      ),
    );
  }
}

class _OrgPerson {
  const _OrgPerson({
    this.id,
    this.order = 0,
    required this.name,
    required this.role,
    this.detail = '',
    this.group = '',
    this.image = '',
  });

  final int? id;
  final int order;
  final String name;
  final String role;
  final String detail;
  final String group;
  final String image;

  factory _OrgPerson.fromLeaderRow(Map<String, dynamic> row) => _OrgPerson(
    id: int.tryParse('${row['id'] ?? ''}'),
    order: int.tryParse('${row['urutan'] ?? ''}') ?? 0,
    name: '${row['nama'] ?? ''}',
    role: '${row['jabatan'] ?? ''}',
    detail: '${row['keterangan'] ?? ''}',
    image: '${row['gambar'] ?? ''}',
  );

  factory _OrgPerson.fromTeacherRow(Map<String, dynamic> row) => _OrgPerson(
    id: int.tryParse('${row['id'] ?? ''}'),
    order: int.tryParse('${row['urutan'] ?? ''}') ?? 0,
    name: '${row['nama'] ?? ''}',
    role: '${row['mata_pelajaran'] ?? ''}',
    group: '${row['kategori'] ?? ''}',
    image: '${row['gambar'] ?? ''}',
  );

  factory _OrgPerson.fromEmployeeRow(Map<String, dynamic> row) => _OrgPerson(
    id: int.tryParse('${row['id'] ?? ''}'),
    order: int.tryParse('${row['urutan'] ?? ''}') ?? 0,
    name: '${row['nama'] ?? ''}',
    role: '${row['jabatan'] ?? ''}',
    image: '${row['gambar'] ?? ''}',
  );
}

class _OrgNode {
  const _OrgNode({
    this.id,
    this.order = 0,
    required this.name,
    required this.role,
    required this.level,
    this.image = '',
    this.icon = '',
  });

  final int? id;
  final int order;
  final String name;
  final String role;
  final int level;
  final String image;
  final String icon;

  factory _OrgNode.fromRow(Map<String, dynamic> row) => _OrgNode(
    id: int.tryParse('${row['id'] ?? ''}'),
    order: int.tryParse('${row['urutan'] ?? ''}') ?? 0,
    name: '${row['nama'] ?? ''}',
    role: '${row['jabatan'] ?? ''}',
    level: int.tryParse('${row['level_bagan'] ?? ''}') ?? 0,
    image: '${row['gambar'] ?? ''}',
    icon: '${row['icon'] ?? ''}',
  );
}
