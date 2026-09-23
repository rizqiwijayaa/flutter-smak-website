part of '../admin_dashboard_page.dart';

/// Isi tab Tampilan pada halaman Pengaturan Website.
///
/// Widget induk tetap bertanggung jawab memuat/menyimpan data ke API. Widget
/// ini hanya mengelola tampilan serta mengirim setiap perubahan melalui
/// callback [onChanged].
class AdminWebsiteAppearanceTab extends StatefulWidget {
  const AdminWebsiteAppearanceTab({
    super.key,
    required this.initialPrimaryHex,
    required this.initialNavigationHex,
    required this.fallbackImage,
    required this.onChanged,
    required this.onPickFallback,
  });

  final String initialPrimaryHex;
  final String initialNavigationHex;
  final String fallbackImage;
  final ValueChanged<WebsiteAppearanceValues> onChanged;
  final Future<void> Function() onPickFallback;

  @override
  State<AdminWebsiteAppearanceTab> createState() =>
      _AdminWebsiteAppearanceTabState();
}

class WebsiteAppearanceValues {
  const WebsiteAppearanceValues({
    required this.primaryHex,
    required this.navigationHex,
  });

  final String primaryHex;
  final String navigationHex;
}

class _AdminWebsiteAppearanceTabState extends State<AdminWebsiteAppearanceTab> {
  late final TextEditingController _primaryController;
  late final TextEditingController _navigationController;

  static const _primaryPresets = <String>[
    '#1463E8',
    '#0756C8',
    '#2563EB',
    '#0EA5E9',
    '#0F766E',
    '#059669',
    '#16A34A',
    '#65A30D',
    '#CA8A04',
    '#EA580C',
    '#DC2626',
    '#DB2777',
    '#9333EA',
    '#7C3AED',
    '#4F46E5',
    '#0891B2',
  ];

  static const _navigationPresets = <String>[
    '#082F63',
    '#05244D',
    '#0F172A',
    '#164E63',
    '#1E3A8A',
    '#1E40AF',
    '#312E81',
    '#3B0764',
    '#4A044E',
    '#450A0A',
    '#431407',
    '#365314',
    '#064E3B',
    '#134E4A',
    '#111827',
    '#292524',
  ];

  @override
  void initState() {
    super.initState();
    _primaryController = TextEditingController(
      text: _normalizeHex(widget.initialPrimaryHex, '#1463E8'),
    );
    _navigationController = TextEditingController(
      text: _normalizeHex(widget.initialNavigationHex, '#082F63'),
    );
  }

