part of '../admin_dashboard_page.dart';

class AdminOverview extends StatelessWidget {
  const AdminOverview({
    super.key,
    required this.api,
    required this.sessionToken,
    required this.onModuleTap,
  });

  final SmakApi api;
  final String sessionToken;
  final ValueChanged<String> onModuleTap;

  Future<List<Map<String, dynamic>>> _loadTable(String table) async {
    try {
      return await api.getTable(table, limit: 100);
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _loadTable('berita'),
        _loadTable('galeri'),
        _loadTable('akademik'),
      ]),
      builder: (context, snapshot) {
        final berita = snapshot.data != null && snapshot.data!.isNotEmpty
            ? snapshot.data![0]
            : <Map<String, dynamic>>[];
        final galeri = snapshot.data != null && snapshot.data!.length > 1
            ? snapshot.data![1]
            : <Map<String, dynamic>>[];
        final akademik = snapshot.data != null && snapshot.data!.length > 2
            ? snapshot.data![2]
            : <Map<String, dynamic>>[];
        final pengumuman = berita
            .where((row) => '${row['kategori']}'.toLowerCase() == 'pengumuman')
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 700;

                return Flex(
                  direction: narrow ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang, Admin!',
                            style: TextStyle(
                              color: _text,
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Berikut ringkasan informasi website SMAK.',
                            style: TextStyle(color: _muted, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    if (!narrow) const SizedBox(width: 20),
                    if (narrow) const SizedBox(height: 16),
                    const _DateCard(),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                int columns = 4;
                if (constraints.maxWidth < 1050) columns = 2;
                if (constraints.maxWidth < 620) columns = 1;

                final width =
                    (constraints.maxWidth - ((columns - 1) * 16)) / columns;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: width,
                      child: DashboardStatCard(
                        label: 'Total Berita',
                        count: berita.length,
                        icon: Icons.article_rounded,
                        color: _blue,
                        firstLabel: 'Terbit',
                        firstValue: _statusCount(berita, [
                          'publikasi',
                          'terbit',
                        ]),
                        secondLabel: 'Draft',
                        secondValue: _statusCount(berita, ['draft']),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: DashboardStatCard(
                        label: 'Total Galeri',
                        count: galeri.length,
                        icon: Icons.photo_library_rounded,
                        color: const Color(0xFF19A866),
                        firstLabel: 'Foto',
                        firstValue: galeri.length,
                        secondLabel: 'Video',
                        secondValue: 0,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: DashboardStatCard(
                        label: 'Data Akademik',
                        count: akademik.length,
                        icon: Icons.school_rounded,
                        color: const Color(0xFF7B4CE2),
                        firstLabel: 'Aktif',
                        firstValue: _statusCount(akademik, ['aktif']),
                        secondLabel: 'Nonaktif',
                        secondValue: _statusCount(akademik, ['nonaktif']),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: DashboardStatCard(
                        label: 'Pengumuman Aktif',
                        count: pengumuman.length,
                        icon: Icons.campaign_rounded,
                        color: const Color(0xFFFF8A00),
                        firstLabel: 'Terbit',
                        firstValue: _statusCount(pengumuman, [
                          'publikasi',
                          'terbit',
                          'aktif',
                        ]),
                        secondLabel: 'Draft',
                        secondValue: _statusCount(pengumuman, ['draft']),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 900) {
                  return Column(
                    children: [
                      _RecentActivity(api: api, sessionToken: sessionToken, onViewAll: () => onModuleTap('Keamanan & Aktivitas')),
                      const SizedBox(height: 18),
                      _QuickActions(onModuleTap: onModuleTap),
                      const SizedBox(height: 18),
                      _RecentAnnouncements(rows: pengumuman),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _RecentActivity(api: api, sessionToken: sessionToken, onViewAll: () => onModuleTap('Keamanan & Aktivitas')),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _QuickActions(onModuleTap: onModuleTap),
                          const SizedBox(height: 20),
                          _RecentAnnouncements(rows: pengumuman),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const _DashboardFooter(),
          ],
        );
      },
    );
  }

  static int _statusCount(
    List<Map<String, dynamic>> rows,
    List<String> values,
  ) {
    final expected = values.map((e) => e.toLowerCase()).toSet();

    return rows.where((row) {
      final status = '${row['status'] ?? ''}'.toLowerCase();
      return expected.contains(status);
    }).length;
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

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

    final date =
        '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';

    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
      decoration: _cardDecoration(radius: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F2FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: _blue,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(color: _muted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.firstLabel,
    required this.firstValue,
    required this.secondLabel,
    required this.secondValue,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final String firstLabel;
  final int firstValue;
  final String secondLabel;
  final int secondValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(.11),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$count',
                      style: const TextStyle(
                        color: _text,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _CardSubCount(
                label: firstLabel,
                value: firstValue,
                valueColor: const Color(0xFF13A65A),
              ),
              const Spacer(),
              _CardSubCount(
                label: secondLabel,
                value: secondValue,
                valueColor: const Color(0xFFFF7900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardSubCount extends StatelessWidget {
  const _CardSubCount({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final int value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
        const SizedBox(width: 10),
        Text(
          '$value',
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({
    required this.api,
    required this.sessionToken,
    required this.onViewAll,
  });

  final SmakApi api;
  final String sessionToken;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: api.getSecurityDashboard(sessionToken),
      builder: (context, snapshot) {
        final security = snapshot.data ?? <String, dynamic>{};
        final activities = security['activities'] is List
            ? (security['activities'] as List)
                .map((item) => Map<String, dynamic>.from(item as Map))
                .toList()
            : <Map<String, dynamic>>[];
        final recent = activities.take(5).map(_fromLog).toList();

        return _AdminPanel(
          title: 'Aktivitas Terbaru',
          minHeight: 510,
          child: recent.isEmpty
              ? const _EmptyState(text: 'Belum ada aktivitas dari database.')
              : Column(
                  children: [
                    for (int i = 0; i < recent.length; i++) ...[
                      _ActivityRow(data: recent[i]),
                      if (i != recent.length - 1)
                        const Divider(height: 1, color: _line),
                    ],
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: onViewAll,
                      label: const Text('Lihat semua aktivitas'),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    ),
                  ],
                ),
        );
      },
    );
  }

  static _ActivityData _fromLog(Map<String, dynamic> row) {
    final action = '${row['action'] ?? ''}';
    final login = action == 'login' || action == 'logout';
    return _ActivityData(
      icon: login ? Icons.login_rounded : Icons.edit_note_rounded,
      color: login ? const Color(0xFF7B4CE2) : _blue,
      title: '${row['description'] ?? 'Aktivitas administrator'}',
      subtitle: 'Oleh ${row['nama'] ?? 'Administrator'} - ${row['module'] ?? 'Sistem'}',
      date: '${row['created_at'] ?? 'Baru saja'}',
    );
  }
}

class _ActivityData {
  const _ActivityData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String date;
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.data});

  final _ActivityData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: data.color.withOpacity(.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(data.icon, color: data.color, size: 27),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            data.date,
            textAlign: TextAlign.right,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onModuleTap});

  final ValueChanged<String> onModuleTap;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickActionData(
        'Tambah Berita',
        Icons.post_add_rounded,
        _blue,
        () => onModuleTap('Berita'),
      ),
      _QuickActionData(
        'Upload Galeri',
        Icons.add_photo_alternate_rounded,
        const Color(0xFF19A866),
        () => onModuleTap('Galeri'),
      ),
      _QuickActionData(
        'Tambah Pengumuman',
        Icons.campaign_rounded,
        const Color(0xFFFF8A00),
        () => onModuleTap('Berita'),
      ),
      _QuickActionData(
        'Tambah Prestasi',
        Icons.emoji_events_rounded,
        const Color(0xFF7B4CE2),
        () => onModuleTap('Akademik'),
      ),
      _QuickActionData(
        'Kelola PPDB',
        Icons.groups_rounded,
        const Color(0xFF5790FF),
        () => onModuleTap('PPDB'),
      ),
      _QuickActionData(
        'Kelola Kontak',
        Icons.phone_rounded,
        const Color(0xFF13A65A),
        () => onModuleTap('Kontak'),
      ),
    ];

    return _AdminPanel(
      title: 'Aksi Cepat',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 520 ? 2 : 3;
          final width = (constraints.maxWidth - ((columns - 1) * 12)) / columns;

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: actions
                .map(
                  (action) => SizedBox(
                    width: width,
                    child: _QuickActionCard(data: action),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData(this.label, this.icon, this.color, this.onTap);

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _QuickActionCard extends StatefulWidget {
  const _QuickActionCard({required this.data});

  final _QuickActionData data;

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.data.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 104,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: hovering ? const Color(0xFFF8FBFF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hovering ? widget.data.color.withOpacity(.5) : _line,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.data.icon, color: widget.data.color, size: 31),
              const SizedBox(height: 10),
              Text(
                widget.data.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentAnnouncements extends StatelessWidget {
  const _RecentAnnouncements({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    final visible = rows.take(3).toList();

    return _AdminPanel(
      title: 'Pengumuman Terbaru',
      child: visible.isEmpty
          ? const _EmptyState(text: 'Belum ada pengumuman aktif.')
          : Column(
              children: visible.map((row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0E0),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.campaign_rounded,
                          color: Color(0xFFFF8A00),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${row['judul'] ?? 'Pengumuman'}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _text,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE4F8EC),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Aktif',
                                    style: TextStyle(
                                      color: Color(0xFF159455),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${row['tanggal_publikasi'] ?? row['tanggal'] ?? row['created_at'] ?? ''}',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _AdminPanel extends StatelessWidget {
  const _AdminPanel({required this.title, required this.child, this.minHeight});

  final String title;
  final Widget child;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Text(text, style: const TextStyle(color: _muted)),
      ),
    );
  }
}

class _DashboardFooter extends StatelessWidget {
  const _DashboardFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 2, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '© 2026 SMAK - Sekolah Menengah Atas Katolik. All rights reserved.',
              style: TextStyle(color: _muted, fontSize: 11),
            ),
          ),
          Text('Versi 1.0.0', style: TextStyle(color: _muted, fontSize: 11)),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration({double radius = 14}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: const Color(0xFFF0F3F8)),
    boxShadow: const [
      BoxShadow(color: Color(0x0D0F172A), blurRadius: 16, offset: Offset(0, 5)),
    ],
  );
}

