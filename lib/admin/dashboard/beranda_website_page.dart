part of '../admin_dashboard_page.dart';

class AdminBerandaWebsitePage extends StatelessWidget {
  const AdminBerandaWebsitePage({super.key, required this.api});

  final SmakApi api;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BerandaHeader(),
        const SizedBox(height: 18),
        _BerandaCollection(
          api: api,
          number: 1,
          title: 'Banner / Hero',
          note: 'Atur tampilan bagian pembuka halaman.',
          table: 'beranda_slider',
          icon: Icons.panorama_outlined,
          layout: _BerandaLayout.hero,
        ),
        _BerandaCollection(
          api: api,
          number: 2,
          title: 'Highlight / Quick Info',
          note: 'Kelola informasi singkat pada bagian highlight.',
          table: 'beranda_keunggulan',
          icon: Icons.auto_awesome_outlined,
          layout: _BerandaLayout.cards,
        ),
        _BerandaCollection(
          api: api,
          number: 3,
          title: 'Tentang Sekolah',
          note: 'Kelola konten pengenalan singkat sekolah.',
          table: 'beranda_tentang',
          icon: Icons.school_outlined,
          layout: _BerandaLayout.feature,
        ),
        _BerandaCollection(
          api: api,
          number: 4,
          title: 'Program Unggulan',
          note: 'Kelola daftar program unggulan sekolah.',
          table: 'beranda_program',
          icon: Icons.menu_book_outlined,
          layout: _BerandaLayout.cards,
        ),
        _BerandaCollection(
          api: api,
          number: 5,
          title: 'Kampanye PPDB',
          note: 'Kelola label, judul, deskripsi, gambar, dan tombol PPDB.',
          table: 'beranda_ppdb',
          icon: Icons.how_to_reg_rounded,
          layout: _BerandaLayout.feature,
        ),
        _BerandaCollection(
          api: api,
          number: 6,
          title: 'Kehidupan di SMAK',
          note: 'Kelola galeri kegiatan dan kehidupan sekolah.',
          table: 'beranda_kehidupan',
          icon: Icons.groups_outlined,
          layout: _BerandaLayout.cards,
        ),
        _BerandaCollection(
          api: api,
          number: 7,
          title: 'Prestasi & Jejak Kami',
          note: 'Kelola statistik ringkas yang ditampilkan di beranda.',
          table: 'beranda_statistik',
          icon: Icons.emoji_events_outlined,
          layout: _BerandaLayout.stats,
        ),
        _BerandaCollection(
          api: api,
          number: 8,
          title: 'Informasi Kontak Ringkas',
          note: 'Kelola kartu alamat, telepon, jam operasional, dan tautan.',
          table: 'beranda_kontak',
          icon: Icons.contact_phone_outlined,
          layout: _BerandaLayout.cards,
        ),
        _BerandaCollection(
          api: api,
          number: 9,
          title: 'Testimoni Beranda',
          note: 'Kelola nama, peran, foto, dan testimoni pengunjung.',
          table: 'beranda_testimoni',
          icon: Icons.rate_review_outlined,
          layout: _BerandaLayout.cards,
        ),
        const SizedBox(height: 2),
        Container(
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
                  'Perubahan pada setiap bagian langsung disimpan ke database melalui tombol Simpan pada editor.',
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

class _BerandaHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beranda Website',
                style: TextStyle(
                  color: _text,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kelola tampilan dan konten halaman beranda website sekolah.',
                style: TextStyle(color: _muted),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _openAdminPreview(context, const LandingPage()),
          icon: const Icon(Icons.visibility_outlined, size: 18),
          label: const Text('Preview Halaman'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _blue,
            side: const BorderSide(color: _line),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          ),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Perubahan disimpan per bagian melalui editor masing-masing.',
              ),
            ),
          ),
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text('Simpan Perubahan'),
          style: FilledButton.styleFrom(
            backgroundColor: _blue,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          ),
        ),
      ],
    );
  }
}

enum _BerandaLayout { hero, feature, cards, stats, list }

class _BerandaCollection extends StatefulWidget {
  const _BerandaCollection({
    required this.api,
    required this.number,
    required this.title,
    required this.note,
    required this.table,
    required this.icon,
    required this.layout,
    this.allowAdd = true,
    this.allowDelete = true,
  });

  final SmakApi api;
  final int number;
  final String title;
  final String note;
  final String table;
  final IconData icon;
  final _BerandaLayout layout;
  final bool allowAdd;
  final bool allowDelete;

  @override
  State<_BerandaCollection> createState() => _BerandaCollectionState();
}