  @override
  void didUpdateWidget(covariant AdminWebsiteAppearanceTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPrimaryHex != widget.initialPrimaryHex) {
      _primaryController.text = _normalizeHex(
        widget.initialPrimaryHex,
        '#1463E8',
      );
    }
    if (oldWidget.initialNavigationHex != widget.initialNavigationHex) {
      _navigationController.text = _normalizeHex(
        widget.initialNavigationHex,
        '#082F63',
      );
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  static String _normalizeHex(String value, String fallback) {
    var result = value.trim().toUpperCase();
    if (!result.startsWith('#')) result = '#$result';
    return RegExp(r'^#[0-9A-F]{6}$').hasMatch(result) ? result : fallback;
  }

  static Color _colorFromHex(String value, Color fallback) {
    final normalized = _normalizeHex(value, '');
    final parsed = int.tryParse(normalized.replaceFirst('#', ''), radix: 16);
    return parsed == null ? fallback : Color(0xFF000000 | parsed);
  }

  void _notifyChanged() {
    widget.onChanged(
      WebsiteAppearanceValues(
        primaryHex: _normalizeHex(_primaryController.text, '#1463E8'),
        navigationHex: _normalizeHex(_navigationController.text, '#082F63'),
      ),
    );
  }

  void _setColor(TextEditingController controller, String value) {
    setState(() => controller.text = value);
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    final primary = _colorFromHex(
      _primaryController.text,
      const Color(0xFF1463E8),
    );
    final navigation = _colorFromHex(
      _navigationController.text,
      const Color(0xFF082F63),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppearanceSummaryCard(compact: compact),
            const SizedBox(height: 14),
            if (compact) ...[
              _buildColorPanel(primary, navigation),
              const SizedBox(height: 14),
              _ThemePreview(primary: primary, navigation: navigation),
            ] else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildColorPanel(primary, navigation)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ThemePreview(
                        primary: primary,
                        navigation: navigation,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            _FallbackImageCard(
              imagePath: widget.fallbackImage,
              onPick: widget.onPickFallback,
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorPanel(Color primary, Color navigation) {
    return _AppearanceCard(
      title: 'Warna Tema',
      subtitle: 'Atur warna yang digunakan di seluruh halaman website.',
      child: Column(
        children: [
          _ColorSettingRow(
            title: 'Warna Utama',
            description: 'Tombol, tautan, badge, dan elemen aksen.',
            controller: _primaryController,
            color: primary,
            presets: _primaryPresets,
            onChanged: () {
              setState(() {});
              _notifyChanged();
            },
            onPresetSelected: (value) => _setColor(_primaryController, value),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFE8EEF6)),
          ),
          _ColorSettingRow(
            title: 'Warna Navigasi',
            description:
                'Teks navbar, bar informasi atas, footer, dan elemen navigasi.',
            controller: _navigationController,
            color: navigation,
            presets: _navigationPresets,
            onChanged: () {
              setState(() {});
              _notifyChanged();
            },
            onPresetSelected: (value) =>
                _setColor(_navigationController, value),
          ),
        ],
      ),
    );
  }
}

class _AppearanceSummaryCard extends StatelessWidget {
  const _AppearanceSummaryCard({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EEF6)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1463E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.palette_rounded, color: Colors.white),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tampilan Global',
                  style: TextStyle(
                    color: Color(0xFF082E65),
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Warna dan gambar berikut diterapkan pada seluruh halaman website publik sekolah.',
                  style: TextStyle(
                    color: Color(0xFF60718A),
                    fontSize: 12.5,
                    height: 1.4,
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

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EEF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF082E65),
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF60718A), fontSize: 11.5),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ColorSettingRow extends StatelessWidget {
  const _ColorSettingRow({
    required this.title,
    required this.description,
    required this.controller,
    required this.color,
    required this.presets,
    required this.onChanged,
    required this.onPresetSelected,
  });

  final String title;
  final String description;
  final TextEditingController controller;
  final Color color;
  final List<String> presets;
  final VoidCallback onChanged;
  final ValueChanged<String> onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF082E65),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          description,
          style: const TextStyle(color: Color(0xFF60718A), fontSize: 11),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 66,
              height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E7F0)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AdminContentTextField(
                controller: controller,
                constraint: AdminContentConstraint.color,
                onChanged: (_) => onChanged(),
                style: const TextStyle(
                  color: Color(0xFF082E65),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFD9E2EE)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'Pilih warna',
              onSelected: onPresetSelected,
              itemBuilder: (_) => presets
                  .map(
                    (hex) => PopupMenuItem<String>(
                      value: hex,
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color:
                                  _AdminWebsiteAppearanceTabState._colorFromHex(
                                    hex,
                                    Colors.blue,
                                  ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(hex),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD9E2EE)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.colorize_rounded,
                  size: 18,
                  color: Color(0xFF60718A),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.primary, required this.navigation});

  final Color primary;
  final Color navigation;

  @override
  Widget build(BuildContext context) {
    return _AppearanceCard(
      title: 'Pratinjau Tema',
      subtitle: 'Simulasi singkat tampilan berdasarkan warna saat ini.',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE1E8F2)),
        ),
        child: Column(
          children: [
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo_sekolah.png',
                    width: 24,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) =>
                        Icon(Icons.school_rounded, color: navigation, size: 18),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'SMAK',
                    style: TextStyle(
                      color: navigation,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Beranda   Profil   Berita   Galeri',
                    style: TextStyle(color: navigation, fontSize: 8),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang di\nSMA Katolik',
                          style: TextStyle(
                            color: Color(0xFF082E65),
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 11),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Selengkapnya',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: List.generate(
                        2,
                        (index) => Expanded(
                          child: Container(
                            height: 104,
                            margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: const Color(0xFFE1E8F2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF1FA),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: Color(0xFFADC2DE),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(width: 30, height: 5, color: primary),
                                const SizedBox(height: 5),
                                Container(
                                  width: 65,
                                  height: 5,
                                  color: const Color(0xFFCFDBEA),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}

class _FallbackImageCard extends StatelessWidget {
  const _FallbackImageCard({required this.imagePath, required this.onPick});

  final String imagePath;
  final Future<void> Function() onPick;

  @override
  Widget build(BuildContext context) {
    return _AppearanceCard(
      title: 'Gambar Fallback',
      subtitle:
          'Ditampilkan otomatis ketika berita, galeri, atau konten lain tidak memiliki gambar.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 680;
          final preview = _AppearanceImagePreview(path: imagePath);
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                imagePath.isEmpty ? 'Belum ada gambar fallback' : imagePath,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF082E65),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              const _AppearanceInfoLine(
                icon: Icons.image_outlined,
                label: 'Format',
                value: 'PNG, JPG, WebP',
              ),
              const _AppearanceInfoLine(
                icon: Icons.aspect_ratio_rounded,
                label: 'Rekomendasi',
                value: '1600 × 900 px (16:9)',
              ),
              const _AppearanceInfoLine(
                icon: Icons.description_outlined,
                label: 'Ukuran maksimum',
                value: '2 MB',
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                preview,
                const SizedBox(height: 13),
                details,
                const SizedBox(height: 13),
                OutlinedButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.upload_rounded, size: 18),
                  label: const Text('Ganti Gambar'),
                ),
              ],
            );
          }

          return Row(
            children: [
              SizedBox(width: 205, child: preview),
              const SizedBox(width: 18),
              Expanded(child: details),
              const SizedBox(width: 18),
              OutlinedButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.upload_rounded, size: 18),
                label: const Text('Ganti Gambar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1463E8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppearanceImagePreview extends StatelessWidget {
  const _AppearanceImagePreview({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (path.isEmpty) {
      child = const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF90A4BF),
        ),
      );
    } else {
      child = websiteContentImage(path, fit: BoxFit.cover);
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: ColoredBox(color: const Color(0xFFEAF2FD), child: child),
      ),
    );
  }
}

class _AppearanceInfoLine extends StatelessWidget {
  const _AppearanceInfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1463E8)),
          const SizedBox(width: 7),
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF60718A), fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF40536D),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
