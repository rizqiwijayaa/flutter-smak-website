part of '../admin_dashboard_page.dart';

/// Isi tab "Identitas" pada halaman Pengaturan Website.
///
/// Pasang file ini di:
/// lib/admin/pengaturan_website/pengaturan_website_identitas_tab.dart
/// lalu tambahkan pada admin_dashboard_page.dart:
/// part 'pengaturan_website/pengaturan_website_identitas_tab.dart';
class AdminWebsiteIdentityTab extends StatefulWidget {
  const AdminWebsiteIdentityTab({
    super.key,
    required this.api,
    this.initialName = 'SMAK Mgr. Soegijapranata',
    this.initialBrandSubtitle = 'Sekolah Menengah Atas Katolik',
    this.initialBrowserTitle = 'SMAK | Sekolah Menengah Atas Katolik',
    this.initialCopyrightYear = '2026',
    this.logoAsset = 'assets/images/logo_sekolah.png',
    this.faviconAsset = 'assets/images/favicon/logo_sekolah.png',
    this.websiteActive = true,
    this.onSave,
    this.onCancel,
    this.onPickLogo,
    this.onPickFavicon,
    this.onChanged,
  });

  final String initialName;
  final String initialBrandSubtitle;
  final SmakApi api;
  final String initialBrowserTitle;
  final String initialCopyrightYear;
  final String logoAsset;
  final String faviconAsset;
  final bool websiteActive;
  final Future<void> Function(Map<String, String> values)? onSave;
  final VoidCallback? onCancel;
  final Future<void> Function()? onPickLogo;
  final Future<void> Function()? onPickFavicon;
  final ValueChanged<Map<String, String>>? onChanged;

  @override
  State<AdminWebsiteIdentityTab> createState() =>
      _AdminWebsiteIdentityTabState();
}

class _AdminWebsiteIdentityTabState extends State<AdminWebsiteIdentityTab> {
  late final TextEditingController _nameController;
  late final TextEditingController _brandSubtitleController;
  late final TextEditingController _browserTitleController;
  late final TextEditingController _yearController;

  bool _saving = false;

  String? _networkUrlFor(String value) {
    final clean = value.trim();
    if (clean.isEmpty || clean.startsWith('assets/')) return null;
    return apiFileUrl(clean);
  }

  String apiFileUrl(String value) => widget.api.getFileUrl(value);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _brandSubtitleController = TextEditingController(text: widget.initialBrandSubtitle);
    _browserTitleController = TextEditingController(
      text: widget.initialBrowserTitle,
    );
    _yearController = TextEditingController(text: widget.initialCopyrightYear);
    _nameController.addListener(_refresh);
    _brandSubtitleController.addListener(_refresh);
    _browserTitleController.addListener(_refresh);
    _yearController.addListener(_refresh);
  }

  void _refresh() {
    widget.onChanged?.call({
      'nama_website': _nameController.text,
      'subtitle_brand': _brandSubtitleController.text,
      'judul_browser': _browserTitleController.text,
      'tahun_copyright': _yearController.text,
    });
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_refresh)
      ..dispose();
    _brandSubtitleController
      ..removeListener(_refresh)
      ..dispose();
    _browserTitleController
      ..removeListener(_refresh)
      ..dispose();
    _yearController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AdminWebsiteIdentityTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialName != widget.initialName &&
        _nameController.text != widget.initialName) {
      _nameController.text = widget.initialName;
    }
    if (oldWidget.initialBrandSubtitle != widget.initialBrandSubtitle &&
        _brandSubtitleController.text != widget.initialBrandSubtitle) {
      _brandSubtitleController.text = widget.initialBrandSubtitle;
    }
    if (oldWidget.initialBrowserTitle != widget.initialBrowserTitle &&
        _browserTitleController.text != widget.initialBrowserTitle) {
      _browserTitleController.text = widget.initialBrowserTitle;
    }
    if (oldWidget.initialCopyrightYear != widget.initialCopyrightYear &&
        _yearController.text != widget.initialCopyrightYear) {
      _yearController.text = widget.initialCopyrightYear;
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _browserTitleController.text.trim().isEmpty ||
        _yearController.text.trim().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi identitas website dengan benar.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onSave?.call({
        'nama_website': _nameController.text.trim(),
        'subtitle_brand': _brandSubtitleController.text.trim(),
        'judul_browser': _browserTitleController.text.trim(),
        'tahun_copyright': _yearController.text.trim(),
      });
      if (!mounted) return;
      // The parent reports success or failure after the API request completes.
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 860;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _IdentitySummary(
          compact: compact,
          name: _nameController.text,
          browserTitle: _browserTitleController.text,
          year: _yearController.text,
          logoAsset: widget.logoAsset,
          logoObjectUrl: _networkUrlFor(widget.logoAsset),
          active: widget.websiteActive,
        ),
        const SizedBox(height: 14),
        if (compact) ...[
          _IdentityForm(
            nameController: _nameController,
            brandSubtitleController: _brandSubtitleController,
            browserTitleController: _browserTitleController,
            yearController: _yearController,
          ),
          const SizedBox(height: 14),
          _IdentityPreview(
            name: _nameController.text,
            browserTitle: _browserTitleController.text,
            logoAsset: widget.logoAsset,
            logoObjectUrl: _networkUrlFor(widget.logoAsset),
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 11,
                child: _IdentityForm(
                  nameController: _nameController,
                  brandSubtitleController: _brandSubtitleController,
                  browserTitleController: _browserTitleController,
                  yearController: _yearController,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 10,
                child: _IdentityPreview(
                  name: _nameController.text,
                  browserTitle: _browserTitleController.text,
                  logoAsset: widget.logoAsset,
                  logoObjectUrl: _networkUrlFor(widget.logoAsset),
                ),
              ),
            ],
          ),
        const SizedBox(height: 14),
        _IdentityBrandAssets(
          compact: compact,
          logoAsset: widget.logoAsset,
          faviconAsset: widget.faviconAsset,
          logoObjectUrl: _networkUrlFor(widget.logoAsset),
          faviconObjectUrl: _networkUrlFor(widget.faviconAsset),
          logoFileName: null,
          faviconFileName: null,
          onPickLogo: () => widget.onPickLogo?.call(),
          onPickFavicon: () => widget.onPickFavicon?.call(),
        ),
      ],
    );
  }
}