class _BerandaCollectionState extends State<_BerandaCollection> {
  late Future<List<Map<String, dynamic>>> _items;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _items = widget.api.getTable(widget.table, limit: 50);
  }

  Future<void> _edit([Map<String, dynamic>? row]) async {
    if (widget.layout == _BerandaLayout.hero) {
      await _editBanner(row);
      return;
    }
    // Beranda memakai editor khusus agar field yang tampil sesuai tiap section,
    // tanpa mengubah editor generik milik modul admin lainnya.
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _BerandaEditDialog(
        api: widget.api,
        table: widget.table,
        title: widget.title,
        note: widget.note,
        icon: widget.icon,
        row: row,
      ),
    );
    if (changed == true && mounted) setState(_reload);
  }

  Future<void> _add() async {
    if (widget.layout == _BerandaLayout.hero) {
      final rows = await widget.api.getTable(widget.table, limit: 50);
      if (rows.length >= 3) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Banner/Hero maksimal 3 slide.')),
          );
          setState(_reload);
        }
        return;
      }
      final orderedRows = _orderedHeroRows(rows);
      final content = orderedRows.isEmpty
          ? <String, dynamic>{
              'judul': 'Selamat Datang di SMAK',
              'nama_singkat': 'SMAK',
              'nama_panjang': 'Sekolah Menengah Atas Katolik',
              'subjudul':
                  'Membentuk generasi unggul, berkarakter, beriman, dan berwawasan global.',
              'teks_tombol_1': 'Profil Sekolah',
              'link_tombol_1': '/profil',
              'teks_tombol_2': 'PPDB Online',
              'link_tombol_2': '/ppdb',
            }
          : Map<String, dynamic>.from(orderedRows.first);
      content
        ..remove('id')
        ..['gambar'] = ''
        ..['urutan'] = orderedRows.isEmpty
            ? 1
            : (orderedRows
                      .map((row) => int.tryParse('${row['urutan'] ?? ''}') ?? 0)
                      .reduce((a, b) => a > b ? a : b) +
                  1)
        ..['status'] = 'aktif';
      await _editBanner(null, initialData: content);
      return;
    }
    await _edit();
  }

  List<Map<String, dynamic>> _orderedHeroRows(List<Map<String, dynamic>> rows) {
    return [...rows]..sort(
      (a, b) => (int.tryParse('${a['urutan'] ?? ''}') ?? 0).compareTo(
        int.tryParse('${b['urutan'] ?? ''}') ?? 0,
      ),
    );
  }

  Future<void> _editHeroContent(
    Map<String, dynamic> content,
    List<Map<String, dynamic>> rows,
  ) async {
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _BerandaEditDialog(
        api: widget.api,
        table: widget.table,
        title: 'Konten Hero',
        note: 'Atur teks Hero dan tautan kedua tombol.',
        icon: widget.icon,
        row: content,
        sliderMode: _SliderEditorMode.content,
        sliderRows: rows,
      ),
    );
    if (changed == true && mounted) setState(_reload);
  }

  Future<void> _editBanner(
    Map<String, dynamic>? row, {
    Map<String, dynamic>? initialData,
  }) async {
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _BerandaEditDialog(
        api: widget.api,
        table: widget.table,
        title: 'Banner',
        note: 'Atur gambar, urutan tampil, dan status banner.',
        icon: widget.icon,
        row: row,
        initialData: initialData,
        sliderMode: _SliderEditorMode.banner,
      ),
    );
    if (changed == true && mounted) setState(_reload);
  }

  Future<void> _changeBanner(Map<String, dynamic> row) async {
    final picker = html.FileUploadInputElement()
      ..accept = 'image/jpeg,image/png,image/webp';
    picker.click();
    await picker.onChange.first;
    final files = picker.files;
    if (files == null || files.isEmpty) return;

    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) return;

    try {
      final filename = await widget.api.uploadFile(
        'beranda_slider',
        files.first,
      );
      final data = Map<String, dynamic>.from(row)
        ..remove('id')
        ..['gambar'] = filename;
      await widget.api.save('beranda_slider', data, id: id);
      if (mounted) {
        setState(_reload);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner berhasil diganti.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengganti banner: $error')));
    }
  }

  Future<void> _clearBanner(Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus gambar banner?'),
        content: const Text(
          'Data slider tetap ada. Hanya gambar bannernya yang dikosongkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD92D20),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      final data = Map<String, dynamic>.from(row)
        ..remove('id')
        ..['gambar'] = '';
      await widget.api.save('beranda_slider', data, id: id);
      if (mounted) {
        setState(_reload);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar banner berhasil dihapus.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus banner: $error')));
    }
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus data?'),
        content: const Text('Data yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD92D20),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await widget.api.delete(widget.table, id);
      if (mounted) setState(_reload);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $error')));
    }
  }

  String _first(
    Map<String, dynamic> row,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = '${row[key] ?? ''}'.trim();
      if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _items,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];

          return Column(
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
                      '${widget.number}',
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
                          widget.title,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.note,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (widget.allowAdd &&
                      (widget.layout != _BerandaLayout.hero || rows.length < 3))
                    FilledButton.icon(
                      onPressed: _add,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Tambah'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _blue,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (snapshot.connectionState != ConnectionState.done)
                const LinearProgressIndicator(minHeight: 2)
              else if (snapshot.hasError)
                _ErrorBox(message: '${snapshot.error}')
              else if (rows.isEmpty)
                const _EmptyBox()
              else
                _buildContent(rows),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(List<Map<String, dynamic>> rows) {
    switch (widget.layout) {
      case _BerandaLayout.hero:
        final orderedRows = _orderedHeroRows(rows);
        return Column(
          children: [
            _buildHeroContent(orderedRows.first, orderedRows),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Gambar Banner / Carousel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _text,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < orderedRows.length; index++) ...[
              _buildBannerCard(orderedRows[index], index),
              if (index != orderedRows.length - 1) const SizedBox(height: 14),
            ],
          ],
        );
      case _BerandaLayout.feature:
        return _buildFeature(rows.first);
      case _BerandaLayout.stats:
        return _buildCards(rows.take(4).toList(), statMode: true);
      case _BerandaLayout.list:
        return _buildList(rows.take(5).toList());
      case _BerandaLayout.cards:
        return _buildCards(rows.take(6).toList());
    }
  }

  Widget _buildHeroContent(
    Map<String, dynamic> row,
    List<Map<String, dynamic>> rows,
  ) {
    final title = _first(row, [
      'judul',
      'nama',
    ], fallback: 'Selamat Datang di SMAK');
    final subtitle = _first(row, ['subjudul']);
    final shortName = _first(row, ['nama_singkat'], fallback: 'SMAK');
    final longName = _first(row, [
      'nama_panjang',
    ], fallback: 'Sekolah Menengah Atas Katolik');
    final description = _first(row, ['deskripsi']);
    final image = _first(row, ['gambar', 'foto']);
    final button1 = _first(row, ['teks_tombol_1'], fallback: 'Profil Sekolah');
    final link1 = _first(row, ['link_tombol_1'], fallback: '/profil-sekolah');
    final button2 = _first(row, ['teks_tombol_2'], fallback: 'PPDB Online');
    final link2 = _first(row, ['link_tombol_2'], fallback: '/ppdb');

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 920;

        final heroPreview = Container(
          height: 190,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF0A4C9D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              websiteContentImage(image, fit: BoxFit.cover),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xF20756C8),
                      Color(0xA0052F6D),
                      Color(0x33052F6D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      shortName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      longName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    const SizedBox(height: 7),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _heroPreviewButton(button1),
                        const SizedBox(width: 7),
                        _heroPreviewButton(button2),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        final textFields = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Judul Utama', style: _labelStyle),
            const SizedBox(height: 5),
            _ReadField(text: title),
            const SizedBox(height: 8),
            const Text('Nama Singkat Hero', style: _labelStyle),
            const SizedBox(height: 5),
            _ReadField(text: shortName),
            const SizedBox(height: 8),
            const Text('Nama Panjang Hero', style: _labelStyle),
            const SizedBox(height: 5),
            _ReadField(text: longName),
            const SizedBox(height: 8),
            const Text('Sub Judul', style: _labelStyle),
            const SizedBox(height: 5),
            _ReadField(text: subtitle),
            const SizedBox(height: 8),
            const Text('Deskripsi', style: _labelStyle),
            const SizedBox(height: 5),
            _ReadField(text: description, minHeight: 68),
          ],
        );

        final top = compact
            ? Column(
                children: [heroPreview, const SizedBox(height: 12), textFields],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 38, child: heroPreview),
                  const SizedBox(width: 14),
                  Expanded(flex: 55, child: textFields),
                ],
              );

        return Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Konten Hero', style: _sectionTitleStyle),
            ),
            const SizedBox(height: 12),
            top,
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _heroButtonBox('Tombol 1', button1, link1)),
                const SizedBox(width: 10),
                Expanded(child: _heroButtonBox('Tombol 2', button2, link2)),
              ],
            ),
            const SizedBox(height: 14),
            _BerandaSummaryGroup(
              title: 'Judul Section dan Tombol Beranda',
              fields: [
                _BerandaSummaryField(
                  'Judul Section Program',
                  '${row['judul_program'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Subjudul Section Program',
                  '${row['subjudul_program'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Judul Section Kehidupan',
                  '${row['judul_kehidupan'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Subjudul Section Kehidupan',
                  '${row['subjudul_kehidupan'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Judul Section Prestasi',
                  '${row['judul_prestasi'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Subjudul Section Prestasi',
                  '${row['subjudul_prestasi'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Judul Section Berita',
                  '${row['judul_berita'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Judul Section Galeri',
                  '${row['judul_galeri'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Teks Tombol Tentang',
                  '${row['teks_tombol_tentang'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Link Tombol Tentang',
                  '${row['link_tombol_tentang'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Teks Tombol Sambutan',
                  '${row['teks_tombol_sambutan'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Link Tombol Sambutan',
                  '${row['link_tombol_sambutan'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Teks Tombol Kesiswaan',
                  '${row['teks_tombol_kesiswaan'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Link Tombol Kesiswaan',
                  '${row['link_tombol_kesiswaan'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Teks Tombol Lihat Semua',
                  '${row['teks_lihat_semua'] ?? ''}',
                ),
                _BerandaSummaryField(
                  'Teks Tombol Lokasi',
                  '${row['teks_tombol_lokasi'] ?? ''}',
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Edit teks dan tombol',
                    onPressed: () => _editHeroContent(row, rows),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: _blue,
                      size: 19,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> row, int index) {
    final image = _first(row, ['gambar', 'foto']);
    final urutan = _first(row, ['urutan'], fallback: '${index + 1}');
    final status = _first(row, ['status'], fallback: 'aktif');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 680;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Urutan Tampil', style: _labelStyle),
              const SizedBox(height: 5),
              _ReadField(text: urutan),
              const SizedBox(height: 10),
              Text('Status Tampil', style: _labelStyle),
              const SizedBox(height: 5),
              _ReadField(text: status == 'nonaktif' ? 'Nonaktif' : 'Aktif'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () => _changeBanner(row),
                    style: FilledButton.styleFrom(backgroundColor: _blue),
                    child: Text(image.isEmpty ? 'Pilih Foto' : 'Ganti Foto'),
                  ),
                  OutlinedButton(
                    onPressed: image.isEmpty ? null : () => _clearBanner(row),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD92D20),
                      side: const BorderSide(color: Color(0xFFFF8A8A)),
                    ),
                    child: const Text('Hapus Foto'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _editBanner(row),
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Edit Banner'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _delete(row),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD92D20),
                      side: const BorderSide(color: Color(0xFFFF8A8A)),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 17),
                    label: const Text('Hapus Banner'),
                  ),
                ],
              ),
            ],
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Banner ${index + 1}', style: _sectionTitleStyle),
              const SizedBox(height: 12),
              if (compact)
                Column(
                  children: [
                    _ImagePreview(
                      api: widget.api,
                      filename: image,
                      height: 150,
                    ),
                    const SizedBox(height: 14),
                    details,
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _ImagePreview(
                        api: widget.api,
                        filename: image,
                        height: 150,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(flex: 5, child: details),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _heroPreviewButton(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: _blue,
        fontSize: 7.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  Widget _heroButtonBox(String label, String text, String link) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 10)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(child: _heroReadBox('Teks Tombol', text)),
            const SizedBox(width: 8),
            Expanded(child: _heroReadBox('Link', link)),
          ],
        ),
      ],
    ),
  );

  Widget _heroReadBox(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _text,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD9E3F0)),
        ),
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF334E70), fontSize: 10),
        ),
      ),
    ],
  );

  Widget _buildFeature(Map<String, dynamic> row) {
    final title = _first(row, [
      'judul',
      'nama',
      'nama_lengkap',
    ], fallback: 'Konten');
    final description = _first(row, [
      'deskripsi',
      'isi',
      'sambutan',
      'ringkasan',
      'subjudul',
    ]);
    final image = _first(row, ['gambar', 'foto', 'foto_kepala_sekolah']);
    final extraFields = <_BerandaSummaryField>[
      if (widget.table == 'beranda_tentang')
        _BerandaSummaryField('Label', '${row['label'] ?? ''}'),
      if (widget.table == 'beranda_ppdb') ...[
        _BerandaSummaryField('Label', '${row['label'] ?? ''}'),
        _BerandaSummaryField('Teks Tombol 1', '${row['teks_tombol_1'] ?? ''}'),
        _BerandaSummaryField(
          'Tautan Tombol 1',
          '${row['link_tombol_1'] ?? ''}',
        ),
        _BerandaSummaryField('Teks Tombol 2', '${row['teks_tombol_2'] ?? ''}'),
        _BerandaSummaryField(
          'Tautan Tombol 2',
          '${row['link_tombol_2'] ?? ''}',
        ),
      ],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageBox = SizedBox(
          width: 210,
          child: _ImagePreview(api: widget.api, filename: image, height: 145),
        );
        final detail = Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 145),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description.isEmpty ? 'Belum ada deskripsi.' : description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, height: 1.45),
                ),
                if (extraFields.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _BerandaSummaryGroup(fields: extraFields, compact: true),
                ],
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: _RowActions(
                    onEdit: () => _edit(row),
                    onDelete: widget.allowDelete ? () => _delete(row) : null,
                  ),
                ),
              ],
            ),
          ),
        );

        if (constraints.maxWidth < 700) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ImagePreview(api: widget.api, filename: image, height: 180),
              const SizedBox(height: 12),
              Row(children: [detail]),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [imageBox, const SizedBox(width: 14), detail],
        );
      },
    );
  }

  IconData _contentIcon(String value, {int index = 0}) {
    final key = value.trim().toLowerCase();
    if (widget.table == 'beranda_keunggulan') {
      return switch (key) {
        'book' => Icons.menu_book_rounded,
        'groups' => Icons.groups_rounded,
        'emoji_events' => Icons.emoji_events_rounded,
        'church' => Icons.church_rounded,
        _ => Icons.auto_awesome_rounded,
      };
    }
    if (widget.table == 'beranda_program') {
      return switch (key) {
        'church' => Icons.church_rounded,
        'emoji_events' => Icons.emoji_events_rounded,
        'computer' => Icons.computer_rounded,
        'developer_board' => Icons.developer_board_rounded,
        _ => Icons.auto_awesome_rounded,
      };
    }
    if (widget.table == 'beranda_statistik') {
      return switch (key) {
        'emoji_events' => Icons.emoji_events_rounded,
        'star' => Icons.star_rounded,
        'groups' => Icons.groups_rounded,
        'verified' => Icons.verified_rounded,
        _ => const [
          Icons.verified_rounded,
          Icons.emoji_events_rounded,
          Icons.star_rounded,
          Icons.groups_rounded,
        ][index % 4],
      };
    }
    if (widget.table == 'beranda_kontak') {
      return switch (key) {
        'phone' => Icons.phone_rounded,
        'schedule' => Icons.schedule_rounded,
        _ => Icons.location_on_rounded,
      };
    }
    return widget.icon;
  }

  Color _contentColor(String value) {
    final parsed = int.tryParse(value.trim().replaceFirst('#', ''), radix: 16);
    return parsed == null ? _blue : Color(0xFF000000 | parsed);
  }

  bool get _showContentSymbol =>
      widget.table == 'beranda_keunggulan' ||
      widget.table == 'beranda_program' ||
      widget.table == 'beranda_statistik' ||
      widget.table == 'beranda_kontak';

  Widget _buildCards(List<Map<String, dynamic>> rows, {bool statMode = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1050
            ? 4
            : width >= 700
            ? 3
            : width >= 460
            ? 2
            : 1;
        final gap = 12.0;
        final cardWidth = (width - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            final title = _first(row, [
              'judul',
              'nama',
              'label',
              'kategori',
            ], fallback: 'Konten');
            final description = _first(row, [
              'deskripsi',
              'subjudul',
              'nilai',
              'value',
              'alamat',
              'telepon',
              'email',
            ]);
            final image = _first(row, ['gambar', 'foto']);
            final extraFields = <_BerandaSummaryField>[
              if (widget.table == 'beranda_kontak')
                _BerandaSummaryField('Tautan', '${row['link'] ?? ''}'),
              if (widget.table == 'beranda_testimoni')
                _BerandaSummaryField(
                  'Peran / Keterangan',
                  '${row['peran'] ?? ''}',
                ),
            ];
            final contentIcon = _contentIcon(
              '${row['icon'] ?? ''}',
              index: index,
            );
            final contentColor = _contentColor('${row['warna'] ?? ''}');

            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kehidupan di SMAK selalu menampilkan kotak foto.
                    // Jika gambar belum diisi, _ImagePreview menampilkan placeholder.
                    if (!statMode &&
                        (image.isNotEmpty ||
                            widget.table == 'beranda_kehidupan')) ...[
                      _ImagePreview(
                        api: widget.api,
                        filename: image,
                        height: widget.table == 'beranda_kehidupan' ? 110 : 88,
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_showContentSymbol) ...[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: contentColor.withOpacity(.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(contentIcon, color: contentColor, size: 23),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description.isEmpty ? '—' : description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                    if (extraFields.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _BerandaSummaryGroup(fields: extraFields, compact: true),
                    ],
                    const SizedBox(height: 8),
                    _RowActions(
                      onEdit: () => _edit(row),
                      onDelete: widget.allowDelete ? () => _delete(row) : null,
                      compact: true,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildList(List<Map<String, dynamic>> rows) {
    return Column(
      children: rows.map((row) {
        final title = _first(row, ['judul', 'nama'], fallback: 'Tanpa judul');
        final description = _first(row, ['deskripsi', 'subjudul', 'tanggal']);
        final image = _first(row, ['gambar', 'foto']);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: _line)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 86,
                child: _ImagePreview(
                  api: widget.api,
                  filename: image,
                  height: 58,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _RowActions(
                onEdit: () => _edit(row),
                onDelete: widget.allowDelete ? () => _delete(row) : null,
                compact: true,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _BerandaFieldSpec {
  const _BerandaFieldSpec(
    this.key,
    this.label, {
    this.multiline = false,
    this.type = _BerandaFieldType.text,
    this.hint,
  });

  final String key;
  final String label;
  final bool multiline;
  final _BerandaFieldType type;
  final String? hint;
}

enum _BerandaFieldType { text, image, number, status }

enum _SliderEditorMode { all, content, banner }

class _BerandaEditDialog extends StatefulWidget {
  const _BerandaEditDialog({
    required this.api,
    required this.table,
    required this.title,
    required this.note,
    required this.icon,
    this.row,
    this.initialData,
    this.sliderMode = _SliderEditorMode.all,
    this.sliderRows = const [],
  });

  final SmakApi api;
  final String table;
  final String title;
  final String note;
  final IconData icon;
  final Map<String, dynamic>? row;
  final Map<String, dynamic>? initialData;
  final _SliderEditorMode sliderMode;
  final List<Map<String, dynamic>> sliderRows;

  @override
  State<_BerandaEditDialog> createState() => _BerandaEditDialogState();
}

class _BerandaEditDialogState extends State<_BerandaEditDialog> {
  late final List<_BerandaFieldSpec> _fields;
  late final Map<String, TextEditingController> _controllers;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _fields = _specsFor(widget.table);
    final data = widget.row ?? widget.initialData ?? const <String, dynamic>{};
    _controllers = {
      for (final field in _fields)
        field.key: TextEditingController(
          text: field.key == 'status' && '${data[field.key] ?? ''}'.isEmpty
              ? 'aktif'
              : '${data[field.key] ?? ''}',
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<_BerandaFieldSpec> _specsFor(String table) {
    switch (table) {
      case 'beranda_slider':
        if (widget.sliderMode == _SliderEditorMode.content) {
          return const [
            _BerandaFieldSpec('judul', 'Judul Hero'),
            _BerandaFieldSpec('nama_singkat', 'Nama Singkat Hero'),
            _BerandaFieldSpec('nama_panjang', 'Nama Panjang Hero'),
            _BerandaFieldSpec('subjudul', 'Subjudul Hero', multiline: true),
            _BerandaFieldSpec('judul_program', 'Judul Section Program'),
            _BerandaFieldSpec(
              'subjudul_program',
              'Subjudul Section Program',
              multiline: true,
            ),
            _BerandaFieldSpec('judul_kehidupan', 'Judul Section Kehidupan'),
            _BerandaFieldSpec(
              'subjudul_kehidupan',
              'Subjudul Section Kehidupan',
              multiline: true,
            ),
            _BerandaFieldSpec('judul_prestasi', 'Judul Section Prestasi'),
            _BerandaFieldSpec(
              'subjudul_prestasi',
              'Subjudul Section Prestasi',
              multiline: true,
            ),
            _BerandaFieldSpec('judul_berita', 'Judul Section Berita'),
            _BerandaFieldSpec('judul_galeri', 'Judul Section Galeri'),
            _BerandaFieldSpec('teks_tombol_tentang', 'Teks Tombol Tentang'),
            _BerandaFieldSpec('link_tombol_tentang', 'Link Tombol Tentang'),
            _BerandaFieldSpec('teks_tombol_sambutan', 'Teks Tombol Sambutan'),
            _BerandaFieldSpec('link_tombol_sambutan', 'Link Tombol Sambutan'),
            _BerandaFieldSpec('teks_tombol_kesiswaan', 'Teks Tombol Kesiswaan'),
            _BerandaFieldSpec('link_tombol_kesiswaan', 'Link Tombol Kesiswaan'),
            _BerandaFieldSpec('teks_lihat_semua', 'Teks Tombol Lihat Semua'),
            _BerandaFieldSpec('teks_tombol_lokasi', 'Teks Tombol Lokasi'),
            _BerandaFieldSpec('teks_tombol_1', 'Teks Tombol 1'),
            _BerandaFieldSpec(
              'link_tombol_1',
              'Tautan Tombol 1',
              hint: 'Contoh: /profil-sekolah',
            ),
            _BerandaFieldSpec('teks_tombol_2', 'Teks Tombol 2'),
            _BerandaFieldSpec(
              'link_tombol_2',
              'Tautan Tombol 2',
              hint: 'Contoh: /ppdb',
            ),
          ];
        }
        if (widget.sliderMode == _SliderEditorMode.banner) {
          return const [
            _BerandaFieldSpec(
              'gambar',
              'Gambar Banner',
              type: _BerandaFieldType.image,
            ),
            _BerandaFieldSpec(
              'urutan',
              'Urutan Tampil',
              type: _BerandaFieldType.number,
            ),
            _BerandaFieldSpec(
              'status',
              'Status Tampil',
              type: _BerandaFieldType.status,
            ),
          ];
        }
        return const [
          _BerandaFieldSpec('judul', 'Judul Hero'),
          _BerandaFieldSpec('nama_singkat', 'Nama Singkat Hero'),
          _BerandaFieldSpec('nama_panjang', 'Nama Panjang Hero'),
          _BerandaFieldSpec('subjudul', 'Subjudul Hero', multiline: true),
          _BerandaFieldSpec(
            'gambar',
            'Gambar Banner',
            type: _BerandaFieldType.image,
          ),
          _BerandaFieldSpec('teks_tombol_1', 'Teks Tombol 1'),
          _BerandaFieldSpec(
            'link_tombol_1',
            'Tautan Tombol 1',
            hint: 'Contoh: /profil-sekolah',
          ),
          _BerandaFieldSpec('teks_tombol_2', 'Teks Tombol 2'),
          _BerandaFieldSpec(
            'link_tombol_2',
            'Tautan Tombol 2',
            hint: 'Contoh: /ppdb',
          ),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_keunggulan':
        return const [
          _BerandaFieldSpec('judul', 'Judul Highlight'),
          _BerandaFieldSpec('deskripsi', 'Deskripsi', multiline: true),
          _BerandaFieldSpec(
            'icon',
            'Nama Ikon',
            hint: 'Contoh: school atau groups',
          ),
          _BerandaFieldSpec('warna', 'Warna Ikon', hint: 'Contoh: #0756C8'),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_tentang':
        return const [
          _BerandaFieldSpec('label', 'Label'),
          _BerandaFieldSpec('judul', 'Judul'),
          _BerandaFieldSpec('deskripsi', 'Deskripsi', multiline: true),
          _BerandaFieldSpec('gambar', 'Gambar', type: _BerandaFieldType.image),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_program':
        return const [
          _BerandaFieldSpec('judul', 'Nama Program'),
          _BerandaFieldSpec('deskripsi', 'Deskripsi', multiline: true),
          _BerandaFieldSpec(
            'gambar',
            'Gambar Program',
            type: _BerandaFieldType.image,
          ),
          _BerandaFieldSpec('icon', 'Nama Ikon', hint: 'Contoh: auto_stories'),
          _BerandaFieldSpec('warna', 'Warna Ikon', hint: 'Contoh: #0756C8'),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_ppdb':
        return const [
          _BerandaFieldSpec('label', 'Label'),
          _BerandaFieldSpec('judul', 'Judul'),
          _BerandaFieldSpec('deskripsi', 'Deskripsi', multiline: true),
          _BerandaFieldSpec(
            'gambar',
            'Gambar Latar',
            type: _BerandaFieldType.image,
          ),
          _BerandaFieldSpec('teks_tombol_1', 'Teks Tombol 1'),
          _BerandaFieldSpec(
            'link_tombol_1',
            'Tautan Tombol 1',
            hint: 'Contoh: /ppdb/daftar',
          ),
          _BerandaFieldSpec('teks_tombol_2', 'Teks Tombol 2'),
          _BerandaFieldSpec(
            'link_tombol_2',
            'Tautan Tombol 2',
            hint: 'Contoh: /ppdb',
          ),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_kehidupan':
        return const [
          _BerandaFieldSpec('judul', 'Judul'),
          _BerandaFieldSpec('deskripsi', 'Deskripsi', multiline: true),
          _BerandaFieldSpec('gambar', 'Gambar', type: _BerandaFieldType.image),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_statistik':
        return const [
          _BerandaFieldSpec('judul', 'Label Statistik'),
          _BerandaFieldSpec('nilai', 'Nilai'),
          _BerandaFieldSpec('icon', 'Nama Ikon', hint: 'Contoh: emoji_events'),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_kontak':
        return const [
          _BerandaFieldSpec('judul', 'Judul Kontak'),
          _BerandaFieldSpec('deskripsi', 'Isi / Keterangan', multiline: true),
          _BerandaFieldSpec(
            'icon',
            'Nama Ikon',
            hint: 'Contoh: location_on atau call',
          ),
          _BerandaFieldSpec(
            'link',
            'Tautan',
            hint: 'Contoh: https://maps.google.com/...',
          ),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'beranda_testimoni':
        return const [
          _BerandaFieldSpec('judul', 'Nama'),
          _BerandaFieldSpec('peran', 'Peran / Keterangan'),
          _BerandaFieldSpec('deskripsi', 'Testimoni', multiline: true),
          _BerandaFieldSpec('gambar', 'Foto', type: _BerandaFieldType.image),
          _BerandaFieldSpec(
            'urutan',
            'Urutan Tampil',
            type: _BerandaFieldType.number,
          ),
          _BerandaFieldSpec(
            'status',
            'Status Tampil',
            type: _BerandaFieldType.status,
          ),
        ];
      case 'berita':
        return const [
          _BerandaFieldSpec('judul', 'Judul'),
          _BerandaFieldSpec('deskripsi', 'Deskripsi', multiline: true),
        ];
      default:
        return const [
          _BerandaFieldSpec('judul', 'Judul'),
          _BerandaFieldSpec('deskripsi', 'Deskripsi', multiline: true),
        ];
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final values = <String, dynamic>{
        for (final field in _fields)
          field.key: _controllers[field.key]!.text.trim(),
      };
      if (widget.table == 'beranda_slider' &&
          widget.sliderMode == _SliderEditorMode.content) {
        for (final row in widget.sliderRows) {
          final data = Map<String, dynamic>.from(row);
          final id = int.tryParse('${data.remove('id') ?? ''}');
          data.addAll(values);
          await widget.api.save(widget.table, data, id: id);
        }
      } else {
        final data = widget.row == null
            ? Map<String, dynamic>.from(widget.initialData ?? const {})
            : Map<String, dynamic>.from(widget.row!);
        final id = int.tryParse('${data.remove('id') ?? ''}');
        data.addAll(values);
        await widget.api.save(widget.table, data, id: id);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
    }
  }

  Future<void> _selectImage(_BerandaFieldSpec spec) async {
    final picker = html.FileUploadInputElement()
      ..accept = 'image/jpeg,image/png,image/webp';
    picker.click();
    await picker.onChange.first;
    final files = picker.files;
    if (files == null || files.isEmpty) return;

    setState(() => _saving = true);
    try {
      final filename = await widget.api.uploadFile(widget.table, files.first);
      if (!mounted) return;
      setState(() {
        _controllers[spec.key]!.text = filename;
        _saving = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.row != null;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 660, maxHeight: 720),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: _blue, size: 21),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${editing ? 'Edit' : 'Tambah'} ${widget.title}',
                          style: const TextStyle(
                            color: _text,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.note,
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
                    onPressed: _saving
                        ? null
                        : () => Navigator.pop(context, false),
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
                    for (int i = 0; i < _fields.length; i++) ...[
                      _field(_fields[i]),
                      if (i != _fields.length - 1) const SizedBox(height: 15),
                    ],
                    if (widget.table == 'beranda_slider') ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFD),
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: _line),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.image_outlined, color: _blue, size: 18),
                            SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Foto banner diganti dari tombol “Ganti Foto” pada kartu Banner / Hero.',
                                style: TextStyle(color: _muted, fontSize: 11.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    onPressed: _saving
                        ? null
                        : () => Navigator.pop(context, false),
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
                    onPressed: _saving ? null : _save,
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
                    icon: _saving
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined, size: 17),
                    label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(_BerandaFieldSpec spec) {
    if (spec.type == _BerandaFieldType.status) {
      final current = _controllers[spec.key]!.text.trim().toLowerCase();
      final value = current == 'nonaktif' ? 'nonaktif' : 'aktif';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spec.label,
            style: const TextStyle(
              color: _text,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            value: value,
            items: const [
              DropdownMenuItem(value: 'aktif', child: Text('Aktif')),
              DropdownMenuItem(value: 'nonaktif', child: Text('Nonaktif')),
            ],
            onChanged: _saving
                ? null
                : (selected) =>
                      _controllers[spec.key]!.text = selected ?? 'aktif',
            decoration: _inputDecoration(),
          ),
        ],
      );
    }

    if (spec.type == _BerandaFieldType.image) {
      final filename = _controllers[spec.key]!.text.trim();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spec.label,
            style: const TextStyle(
              color: _text,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          _ImagePreview(api: widget.api, filename: filename, height: 150),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : () => _selectImage(spec),
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: Text(
                    filename.isEmpty ? 'Pilih Gambar' : 'Ganti Gambar',
                  ),
                ),
              ),
              if (filename.isNotEmpty) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _saving
                      ? null
                      : () => setState(() => _controllers[spec.key]!.clear()),
                  child: const Text('Hapus'),
                ),
              ],
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          spec.label,
          style: const TextStyle(
            color: _text,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        AdminContentTextField(
          controller: _controllers[spec.key],
          constraint: adminConstraintFor(
            spec.label,
            maxLines: spec.multiline ? 6 : 1,
          ),
          keyboardType: spec.type == _BerandaFieldType.number
              ? TextInputType.number
              : TextInputType.text,
          minLines: spec.multiline ? 3 : 1,
          maxLines: spec.multiline ? 6 : 1,
          decoration: _inputDecoration(
            hintText: spec.hint ?? 'Masukkan ${spec.label.toLowerCase()}',
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hintText}) => InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(0xFF9AA9BA), fontSize: 12),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD5DFEB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _blue, width: 1.4),
    ),
  );
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.api,
    required this.filename,
    required this.height,
  });

  final SmakApi api;
  final String filename;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: filename.trim().isEmpty
          ? const Center(
              child: Icon(Icons.image_outlined, color: _muted, size: 34),
            )
          : websiteContentImage(filename, fit: BoxFit.cover),
    );
  }
}

class _BerandaSummaryField {
  const _BerandaSummaryField(this.label, this.value);

  final String label;
  final String value;
}

class _BerandaSummaryGroup extends StatelessWidget {
  const _BerandaSummaryGroup({
    required this.fields,
    this.title,
    this.compact = false,
  });

  final List<_BerandaSummaryField> fields;
  final String? title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 10 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: _sectionTitleStyle),
            const SizedBox(height: 10),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = !compact && constraints.maxWidth >= 720 ? 2 : 1;
              final spacing = columns == 2 ? 12.0 : 0.0;
              final itemWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: 10,
                children: fields
                    .map(
                      (field) => SizedBox(
                        width: itemWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(field.label, style: _labelStyle),
                            const SizedBox(height: 5),
                            _ReadField(text: field.value),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReadField extends StatelessWidget {
  const _ReadField({required this.text, this.minHeight = 42});

  final String text;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Text(
        text.isEmpty ? '—' : text,
        style: const TextStyle(color: Color(0xFF334155), fontSize: 12),
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions({
    required this.onEdit,
    this.onDelete,
    this.compact = false,
  });

  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Edit',
          visualDensity: compact
              ? VisualDensity.compact
              : VisualDensity.standard,
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, color: _blue, size: 19),
        ),
        if (onDelete != null)
          IconButton(
            tooltip: 'Hapus',
            visualDensity: compact
                ? VisualDensity.compact
                : VisualDensity.standard,
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFE5484D),
              size: 19,
            ),
          ),
      ],
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: const Text(
        'Belum ada data pada bagian ini.',
        style: TextStyle(color: _muted, fontSize: 12),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFD7D7)),
      ),
      child: Text(
        'Gagal memuat data: $message',
        style: const TextStyle(color: Color(0xFFB42318), fontSize: 12),
      ),
    );
  }
}

const TextStyle _labelStyle = TextStyle(
  color: _text,
  fontSize: 11,
  fontWeight: FontWeight.w700,
);

const TextStyle _sectionTitleStyle = TextStyle(
  color: _text,
  fontSize: 15,
  fontWeight: FontWeight.w900,
);
