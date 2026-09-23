part of '../admin_dashboard_page.dart';

class AdminPenggunaPage extends StatefulWidget {
  const AdminPenggunaPage({super.key, required this.api, required this.module});

  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminPenggunaPage> createState() => _AdminPenggunaPageState();
}

class _AdminPenggunaPageState extends State<AdminPenggunaPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Semua Status';
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUsers();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadUsers() {
    return widget.api.getTable(widget.module.table);
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _loadUsers();
    });
  }

  Future<void> _editUser({Map<String, dynamic>? row}) async {
    final saved = await _openAdminEditor(
      context,
      widget.api,
      widget.module,
      row: row,
    );
    if (mounted && saved == true) _refreshUsers();
  }

  Future<void> _deleteUser(Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) return;
    if (id == 1 || '${row['username'] ?? ''}'.trim().toLowerCase() == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akun Administrator utama tidak dapat dihapus.'),
        ),
      );
      return;
    }
    final name = _displayName(row);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus Pengguna?'),
        content: Text('Akun "$name" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.api.delete(widget.module.table, id);
      if (!mounted) return;
      _refreshUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengguna "$name" berhasil dihapus.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus pengguna: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        final rows = snapshot.data ?? const <Map<String, dynamic>>[];
        final filtered = _filterUsers(rows);
        final totalUsers = rows.length;
        final activeUsers = rows.where(_isUserActive).length;
        final adminUsers = rows.where(_isPrimaryAdmin).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PenggunaHeader(onAdd: () => _editUser()),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 1040;
                if (compact) {
                  return Column(
                    children: [
                      _PenggunaStatCard(
                        title: 'Total Pengguna',
                        value: '$totalUsers',
                        icon: Icons.groups_rounded,
                        accent: const Color(0xFF1463E8),
                        iconBackground: const Color(0xFFEAF2FF),
                      ),
                      const SizedBox(height: 12),
                      _PenggunaStatCard(
                        title: 'Akun Aktif',
                        value: '$activeUsers',
                        icon: Icons.person_add_alt_1_rounded,
                        accent: const Color(0xFF16A34A),
                        iconBackground: const Color(0xFFEAF8EF),
                      ),
                      const SizedBox(height: 12),
                      _PenggunaStatCard(
                        title: 'Admin Utama',
                        value:
                            '${adminUsers == 0 && totalUsers > 0 ? 1 : adminUsers}',
                        icon: Icons.shield_rounded,
                        accent: const Color(0xFF082F63),
                        iconBackground: const Color(0xFFEFF3FA),
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: _PenggunaStatCard(
                        title: 'Total Pengguna',
                        value: '$totalUsers',
                        icon: Icons.groups_rounded,
                        accent: const Color(0xFF1463E8),
                        iconBackground: const Color(0xFFEAF2FF),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _PenggunaStatCard(
                        title: 'Akun Aktif',
                        value: '$activeUsers',
                        icon: Icons.person_add_alt_1_rounded,
                        accent: const Color(0xFF16A34A),
                        iconBackground: const Color(0xFFEAF8EF),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _PenggunaStatCard(
                        title: 'Admin Utama',
                        value:
                            '${adminUsers == 0 && totalUsers > 0 ? 1 : adminUsers}',
                        icon: Icons.shield_rounded,
                        accent: const Color(0xFF082F63),
                        iconBackground: const Color(0xFFEFF3FA),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _PenggunaTableCard(
              api: widget.api,
              searchController: _searchController,
              selectedStatus: _selectedStatus,
              onStatusChanged: (value) {
                setState(() => _selectedStatus = value ?? 'Semua Status');
              },
              onRefresh: _refreshUsers,
              users: filtered,
              totalUsers: rows.length,
              loading: snapshot.connectionState == ConnectionState.waiting,
              onEdit: (row) => _editUser(row: row),
              onDelete: _deleteUser,
            ),
            const SizedBox(height: 14),
            const _PenggunaInfoStrip(),
            const SizedBox(height: 14),
            const _PenggunaSecurityCard(),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _filterUsers(List<Map<String, dynamic>> rows) {
    final keyword = _searchController.text.trim().toLowerCase();
    return rows.where((row) {
      final status = _normalizedStatus(row);
      final searchMatch =
          keyword.isEmpty ||
          _displayName(row).toLowerCase().contains(keyword) ||
          _username(row).toLowerCase().contains(keyword);
      final statusMatch =
          _selectedStatus == 'Semua Status' ||
          (_selectedStatus == 'Aktif' && status == 'aktif') ||
          (_selectedStatus == 'Nonaktif' && status != 'aktif');
      return searchMatch && statusMatch;
    }).toList();
  }

  bool _isUserActive(Map<String, dynamic> row) =>
      _normalizedStatus(row) == 'aktif';

  bool _isPrimaryAdmin(Map<String, dynamic> row) {
    final role = _displayRole(row).toLowerCase();
    final username = _username(row).toLowerCase();
    return role.contains('admin') || username == 'admin';
  }

  String _displayName(Map<String, dynamic> row) {
    for (final key in ['nama', 'name', 'nama_lengkap', 'full_name']) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    final username = _username(row);
    return username.isEmpty ? 'Administrator' : _titleCase(username);
  }

  String _username(Map<String, dynamic> row) {
    for (final key in ['username', 'email', 'user_name']) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return 'admin';
  }

  String _displayRole(Map<String, dynamic> row) {
    for (final key in ['peran', 'role', 'jabatan']) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return _titleCase(value.replaceAll('_', ' '));
    }
    return 'Administrator';
  }

  String _normalizedStatus(Map<String, dynamic> row) {
    final status = '${row['status'] ?? row['is_active'] ?? row['active'] ?? ''}'
        .trim()
        .toLowerCase();
    if (status == '1' ||
        status == 'true' ||
        status == 'aktif' ||
        status == 'active') {
      return 'aktif';
    }
    if (status.isEmpty) return 'aktif';
    return 'nonaktif';
  }

  String _statusLabel(Map<String, dynamic> row) =>
      _normalizedStatus(row) == 'aktif' ? 'Aktif' : 'Nonaktif';

  String _lastLogin(Map<String, dynamic> row) {
    for (final key in [
      'last_login',
      'login_terakhir',
      'updated_at',
      'last_seen',
      'created_at',
    ]) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return 'Belum ada data';
  }

  String _userId(Map<String, dynamic> row) => '${row['id'] ?? '-'}';

  String _initials(Map<String, dynamic> row) {
    final name = _displayName(row).trim();
    if (name.isEmpty) return 'AD';
    final parts = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.length == 1) {
      final word = parts.first;
      return word.length >= 2
          ? word.substring(0, 2).toUpperCase()
          : word.toUpperCase();
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  String _titleCase(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }
}

class _PenggunaHeader extends StatelessWidget {
  const _PenggunaHeader({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengguna',
                style: TextStyle(
                  color: Color(0xFF082E65),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kelola akun administrator',
                style: TextStyle(color: Color(0xFF60718A), fontSize: 13),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Pengguna'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1463E8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _PenggunaStatCard extends StatelessWidget {
  const _PenggunaStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.iconBackground,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EBF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08082E65),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent, size: 38),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF60718A), fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF082E65),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PenggunaTableCard extends StatelessWidget {
  const _PenggunaTableCard({
    required this.api,
    required this.searchController,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onRefresh,
    required this.users,
    required this.totalUsers,
    required this.loading,
    required this.onEdit,
    required this.onDelete,
  });

  final SmakApi api;
  final TextEditingController searchController;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onRefresh;
  final List<Map<String, dynamic>> users;
  final int totalUsers;
  final bool loading;
  final ValueChanged<Map<String, dynamic>> onEdit;
  final ValueChanged<Map<String, dynamic>> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EBF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08082E65),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 920;
              final heading = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Pengguna',
                    style: TextStyle(
                      color: Color(0xFF17243A),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalUsers pengguna terdaftar',
                    style: const TextStyle(
                      color: Color(0xFF60718A),
                      fontSize: 13,
                    ),
                  ),
                ],
              );
              final filters = Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: compact ? constraints.maxWidth : 400,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari nama atau username...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9E3F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9E3F0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: compact ? constraints.maxWidth : 290,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'Semua Status',
                          child: Text('Semua Status'),
                        ),
                        DropdownMenuItem(value: 'Aktif', child: Text('Aktif')),
                        DropdownMenuItem(
                          value: 'Nonaktif',
                          child: Text('Nonaktif'),
                        ),
                      ],
                      onChanged: onStatusChanged,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9E3F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9E3F0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: onRefresh,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFFD9E3F0)),
                    ),
                    child: const Icon(Icons.refresh_rounded),
                  ),
                ],
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [heading, const SizedBox(height: 16), filters],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: 20),
                  Flexible(flex: 2, child: filters),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE4EBF4)),
            ),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(28),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : users.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(28),
                    child: Text(
                      'Belum ada pengguna yang sesuai filter.',
                      style: TextStyle(color: Color(0xFF60718A)),
                    ),
                  )
                : Column(
                    children: [
                      const _PenggunaTableHeader(),
                      const Divider(height: 1, color: Color(0xFFE8EEF6)),
                      ...users.map(
                        (row) => _PenggunaTableRow(
                          api: api,
                          row: row,
                          onEdit: () => onEdit(row),
                          onDelete: () => onDelete(row),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(14),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Menampilkan ${users.length} dari $totalUsers pengguna',
                              style: const TextStyle(
                                color: Color(0xFF60718A),
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            _PaginationButton(
                              icon: Icons.chevron_left_rounded,
                              enabled: false,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1463E8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _PaginationButton(
                              icon: Icons.chevron_right_rounded,
                              enabled: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _PenggunaTableHeader extends StatelessWidget {
  const _PenggunaTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      color: const Color(0xFFFBFCFE),
      child: const Row(
        children: [
          Expanded(flex: 28, child: _TableTitle('PENGGUNA')),
          Expanded(flex: 18, child: _TableTitle('USERNAME')),
          Expanded(flex: 18, child: _TableTitle('PERAN')),
          Expanded(flex: 15, child: _TableTitle('STATUS')),
          Expanded(flex: 20, child: _TableTitle('LOGIN TERAKHIR')),
          Expanded(flex: 11, child: _TableTitle('AKSI')),
        ],
      ),
    );
  }
}

class _PenggunaTableRow extends StatelessWidget {
  const _PenggunaTableRow({
    required this.api,
    required this.row,
    required this.onEdit,
    required this.onDelete,
  });

  final SmakApi api;
  final Map<String, dynamic> row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _displayName() {
    for (final key in ['nama', 'name', 'nama_lengkap', 'full_name']) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    final username = _username();
    return username.isEmpty ? 'Administrator' : _titleCase(username);
  }

  String _username() {
    for (final key in ['username', 'email', 'user_name']) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return 'admin';
  }

  String _role() {
    for (final key in ['peran', 'role', 'jabatan']) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return _titleCase(value.replaceAll('_', ' '));
    }
    return 'Administrator';
  }

  bool _active() {
    final status = '${row['status'] ?? row['is_active'] ?? row['active'] ?? ''}'
        .trim()
        .toLowerCase();
    return status.isEmpty ||
        status == '1' ||
        status == 'true' ||
        status == 'aktif' ||
        status == 'active';
  }

  String _lastLogin() {
    for (final key in [
      'last_login',
      'login_terakhir',
      'updated_at',
      'last_seen',
      'created_at',
    ]) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty) return value;
    }
    return 'Belum ada data';
  }

  String _initials() {
    final name = _displayName();
    final parts = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.length == 1) {
      return parts.first.length >= 2
          ? parts.first.substring(0, 2).toUpperCase()
          : parts.first.toUpperCase();
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  String _titleCase(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final active = _active();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE8EEF6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 28,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFEAF2FF),
                  child: ClipOval(
                    child: '${row['foto'] ?? ''}'.trim().isEmpty
                        ? _UserInitialsAvatar(initials: _initials())
                        : websiteContentImage(
                            '${row['foto']}'.trim(),
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayName(),
                      style: const TextStyle(
                        color: Color(0xFF17243A),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${row['id'] ?? '-'}',
                      style: const TextStyle(
                        color: Color(0xFF60718A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 18,
            child: Text(
              _username(),
              style: const TextStyle(color: Color(0xFF46576D), fontSize: 14),
            ),
          ),
          Expanded(
            flex: 18,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _UserPill(
                label: _role(),
                textColor: const Color(0xFF1463E8),
                background: const Color(0xFFEAF2FF),
              ),
            ),
          ),
          Expanded(
            flex: 15,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _UserPill(
                label: active ? 'Aktif' : 'Nonaktif',
                textColor: active
                    ? const Color(0xFF169B53)
                    : const Color(0xFF6C7B90),
                background: active
                    ? const Color(0xFFEAF8EF)
                    : const Color(0xFFF0F3F7),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Text(
              _lastLogin(),
              style: const TextStyle(color: Color(0xFF46576D), fontSize: 14),
            ),
          ),
          Expanded(
            flex: 11,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: FilledButton(
                      onPressed: onEdit,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1463E8),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Icon(Icons.edit_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: PopupMenuButton<String>(
                      tooltip: 'Aksi lainnya',
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        if (value == 'delete') onDelete();
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem<String>(
                          value: 'delete',
                          enabled:
                              !(int.tryParse('${row['id'] ?? ''}') == 1 ||
                                  _username().toLowerCase() == 'admin'),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text('Hapus Pengguna'),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD9E3F0)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.more_vert_rounded, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserInitialsAvatar extends StatelessWidget {
  const _UserInitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Color(0xFF1463E8),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class _TableTitle extends StatelessWidget {
  const _TableTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF3F516A),
        fontSize: 12.5,
        fontWeight: FontWeight.w800,
        letterSpacing: .25,
      ),
    );
  }
}

class _UserPill extends StatelessWidget {
  const _UserPill({
    required this.label,
    required this.textColor,
    required this.background,
  });

  final String label;
  final Color textColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({required this.icon, required this.enabled});

  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9E3F0)),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: enabled ? const Color(0xFF60718A) : const Color(0xFFB7C2D0),
      ),
    );
  }
}

class _PenggunaInfoStrip extends StatelessWidget {
  const _PenggunaInfoStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4E5FB)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_rounded, color: Color(0xFF1463E8)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Akun administrator memiliki akses ke seluruh pengelolaan website. Pastikan hanya pengguna resmi yang diberikan akses.',
              style: TextStyle(
                color: Color(0xFF35567E),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PenggunaSecurityCard extends StatelessWidget {
  const _PenggunaSecurityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EBF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08082E65),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Keamanan Akun',
            style: TextStyle(
              color: Color(0xFF17243A),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 860;
              final left = const _SecurityHintItem(
                icon: Icons.lock_rounded,
                title: 'Gunakan password yang kuat',
                description:
                    'Gunakan kombinasi huruf besar, kecil, angka, dan simbol.',
              );
              final right = const _SecurityHintItem(
                icon: Icons.person_off_rounded,
                title: 'Nonaktifkan akun yang tidak digunakan',
                description:
                    'Nonaktifkan akun jika tidak lagi diperlukan untuk menjaga keamanan.',
              );
              if (compact) {
                return Column(
                  children: [left, const SizedBox(height: 18), right],
                );
              }
              return Row(
                children: [
                  Expanded(child: left),
                  const SizedBox(width: 22),
                  Expanded(child: right),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SecurityHintItem extends StatelessWidget {
  const _SecurityHintItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF1463E8), size: 30),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF17243A),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF60718A),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