class _IdentityPageHeading extends StatelessWidget {
  const _IdentityPageHeading({
    required this.saving,
    required this.onCancel,
    required this.onSave,
  });

  final bool saving;
  final VoidCallback? onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Pengaturan Website',
              style: TextStyle(
                color: _text,
                fontSize: 27,
                height: 1.1,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Kelola identitas, tampilan global, status, dan keamanan website.',
              style: TextStyle(color: _muted, fontSize: 13),
            ),
          ],
        );
        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: saving ? null : onCancel,
              child: const Text('Batal'),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: saving ? null : onSave,
              style: FilledButton.styleFrom(backgroundColor: _blue),
              icon: saving
                  ? const SizedBox.square(
                      dimension: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 17),
              label: Text(saving ? 'Menyimpan...' : 'Simpan Perubahan'),
            ),
          ],
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 16), actions],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: title),
            actions,
          ],
        );
      },
    );
  }
}

class _IdentitySettingsTabs extends StatelessWidget {
  const _IdentitySettingsTabs();

  @override
  Widget build(BuildContext context) {
    const tabs = [
      'Identitas',
      'Tampilan',
      'SEO Dasar',
      'Status Website',
      'Keamanan & Aktivitas',
    ];
    return Container(
      height: 49,
      padding: const EdgeInsets.all(5),
      decoration: _identityCardDecoration(radius: 13),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final active = tab == 'Identitas';
            return Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? const Color(0xFFEAF2FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: active ? _blue : _text,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _IdentitySummary extends StatelessWidget {
  const _IdentitySummary({
    required this.compact,
    required this.name,
    required this.browserTitle,
    required this.year,
    required this.logoAsset,
    required this.logoObjectUrl,
    required this.active,
  });

  final bool compact;
  final String name;
  final String browserTitle;
  final String year;
  final String logoAsset;
  final String? logoObjectUrl;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final identity = Row(
      children: [
        _IdentityBrandImage(
          asset: logoAsset,
          networkUrl: logoObjectUrl,
          size: 82,
          padding: 8,
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 7,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    name.isEmpty ? 'Nama Website' : name,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFFE8F8EE)
                          : const Color(0xFFFFF3E1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active
                            ? const Color(0xFFBDE7CB)
                            : const Color(0xFFFFD99B),
                      ),
                    ),
                    child: Text(
                      active ? 'Website Aktif' : 'Website Nonaktif',
                      style: TextStyle(
                        color: active
                            ? const Color(0xFF178442)
                            : const Color(0xFFB76800),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Sekolah Menengah Atas Katolik',
                style: TextStyle(color: _muted, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );

    final summaries = Wrap(
      spacing: 8,
      runSpacing: 12,
      children: [
        _IdentitySummaryItem(
          icon: Icons.description_outlined,
          label: 'Nama Website',
          value: name.isEmpty ? '-' : name,
        ),
        _IdentitySummaryItem(
          icon: Icons.language_rounded,
          label: 'Judul Browser',
          value: browserTitle.isEmpty ? '-' : browserTitle,
        ),
        _IdentitySummaryItem(
          icon: Icons.copyright_rounded,
          label: 'Hak Cipta',
          value: year.isEmpty ? '-' : year,
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _identityCardDecoration(),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [identity, const SizedBox(height: 20), summaries],
            )
          : Row(
              children: [
                Expanded(flex: 10, child: identity),
                Container(width: 1, height: 70, color: _line),
                const SizedBox(width: 16),
                Expanded(flex: 12, child: summaries),
              ],
            ),
    );
  }
}

class _IdentitySummaryItem extends StatelessWidget {
  const _IdentitySummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEAF2FF),
            ),
            child: Icon(icon, color: _blue, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: _muted, fontSize: 10.5),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

class _IdentityForm extends StatelessWidget {
  const _IdentityForm({
    required this.nameController,
    required this.brandSubtitleController,
    required this.browserTitleController,
    required this.yearController,
  });

  final TextEditingController nameController;
  final TextEditingController brandSubtitleController;
  final TextEditingController browserTitleController;
  final TextEditingController yearController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _identityCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IdentityCardTitle('Informasi Website'),
          const SizedBox(height: 16),
          _IdentityField(
            label: 'Nama Website',
            helper: 'Nama resmi website yang ditampilkan di berbagai bagian.',
            controller: nameController,
            maxLength: 100,
          ),
          const SizedBox(height: 13),
          _IdentityField(
            label: 'Subtitle Brand',
            helper: 'Teks di bawah nama sekolah pada header website.',
            controller: brandSubtitleController,
            maxLength: 160,
          ),
          const SizedBox(height: 13),
          _IdentityField(
            label: 'Judul Tab Browser',
            helper: 'Judul yang muncul pada tab browser.',
            controller: browserTitleController,
            maxLength: 60,
          ),
          const SizedBox(height: 13),
          _IdentityField(
            label: 'Tahun Hak Cipta',
            helper: 'Tahun hak cipta yang ditampilkan di footer website.',
            controller: yearController,
            maxLength: 4,
            numbersOnly: true,
          ),
        ],
      ),
    );
  }
}

class _IdentityField extends StatelessWidget {
  const _IdentityField({
    required this.label,
    required this.helper,
    required this.controller,
    required this.maxLength,
    this.numbersOnly = false,
  });

  final String label;
  final String helper;
  final TextEditingController controller;
  final int maxLength;
  final bool numbersOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        AdminContentTextField(
          controller: controller,
          constraint: adminConstraintFor(label, existingMaxCharacters: maxLength),
          keyboardType: numbersOnly ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCAD4E2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _blue, width: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                helper,
                style: const TextStyle(color: _muted, fontSize: 10.5),
              ),
            ),
            Text(
              '${controller.text.length} / $maxLength',
              style: const TextStyle(color: _muted, fontSize: 10.5),
            ),
          ],
        ),
      ],
    );
  }
}

