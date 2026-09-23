part of '../admin_dashboard_page.dart';

class AdminWebEditorPage extends StatefulWidget {
  const AdminWebEditorPage({
    super.key,
    required this.api,
    required this.module,
    required this.onOpenAdminPage,
  });

  final SmakApi api;
  final AdminModule module;
  final ValueChanged<String> onOpenAdminPage;

  @override
  State<AdminWebEditorPage> createState() => _AdminWebEditorPageState();
}

class _AdminWebEditorPageState extends State<AdminWebEditorPage> {
  static const List<_WebEditorEntry> _entries = [
    _WebEditorEntry(
      title: 'Beranda',
      subtitle: 'Halaman Utama',
      category: 'Beranda',
      group: 'Beranda',
      adminPage: 'Web Editor',
      accent: Color(0xFF1B4FA3),
      preview: _PreviewPreset.hero,
    ),
    _WebEditorEntry(
      title: 'Identitas Sekolah',
      subtitle: 'Profil Sekolah',
      category: 'Profil Sekolah',
      group: 'Profil Sekolah',
      adminPage: 'Identitas Sekolah',
      accent: Color(0xFF1557B0),
      preview: _PreviewPreset.identity,
    ),
    _WebEditorEntry(
      title: 'Sambutan Kepala Sekolah',
      subtitle: 'Profil Sekolah',
      category: 'Profil Sekolah',
      group: 'Profil Sekolah',
      adminPage: 'Identitas Sekolah',
      accent: Color(0xFF1854AE),
      preview: _PreviewPreset.principal,
    ),
    _WebEditorEntry(
      title: 'Sejarah Sekolah',
      subtitle: 'Profil Sekolah',
      category: 'Profil Sekolah',
      group: 'Profil Sekolah',
      adminPage: 'Identitas Sekolah',
      accent: Color(0xFF1B56B2),
      preview: _PreviewPreset.timeline,
    ),
    _WebEditorEntry(
      title: 'Visi & Misi',
      subtitle: 'Profil Sekolah',
      category: 'Profil Sekolah',
      group: 'Profil Sekolah',
      adminPage: 'Identitas Sekolah',
      accent: Color(0xFF1152AA),
      preview: _PreviewPreset.vision,
    ),
    _WebEditorEntry(
      title: 'Struktur Organisasi',
      subtitle: 'Profil Sekolah',
      category: 'Profil Sekolah',
      group: 'Profil Sekolah',
      adminPage: 'Identitas Sekolah',
      accent: Color(0xFF1550A3),
      preview: _PreviewPreset.structure,
    ),
    _WebEditorEntry(
      title: 'Sarana & Prasarana',
      subtitle: 'Profil Sekolah',
      category: 'Profil Sekolah',
      group: 'Profil Sekolah',
      adminPage: 'Identitas Sekolah',
      accent: Color(0xFF1A4EA0),
      preview: _PreviewPreset.facilities,
    ),
    _WebEditorEntry(
      title: 'Prestasi Akademik',
      subtitle: 'Akademik',
      category: 'Akademik',
      group: 'Akademik',
      adminPage: 'Prestasi Akademik',
      accent: Color(0xFF155AB8),
      preview: _PreviewPreset.achievement,
    ),
    _WebEditorEntry(
      title: 'Kurikulum',
      subtitle: 'Akademik',
      category: 'Akademik',
      group: 'Akademik',
      adminPage: 'Prestasi Akademik',
      accent: Color(0xFF1750A8),
      preview: _PreviewPreset.curriculum,
    ),
    _WebEditorEntry(
      title: 'Kalender Akademik',
      subtitle: 'Akademik',
      category: 'Akademik',
      group: 'Akademik',
      adminPage: 'Prestasi Akademik',
      accent: Color(0xFF184FA2),
      preview: _PreviewPreset.calendar,
    ),
    _WebEditorEntry(
      title: 'Jadwal Pelajaran',
      subtitle: 'Akademik',
      category: 'Akademik',
      group: 'Akademik',
      adminPage: 'Prestasi Akademik',
      accent: Color(0xFF1453A6),
      preview: _PreviewPreset.schedule,
    ),
    _WebEditorEntry(
      title: 'Tata Tertib',
      subtitle: 'Kesiswaan',
      category: 'Kesiswaan',
      group: 'Kesiswaan',
      adminPage: 'Tata Tertib',
      accent: Color(0xFF1752A8),
      preview: _PreviewPreset.rules,
    ),
    _WebEditorEntry(
      title: 'Ekstrakurikuler',
      subtitle: 'Kesiswaan',
      category: 'Kesiswaan',
      group: 'Kesiswaan',
      adminPage: 'Tata Tertib',
      accent: Color(0xFF1856B1),
      preview: _PreviewPreset.extracurricular,
    ),
    _WebEditorEntry(
      title: 'OSIS',
      subtitle: 'Kesiswaan',
      category: 'Kesiswaan',
      group: 'Kesiswaan',
      adminPage: 'Tata Tertib',
      accent: Color(0xFF1654AF),
      preview: _PreviewPreset.osis,
    ),
    _WebEditorEntry(
      title: 'Prestasi Siswa',
      subtitle: 'Kesiswaan',
      category: 'Kesiswaan',
      group: 'Kesiswaan',
      adminPage: 'Tata Tertib',
      accent: Color(0xFF1A59B7),
      preview: _PreviewPreset.studentAchievement,
    ),
    _WebEditorEntry(
      title: 'Berita',
      subtitle: 'Lainnya',
      category: 'Lainnya',
      group: 'Lainnya',
      adminPage: 'Berita',
      accent: Color(0xFF1552A9),
      preview: _PreviewPreset.news,
    ),
    _WebEditorEntry(
      title: 'Galeri',
      subtitle: 'Lainnya',
      category: 'Lainnya',
      group: 'Lainnya',
      adminPage: 'Galeri',
      accent: Color(0xFF1656B0),
      preview: _PreviewPreset.gallery,
    ),
    _WebEditorEntry(
      title: 'PPDB',
      subtitle: 'Lainnya',
      category: 'Lainnya',
      group: 'Lainnya',
      adminPage: 'PPDB',
      accent: Color(0xFF1754AB),
      preview: _PreviewPreset.ppdb,
    ),
    _WebEditorEntry(
      title: 'Kontak',
      subtitle: 'Lainnya',
      category: 'Lainnya',
      group: 'Lainnya',
      adminPage: 'Kontak',
      accent: Color(0xFF1450A3),
      preview: _PreviewPreset.contact,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua Kategori';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_WebEditorEntry> get _filteredEntries {
    final keyword = _searchController.text.trim().toLowerCase();
    return _entries.where((entry) {
      final categoryMatch =
          _selectedCategory == 'Semua Kategori' ||
          entry.category == _selectedCategory;
      final keywordMatch =
          keyword.isEmpty ||
          entry.title.toLowerCase().contains(keyword) ||
          entry.group.toLowerCase().contains(keyword) ||
          entry.subtitle.toLowerCase().contains(keyword);
      return categoryMatch && keywordMatch;
    }).toList();
  }

  Map<String, List<_WebEditorEntry>> _groupEntries(
    List<_WebEditorEntry> entries,
  ) {
    final grouped = <String, List<_WebEditorEntry>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.group, () => <_WebEditorEntry>[]).add(entry);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEntries;
    final grouped = _groupEntries(filtered);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Web Editor',
          style: TextStyle(
            color: Color(0xFF082E65),
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.module.description,
          style: const TextStyle(color: Color(0xFF60718A), fontSize: 14),
        ),
        const SizedBox(height: 18),
        const Text(
          'Kelola tampilan dan konten setiap halaman website.',
          style: TextStyle(color: Color(0xFF60718A), fontSize: 13),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 280,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari halaman...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD7E2F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD7E2F0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD7E2F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD7E2F0)),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Semua Kategori',
                    child: Text('Semua Kategori'),
                  ),
                  DropdownMenuItem(value: 'Beranda', child: Text('Beranda')),
                  DropdownMenuItem(
                    value: 'Profil Sekolah',
                    child: Text('Profil Sekolah'),
                  ),
                  DropdownMenuItem(value: 'Akademik', child: Text('Akademik')),
                  DropdownMenuItem(
                    value: 'Kesiswaan',
                    child: Text('Kesiswaan'),
                  ),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (value) {
                  setState(() => _selectedCategory = value ?? 'Semua Kategori');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4EBF4)),
            ),
            child: const Text(
              'Halaman yang dicari belum ditemukan.',
              style: TextStyle(color: Color(0xFF60718A)),
            ),
          )
        else
          ...grouped.entries.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.key,
                    style: const TextStyle(
                      color: Color(0xFF082E65),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount = 3;
                      if (width < 1180) crossAxisCount = 2;
                      if (width < 760) crossAxisCount = 1;
                      final cardWidth =
                          (width - ((crossAxisCount - 1) * 16)) /
                          crossAxisCount;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: section.value
                            .map(
                              (entry) => SizedBox(
                                width: cardWidth,
                                child: _WebEditorEntryCard(
                                  entry: entry,
                                  onOpenAdminPage: () =>
                                      widget.onOpenAdminPage(entry.adminPage),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          'Menampilkan ${filtered.length} halaman website',
          style: const TextStyle(color: Color(0xFF60718A), fontSize: 13),
        ),
      ],
    );
  }
}

