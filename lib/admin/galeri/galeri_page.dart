part of '../admin_dashboard_page.dart';

class AdminGalleryPage extends StatefulWidget {
  const AdminGalleryPage({super.key, required this.api});

  final SmakApi api;

  @override
  State<AdminGalleryPage> createState() => _AdminGalleryPageState();
}

class _AdminGalleryPageState extends State<AdminGalleryPage> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Map<String, dynamic>>> _future;
  String _selectedCategory = 'Semua Kategori';
  String _selectedStatus = 'Semua';
  String _sort = 'Terbaru';
  bool _gridMode = true;
  int _page = 1;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    _future = widget.api.getTable('galeri', limit: 500);
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        final allRows = snapshot.data ?? <Map<String, dynamic>>[];
        final categories = _categories(allRows);
        final rows = _filteredRows(allRows);
        final totalPages = rows.isEmpty ? 1 : (rows.length / _pageSize).ceil();

        if (_page > totalPages) {
          _page = totalPages;
        }

        final start = (_page - 1) * _pageSize;
        final end = (start + _pageSize).clamp(0, rows.length);
        final pageRows = rows.isEmpty
            ? <Map<String, dynamic>>[]
            : rows.sublist(start, end);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _GalleryBreadcrumb(),
            const SizedBox(height: 12),
            _GalleryHeader(
              onCategory: () => _showCategories(categories),
              onUpload: () async {
                await _openAdminEditor(
                  context,
                  widget.api,
                  const AdminModule(
                    'Galeri',
                    'Kelola foto kegiatan sekolah',
                    Icons.photo_library_rounded,
                    'galeri',
                  ),
                );
                await _refresh();
              },
            ),
            const SizedBox(height: 20),
            _GalleryStats(rows: allRows),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _GalleryToolbar(
                    searchController: _searchController,
                    categories: categories,
                    selectedCategory: _selectedCategory,
                    selectedStatus: _selectedStatus,
                    sort: _sort,
                    gridMode: _gridMode,
                    onSearch: (_) => setState(() => _page = 1),
                    onCategory: (value) => setState(() {
                      _selectedCategory = value ?? 'Semua Kategori';
                      _page = 1;
                    }),
                    onStatus: (value) => setState(() {
                      _selectedStatus = value ?? 'Semua';
                      _page = 1;
                    }),
                    onSort: (value) => setState(() {
                      _sort = value ?? 'Terbaru';
                      _page = 1;
                    }),
                    onMode: (value) => setState(() => _gridMode = value),
                  ),
                  const SizedBox(height: 18),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Padding(
                      padding: EdgeInsets.all(60),
                      child: CircularProgressIndicator(),
                    )
                  else if (snapshot.hasError)
                    Padding(
                      padding: const EdgeInsets.all(45),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Color(0xFFD92D20),
                            size: 42,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal memuat galeri: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => setState(_reload),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  else if (pageRows.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(60),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            color: _muted,
                            size: 48,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada foto galeri yang sesuai.',
                            style: TextStyle(color: _muted),
                          ),
                        ],
                      ),
                    )
                  else if (_gridMode)
                    _GalleryGrid(
                      rows: pageRows,
                      imageUrl: _imageUrl,
                      onPreview: _preview,
                      onEdit: _edit,
                      onDelete: _delete,
                    )
                  else
                    _GalleryList(
                      rows: pageRows,
                      imageUrl: _imageUrl,
                      onPreview: _preview,
                      onEdit: _edit,
                      onDelete: _delete,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _GalleryPagination(
              totalRows: rows.length,
              page: _page,
              totalPages: totalPages,
              pageSize: _pageSize,
              onPage: (value) => setState(() => _page = value),
              onPageSize: (value) => setState(() {
                _pageSize = value ?? 10;
                _page = 1;
              }),
            ),
            const SizedBox(height: 12),
            const _DashboardFooter(),
          ],
        );
      },
    );
  }

  List<String> _categories(List<Map<String, dynamic>> rows) {
    final result =
        rows
            .map((row) => '${row['kategori'] ?? ''}'.trim())
            .where((value) => value.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    return ['Semua Kategori', ...result];
  }

  List<Map<String, dynamic>> _filteredRows(List<Map<String, dynamic>> source) {
    final keyword = _searchController.text.trim().toLowerCase();

    final rows = source.where((row) {
      final title = '${row['judul'] ?? ''}'.toLowerCase();
      final category = '${row['kategori'] ?? ''}'.toLowerCase();
      final description = '${row['deskripsi'] ?? ''}'.toLowerCase();
      final status = '${row['status'] ?? 'aktif'}'.toLowerCase();

      final searchMatch =
          keyword.isEmpty ||
          title.contains(keyword) ||
          category.contains(keyword) ||
          description.contains(keyword);

      final categoryMatch =
          _selectedCategory == 'Semua Kategori' ||
          category == _selectedCategory.toLowerCase();

      final statusMatch =
          _selectedStatus == 'Semua' || status == _selectedStatus.toLowerCase();

      return searchMatch && categoryMatch && statusMatch;
    }).toList();

    rows.sort((a, b) {
      switch (_sort) {
        case 'Terlama':
          return _dateOf(a).compareTo(_dateOf(b));
        case 'Judul A-Z':
          return '${a['judul'] ?? ''}'.toLowerCase().compareTo(
            '${b['judul'] ?? ''}'.toLowerCase(),
          );
        case 'Judul Z-A':
          return '${b['judul'] ?? ''}'.toLowerCase().compareTo(
            '${a['judul'] ?? ''}'.toLowerCase(),
          );
        default:
          return _dateOf(b).compareTo(_dateOf(a));
      }
    });

    return rows;
  }

  DateTime _dateOf(Map<String, dynamic> row) {
    return DateTime.tryParse('${row['tanggal'] ?? row['created_at'] ?? ''}') ??
        DateTime(2000);
  }

  String _imageUrl(Map<String, dynamic> row) {
    return '${row['gambar'] ?? ''}'.trim();
  }

  Future<void> _edit(Map<String, dynamic> row) async {
    await _openAdminEditor(
      context,
      widget.api,
      const AdminModule(
        'Galeri',
        'Kelola foto kegiatan sekolah',
        Icons.photo_library_rounded,
        'galeri',
      ),
      row: row,
    );
    await _refresh();
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final id = (row['id'] as num?)?.toInt();
    if (id == null) return;

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Hapus foto?'),
            content: Text(
              'Foto "${row['judul'] ?? 'Galeri'}" akan dihapus permanen.',
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
        ) ??
        false;

    if (!confirmed) return;

    try {
      await widget.api.delete('galeri', id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto galeri berhasil dihapus.')),
      );
      await _refresh();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $error')));
    }
  }

  void _preview(Map<String, dynamic> row) {
    final items = <Map<String, dynamic>>[row];
    final raw = '${row['gambar_lain'] ?? ''}'.trim();
    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final item in decoded) {
            final filename = '$item'.trim();
            if (filename.isNotEmpty) {
              items.add({...row, 'gambar': filename, 'foto': filename});
            }
          }
        }
      } catch (_) {
        // Data lama tanpa daftar foto tambahan tetap dapat dipreview.
      }
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => _GalleryPreviewDialog(
        items: items,
        initialIndex: 0,
        imageUrl: _imageUrl,
      ),
    );
  }

  Future<void> _showCategories(List<String> categories) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kategori Galeri'),
        content: SizedBox(
          width: 400,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories
                .where((item) => item != 'Semua Kategori')
                .map((item) => Chip(label: Text(item)))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

class _GalleryBreadcrumb extends StatelessWidget {
  const _GalleryBreadcrumb();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text('Dashboard', style: TextStyle(color: _blue, fontSize: 12)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Icon(Icons.chevron_right_rounded, size: 17, color: _muted),
        ),
        Text('Galeri', style: TextStyle(color: _blue, fontSize: 12)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Icon(Icons.chevron_right_rounded, size: 17, color: _muted),
        ),
        Text('Galeri Kegiatan', style: TextStyle(color: _muted, fontSize: 12)),
      ],
    );
  }
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader({required this.onCategory, required this.onUpload});

  final VoidCallback onCategory;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;
        const title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Galeri Kegiatan',
              style: TextStyle(
                color: _text,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Kelola semua foto kegiatan sekolah.',
              style: TextStyle(color: _muted, fontSize: 13),
            ),
          ],
        );

        return Flex(
          direction: compact ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compact) title else const Expanded(child: title),
            if (compact) const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      _openAdminPreview(context, const GaleriPage()),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview Halaman'),
                ),
                OutlinedButton.icon(
                  onPressed: onCategory,
                  icon: const Icon(Icons.category_outlined),
                  label: const Text('Kategori'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 15,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Upload Kegiatan'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _GalleryStats extends StatelessWidget {
  const _GalleryStats({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    final active = rows.where((row) {
      return '${row['status'] ?? 'aktif'}'.toLowerCase() == 'aktif';
    }).length;

    final inactive = rows.length - active;
    final categories = rows
        .map((row) => '${row['kategori'] ?? ''}'.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .length;

    final cards = [
      _GalleryStatData(
        'Total Kegiatan',
        rows.length,
        'Semua waktu',
        Icons.widgets_outlined,
        const Color(0xFF1463E8),
      ),
      _GalleryStatData(
        'Foto Aktif',
        active,
        'Ditampilkan di website',
        Icons.photo_rounded,
        const Color(0xFF18A866),
      ),
      _GalleryStatData(
        'Foto Nonaktif',
        inactive,
        'Tidak ditampilkan',
        Icons.hide_image_outlined,
        const Color(0xFFE9A113),
      ),
      _GalleryStatData(
        'Total Kategori',
        categories,
        'Kategori kegiatan',
        Icons.grid_view_rounded,
        const Color(0xFF7B4CE2),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 4;
        if (constraints.maxWidth < 1050) columns = 2;
        if (constraints.maxWidth < 580) columns = 1;

        final width = (constraints.maxWidth - ((columns - 1) * 16)) / columns;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards
              .map(
                (card) => SizedBox(
                  width: width,
                  child: _GalleryStatCard(data: card),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _GalleryStatData {
  const _GalleryStatData(
    this.label,
    this.value,
    this.note,
    this.icon,
    this.color,
  );

  final String label;
  final int value;
  final String note;
  final IconData icon;
  final Color color;
}

class _GalleryStatCard extends StatelessWidget {
  const _GalleryStatCard({required this.data});

  final _GalleryStatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: data.color.withOpacity(.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(data.icon, color: data.color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${data.value}',
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 23,
                  ),
                ),
                Text(
                  data.note,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryToolbar extends StatelessWidget {
  const _GalleryToolbar({
    required this.searchController,
    required this.categories,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.sort,
    required this.gridMode,
    required this.onSearch,
    required this.onCategory,
    required this.onStatus,
    required this.onSort,
    required this.onMode,
  });

  final TextEditingController searchController;
  final List<String> categories;
  final String selectedCategory;
  final String selectedStatus;
  final String sort;
  final bool gridMode;
  final ValueChanged<String> onSearch;
  final ValueChanged<String?> onCategory;
  final ValueChanged<String?> onStatus;
  final ValueChanged<String?> onSort;
  final ValueChanged<bool> onMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth < 760;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: fullWidth ? constraints.maxWidth : 300,
              height: 46,
              child: TextField(
                controller: searchController,
                onChanged: onSearch,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Cari kegiatan, judul, atau kategori...',
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: _line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: _line),
                  ),
                ),
              ),
            ),
            _GalleryDropdown(
              width: fullWidth ? constraints.maxWidth : 175,
              value: selectedCategory,
              items: categories,
              onChanged: onCategory,
            ),
            _GalleryDropdown(
              width: fullWidth ? constraints.maxWidth : 155,
              value: selectedStatus,
              items: const ['Semua', 'aktif', 'nonaktif'],
              labels: const {
                'Semua': 'Status: Semua',
                'aktif': 'Aktif',
                'nonaktif': 'Nonaktif',
              },
              onChanged: onStatus,
            ),
            _GalleryDropdown(
              width: fullWidth ? constraints.maxWidth : 170,
              value: sort,
              items: const ['Terbaru', 'Terlama', 'Judul A-Z', 'Judul Z-A'],
              labels: const {
                'Terbaru': 'Urutkan: Terbaru',
                'Terlama': 'Urutkan: Terlama',
                'Judul A-Z': 'Judul A-Z',
                'Judul Z-A': 'Judul Z-A',
              },
              onChanged: onSort,
            ),
            SizedBox(
              height: 46,
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    icon: Icon(Icons.grid_view_rounded, size: 18),
                  ),
                  ButtonSegment(
                    value: false,
                    icon: Icon(Icons.view_list_rounded, size: 18),
                  ),
                ],
                selected: {gridMode},
                onSelectionChanged: (selection) => onMode(selection.first),
                showSelectedIcon: false,
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GalleryDropdown extends StatelessWidget {
  const _GalleryDropdown({
    required this.width,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labels = const {},
  });

  final double width;
  final String value;
  final List<String> items;
  final Map<String, String> labels;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 46,
      child: DropdownButtonFormField<String>(
        initialValue: items.contains(value) ? value : items.first,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 19),
        style: const TextStyle(
          color: _text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              labels[item] ?? item,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: _line),
          ),
        ),
      ),
    );
  }
}

class _GalleryGrid extends StatelessWidget {
  const _GalleryGrid({
    required this.rows,
    required this.imageUrl,
    required this.onPreview,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Map<String, dynamic>> rows;
  final String Function(Map<String, dynamic>) imageUrl;
  final ValueChanged<Map<String, dynamic>> onPreview;
  final ValueChanged<Map<String, dynamic>> onEdit;
  final ValueChanged<Map<String, dynamic>> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 5;
        if (constraints.maxWidth < 1250) columns = 4;
        if (constraints.maxWidth < 980) columns = 3;
        if (constraints.maxWidth < 700) columns = 2;
        if (constraints.maxWidth < 440) columns = 1;

        final width = (constraints.maxWidth - ((columns - 1) * 14)) / columns;

        return Wrap(
          spacing: 14,
          runSpacing: 16,
          children: rows
              .map(
                (row) => SizedBox(
                  width: width,
                  child: _GalleryCard(
                    row: row,
                    imageUrl: imageUrl(row),
                    onPreview: () => onPreview(row),
                    onEdit: () => onEdit(row),
                    onDelete: () => onDelete(row),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({
    required this.row,
    required this.imageUrl,
    required this.onPreview,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> row;
  final String imageUrl;
  final VoidCallback onPreview;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final active = '${row['status'] ?? 'aktif'}'.toLowerCase() == 'aktif';

    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _GalleryImage(url: imageUrl, radius: BorderRadius.zero),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GalleryCategoryBadge(
                  label: '${row['kategori'] ?? 'Kegiatan'}',
                ),
                const SizedBox(height: 8),
                Text(
                  '${row['judul'] ?? 'Galeri Kegiatan'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: _muted,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _galleryDate(row),
                        style: const TextStyle(color: _muted, fontSize: 10),
                      ),
                    ),
                    _GalleryStatusBadge(active: active),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _GalleryIconButton(
                        icon: Icons.visibility_outlined,
                        color: _blue,
                        onTap: onPreview,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _GalleryIconButton(
                        icon: Icons.edit_outlined,
                        color: _blue,
                        onTap: onEdit,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: _GalleryIconButton(
                        icon: Icons.delete_outline_rounded,
                        color: const Color(0xFFE53935),
                        onTap: onDelete,
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
}

class _GalleryList extends StatelessWidget {
  const _GalleryList({
    required this.rows,
    required this.imageUrl,
    required this.onPreview,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Map<String, dynamic>> rows;
  final String Function(Map<String, dynamic>) imageUrl;
  final ValueChanged<Map<String, dynamic>> onPreview;
  final ValueChanged<Map<String, dynamic>> onEdit;
  final ValueChanged<Map<String, dynamic>> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows.map((row) {
        final active = '${row['status'] ?? 'aktif'}'.toLowerCase() == 'aktif';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 76,
                child: _GalleryImage(
                  url: imageUrl(row),
                  radius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GalleryCategoryBadge(
                      label: '${row['kategori'] ?? 'Kegiatan'}',
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${row['judul'] ?? 'Galeri Kegiatan'}',
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _galleryDate(row),
                      style: const TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _GalleryStatusBadge(active: active),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => onPreview(row),
                icon: const Icon(Icons.visibility_outlined, color: _blue),
              ),
              IconButton(
                onPressed: () => onEdit(row),
                icon: const Icon(Icons.edit_outlined, color: _blue),
              ),
              IconButton(
                onPressed: () => onDelete(row),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GalleryPreviewDialog extends StatefulWidget {
  const _GalleryPreviewDialog({
    required this.items,
    required this.initialIndex,
    required this.imageUrl,
  });

  final List<Map<String, dynamic>> items;
  final int initialIndex;
  final String Function(Map<String, dynamic>) imageUrl;

  @override
  State<_GalleryPreviewDialog> createState() => _GalleryPreviewDialogState();
}

class _GalleryPreviewDialogState extends State<_GalleryPreviewDialog> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.items[_currentIndex];
    final total = widget.items.length;
    final currentUrl = widget.imageUrl(currentItem);
    final title = '${currentItem['judul'] ?? 'Galeri'}';
    final category = '${currentItem['kategori'] ?? 'Tanpa kategori'}';
    final description = '${currentItem['deskripsi'] ?? ''}'.trim();

    return Dialog(
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _line)),
              ),
              child: Row(
                children: [
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
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$category • ${_galleryDate(currentItem)}'
                          '${total > 1 ? " • Foto ${_currentIndex + 1} dari $total" : ""}',
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, size: 24),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF0F172A),
                    child: _GalleryImage(
                      url: currentUrl,
                      radius: BorderRadius.zero,
                    ),
                  ),
                  if (total > 1) ...[
                    Positioned(
                      left: 14,
                      child: IconButton(
                        onPressed: _currentIndex > 0
                            ? () => setState(() => _currentIndex--)
                            : null,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.55),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 14,
                      child: IconButton(
                        onPressed: _currentIndex < total - 1
                            ? () => setState(() => _currentIndex++)
                            : null,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.55),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / $total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (total > 1)
              Container(
                height: 84,
                color: const Color(0xFF0B132B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: total,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = index == _currentIndex;
                    final thumbUrl = widget.imageUrl(widget.items[index]);

                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? _blue : Colors.transparent,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _GalleryImage(
                          url: thumbUrl,
                          radius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (description.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: _line)),
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.url, required this.radius});

  final String url;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: websiteContentImage(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _GalleryCategoryBadge extends StatelessWidget {
  const _GalleryCategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: _blue,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GalleryStatusBadge extends StatelessWidget {
  const _GalleryStatusBadge({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE4F8EC) : const Color(0xFFF0F2F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'Aktif' : 'Nonaktif',
        style: TextStyle(
          color: active ? const Color(0xFF159455) : const Color(0xFF718096),
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }
}

class _GalleryIconButton extends StatelessWidget {
  const _GalleryIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        height: 31,
        decoration: BoxDecoration(
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(7),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }
}

class _GalleryPagination extends StatelessWidget {
  const _GalleryPagination({
    required this.totalRows,
    required this.page,
    required this.totalPages,
    required this.pageSize,
    required this.onPage,
    required this.onPageSize,
  });

  final int totalRows;
  final int page;
  final int totalPages;
  final int pageSize;
  final ValueChanged<int> onPage;
  final ValueChanged<int?> onPageSize;

  @override
  Widget build(BuildContext context) {
    final start = totalRows == 0 ? 0 : ((page - 1) * pageSize) + 1;
    final end = (page * pageSize).clamp(0, totalRows);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;

        return Flex(
          direction: compact ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Menampilkan $start - $end dari $totalRows data',
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ),
            if (compact) const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: [
                IconButton(
                  onPressed: page > 1 ? () => onPage(page - 1) : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                for (final value in _visiblePages(page, totalPages))
                  if (value == -1)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 12,
                      ),
                      child: Text('...'),
                    )
                  else
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: value == page
                          ? FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: _blue,
                              ),
                              child: Text('$value'),
                            )
                          : OutlinedButton(
                              onPressed: () => onPage(value),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Text('$value'),
                            ),
                    ),
                IconButton(
                  onPressed: page < totalPages ? () => onPage(page + 1) : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            if (!compact) const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tampilkan',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: pageSize,
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10')),
                    DropdownMenuItem(value: 12, child: Text('12')),
                    DropdownMenuItem(value: 20, child: Text('20')),
                  ],
                  onChanged: onPageSize,
                ),
                const SizedBox(width: 8),
                const Text(
                  'data',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static List<int> _visiblePages(int current, int total) {
    if (total <= 5) {
      return List.generate(total, (index) => index + 1);
    }

    final values = <int>[1];
    if (current > 3) values.add(-1);

    for (int value = current - 1; value <= current + 1; value++) {
      if (value > 1 && value < total) values.add(value);
    }

    if (current < total - 2) values.add(-1);
    values.add(total);
    return values;
  }
}

String _galleryDate(Map<String, dynamic> row) {
  final raw = '${row['tanggal'] ?? row['created_at'] ?? ''}';
  final date = DateTime.tryParse(raw);
  if (date == null) return raw.isEmpty ? '-' : raw;

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

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