class _IdentityPreview extends StatelessWidget {
  const _IdentityPreview({
    required this.name,
    required this.browserTitle,
    required this.logoAsset,
    required this.logoObjectUrl,
  });

  final String name;
  final String browserTitle;
  final String logoAsset;
  final String? logoObjectUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _identityCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IdentityCardTitle('Pratinjau Identitas'),
          const SizedBox(height: 15),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              children: [
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: const Color(0xFFF2F4F8),
                  child: Row(
                    children: [
                      ...const [
                        Color(0xFFFF6B61),
                        Color(0xFFFFBE3D),
                        Color(0xFF53C86A),
                      ].map(
                        (color) => Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Container(
                          height: 31,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            border: Border.all(color: _line),
                          ),
                          child: Row(
                            children: [
                              _IdentityBrandImage(
                                asset: logoAsset,
                                networkUrl: logoObjectUrl,
                                size: 18,
                                padding: 1,
                                border: false,
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  browserTitle.isEmpty
                                      ? 'Judul browser'
                                      : browserTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _text,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const Icon(Icons.close, size: 13, color: _muted),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Icon(Icons.add, size: 17, color: _muted),
                    ],
                  ),
                ),
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, size: 16, color: _muted),
                      const SizedBox(width: 12),
                      const Icon(Icons.refresh, size: 16, color: _muted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 27,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F4F8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'https://www.smak-soegijapranata.sch.id',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: _muted, fontSize: 9.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 104,
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: _line)),
                  ),
                  child: Row(
                    children: [
                      _IdentityBrandImage(
                        asset: logoAsset,
                        networkUrl: logoObjectUrl,
                        size: 62,
                        padding: 3,
                        border: false,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isEmpty ? 'SMAK' : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _text,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Sekolah Menengah Atas Katolik',
                              style: TextStyle(color: _muted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.menu_rounded, color: _text, size: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          const Center(
            child: Text(
              'Pratinjau otomatis berdasarkan data di samping',
              style: TextStyle(color: _muted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityBrandAssets extends StatelessWidget {
  const _IdentityBrandAssets({
    required this.compact,
    required this.logoAsset,
    required this.faviconAsset,
    required this.logoObjectUrl,
    required this.faviconObjectUrl,
    required this.logoFileName,
    required this.faviconFileName,
    required this.onPickLogo,
    required this.onPickFavicon,
  });

  final bool compact;
  final String logoAsset;
  final String faviconAsset;
  final String? logoObjectUrl;
  final String? faviconObjectUrl;
  final String? logoFileName;
  final String? faviconFileName;
  final VoidCallback onPickLogo;
  final VoidCallback onPickFavicon;

  @override
  Widget build(BuildContext context) {
    final logo = _IdentityAssetTile(
      title: 'Logo Website',
      fileName: logoFileName ?? logoAsset,
      metadata: 'PNG • Latar transparan',
      asset: logoAsset,
      objectUrl: logoObjectUrl,
      buttonLabel: 'Ganti Logo',
      onPressed: onPickLogo,
      large: true,
    );
    final favicon = _IdentityAssetTile(
      title: 'Favicon Browser',
      fileName: faviconFileName ?? faviconAsset,
      metadata: 'PNG • Disarankan 32 × 32 px',
      asset: faviconAsset,
      objectUrl: faviconObjectUrl,
      buttonLabel: 'Ganti Favicon',
      onPressed: onPickFavicon,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _identityCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IdentityCardTitle('Aset Branding'),
          const SizedBox(height: 14),
          if (compact) ...[
            logo,
            const SizedBox(height: 12),
            favicon,
          ] else
            Row(
              children: [
                Expanded(child: logo),
                const SizedBox(width: 14),
                Expanded(child: favicon),
              ],
            ),
        ],
      ),
    );
  }
}

class _IdentityAssetTile extends StatelessWidget {
  const _IdentityAssetTile({
    required this.title,
    required this.fileName,
    required this.metadata,
    required this.asset,
    required this.objectUrl,
    required this.buttonLabel,
    required this.onPressed,
    this.large = false,
  });

  final String title;
  final String fileName;
  final String metadata;
  final String asset;
  final String? objectUrl;
  final String buttonLabel;
  final VoidCallback onPressed;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          _IdentityBrandImage(
            asset: asset,
            networkUrl: objectUrl,
            size: large ? 72 : 56,
            padding: large ? 6 : 10,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _text, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Text(
                  metadata,
                  style: const TextStyle(color: _muted, fontSize: 10.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.upload_rounded, size: 15),
            label: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _IdentityInfoStrip extends StatelessWidget {
  const _IdentityInfoStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: _blue, size: 20),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identitas ini digunakan pada navbar, tab browser, halaman login, dan footer website.',
                  style: TextStyle(
                    color: _text,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pastikan logo tetap jelas pada latar terang maupun gelap.',
                  style: TextStyle(color: _muted, fontSize: 10.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityCardTitle extends StatelessWidget {
  const _IdentityCardTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _text,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _IdentityBrandImage extends StatelessWidget {
  const _IdentityBrandImage({
    required this.asset,
    required this.size,
    required this.padding,
    this.networkUrl,
    this.border = true,
  });

  final String asset;
  final String? networkUrl;
  final double size;
  final double padding;
  final bool border;

  @override
  Widget build(BuildContext context) {
    Widget fallback() =>
        const Center(child: Icon(Icons.school_rounded, color: _blue));
    final image = networkUrl != null
        ? websiteContentImage(networkUrl!, fit: BoxFit.contain)
        : Image.asset(
            asset,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => fallback(),
          );

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(12),
        border: border ? Border.all(color: _line) : null,
      ),
      child: image,
    );
  }
}

BoxDecoration _identityCardDecoration({double radius = 14}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: _line),
  boxShadow: const [
    BoxShadow(color: Color(0x08082F63), blurRadius: 18, offset: Offset(0, 6)),
  ],
);
