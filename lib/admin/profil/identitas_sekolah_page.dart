part of '../admin_dashboard_page.dart';

class AdminIdentitasSekolahCrudPage extends StatefulWidget {
  const AdminIdentitasSekolahCrudPage({super.key, required this.api});

  final SmakApi api;

  @override
  State<AdminIdentitasSekolahCrudPage> createState() =>
      _AdminIdentitasSekolahCrudPageState();
}

class _AdminIdentitasSekolahCrudPageState
    extends State<AdminIdentitasSekolahCrudPage> {
  late Future<Map<String, dynamic>?> _identityFuture;

  @override
  void initState() {
    super.initState();
    _identityFuture = _loadIdentity();
  }

  Future<Map<String, dynamic>?> _loadIdentity() async {
    final rows = await widget.api.getTable('profil_identitas', limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  void _refresh() => setState(() => _identityFuture = _loadIdentity());

  Future<void> _edit(Map<String, dynamic>? row) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _IdentitySchoolEditor(api: widget.api, row: row),
    );
    if (saved == true) _refresh();
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus identitas sekolah?'),
        content: const Text('Data identitas akan dihapus dari database.'),
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
      await widget.api.delete('profil_identitas', id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data identitas berhasil dihapus.')),
      );
      _refresh();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus data: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>?>(
    future: _identityFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const SizedBox(
          height: 480,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (snapshot.hasError) {
        return _IdentitySetupNotice(onRetry: _refresh);
      }
      final row = snapshot.data;
      if (row == null) {
        return _IdentityEmptyState(onAdd: () => _edit(null));
      }
      return _IdentitySchoolDashboard(
        row: row,
        onEdit: () => _edit(row),
        onDelete: () => _delete(row),
      );
    },
  );
}

class _IdentitySchoolDashboard extends StatelessWidget {
  const _IdentitySchoolDashboard({
    required this.row,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _value(String key, [String fallback = '-']) {
    final value = '${row[key] ?? ''}'.trim();
    return value.isEmpty ? fallback : value;
  }

  @override
  Widget build(BuildContext context) {
    final updated = _value('updated_at', 'Belum tercatat');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Identitas Sekolah',
                    style: TextStyle(
                      color: _text,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Kelola informasi yang ditampilkan pada halaman profil sekolah.',
                    style: TextStyle(color: _muted),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openAdminPreview(
                    context,
                    const IdentitasSekolahPage(),
                  ),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview Halaman'),
                ),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Hapus'),
                ),
                FilledButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Identitas'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _IdentityMetricCard(
                icon: Icons.assignment_rounded,
                iconColor: _blue,
                label: 'Kelengkapan Profil',
                value: '${_completion(row)}%',
                note: 'Informasi sekolah sudah diisi',
              ),
              _IdentityMetricCard(
                icon: Icons.calendar_month_rounded,
                iconColor: const Color(0xFF16A765),
                label: 'Terakhir Diperbarui',
                value: updated,
                note: 'Data dari database',
              ),
              _IdentityMetricCard(
                icon: Icons.verified_user_rounded,
                iconColor: const Color(0xFF8B46D9),
                label: 'Status Tampilan',
                value: _value('status_tampil', 'Ditampilkan'),
                note: 'Informasi ini tampil di website',
              ),
            ];
            if (constraints.maxWidth < 860) {
              return Column(
                children: cards
                    .map(
                      (card) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: card,
                      ),
                    )
                    .toList(),
              );
            }
            return Row(
              children: cards
                  .map(
                    (card) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: card,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        _IdentityPanel(
          title: 'Informasi Utama Sekolah',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final information = Column(
                children: [
                  _IdentityRow(
                    Icons.account_balance_rounded,
                    'Nama Sekolah',
                    _value('nama_sekolah'),
                  ),
                  _IdentityRow(
                    Icons.location_on_outlined,
                    'Alamat',
                    _value('alamat'),
                  ),
                  _IdentityRow(
                    Icons.phone_outlined,
                    'Telepon',
                    _value('telepon'),
                  ),
                  _IdentityRow(
                    Icons.mail_outline_rounded,
                    'Email',
                    _value('email'),
                  ),
                  _IdentityRow(
                    Icons.workspace_premium_outlined,
                    'Akreditasi',
                    _value('akreditasi'),
                  ),
                  _IdentityRow(
                    Icons.domain_outlined,
                    'Status Sekolah',
                    _value('status_sekolah'),
                  ),
                  _IdentityRow(
                    Icons.language_rounded,
                    'Website',
                    _value('website'),
                  ),
                ],
              );
              final emblem = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_sekolah.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.school_rounded,
                      color: _blue,
                      size: 94,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '"${_value('motto_sekolah', 'Membentuk pribadi beriman, berilmu, berkarakter, dan berprestasi.')}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _blue,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
              if (constraints.maxWidth < 820) {
                return Column(
                  children: [information, const SizedBox(height: 20), emblem],
                );
              }
              return Row(
                children: [
                  Expanded(flex: 6, child: information),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: emblem),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final official = _IdentityPanel(
              title: 'Identitas Resmi',
              child: Column(
                children: [
                  _IdentityRow(Icons.badge_outlined, 'NPSN', _value('npsn')),
                  _IdentityRow(Icons.tag_rounded, 'NSS', _value('nss')),
                  _IdentityRow(
                    Icons.school_outlined,
                    'Jenjang Pendidikan',
                    _value('jenjang_pendidikan'),
                  ),
                  _IdentityRow(
                    Icons.account_balance_outlined,
                    'Status Kepemilikan',
                    _value('status_kepemilikan'),
                  ),
                  _IdentityRow(
                    Icons.business_outlined,
                    'Kementerian',
                    _value('kementerian'),
                  ),
                  _IdentityRow(
                    Icons.groups_outlined,
                    'Yayasan',
                    _value('yayasan'),
                  ),
                  _IdentityRow(
                    Icons.location_city_outlined,
                    'RT / RW',
                    _value('rt_rw'),
                  ),
                  _IdentityRow(
                    Icons.markunread_mailbox_outlined,
                    'Kode Pos',
                    _value('kode_pos'),
                  ),
                ],
              ),
            );
            final additional = _IdentityPanel(
              title: 'Informasi Tambahan',
              child: Column(
                children: [
                  _IdentityRow(
                    Icons.person_outline_rounded,
                    'Kepala Sekolah',
                    _value('kepala_sekolah'),
                  ),
                  _IdentityRow(
                    Icons.calendar_today_outlined,
                    'Tahun Berdiri',
                    _value('tahun_berdiri'),
                  ),
                  _IdentityRow(
                    Icons.menu_book_outlined,
                    'Kurikulum',
                    _value('kurikulum'),
                  ),
                  _IdentityRow(
                    Icons.schedule_rounded,
                    'Jam Operasional',
                    _value('jam_operasional'),
                  ),
                  _IdentityRow(
                    Icons.star_outline_rounded,
                    'Motto Sekolah',
                    _value('motto_sekolah'),
                  ),
                  _IdentityRow(
                    Icons.location_on_outlined,
                    'Kelurahan',
                    _value('kelurahan'),
                  ),
                  _IdentityRow(
                    Icons.map_outlined,
                    'Kecamatan',
                    _value('kecamatan'),
                  ),
                  _IdentityRow(
                    Icons.public_outlined,
                    'Kabupaten / Kota',
                    _value('kabupaten_kota'),
                  ),
                  _IdentityRow(
                    Icons.public_rounded,
                    'Provinsi / Negara',
                    '${_value('provinsi')} / ${_value('negara')}',
                  ),
                  _IdentityRow(
                    Icons.my_location_outlined,
                    'Posisi Geografis',
                    _value('posisi_geografis'),
                  ),
                ],
              ),
            );
            if (constraints.maxWidth < 820)
              return Column(
                children: [official, const SizedBox(height: 16), additional],
              );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: official),
                const SizedBox(width: 16),
                Expanded(child: additional),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _IdentityPanel(
          title: 'Legalitas dan Keuangan Sekolah',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final legal = [
                _IdentityRow(
                  Icons.description_outlined,
                  'SK Pendirian Sekolah',
                  _value('sk_pendirian_sekolah'),
                ),
                _IdentityRow(
                  Icons.event_outlined,
                  'Tanggal SK Pendirian',
                  _value('tanggal_sk_pendirian'),
                ),
                _IdentityRow(
                  Icons.description_outlined,
                  'SK Izin Operasional',
                  _value('sk_izin_operasional'),
                ),
                _IdentityRow(
                  Icons.event_available_outlined,
                  'Tanggal SK Izin',
                  _value('tgl_sk_izin_operasional'),
                ),
                _IdentityRow(
                  Icons.accessibility_new_outlined,
                  'Kebutuhan Khusus Dilayani',
                  _value('kebutuhan_khusus_dilayani'),
                ),
              ];
              final finance = [
                _IdentityRow(
                  Icons.account_balance_wallet_outlined,
                  'Nomor Rekening',
                  _value('nomor_rekening'),
                ),
                _IdentityRow(
                  Icons.account_balance_outlined,
                  'Nama Bank',
                  _value('nama_bank'),
                ),
                _IdentityRow(
                  Icons.business_center_outlined,
                  'Cabang KCP / Unit',
                  _value('cabang_kcp_unit'),
                ),
                _IdentityRow(
                  Icons.person_outline_rounded,
                  'Rekening Atas Nama',
                  _value('rekening_atas_nama'),
                ),
                _IdentityRow(
                  Icons.verified_outlined,
                  'MBS / Iuran Tahunan',
                  '${_value('mbs')} / ${_value('iuran_tahunan')}',
                ),
              ];
              if (constraints.maxWidth < 820) {
                return Column(
                  children: [...legal, const Divider(), ...finance],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(children: legal)),
                  const SizedBox(width: 24),
                  Expanded(child: Column(children: finance)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  static int _completion(Map<String, dynamic> row) {
    const fields = [
      'nama_sekolah',
      'alamat',
      'telepon',
      'email',
      'akreditasi',
      'npsn',
      'nss',
      'kepala_sekolah',
      'tahun_berdiri',
      'kurikulum',
    ];
    final filled = fields
        .where((field) => '${row[field] ?? ''}'.trim().isNotEmpty)
        .length;
    return (filled * 100 / fields.length).round();
  }
}

class _IdentityMetricCard extends StatelessWidget {
  const _IdentityMetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.note,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String note;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _IdentityPanel extends StatelessWidget {
  const _IdentityPanel({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF2FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _blue, size: 16),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 145,
          child: Text(label, style: const TextStyle(color: _text)),
        ),
        const Text(':', style: TextStyle(color: _muted)),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: _text, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

class _IdentityEmptyState extends StatelessWidget {
  const _IdentityEmptyState({required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => _IdentityPanel(
    title: 'Identitas Sekolah',
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Icon(Icons.account_balance_outlined, size: 52, color: _blue),
            const SizedBox(height: 12),
            const Text(
              'Data identitas belum tersedia',
              style: TextStyle(color: _text, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan data pertama untuk ditampilkan pada dashboard dan website.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Identitas'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _IdentitySetupNotice extends StatelessWidget {
  const _IdentitySetupNotice({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => _IdentityPanel(
    title: 'Identitas Sekolah',
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Icon(Icons.storage_outlined, size: 52, color: _blue),
            const SizedBox(height: 12),
            const Text(
              'Tabel identitas belum siap',
              style: TextStyle(color: _text, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Data profil_identitas belum tersedia. Lalu klik coba lagi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _IdentitySchoolEditor extends StatefulWidget {
  const _IdentitySchoolEditor({required this.api, this.row});
  final SmakApi api;
  final Map<String, dynamic>? row;
  @override
  State<_IdentitySchoolEditor> createState() => _IdentitySchoolEditorState();
}

class _IdentitySchoolEditorState extends State<_IdentitySchoolEditor> {
  static const _fields = <({String key, String label, int lines})>[
    (key: 'nama_sekolah', label: 'Nama Sekolah', lines: 1),
    (key: 'alamat', label: 'Alamat', lines: 2),
    (key: 'rt_rw', label: 'RT / RW', lines: 1),
    (key: 'kode_pos', label: 'Kode Pos', lines: 1),
    (key: 'kelurahan', label: 'Kelurahan', lines: 1),
    (key: 'kecamatan', label: 'Kecamatan', lines: 1),
    (key: 'kabupaten_kota', label: 'Kabupaten / Kota', lines: 1),
    (key: 'provinsi', label: 'Provinsi', lines: 1),
    (key: 'negara', label: 'Negara', lines: 1),
    (key: 'posisi_geografis', label: 'Posisi Geografis', lines: 1),
    (key: 'telepon', label: 'Telepon', lines: 1),
    (key: 'email', label: 'Email', lines: 1),
    (key: 'website', label: 'Website', lines: 1),
    (key: 'akreditasi', label: 'Akreditasi', lines: 1),
    (key: 'status_sekolah', label: 'Status Sekolah', lines: 1),
    (key: 'npsn', label: 'NPSN', lines: 1),
    (key: 'nss', label: 'NSS', lines: 1),
    (key: 'jenjang_pendidikan', label: 'Jenjang Pendidikan', lines: 1),
    (key: 'status_kepemilikan', label: 'Status Kepemilikan', lines: 1),
    (key: 'yayasan', label: 'Yayasan', lines: 1),
    (key: 'kementerian', label: 'Kementerian', lines: 2),
    (key: 'kepala_sekolah', label: 'Kepala Sekolah', lines: 1),
    (key: 'tahun_berdiri', label: 'Tahun Berdiri', lines: 1),
    (key: 'kurikulum', label: 'Kurikulum', lines: 1),
    (key: 'jam_operasional', label: 'Jam Operasional', lines: 1),
    (key: 'motto_sekolah', label: 'Motto Sekolah', lines: 2),
    (key: 'sk_pendirian_sekolah', label: 'SK Pendirian Sekolah', lines: 1),
    (key: 'tanggal_sk_pendirian', label: 'Tanggal SK Pendirian', lines: 1),
    (key: 'sk_izin_operasional', label: 'SK Izin Operasional', lines: 1),
    (
      key: 'tgl_sk_izin_operasional',
      label: 'Tanggal SK Izin Operasional',
      lines: 1,
    ),
    (
      key: 'kebutuhan_khusus_dilayani',
      label: 'Kebutuhan Khusus Dilayani',
      lines: 1,
    ),
    (key: 'nomor_rekening', label: 'Nomor Rekening', lines: 1),
    (key: 'nama_bank', label: 'Nama Bank', lines: 1),
    (key: 'cabang_kcp_unit', label: 'Cabang KCP / Unit', lines: 1),
    (key: 'rekening_atas_nama', label: 'Rekening Atas Nama', lines: 1),
    (key: 'mbs', label: 'MBS', lines: 1),
    (key: 'iuran_tahunan', label: 'Iuran Tahunan', lines: 1),
  ];
  late final Map<String, TextEditingController> _controllers;
  final ScrollController _formScrollController = ScrollController();
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in _fields)
        field.key: TextEditingController(
          text: '${widget.row?[field.key] ?? ''}',
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _formScrollController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_controllers['nama_sekolah']!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama sekolah wajib diisi.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.api.save('profil_identitas', {
        for (final entry in _controllers.entries)
          entry.key: entry.value.text.trim(),
        'status_tampil': 'Ditampilkan',
      }, id: int.tryParse('${widget.row?['id'] ?? ''}'));
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  IconData _iconFor(String key) => switch (key) {
    'nama_sekolah' => Icons.account_balance_rounded,
    'alamat' || 'posisi_geografis' => Icons.location_on_outlined,
    'telepon' => Icons.phone_outlined,
    'email' || 'kode_pos' => Icons.mail_outline_rounded,
    'website' || 'negara' => Icons.language_rounded,
    'akreditasi' => Icons.workspace_premium_outlined,
    'rt_rw' || 'yayasan' => Icons.groups_outlined,
    'kelurahan' ||
    'kecamatan' ||
    'kabupaten_kota' => Icons.location_city_outlined,
    'provinsi' => Icons.map_outlined,
    'npsn' || 'nss' => Icons.badge_outlined,
    'jenjang_pendidikan' || 'kurikulum' => Icons.school_outlined,
    'kepala_sekolah' => Icons.person_outline_rounded,
    'tahun_berdiri' ||
    'tanggal_sk_pendirian' ||
    'tgl_sk_izin_operasional' => Icons.calendar_today_outlined,
    'nomor_rekening' || 'nama_bank' => Icons.account_balance_outlined,
    _ => Icons.description_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 950,
          maxHeight: screen.height - 48,
        ),
        child: SizedBox(
          height: screen.height - 48,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(38, 30, 38, 20),
                child: Text(
                  widget.row == null
                      ? 'Tambah Identitas Sekolah'
                      : 'Edit Identitas Sekolah',
                  style: const TextStyle(
                    color: _text,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _formScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: _formScrollController,
                    primary: false,
                    padding: const EdgeInsets.fromLTRB(38, 6, 30, 20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final twoColumns = constraints.maxWidth >= 650;
                        final fieldWidth = twoColumns
                            ? (constraints.maxWidth - 20) / 2
                            : constraints.maxWidth;
                        return Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: _fields
                              .map(
                                (field) => SizedBox(
                                  width: fieldWidth,
                                  child: AdminContentFormField(
                                    controller: _controllers[field.key],
                                    minLines: field.lines,
                                    maxLines: field.lines,
                                    decoration: InputDecoration(
                                      labelText: field.label,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      prefixIcon: Icon(
                                        _iconFor(field.key),
                                        color: const Color(0xFF2863BE),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 15,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFD8E0EC),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFD8E0EC),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: _blue,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(38, 16, 38, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE8EEF6))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _saving ? null : () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 14),
                    FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 15,
                        ),
                      ),
                      icon: _saving
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: const Text('Simpan Perubahan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
