part of '../admin_dashboard_page.dart';

Future<bool?> _openAdminEditor(
  BuildContext context,
  SmakApi api,
  AdminModule module, {
  Map<String, dynamic>? row,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) =>
        _AdminEditorDialog(api: api, module: module, row: row),
  );
}

class _AdminEditorDialog extends StatefulWidget {
  const _AdminEditorDialog({required this.api, required this.module, this.row});

  final SmakApi api;
  final AdminModule module;
  final Map<String, dynamic>? row;

  @override
  State<_AdminEditorDialog> createState() => _AdminEditorDialogState();
}

class _AdminEditorDialogState extends State<_AdminEditorDialog> {
  static const List<_ProfileSchoolFieldSpec> _profileSummaryFields = [
    _ProfileSchoolFieldSpec(
      key: 'nama_sekolah',
      label: 'Nama Sekolah',
      hint: 'SMAS KRISTEN MGR S LUMAJANG',
    ),
    _ProfileSchoolFieldSpec(
      key: 'status_sekolah',
      label: 'Status Sekolah',
      hint: 'Swasta',
    ),
    _ProfileSchoolFieldSpec(
      key: 'jenjang_pendidikan',
      label: 'Jenjang Pendidikan',
      hint: 'SMA',
    ),
    _ProfileSchoolFieldSpec(
      key: 'tahun_berdiri',
      label: 'Tahun Berdiri',
      hint: '1983',
    ),
    _ProfileSchoolFieldSpec(
      key: 'yayasan',
      label: 'Yayasan',
      hint: 'Yayasan Soegijapranata',
    ),
    _ProfileSchoolFieldSpec(key: 'akreditasi', label: 'Akreditasi', hint: 'A'),
    _ProfileSchoolFieldSpec(
      key: 'akreditasi_deskripsi',
      label: 'Deskripsi Akreditasi',
      hint: 'Akreditasi BAN-S/M',
      maxLines: 2,
    ),
  ];

  static const List<_ProfileSchoolFieldSpec> _profileIdentityFields = [
    _ProfileSchoolFieldSpec(key: 'npsn', label: 'NPSN', hint: '20520822'),
    _ProfileSchoolFieldSpec(
      key: 'alamat_sekolah',
      label: 'Alamat Sekolah',
      hint: 'Jl. Diponegoro No. 63 Lumajang',
      maxLines: 2,
    ),
    _ProfileSchoolFieldSpec(key: 'rt_rw', label: 'RT / RW', hint: '6 / 4'),
    _ProfileSchoolFieldSpec(key: 'kode_pos', label: 'Kode Pos', hint: '67315'),
    _ProfileSchoolFieldSpec(
      key: 'kelurahan',
      label: 'Kelurahan',
      hint: 'Jogoyudan',
    ),
    _ProfileSchoolFieldSpec(
      key: 'kecamatan',
      label: 'Kecamatan',
      hint: 'Kec. Lumajang',
    ),
    _ProfileSchoolFieldSpec(
      key: 'kabupaten_kota',
      label: 'Kabupaten/Kota',
      hint: 'Kab. Lumajang',
    ),
    _ProfileSchoolFieldSpec(
      key: 'provinsi',
      label: 'Provinsi',
      hint: 'Jawa Timur',
    ),
    _ProfileSchoolFieldSpec(key: 'negara', label: 'Negara', hint: 'Indonesia'),
    _ProfileSchoolFieldSpec(
      key: 'posisi_geografis',
      label: 'Posisi Geografis',
      hint: '-8.1335 (Lintang) / 113.2287 (Bujur)',
      maxLines: 2,
    ),
  ];