class _WebEditorEntryCard extends StatelessWidget {
  const _WebEditorEntryCard({
    required this.entry,
    required this.onOpenAdminPage,
  });

  final _WebEditorEntry entry;
  final VoidCallback onOpenAdminPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: const TextStyle(
                        color: Color(0xFF082E65),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF60718A),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: onOpenAdminPage,
                icon: const Icon(Icons.edit_rounded, size: 14),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  foregroundColor: const Color(0xFF1463E8),
                  side: const BorderSide(color: Color(0xFFD5E4FB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.52,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDCE7F5)),
                color: const Color(0xFFF8FBFF),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _WebEditorPreviewThumbnail(entry: entry),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebEditorPreviewThumbnail extends StatelessWidget {
  const _WebEditorPreviewThumbnail({required this.entry});

  final _WebEditorEntry entry;

  @override
  Widget build(BuildContext context) {
    final accent = entry.accent;
    return Column(
      children: [
        Container(
          height: 22,
          color: const Color(0xFF0A3678),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3B43C),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'SMAK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              const Text(
                'Beranda   Profil   Akademik   Kesiswaan',
                style: TextStyle(
                  color: Color(0xFFDCE9FF),
                  fontSize: 6.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent.withOpacity(.98), const Color(0xFFF9FBFF)],
                stops: const [0.32, 0.32],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _buildPreset(entry.preview, accent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreset(_PreviewPreset preset, Color accent) {
    switch (preset) {
      case _PreviewPreset.hero:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang di\nSMA Katolik',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF7AA35A), Color(0xFF305A2C)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 8,
                            right: 8,
                            bottom: 8,
                            child: Container(
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.18),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E4A98),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case _PreviewPreset.identity:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .58),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _PreviewMetric(label: 'Nama Sekolah')),
                SizedBox(width: 10),
                Expanded(child: _PreviewMetric(label: 'Akreditasi')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _PreviewMetric(label: 'NPSN')),
                SizedBox(width: 10),
                Expanded(child: _PreviewMetric(label: 'Status')),
              ],
            ),
          ],
        );
      case _PreviewPreset.principal:
        return _PreviewBody(
          children: [
            const _PreviewLine(widthFactor: .64),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: const [
                  _PreviewAvatar(),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PreviewLine(widthFactor: .86),
                        SizedBox(height: 6),
                        _PreviewLine(widthFactor: .95),
                        SizedBox(height: 6),
                        _PreviewLine(widthFactor: .76),
                        Spacer(),
                        _PreviewLine(widthFactor: .48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case _PreviewPreset.timeline:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .68),
            SizedBox(height: 10),
            _PreviewTimeline(),
          ],
        );
      case _PreviewPreset.vision:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .42),
            SizedBox(height: 10),
            _PreviewTextBlock(lines: 4),
            SizedBox(height: 8),
            _PreviewTextBlock(lines: 4),
          ],
        );
      case _PreviewPreset.structure:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .65),
            SizedBox(height: 10),
            _PreviewTree(),
          ],
        );
      case _PreviewPreset.facilities:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .72),
            SizedBox(height: 10),
            _PreviewIconGrid(),
          ],
        );
      case _PreviewPreset.achievement:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .62),
            SizedBox(height: 10),
            _PreviewTrophyRow(),
          ],
        );
      case _PreviewPreset.curriculum:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .52),
            SizedBox(height: 10),
            _PreviewBulletList(count: 5),
          ],
        );
      case _PreviewPreset.calendar:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .58),
            SizedBox(height: 10),
            _PreviewTable(rows: 4),
          ],
        );
      case _PreviewPreset.schedule:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .56),
            SizedBox(height: 10),
            _PreviewTable(rows: 5),
          ],
        );
      case _PreviewPreset.rules:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .5),
            SizedBox(height: 10),
            _PreviewNumberedList(count: 5),
          ],
        );
      case _PreviewPreset.extracurricular:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .68),
            SizedBox(height: 10),
            _PreviewIconGrid(),
          ],
        );
      case _PreviewPreset.osis:
        return _PreviewBody(
          children: [
            const _PreviewLine(widthFactor: .34),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: const [
                  _PreviewBadge(),
                  SizedBox(width: 10),
                  Expanded(child: _PreviewBulletList(count: 4)),
                ],
              ),
            ),
          ],
        );
      case _PreviewPreset.studentAchievement:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .6),
            SizedBox(height: 10),
            _PreviewMedalList(),
          ],
        );
      case _PreviewPreset.news:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .36),
            SizedBox(height: 10),
            _PreviewNewsLayout(),
          ],
        );
      case _PreviewPreset.gallery:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .38),
            SizedBox(height: 10),
            _PreviewPhotoGrid(),
          ],
        );
      case _PreviewPreset.ppdb:
        return _PreviewBody(
          children: [
            const _PreviewLine(widthFactor: .26),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: const [
                  Expanded(child: _PreviewTextBlock(lines: 4)),
                  SizedBox(width: 10),
                  _PreviewStudents(),
                ],
              ),
            ),
          ],
        );
      case _PreviewPreset.contact:
        return _PreviewBody(
          children: const [
            _PreviewLine(widthFactor: .34),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _PreviewBulletList(count: 4)),
                SizedBox(width: 10),
                Expanded(child: _PreviewMap()),
              ],
            ),
          ],
        );
    }
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.widthFactor, this.height = 6});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFD7E4F6),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF57708F),
              fontSize: 6.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const _PreviewLine(widthFactor: .8, height: 5),
          const SizedBox(height: 4),
          const _PreviewLine(widthFactor: .58, height: 5),
        ],
      ),
    );
  }
}

