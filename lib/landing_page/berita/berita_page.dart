import 'package:flutter/material.dart';

import '../../services/smak_api.dart';
import '../../services/website_identity.dart';
import '../site_chrome.dart';

const _navy = Color(0xFF082E65);
const _blue = Color(0xFF0756C8);
const _muted = Color(0xFF64748B);
const _line = Color(0xFFE2E8F0);
const _bg = Color(0xFFF7F9FC);

String _newsDescription(Map<String, dynamic> row) =>
    '${row['deskripsi'] ?? row['ringkasan'] ?? row['isi'] ?? ''}'.trim();

String _newsImage(Map<String, dynamic> row) =>
    '${row['gambar'] ?? row['thumbnail'] ?? row['foto'] ?? ''}'.trim();

String _newsDate(Map<String, dynamic> row) =>
    '${row['tanggal'] ?? row['tanggal_publikasi'] ?? row['created_at'] ?? ''}'
        .trim();

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  final _search = TextEditingController();
  late Future<List<Map<String, dynamic>>> _future;
  String _category = 'Semua';

  @override
  void initState() {
    super.initState();
    _future = const SmakApi().getTable('berita', limit: 100);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          final allRows = (snapshot.data ?? const <Map<String, dynamic>>[])
              .where(
                (row) =>
                    '${row['status'] ?? 'aktif'}'.toLowerCase() != 'nonaktif',
              )
              .toList();
          final categories = _categories(allRows);
          final rows = _filtered(allRows);

          return SingleChildScrollView(
            child: Column(
              children: [
                const SharedSmakNavigationBar(
                  profilePages: {},
                  academicPages: {},
                  studentPages: {},
                  initialActive: 'Berita',
                ),
                const _NewsHero(),
                _NewsContent(
                  rows: rows,
                  allRows: allRows,
                  categories: categories,
                  selectedCategory: _category,
                  searchController: _search,
                  loading: snapshot.connectionState == ConnectionState.waiting,
                  error: snapshot.error,
                  onSearch: () => setState(() {}),
                  onCategory: (value) => setState(() => _category = value),
                  onRetry: () => setState(() {
                    _future = const SmakApi().getTable('berita', limit: 100);
                  }),
                ),
                const SharedSmakFooter(
                  profilePages: {},
                  academicPages: {},
                  studentPages: {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<String> _categories(List<Map<String, dynamic>> rows) {
    final values = <String>{'Semua'};
    for (final row in rows) {
      final value = '${row['kategori'] ?? 'Berita'}'.trim();
      if (value.isNotEmpty) values.add(value);
    }
    return values.toList();
  }

  List<Map<String, dynamic>> _filtered(List<Map<String, dynamic>> rows) {
    final query = _search.text.trim().toLowerCase();
    return rows.where((row) {
      final category = '${row['kategori'] ?? 'Berita'}';
      final title = '${row['judul'] ?? ''}'.toLowerCase();
      final description = _newsDescription(row).toLowerCase();
      final categoryMatch = _category == 'Semua' || category == _category;
      final searchMatch =
          query.isEmpty || title.contains(query) || description.contains(query);
      return categoryMatch && searchMatch;
    }).toList();
  }
}

class _NewsHero extends StatelessWidget {
  const _NewsHero();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 30),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF0B458F), Color(0xFF073474)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: const Center(
      child: SizedBox(
        width: 1270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Berita & Pengumuman',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Beranda   ›   Berita',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NewsContent extends StatelessWidget {
  const _NewsContent({
    required this.rows,
    required this.allRows,
    required this.categories,
    required this.selectedCategory,
    required this.searchController,
    required this.loading,
    required this.error,
    required this.onSearch,
    required this.onCategory,
    required this.onRetry,
  });

  final List<Map<String, dynamic>> rows;
  final List<Map<String, dynamic>> allRows;
  final List<String> categories;
  final String selectedCategory;
  final TextEditingController searchController;
  final bool loading;
  final Object? error;
  final VoidCallback onSearch;
  final ValueChanged<String> onCategory;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 24, 30, 38),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 850;
              final main = _buildMain(context);
              final side = _NewsSidebar(
                rows: allRows,
                categories: categories,
                selectedCategory: selectedCategory,
                controller: searchController,
                onSearch: onSearch,
                onCategory: onCategory,
              );
              return compact
                  ? Column(children: [main, const SizedBox(height: 24), side])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: main),
                        const SizedBox(width: 28),
                        SizedBox(width: 290, child: side),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMain(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(80),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return _MessageBox(
        icon: Icons.cloud_off_rounded,
        text: 'Berita belum dapat dimuat.',
        action: TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
      );
    }
    if (rows.isEmpty) {
      return const _MessageBox(
        icon: Icons.article_outlined,
        text: 'Belum ada berita yang sesuai.',
      );
    }

    // Tiga konten terbaru selalu menjadi sorotan:
    // #1 = featured besar, #2-#3 = dua highlight di bawahnya.
    // Konten ke-4 dan seterusnya otomatis turun ke daftar memanjang.
    final featured = rows.first;
    final highlights = rows.skip(1).take(2).toList();

    // Preview sementara selama database masih hanya berisi 3 berita.
    // Begitu berita asli ke-4 dst tersedia, list ini otomatis memakai data DB.
    final archive = rows.length > 3
        ? rows.skip(3).toList()
        : <Map<String, dynamic>>[
            {
              'judul': 'Kegiatan Literasi Bersama Siswa',
              'deskripsi':
                  'Siswa mengikuti kegiatan literasi bersama untuk membangun kebiasaan membaca dan berdiskusi di lingkungan sekolah.',
              'kategori': 'berita',
              'tanggal': '2026-08-04',
              '_dummy': true,
            },
            {
              'judul': 'Pengumuman Kegiatan Sekolah',
              'deskripsi':
                  'Informasi terbaru mengenai agenda dan kegiatan sekolah untuk seluruh peserta didik dan orang tua.',
              'kategori': 'pengumuman',
              'tanggal': '2026-08-02',
              '_dummy': true,
            },
            {
              'judul': 'Kebersamaan dalam Kegiatan Sekolah',
              'deskripsi':
                  'Dokumentasi kegiatan siswa dan guru dalam membangun lingkungan belajar yang aktif, nyaman, dan penuh kebersamaan.',
              'kategori': 'berita',
              'tanggal': '2026-07-30',
              '_dummy': true,
            },
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3 Berita Terbaru',
          style: TextStyle(
            color: _navy,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        _FeaturedNews(row: featured),
        if (highlights.isNotEmpty) ...[
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 580 ? 1 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: highlights.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: columns == 1 ? 2.2 : 1.45,
                ),
                itemBuilder: (_, index) => _NewsCard(row: highlights[index]),
              );
            },
          ),
        ],
        if (archive.isNotEmpty) ...[
          const SizedBox(height: 30),
          const Text(
            'Berita Lainnya',
            style: TextStyle(
              color: _navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          ...archive.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _NewsListCard(row: row),
            ),
          ),
        ],
      ],
    );
  }
}