  static const List<_ProfileSchoolFieldSpec> _profileDetailFields = [
    _ProfileSchoolFieldSpec(
      key: 'sk_pendirian_sekolah',
      label: 'SK Pendirian Sekolah',
      hint: '060/PENG.YK/1983',
    ),
    _ProfileSchoolFieldSpec(
      key: 'tanggal_sk_pendirian',
      label: 'Tanggal SK Pendirian',
      hint: '1983-12-31',
    ),
    _ProfileSchoolFieldSpec(
      key: 'status_kepemilikan',
      label: 'Status Kepemilikan',
      hint: 'Yayasan',
    ),
    _ProfileSchoolFieldSpec(
      key: 'sk_izin_operasional',
      label: 'SK Izin Operasional',
      hint: '45/14.01.02/02/IV/2025',
    ),
    _ProfileSchoolFieldSpec(
      key: 'tgl_sk_izin_operasional',
      label: 'Tgl SK Izin Operasional',
      hint: '2025-04-15',
    ),
    _ProfileSchoolFieldSpec(
      key: 'kebutuhan_khusus_dilayani',
      label: 'Kebutuhan Khusus Dilayani',
      hint: '-',
    ),
    _ProfileSchoolFieldSpec(
      key: 'nomor_rekening',
      label: 'Nomor Rekening',
      hint: '0092035905',
    ),
    _ProfileSchoolFieldSpec(
      key: 'nama_bank',
      label: 'Nama Bank',
      hint: 'BPD JAWA TIMUR',
    ),
    _ProfileSchoolFieldSpec(
      key: 'cabang_kcp_unit',
      label: 'Cabang KCP/Unit',
      hint: 'BPD JAWA TIMUR CABANG LUMAJANG',
      maxLines: 2,
    ),
    _ProfileSchoolFieldSpec(
      key: 'rekening_atas_nama',
      label: 'Rekening Atas Nama',
      hint: 'SMUKATOLIKMGRSOEGIJAPRANATA',
      maxLines: 2,
    ),
    _ProfileSchoolFieldSpec(key: 'mbs', label: 'MBS', hint: 'Ya'),
    _ProfileSchoolFieldSpec(
      key: 'iuran_tahunan',
      label: 'Iuran Tahunan',
      hint: '0',
    ),
  ];

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageController;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool get _isUser => widget.module.table == 'users';
  late final Map<String, TextEditingController> _profileControllers;