class _PreviewAvatar extends StatelessWidget {
  const _PreviewAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFF97A5B8),
        size: 34,
      ),
    );
  }
}

class _PreviewTimeline extends StatelessWidget {
  const _PreviewTimeline();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.circle, size: 8, color: Color(0xFF1A5BBA)),
                ),
                SizedBox(width: 8),
                Expanded(child: _PreviewTextBlock(lines: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewTextBlock extends StatelessWidget {
  const _PreviewTextBlock({required this.lines});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lines,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: _PreviewLine(widthFactor: index == lines - 1 ? .72 : 1),
        ),
      ),
    );
  }
}

class _PreviewTree extends StatelessWidget {
  const _PreviewTree();

  @override
  Widget build(BuildContext context) {
    Widget node(String label) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFBCD0EE)),
          color: const Color(0xFFF8FBFF),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A678B),
            fontSize: 6.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          node('Kepala Sekolah'),
          const SizedBox(height: 8),
          node('Wakil Kepala Sekolah'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: node('Kurikulum')),
              const SizedBox(width: 6),
              Expanded(child: node('Kesiswaan')),
              const SizedBox(width: 6),
              Expanded(child: node('Humas')),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewIconGrid extends StatelessWidget {
  const _PreviewIconGrid();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        children: List.generate(
          8,
          (index) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F9FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.dashboard_customize_rounded,
              color: Color(0xFF1A5AB7),
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewTrophyRow extends StatelessWidget {
  const _PreviewTrophyRow();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  color: [
                    const Color(0xFFE2B13C),
                    const Color(0xFF98A3B5),
                    const Color(0xFFB57A3C),
                  ][index],
                  size: 28,
                ),
                const SizedBox(height: 6),
                const _PreviewLine(widthFactor: .8, height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewBulletList extends StatelessWidget {
  const _PreviewBulletList({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            children: const [
              Icon(Icons.circle, size: 7, color: Color(0xFF1A5AB7)),
              SizedBox(width: 8),
              Expanded(child: _PreviewLine(widthFactor: 1)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewTable extends StatelessWidget {
  const _PreviewTable({required this.rows});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDCE6F5)),
        ),
        child: Column(
          children: [
            Container(height: 16, color: const Color(0xFFEFF5FD)),
            ...List.generate(
              rows,
              (index) => Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE7EEF8))),
                  ),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(width: 1, color: const Color(0xFFE7EEF8)),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewNumberedList extends StatelessWidget {
  const _PreviewNumberedList({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            children: [
              Text(
                '${index + 1}.',
                style: const TextStyle(
                  color: Color(0xFF58759A),
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: _PreviewLine(widthFactor: 1)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.workspace_premium_rounded,
        color: Color(0xFFE0A225),
        size: 36,
      ),
    );
  }
}

class _PreviewMedalList extends StatelessWidget {
  const _PreviewMedalList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.military_tech_rounded,
                color: [
                  const Color(0xFFE1B03A),
                  const Color(0xFFA4B0C1),
                  const Color(0xFFBB8A4B),
                ][index],
                size: 18,
              ),
              const SizedBox(width: 8),
              const Expanded(child: _PreviewTextBlock(lines: 2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewNewsLayout extends StatelessWidget {
  const _PreviewNewsLayout();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD8E3B8),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: _PreviewTextBlock(lines: 5)),
        ],
      ),
    );
  }
}

class _PreviewPhotoGrid extends StatelessWidget {
  const _PreviewPhotoGrid();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: List.generate(
          6,
          (index) => Container(
            decoration: BoxDecoration(
              color: [
                const Color(0xFFD2E3C0),
                const Color(0xFFC9DAEE),
                const Color(0xFFE8D3C4),
              ][index % 3],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewStudents extends StatelessWidget {
  const _PreviewStudents();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      child: Stack(
        children: const [
          Positioned(
            left: 0,
            bottom: 0,
            child: _StudentFigure(color: Color(0xFF8FB5E8)),
          ),
          Positioned(
            left: 22,
            bottom: 0,
            child: _StudentFigure(color: Color(0xFFD2B58D)),
          ),
          Positioned(
            left: 44,
            bottom: 0,
            child: _StudentFigure(color: Color(0xFF7EA2DA)),
          ),
        ],
      ),
    );
  }
}

class _StudentFigure extends StatelessWidget {
  const _StudentFigure({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE5C7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 20,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class _PreviewMap extends StatelessWidget {
  const _PreviewMap();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFFE2F0DE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.location_on_rounded,
          color: Color(0xFFE24B4B),
          size: 26,
        ),
      ),
    );
  }
}

class _WebEditorEntry {
  const _WebEditorEntry({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.group,
    required this.adminPage,
    required this.accent,
    required this.preview,
  });

  final String title;
  final String subtitle;
  final String category;
  final String group;
  final String adminPage;
  final Color accent;
  final _PreviewPreset preview;
}

enum _PreviewPreset {
  hero,
  identity,
  principal,
  timeline,
  vision,
  structure,
  facilities,
  achievement,
  curriculum,
  calendar,
  schedule,
  rules,
  extracurricular,
  osis,
  studentAchievement,
  news,
  gallery,
  ppdb,
  contact,
}