class _FeaturedNews extends StatelessWidget {
  const _FeaturedNews({required this.row});
  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => _openDetail(context, row),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;
          final image = SizedBox(
            height: compact ? 210 : 235,
            child: _NewsImage(row: row),
          );
          final copy = Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Badge('${row['kategori'] ?? 'BERITA'}'),
                const SizedBox(height: 10),
                Text(
                  '${row['judul'] ?? 'Berita Sekolah'}',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                _DateText(row: row),
                const SizedBox(height: 10),
                Text(
                  _newsDescription(row),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    height: 1.5,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Baca Selengkapnya  →',
                  style: TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
          return compact
              ? Column(children: [image, copy])
              : Row(
                  children: [
                    Expanded(flex: 5, child: image),
                    Expanded(flex: 5, child: copy),
                  ],
                );
        },
      ),
    ),
  );
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.row});
  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => _openDetail(context, row),
    borderRadius: BorderRadius.circular(11),
    child: Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              height: double.infinity,
              child: _NewsImage(row: row),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Badge('${row['kategori'] ?? 'BERITA'}'),
                  const SizedBox(height: 7),
                  Text(
                    '${row['judul'] ?? 'Berita Sekolah'}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _DateText(row: row),
                  const SizedBox(height: 7),
                  Expanded(
                    child: Text(
                      _newsDescription(row),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 10.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const Text(
                    'Baca Selengkapnya  →',
                    style: TextStyle(
                      color: _blue,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
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

class _NewsListCard extends StatelessWidget {
  const _NewsListCard({required this.row});
  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: row['_dummy'] == true ? null : () => _openDetail(context, row),
    borderRadius: BorderRadius.circular(11),
    child: Container(
      height: 150,
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 210,
            height: double.infinity,
            child: _NewsImage(row: row),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Badge('${row['kategori'] ?? 'BERITA'}'),
                      const SizedBox(width: 10),
                      _DateText(row: row),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    '${row['judul'] ?? 'Berita Sekolah'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Expanded(
                    child: Text(
                      _newsDescription(row),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const Text(
                    'Baca Selengkapnya  →',
                    style: TextStyle(
                      color: _blue,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
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

class _NewsSidebar extends StatelessWidget {
  const _NewsSidebar({
    required this.rows,
    required this.categories,
    required this.selectedCategory,
    required this.controller,
    required this.onSearch,
    required this.onCategory,
  });
  final List<Map<String, dynamic>> rows;
  final List<String> categories;
  final String selectedCategory;
  final TextEditingController controller;
  final VoidCallback onSearch;
  final ValueChanged<String> onCategory;

  @override
  Widget build(BuildContext context) {
    final announcements = rows
        .where(
          (r) => '${r['kategori'] ?? ''}'.toLowerCase().contains('pengumuman'),
        )
        .take(3)
        .toList();
    return Column(
      children: [
        TextField(
          controller: controller,
          onSubmitted: (_) => onSearch(),
          decoration: InputDecoration(
            hintText: 'Cari berita...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              onPressed: onSearch,
            ),
            filled: true,
            fillColor: Colors.white,
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
        const SizedBox(height: 16),
        _SideCard(
          title: 'Kategori Berita',
          child: Column(
            children: categories.map((category) {
              final count = category == 'Semua'
                  ? rows.length
                  : rows
                        .where(
                          (r) => '${r['kategori'] ?? 'Berita'}' == category,
                        )
                        .length;
              final selected = category == selectedCategory;
              return InkWell(
                onTap: () => onCategory(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: _line)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: selected ? _blue : _navy,
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(color: _blue, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (announcements.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SideCard(
            title: 'Pengumuman Terbaru',
            child: Column(
              children: announcements
                  .map(
                    (row) => InkWell(
                      onTap: () => _openDetail(context, row),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3E79AE),
                                    Color(0xFF173C6D),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.article_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _Badge('${row['kategori'] ?? 'PENGUMUMAN'}'),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${row['judul'] ?? ''}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _navy,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _SideCard extends StatelessWidget {
  const _SideCard({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _navy,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE5F0FF),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: _blue,
        fontSize: 9,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _DateText extends StatelessWidget {
  const _DateText({required this.row});
  final Map<String, dynamic> row;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.calendar_month_outlined, color: _muted, size: 13),
      const SizedBox(width: 5),
      Text(
        _formatDate(_newsDate(row)),
        style: const TextStyle(color: _muted, fontSize: 10.5),
      ),
    ],
  );
}

class _NewsImage extends StatelessWidget {
  const _NewsImage({required this.row});
  final Map<String, dynamic> row;
  @override
  Widget build(BuildContext context) {
    final file = _newsImage(row);
    return websiteContentImage(
      file,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

}

class _MessageBox extends StatelessWidget {
  const _MessageBox({required this.icon, required this.text, this.action});
  final IconData icon;
  final String text;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(50),
    decoration: _cardDecoration(),
    child: Column(
      children: [
        Icon(icon, color: _muted, size: 42),
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(color: _muted)),
        ?action,
      ],
    ),
  );
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(11),
  border: Border.all(color: _line),
  boxShadow: const [
    BoxShadow(color: Color(0x0A0F172A), blurRadius: 10, offset: Offset(0, 3)),
  ],
);

void _openDetail(BuildContext context, Map<String, dynamic> row) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => BeritaDetailPage(berita: row)));
}

class BeritaDetailPage extends StatelessWidget {
  const BeritaDetailPage({super.key, required this.berita});
  final Map<String, dynamic> berita;

  @override
  Widget build(BuildContext context) {
    final image = _newsImage(berita);
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SharedSmakNavigationBar(
              profilePages: {},
              academicPages: {},
              studentPages: {},
              initialActive: 'Berita',
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF073B86),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1050),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${berita['judul'] ?? 'Berita Sekolah'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'Beranda  ›  Berita  ›  ${berita['kategori'] ?? 'Berita'}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Badge('${berita['kategori'] ?? 'BERITA'}'),
                            const SizedBox(width: 10),
                            _DateText(row: berita),
                          ],
                        ),
                        if (image.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 2,
                              child: _NewsImage(row: berita),
                            ),
                          ),
                        ],
                        const SizedBox(height: 22),
                        Text(
                          _newsDescription(berita).isEmpty
                              ? 'Informasi kegiatan SMAK Mgr. Soegijapranata.'
                              : _newsDescription(berita),
                          style: const TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 22),
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Kembali ke Berita'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SharedSmakFooter(
              profilePages: {},
              academicPages: {},
              studentPages: {},
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value.isEmpty ? '-' : value;
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