  final List<String> _uploadedFiles = [];
  bool _isUploading = false;
  bool _isSaving = false;
  String _uploadStatus = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: '${widget.row?['judul'] ?? widget.row?['nama'] ?? ''}',
    );
    _descriptionController = TextEditingController(
      text: '${widget.row?['deskripsi'] ?? ''}',
    );
    _categoryController = TextEditingController(
      text: '${widget.row?['kategori'] ?? ''}',
    );
    _imageController = TextEditingController(
      text: '${widget.row?[_isUser ? 'foto' : 'gambar'] ?? ''}',
    );
    if (_isUser) {
      _usernameController.text = '${widget.row?['username'] ?? ''}';
      _emailController.text = '${widget.row?['email'] ?? ''}';
    }
    _profileControllers = {
      for (final field in [
        ..._profileSummaryFields,
        ..._profileIdentityFields,
        ..._profileDetailFields,
      ])
        field.key: TextEditingController(
          text: '${widget.row?[field.key] ?? ''}',
        ),
    };
    final initialImage = _imageController.text.trim();
    if (initialImage.isNotEmpty) {
      _uploadedFiles.add(initialImage);
    }
    final additionalImages = '${widget.row?['gambar_lain'] ?? ''}'.trim();
    if (additionalImages.isNotEmpty) {
      try {
        final decoded = jsonDecode(additionalImages);
        if (decoded is List) {
          _uploadedFiles.addAll(
            decoded
                .map((item) => '$item'.trim())
                .where(
                  (item) => item.isNotEmpty && !_uploadedFiles.contains(item),
                ),
          );
        }
      } catch (_) {
        // Data galeri lama belum memiliki daftar foto tambahan.
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    for (final controller in _profileControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickAndUploadFiles() async {
    final picker = html.FileUploadInputElement()
      ..multiple = !_isUser
      ..accept = 'image/jpeg,image/png,image/webp';
    picker.click();
    await picker.onChange.first;
    final files = picker.files;
    if (files == null || files.isEmpty) return;

    setState(() {
      _isUploading = true;
      _uploadStatus = 'Mengunggah 0/${files.length} file...';
    });

    int successCount = 0;
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      setState(() {
        _uploadStatus = 'Mengunggah ${i + 1}/${files.length}: ${file.name}...';
      });
      try {
        final filename = await widget.api.uploadFile(widget.module.table, file);
        if (_isUser) _uploadedFiles.clear();
        _uploadedFiles.add(filename);
        successCount++;
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengunggah ${file.name}: $error')),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _isUploading = false;
        _uploadStatus = '';
        if (_uploadedFiles.isNotEmpty) {
          _imageController.text = _uploadedFiles.first;
        }
      });
      if (successCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$successCount file berhasil diunggah.')),
        );
      }
    }
  }

  Future<void> _saveData() async {
    if (_isUser) {
      await _saveUserData();
      return;
    }
    if (widget.module.table == 'profil_sekolah') {
      await _saveProfileSchoolData();
      return;
    }

    final rawTitle = _titleController.text.trim();
    final rawCategory = _categoryController.text.trim();
    final description = _descriptionController.text.trim();
    final singleImage = _imageController.text.trim();

    final category = rawCategory.isNotEmpty ? rawCategory : 'Kegiatan';
    final baseTitle = rawTitle.isNotEmpty ? rawTitle : 'Galeri Kegiatan';

    final filesToSave = _uploadedFiles.isNotEmpty
        ? _uploadedFiles
        : (singleImage.isNotEmpty ? [singleImage] : ['']);

    setState(() => _isSaving = true);

    try {
      final isGallery = widget.module.table == 'galeri';
      final data = <String, dynamic>{
        'judul': baseTitle,
        'nama': baseTitle,
        'kategori': category,
        'deskripsi': description,
        'gambar': filesToSave.first,
        'foto': filesToSave.first,
        if (isGallery) 'gambar_lain': jsonEncode(filesToSave.skip(1).toList()),
        if (widget.row == null)
          'tanggal': DateTime.now().toString().split(' ').first,
        'status': 'aktif',
      };

      await widget.api.save(
        widget.module.table,
        data,
        id: widget.row == null ? null : (widget.row!['id'] as num?)?.toInt(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isGallery
                  ? 'Kegiatan berhasil disimpan dengan ${filesToSave.where((file) => file.isNotEmpty).length} foto.'
                  : 'Data berhasil disimpan.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
      }
    }
  }

  Future<void> _saveUserData() async {
    final rawId = widget.row?['id'];
    final id = widget.row == null
        ? null
        : rawId is num && rawId.isFinite && rawId == rawId.roundToDouble()
        ? rawId.toInt()
        : int.tryParse('$rawId');
    String? error;
    if (widget.row != null && (id == null || id <= 0)) {
      error = 'ID pengguna tidak valid.';
    } else if (_titleController.text.trim().isEmpty) {
      error = 'Nama wajib diisi.';
    } else if (_usernameController.text.trim().isEmpty) {
      error = 'Username wajib diisi.';
    } else if (widget.row == null && _passwordController.text.isEmpty) {
      error = 'Password wajib diisi untuk admin baru.';
    }
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => _isSaving = true);
    try {
      await widget.api.save('users', {
        'nama': _titleController.text.trim(),
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'foto': _imageController.text.trim(),
        if (_passwordController.text.isNotEmpty)
          'password': _passwordController.text,
      }, id: id);
      if (!mounted) return;
      _passwordController.clear();
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data admin berhasil disimpan.')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan admin. Periksa data dan coba lagi.')),
      );
    }
  }

  Future<void> _saveProfileSchoolData() async {
    setState(() => _isSaving = true);

    try {
      final data = <String, dynamic>{
        for (final entry in _profileControllers.entries)
          entry.key: entry.value.text.trim(),
      };
      final schoolName = _profileControllers['nama_sekolah']?.text.trim() ?? '';
      if (schoolName.isNotEmpty) {
        data['nama'] = schoolName;
        data['judul'] = schoolName;
      }
      final status = _profileControllers['status_sekolah']?.text.trim() ?? '';
      if (status.isNotEmpty) {
        data['status'] = status;
      }
      data['kategori'] = 'Identitas Sekolah';
      data['deskripsi'] =
          _profileControllers['akreditasi_deskripsi']?.text.trim() ?? '';

      await widget.api.save(
        widget.module.table,
        data,
        id: widget.row == null ? null : (widget.row!['id'] as num?)?.toInt(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data identitas sekolah berhasil disimpan.'),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.module.table == 'galeri') {
      return _buildGalleryEditor(context);
    }
    if (widget.module.table == 'profil_sekolah') {
      return _buildProfileSchoolEditor(context);
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 18, 14, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: _line)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.module.icon, color: _blue, size: 21),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.row == null ? 'Tambah' : 'Edit'} ${widget.module.title}',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.module.description,
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
                    tooltip: 'Tutup',
                    onPressed: _isUploading || _isSaving
                        ? null
                        : () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: _muted),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCleanEditorField(
                      controller: _titleController,
                      label: _isUser ? 'Nama' : 'Judul / Nama',
                      hint: _isUser ? 'Masukkan nama admin' : 'Masukkan judul atau nama',
                    ),
                    const SizedBox(height: 15),
                    if (_isUser) ...[
                      _buildCleanEditorField(
                        controller: _usernameController,
                        label: 'Username',
                        hint: 'Masukkan username',
                      ),
                      const SizedBox(height: 15),
                      _buildCleanEditorField(
                        controller: _emailController,
                        label: 'Email (opsional)',
                        hint: 'Masukkan email',
                      ),
                      const SizedBox(height: 15),
                      _buildCleanEditorField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: widget.row == null
                            ? 'Wajib diisi untuk admin baru'
                            : 'Kosongkan untuk mempertahankan password',
                        obscureText: true,
                      ),
                    ] else ...[
                    _buildCleanEditorField(
                      controller: _categoryController,
                      label: 'Kategori',
                      hint: 'Masukkan kategori',
                    ),
                    const SizedBox(height: 15),
                    _buildCleanEditorField(
                      controller: _descriptionController,
                      label: 'Deskripsi',
                      hint: 'Masukkan deskripsi',
                      maxLines: 4,
                    ),
                    ],
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFD),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isUser ? 'Foto (opsional)' : 'Media',
                            style: const TextStyle(
                              color: _text,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _isUploading || _isSaving
                                  ? null
                                  : _pickAndUploadFiles,
                              icon: const Icon(
                                Icons.cloud_upload_outlined,
                                size: 18,
                              ),
                              label: Text(
                                _isUploading
                                    ? 'Mengunggah...'
                                    : (_isUser ? 'Pilih Foto' : 'Pilih Foto / Video'),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _blue,
                                side: const BorderSide(
                                  color: Color(0xFFBFD2EF),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          if (_isUploading) ...[
                            const SizedBox(height: 10),
                            const LinearProgressIndicator(),
                            const SizedBox(height: 6),
                            Text(
                              _uploadStatus,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          if (_uploadedFiles.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _uploadedFiles
                                  .map(
                                    (file) => InputChip(
                                      label: Text(
                                        file,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onDeleted: _isSaving
                                          ? null
                                          : () {
                                              setState(() {
                                                _uploadedFiles.remove(file);
                                                if (_imageController.text ==
                                                    file) {
                                                  _imageController.text =
                                                      _uploadedFiles.isEmpty
                                                      ? ''
                                                      : _uploadedFiles.first;
                                                }
                                              });
                                            },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          if (_imageController.text.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'File utama: ${_imageController.text.trim()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFD),
                border: Border(top: BorderSide(color: _line)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isUploading || _isSaving
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _text,
                      side: const BorderSide(color: Color(0xFFD5DFEB)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _isUploading || _isSaving ? null : _saveData,
                    style: FilledButton.styleFrom(
                      backgroundColor: _blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: _isSaving
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined, size: 17),
                    label: Text(
                      _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanEditorField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _text,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        AdminContentTextField(
          controller: controller,
          constraint: adminConstraintFor(label, maxLines: maxLines),
          obscureText: obscureText,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          minLines: maxLines > 1 ? 3 : 1,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9AA9BA), fontSize: 12),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD5DFEB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _blue, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryEditor(BuildContext context) {
    final editing = widget.row != null;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 820;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980, maxHeight: 760),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 20, 18, 18),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: _blue,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          editing ? 'Edit Kegiatan' : 'Tambah Kegiatan',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          editing
                              ? 'Perbarui informasi dan foto kegiatan sekolah.'
                              : 'Tambahkan kegiatan beserta dokumentasi fotonya ke galeri.',
                          style: const TextStyle(color: _muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isUploading || _isSaving
                        ? null
                        : () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: _muted,
                      side: const BorderSide(color: _line),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: _line),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(26),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGalleryInformation(),
                          const SizedBox(height: 28),
                          _buildGalleryUploader(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildGalleryInformation()),
                          Container(
                            width: 1,
                            height: 430,
                            margin: const EdgeInsets.symmetric(horizontal: 26),
                            color: _line,
                          ),
                          Expanded(child: _buildGalleryUploader()),
                        ],
                      ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(26, 16, 26, 18),
              decoration: const BoxDecoration(
                color: Color(0xFFFBFCFE),
                border: Border(top: BorderSide(color: _line)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isUploading || _isSaving
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _text,
                      side: const BorderSide(color: _line),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isUploading || _isSaving ? null : _saveData,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined, size: 18),
                    label: Text(
                      _isSaving
                          ? 'Menyimpan...'
                          : (editing ? 'Simpan Perubahan' : 'Simpan Kegiatan'),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSchoolEditor(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 1060,
        constraints: const BoxConstraints(maxWidth: 1060),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x240F172A),
              blurRadius: 30,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 30, 36, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: _blue,
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Data Sekolah',
                          style: TextStyle(
                            color: _text,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Perbarui informasi resmi sekolah.',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: _isSaving ? null : () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFDCE6F2)),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF5E708B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: _line),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(36, 24, 36, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 860;
                        final leftSection = _ProfileEditorSection(
                          title: '1. Identitas Sekolah',
                          children: [
                            ..._profileSummaryFields.map(
                              (field) =>
                                  _buildProfileEditorField(context, field),
                            ),
                            ..._profileIdentityFields.map(
                              (field) =>
                                  _buildProfileEditorField(context, field),
                            ),
                          ],
                        );
                        final rightSection = _ProfileEditorSection(
                          title: '2. Data Pelengkap',
                          children: _profileDetailFields
                              .map(
                                (field) =>
                                    _buildProfileEditorField(context, field),
                              )
                              .toList(),
                        );

                        if (compact) {
                          return Column(
                            children: [
                              leftSection,
                              const SizedBox(height: 24),
                              rightSection,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: leftSection),
                            Container(
                              width: 1,
                              height: 760,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              color: _line,
                            ),
                            Expanded(child: rightSection),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFDCE7F6)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_rounded, color: _blue, size: 28),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Pastikan data yang diubah sudah sesuai dengan dokumen resmi sekolah.',
                              style: TextStyle(
                                color: Color(0xFF567193),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 18,
                            ),
                            side: const BorderSide(color: Color(0xFF9AB0D0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: _text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        FilledButton.icon(
                          onPressed: _isSaving ? null : _saveData,
                          style: FilledButton.styleFrom(
                            backgroundColor: _blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTextField(String key, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AdminContentTextField(
        controller: _profileControllers[key],
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD9E3F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _blue),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileEditorField(
    BuildContext context,
    _ProfileSchoolFieldSpec field,
  ) {
    switch (field.key) {
      case 'jenjang_pendidikan':
        return _buildProfileDropdownField(
          key: field.key,
          label: field.label,
          options: const ['SMA', 'SMK', 'MA'],
        );
      case 'status_sekolah':
        return _buildProfileDropdownField(
          key: field.key,
          label: field.label,
          options: const ['Swasta', 'Negeri'],
        );
      case 'status_kepemilikan':
        return _buildProfileDropdownField(
          key: field.key,
          label: field.label,
          options: const ['Yayasan', 'Pemerintah', 'Lainnya'],
        );
      case 'mbs':
        return _buildProfileDropdownField(
          key: field.key,
          label: field.label,
          options: const ['Ya', 'Tidak'],
        );
      case 'tanggal_sk_pendirian':
      case 'tgl_sk_izin_operasional':
        return _buildProfileDateField(
          context,
          key: field.key,
          label: field.label,
        );
      default:
        return _buildProfileTextField(
          field.key,
          field.label,
          maxLines: field.maxLines,
        );
    }
  }

  Widget _buildProfileDropdownField({
    required String key,
    required String label,
    required List<String> options,
  }) {
    final controller = _profileControllers[key]!;
    final current = controller.text.trim();
    final value = options.contains(current)
        ? current
        : (current.isEmpty ? null : current);
    final items = <String>{...options};
    if (current.isNotEmpty) {
      items.add(current);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD9E3F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _blue),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 4,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: const Text('Pilih'),
            items: items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
            onChanged: _isSaving
                ? null
                : (newValue) {
                    if (newValue != null) {
                      setState(() => controller.text = newValue);
                    }
                  },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDateField(
    BuildContext context, {
    required String key,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AdminContentTextField(
        controller: _profileControllers[key],
        readOnly: true,
        onTap: _isSaving ? null : () => _pickDate(context, key),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD9E3F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _blue),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, String key) async {
    final controller = _profileControllers[key]!;
    final initial =
        _tryParseDate(controller.text.trim()) ?? DateTime(2025, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950, 1, 1),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked != null && mounted) {
      setState(() {
        controller.text =
            '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  DateTime? _tryParseDate(String value) {
    if (value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  Widget _buildGalleryInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Kegiatan',
          style: TextStyle(
            color: _text,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Judul / Nama Kegiatan',
          style: TextStyle(
            color: _text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        AdminContentTextField(
          controller: _titleController,
          constraint: AdminContentConstraint.title,
          decoration: _galleryInputDecoration('Masukkan judul kegiatan'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Kategori',
          style: TextStyle(
            color: _text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        AdminContentTextField(
          controller: _categoryController,
          constraint: AdminContentConstraint.shortLabel,
          decoration: _galleryInputDecoration('Masukkan kategori kegiatan')
              .copyWith(
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _muted,
                ),
              ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Deskripsi',
          style: TextStyle(
            color: _text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        AdminContentTextField(
          constraint: AdminContentConstraint.shortDescription.copyWith(maxCharacters: 200),
          controller: _descriptionController,
          maxLines: 5,
          decoration: _galleryInputDecoration(
            'Tulis deskripsi singkat kegiatan (opsional)',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: _blue, size: 19),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Foto pertama otomatis menjadi cover kegiatan. Foto berikutnya tetap tersimpan di album kegiatan yang sama.',
                  style: TextStyle(
                    color: Color(0xFF46617E),
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Foto',
          style: TextStyle(
            color: _text,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _isUploading || _isSaving ? null : _pickAndUploadFiles,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFFFBFDFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC9D7E8), width: 1.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined, color: _blue, size: 45),
                const SizedBox(height: 12),
                const Text(
                  'Klik untuk memilih foto kegiatan',
                  style: TextStyle(color: _text, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Bisa pilih beberapa foto sekaligus • JPG, PNG, WEBP',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
                const SizedBox(height: 13),
                OutlinedButton.icon(
                  onPressed: _isUploading || _isSaving
                      ? null
                      : _pickAndUploadFiles,
                  icon: const Icon(Icons.folder_open_rounded, size: 17),
                  label: const Text('Pilih Foto'),
                  style: OutlinedButton.styleFrom(foregroundColor: _blue),
                ),
              ],
            ),
          ),
        ),
        if (_isUploading) ...[
          const SizedBox(height: 10),
          const LinearProgressIndicator(),
          const SizedBox(height: 6),
          Text(
            _uploadStatus,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Preview Foto',
                style: TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (_uploadedFiles.isNotEmpty)
              Text(
                '${_uploadedFiles.length} foto',
                style: const TextStyle(
                  color: _blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (_uploadedFiles.isEmpty)
          Container(
            width: double.infinity,
            height: 108,
            decoration: BoxDecoration(
              color: const Color(0xFFFBFCFE),
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, color: Color(0xFFB3C0CF), size: 30),
                SizedBox(height: 6),
                Text(
                  'Belum ada foto dipilih',
                  style: TextStyle(color: _muted, fontSize: 11.5),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: _uploadedFiles.asMap().entries.map((entry) {
              final index = entry.key;
              final filename = entry.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 105,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FC),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: index == 0 ? _blue : _line,
                        width: index == 0 ? 2 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: websiteContentImage(filename, fit: BoxFit.cover),
                  ),
                  if (index == 0)
                    Positioned(
                      left: 5,
                      bottom: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Cover',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: -5,
                    top: -5,
                    child: InkWell(
                      onTap: _isUploading || _isSaving
                          ? null
                          : () {
                              setState(() {
                                _uploadedFiles.removeAt(index);
                                _imageController.text = _uploadedFiles.isEmpty
                                    ? ''
                                    : _uploadedFiles.first;
                              });
                            },
                      child: const CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xFFE53935),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }

  InputDecoration _galleryInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9AAABD), fontSize: 12),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xFFD7E0EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: _blue, width: 1.4),
      ),
    );
  }
}
