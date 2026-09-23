part of '../admin_dashboard_page.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.activePage,
    required this.onSelect,
    required this.onLogout,
    this.width = 250,
  });

  final String activePage;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;
  final double width;

  @override
  Widget build(BuildContext context) {
    final profileActive = const {
      'Profil',
      'Profil Sekolah',
      'Identitas Sekolah',
      'Sambutan Kepala Sekolah',
      'Sejarah Sekolah',
      'Visi & Misi',
      'Struktur Organisasi',
      'Sarana & Prasarana',
    }.contains(activePage);
    final akademikActive = const {
      'Akademik',
      'Prestasi Akademik',
      'Kurikulum',
      'Kalender Akademik',
      'Jadwal Pelajaran',
    }.contains(activePage);
    final kesiswaanActive = const {
      'Kesiswaan',
      'Tata Tertib',
      'OSIS',
      'Prestasi Siswa',
      'Ekstrakurikuler',
    }.contains(activePage);

    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _line)),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AdminMenuLabel('NAVIGASI'),
                  const SizedBox(height: 8),
                  AdminSideItem(
                    'Dashboard',
                    Icons.home_outlined,
                    activePage == 'Dashboard',
                    () => onSelect('Dashboard'),
                  ),
                  AdminSideItem(
                    'Beranda Website',
                    Icons.language_rounded,
                    activePage == 'Web Editor',
                    () => onSelect('Web Editor'),
                  ),
                  AdminSideDropdown(
                    label: 'Profil Sekolah',
                    icon: Icons.home_work_outlined,
                    selected: profileActive,
                    onTap: () => onSelect('Identitas Sekolah'),
                    children: [
                      AdminSideDropdownItem(
                        label: 'Identitas Sekolah',
                        selected:
                            activePage == 'Identitas Sekolah' ||
                            activePage == 'Profil Sekolah' ||
                            activePage == 'Profil',
                        onTap: () => onSelect('Identitas Sekolah'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Sambutan Kepala Sekolah',
                        selected: activePage == 'Sambutan Kepala Sekolah',
                        onTap: () => onSelect('Sambutan Kepala Sekolah'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Sejarah Sekolah',
                        selected: activePage == 'Sejarah Sekolah',
                        onTap: () => onSelect('Sejarah Sekolah'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Visi & Misi',
                        selected: activePage == 'Visi & Misi',
                        onTap: () => onSelect('Visi & Misi'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Struktur Organisasi',
                        selected: activePage == 'Struktur Organisasi',
                        onTap: () => onSelect('Struktur Organisasi'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Sarana & Prasarana',
                        selected: activePage == 'Sarana & Prasarana',
                        onTap: () => onSelect('Sarana & Prasarana'),
                      ),
                    ],
                  ),
                  AdminSideDropdown(
                    label: 'Akademik',
                    icon: Icons.auto_stories_outlined,
                    selected: akademikActive,
                    onTap: () => onSelect('Prestasi Akademik'),
                    children: [
                      AdminSideDropdownItem(
                        label: 'Prestasi Akademik',
                        selected:
                            activePage == 'Prestasi Akademik' ||
                            activePage == 'Akademik',
                        onTap: () => onSelect('Prestasi Akademik'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Kurikulum',
                        selected: activePage == 'Kurikulum',
                        onTap: () => onSelect('Kurikulum'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Kalender Akademik',
                        selected: activePage == 'Kalender Akademik',
                        onTap: () => onSelect('Kalender Akademik'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Jadwal Pelajaran',
                        selected: activePage == 'Jadwal Pelajaran',
                        onTap: () => onSelect('Jadwal Pelajaran'),
                      ),
                    ],
                  ),
                  AdminSideDropdown(
                    label: 'Kesiswaan',
                    icon: Icons.groups_outlined,
                    selected: kesiswaanActive,
                    onTap: () => onSelect('Tata Tertib'),
                    children: [
                      AdminSideDropdownItem(
                        label: 'Tata Tertib',
                        selected:
                            activePage == 'Tata Tertib' ||
                            activePage == 'Kesiswaan',
                        onTap: () => onSelect('Tata Tertib'),
                      ),
                      AdminSideDropdownItem(
                        label: 'OSIS',
                        selected: activePage == 'OSIS',
                        onTap: () => onSelect('OSIS'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Prestasi Siswa',
                        selected: activePage == 'Prestasi Siswa',
                        onTap: () => onSelect('Prestasi Siswa'),
                      ),
                      AdminSideDropdownItem(
                        label: 'Ekstrakurikuler',
                        selected: activePage == 'Ekstrakurikuler',
                        onTap: () => onSelect('Ekstrakurikuler'),
                      ),
                    ],
                  ),
                  AdminSideItem(
                    'Berita',
                    Icons.article_outlined,
                    activePage == 'Berita',
                    () => onSelect('Berita'),
                  ),
                  AdminSideItem(
                    'Galeri',
                    Icons.photo_library_outlined,
                    activePage == 'Galeri',
                    () => onSelect('Galeri'),
                  ),
                  AdminSideItem(
                    'PPDB',
                    Icons.how_to_reg_outlined,
                    activePage == 'PPDB',
                    () => onSelect('PPDB'),
                  ),
                  AdminSideItem(
                    'Kontak',
                    Icons.contact_phone_outlined,
                    activePage == 'Kontak',
                    () => onSelect('Kontak'),
                  ),
                  const SizedBox(height: 10),
                  const _AdminMenuLabel('PENGATURAN'),
                  const SizedBox(height: 8),
                  AdminSideItem(
                    'Pengguna',
                    Icons.people_outline_rounded,
                    activePage == 'Pengguna',
                    () => onSelect('Pengguna'),
                  ),
                  AdminSideItem(
                    'Pengaturan Website',
                    Icons.settings_outlined,
                    activePage == 'Pengaturan Website',
                    () => onSelect('Pengaturan Website'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCE7F6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.help_rounded, color: _blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Bantuan',
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: AdminSideItem(
              'Logout',
              Icons.logout_rounded,
              false,
              onLogout,
              logout: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminMenuLabel extends StatelessWidget {
  const _AdminMenuLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF8A9AAF),
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: .7,
      ),
    ),
  );
}

class AdminSideDropdownItem {
  const AdminSideDropdownItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
}

class AdminSideDropdown extends StatefulWidget {
  const AdminSideDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.children,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final List<AdminSideDropdownItem> children;
  @override
  State<AdminSideDropdown> createState() => _AdminSideDropdownState();
}

class _AdminSideDropdownState extends State<AdminSideDropdown> {
  late bool expanded;
  @override
  void initState() {
    super.initState();
    expanded = widget.selected;
  }

  @override
  void didUpdateWidget(covariant AdminSideDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected && !oldWidget.selected) expanded = true;
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AdminSideItem(
        widget.label,
        widget.icon,
        widget.selected,
        () {
          setState(() => expanded = !expanded);
          if (!expanded) return;
        },
        trailing: Icon(
          expanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          size: 18,
          color: widget.selected ? Colors.white : _muted,
        ),
      ),
      AnimatedCrossFade(
        duration: const Duration(milliseconds: 160),
        crossFadeState: expanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 4),
          child: Column(
            children: widget.children
                .map(
                  (item) => _AdminSubSideItem(
                    label: item.label,
                    selected: item.selected,
                    onTap: item.onTap,
                  ),
                )
                .toList(),
          ),
        ),
        secondChild: const SizedBox.shrink(),
      ),
    ],
  );
}

class _AdminSubSideItem extends StatefulWidget {
  const _AdminSubSideItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  State<_AdminSubSideItem> createState() => _AdminSubSideItemState();
}

class _AdminSubSideItemState extends State<_AdminSubSideItem> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    final highlighted = widget.selected || hovering;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: highlighted ? const Color(0xFFF0F5FD) : Colors.transparent,
            border: widget.selected
                ? const Border(left: BorderSide(color: _blue, width: 2))
                : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: highlighted ? _text : const Color(0xFF5D6D82),
              fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

class AdminSideItem extends StatefulWidget {
  const AdminSideItem(
    this.label,
    this.icon,
    this.selected,
    this.onTap, {
    super.key,
    this.logout = false,
    this.trailing,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool logout;
  final Widget? trailing;
  @override
  State<AdminSideItem> createState() => _AdminSideItemState();
}

class _AdminSideItemState extends State<AdminSideItem> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    final highlighted = widget.selected || hovering;
    final fg = widget.logout
        ? const Color(0xFFD92D20)
        : (widget.selected ? Colors.white : _text);
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hovering = true),
        onExit: (_) => setState(() => hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
            decoration: BoxDecoration(
              color: widget.logout
                  ? (hovering ? const Color(0xFFFFF1F1) : Colors.transparent)
                  : widget.selected
                  ? _blue
                  : (highlighted
                        ? const Color(0xFFF3F7FC)
                        : Colors.transparent),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: fg, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: fg,
                      fontWeight: widget.selected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
