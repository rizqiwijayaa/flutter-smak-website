import 'package:flutter/material.dart';

import '../../services/smak_api.dart';
import '../../services/website_identity.dart';
import 'galeri_detail_page.dart';
import '../site_chrome.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  String selectedCategory = 'Semua Kegiatan';
  int currentPage = 1;
  final api = const SmakApi();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 850;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FD),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: api.getTable('galeri', limit: 100),
        builder: (context, snapshot) {
          final rows = (snapshot.data ?? const <Map<String, dynamic>>[])
              .where((row) => '${row['status'] ?? 'aktif'}' == 'aktif')
              .toList();
          final categories = _categories(rows);
          final filtered = selectedCategory == 'Semua Kegiatan'
              ? rows
              : rows
                    .where(
                      (row) => '${row['kategori'] ?? ''}' == selectedCategory,
                    )
                    .toList();
          return SingleChildScrollView(
            child: Column(
              children: [
                SharedSmakNavigationBar(
                  profilePages: const {},
                  academicPages: const {},
                  studentPages: const {},
                  galleryPage: const GaleriPage(),
                  initialActive: 'Galeri',
                ),
                _GalleryHero(imageUrl: _heroImage(rows)),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 18 : 80,
                    28,
                    compact ? 18 : 80,
                    40,
                  ),
                  child: compact
                      ? Column(
                          children: [
                            _CategoryPanel(
                              categories: categories,
                              selected: selectedCategory,
                              onSelected: _selectCategory,
                            ),
                            const SizedBox(height: 24),
                            _GalleryGrid(
                              rows: filtered,
                              loading:
                                  snapshot.connectionState ==
                                  ConnectionState.waiting,
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 270,
                              child: _CategoryPanel(
                                categories: categories,
                                selected: selectedCategory,
                                onSelected: _selectCategory,
                              ),
                            ),
                            const SizedBox(width: 28),
                            Expanded(
                              child: _GalleryGrid(
                                rows: filtered,
                                loading:
                                    snapshot.connectionState ==
                                    ConnectionState.waiting,
                              ),
                            ),
                          ],
                        ),
                ),
                SharedSmakFooter(
                  profilePages: const {},
                  academicPages: const {},
                  studentPages: const {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      currentPage = 1;
    });
  }

  List<String> _categories(List<Map<String, dynamic>> rows) {
    final result = <String>{'Semua Kegiatan'};
    for (final row in rows) {
      final category = '${row['kategori'] ?? ''}'.trim();
      if (category.isNotEmpty) result.add(category);
    }
    return result.toList();
  }

  String? _heroImage(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return null;
    final image = '${rows.first['gambar'] ?? ''}'.trim();
    if (image.isEmpty) return null;
    return image;
  }
}

class _GalleryHero extends StatelessWidget {
  const _GalleryHero({required this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(imageUrl ?? '', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xEC062C64), Color(0xAF0B559C)],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Galeri Kegiatan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Beranda   ›   Galeri   ›   Galeri Kegiatan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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

class _CategoryPanel extends StatelessWidget {
  const _CategoryPanel({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C0F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Kegiatan',
            style: TextStyle(
              color: Color(0xFF082E65),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ...categories.map(
            (category) => InkWell(
              onTap: () => onSelected(category),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selected == category
                      ? const Color(0xFFE8F1FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _categoryIcon(category),
                      color: const Color(0xFF0756C8),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: const Color(0xFF082E65),
                          fontWeight: selected == category
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryGrid extends StatelessWidget {
  const _GalleryGrid({required this.rows, required this.loading});
  final List<Map<String, dynamic>> rows;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: CircularProgressIndicator(),
        ),
      );
    if (rows.isEmpty)
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Text(
            'Belum ada foto kegiatan.',
            style: TextStyle(color: Color(0xFF526178)),
          ),
        ),
      );
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 1000
            ? 4
            : constraints.maxWidth > 650
            ? 3
            : 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Semua Kegiatan',
                  style: TextStyle(
                    color: Color(0xFF082E65),
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EEFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${rows.length} Kegiatan',
                    style: const TextStyle(
                      color: Color(0xFF0756C8),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rows.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: .78,
              ),
              itemBuilder: (context, index) => _GalleryCard(row: rows[index]),
            ),
          ],
        );
      },
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.row});
  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final image = '${row['gambar'] ?? row['foto'] ?? ''}'.trim();
    final title = '${row['judul'] ?? 'Kegiatan Sekolah'}';
    final category = '${row['kategori'] ?? 'Kegiatan'}';
    return InkWell(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => GaleriDetailPage(gallery: row))),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x100F172A),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: websiteContentImage(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F0FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Color(0xFF0756C8),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF082E65),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lihat Foto  →',
                    style: const TextStyle(
                      color: Color(0xFF0756C8),
                      fontWeight: FontWeight.w700,
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
}

IconData _categoryIcon(String category) {
  final value = category.toLowerCase();
  if (value.contains('upacara')) return Icons.flag_outlined;
  if (value.contains('akademik')) return Icons.menu_book_outlined;
  if (value.contains('ekstra')) return Icons.directions_run_rounded;
  if (value.contains('seni')) return Icons.palette_outlined;
  if (value.contains('olahraga')) return Icons.sports_basketball_outlined;
  return Icons.grid_view_rounded;
}
