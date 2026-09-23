part of '../admin_dashboard_page.dart';

// Aset bawaan yang dipakai selama admin belum mengunggah penggantinya.
// Jika nama file di project berbeda, cukup ubah tiga konstanta ini.
const String _defaultWebsiteLogo = 'assets/images/logo_sekolah.png';
const String _defaultWebsiteFavicon = 'assets/images/favicon_sekolah.png';
const String _defaultFallbackImage =
    'assets/images/fallback/fallback_sekolah.png';

class AdminPengaturanWebsitePage extends StatefulWidget {
  const AdminPengaturanWebsitePage({
    super.key,
    required this.api,
    required this.module,
    required this.sessionToken,
    this.initialTab = 'Identitas',
  });

  final SmakApi api;
  final AdminModule module;
  final String sessionToken;
  final String initialTab;

  @override
  State<AdminPengaturanWebsitePage> createState() =>
      _AdminPengaturanWebsitePageState();
}

class _AdminPengaturanWebsitePageState
    extends State<AdminPengaturanWebsitePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _brandSubtitle = TextEditingController();
  final _browserTitle = TextEditingController();
  final _copyright = TextEditingController();
  final _primaryColor = TextEditingController();
  final _secondaryColor = TextEditingController();
  final _maintenanceMessage = TextEditingController();
  final _seoDescription = TextEditingController();
  final _seoKeywords = TextEditingController();

  // Konten halaman Login.
  final _loginHeroTitle = TextEditingController();
  final _loginHeroDescription = TextEditingController();
  final _loginFormTitle = TextEditingController();
  final _loginFormSubtitle = TextEditingController();
  final _loginSchoolSubtitle = TextEditingController();
  final _loginBrandMessage = TextEditingController();

  Map<String, String> _footer = _defaultFooterValues();

  final Map<String, int> _settingIds = {};
  String _tab = 'Identitas';
  String _logo = _defaultWebsiteLogo;
  String _favicon = _defaultWebsiteFavicon;
  String _fallback = _defaultFallbackImage;
  String _loginHeroImage = '';
  bool _websiteActive = true;
  bool _maintenance = false;
  bool _loading = true;
  bool _saving = false;
  Timer? _statusSaveTimer;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
    _setDefaults();
    _load();
  }

  void _setDefaults() {
    _name.text = 'SMAK Mgr. Soegijapranata';
    _brandSubtitle.text = 'Sekolah Menengah Atas Katolik';
    _browserTitle.text = 'SMAK | Sekolah Menengah Atas Katolik';
    _copyright.text = '2026';
    _primaryColor.text = '#1463E8';
    _secondaryColor.text = '#082F63';
    _maintenanceMessage.text =
        'Website sedang dalam pemeliharaan. Silakan kembali beberapa saat lagi.';
    _seoDescription.text = 'Website resmi SMAK Mgr. Soegijapranata Lumajang.';
    _seoKeywords.text = 'SMAK, SMA Katolik, sekolah Lumajang';

    _loginHeroTitle.text = 'Login';
    _loginHeroDescription.text =
        'Masuk untuk mengakses informasi dan layanan sekolah.';
    _loginFormTitle.text = 'Selamat Datang Kembali!';
    _loginFormSubtitle.text = 'Silakan masuk untuk melanjutkan';
    _loginSchoolSubtitle.text = 'Sekolah Menengah Atas Katolik';
    _loginBrandMessage.text =
        'Membentuk generasi unggul, berkarakter, beriman, dan berwawasan global.';
    _loginHeroImage = '';

    _logo = _defaultWebsiteLogo;
    _favicon = _defaultWebsiteFavicon;
    _fallback = _defaultFallbackImage;
    _footer = _defaultFooterValues();
  }

  Future<void> _load() async {
    try {
      final sections = await Future.wait([
        _loadSetting('pengaturan_identitas'),
        _loadSetting('pengaturan_tampilan'),
        _loadSetting('pengaturan_seo'),
        _loadSetting('pengaturan_status'),
        _loadSetting('pengaturan_footer'),
        _loadSetting('pengaturan_login'),
      ]);
      final identity = sections[0];
      final appearance = sections[1];
      final seo = sections[2];
      final status = sections[3];
      final footer = sections[4];
      final login = sections[5];

      _name.text = '${identity['nama_website'] ?? _name.text}';
      _brandSubtitle.text = '${identity['subtitle_brand'] ?? _brandSubtitle.text}';
      _browserTitle.text = '${identity['judul_browser'] ?? _browserTitle.text}';
      _copyright.text = '${identity['tahun_copyright'] ?? _copyright.text}';
      _logo = _assetOrDatabaseValue(identity['logo'], _defaultWebsiteLogo);
      _favicon = _assetOrDatabaseValue(
        identity['favicon'],
        _defaultWebsiteFavicon,
      );

      _primaryColor.text = '${appearance['warna_utama'] ?? _primaryColor.text}';
      _secondaryColor.text =
          '${appearance['warna_sekunder'] ?? _secondaryColor.text}';
      _fallback = _assetOrDatabaseValue(
        appearance['gambar_fallback'],
        _defaultFallbackImage,
      );

      _seoDescription.text = '${seo['deskripsi_seo'] ?? _seoDescription.text}';
      _seoKeywords.text = '${seo['kata_kunci_seo'] ?? _seoKeywords.text}';

      _maintenanceMessage.text =
          '${status['maintenance_message'] ?? _maintenanceMessage.text}';
      _websiteActive = '${status['website_active'] ?? '1'}' != '0';
      _maintenance = '${status['maintenance_mode'] ?? '0'}' == '1';

      _footer = {
        for (final entry in _defaultFooterValues().entries)
          entry.key: '${footer[entry.key] ?? entry.value}',
      };

      _loginHeroTitle.text = '${login['hero_title'] ?? _loginHeroTitle.text}';
      _loginHeroDescription.text =
          '${login['hero_description'] ?? _loginHeroDescription.text}';
      _loginFormTitle.text = '${login['form_title'] ?? _loginFormTitle.text}';
      _loginFormSubtitle.text =
          '${login['form_subtitle'] ?? _loginFormSubtitle.text}';
      _loginSchoolSubtitle.text =
          '${login['school_subtitle'] ?? _loginSchoolSubtitle.text}';
      _loginBrandMessage.text =
          '${login['brand_message'] ?? _loginBrandMessage.text}';
      _loginHeroImage = '${login['hero_image'] ?? ''}'.trim();
    } catch (_) {
      // Nilai bawaan tetap dipakai sebelum tabel pengaturan selesai dimigrasi.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Map<String, dynamic>> _loadSetting(String table) async {
    try {
      final rows = await widget.api.getTable(table, limit: 1);
      if (rows.isEmpty) return <String, dynamic>{};
      final row = rows.first;
      final id = int.tryParse('${row['id'] ?? ''}');
      if (id != null) _settingIds[table] = id;
      return row;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? true)) return;
    if (_tab == 'Identitas' &&
        (_name.text.trim().isEmpty ||
            _browserTitle.text.trim().isEmpty ||
            _copyright.text.trim().length != 4)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi identitas website dengan benar.'),
        ),
      );
      return;
    }
    final setting = _activeSetting();
    if (setting == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data keamanan tersimpan otomatis pada log sistem.'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.api.save(
        setting.table,
        setting.data,
        id: _settingIds[setting.table],
      );
      await websiteIdentityController.load(api: widget.api);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengaturan $_tab berhasil disimpan.')),
      );
      await _load();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _queueStatusSave(WebsiteStatusValues values) {
    setState(() {
      _websiteActive = values.websiteActive;
      _maintenance = values.maintenanceMode;
      _maintenanceMessage.text = values.maintenanceMessage;
    });
    _statusSaveTimer?.cancel();
    _statusSaveTimer = Timer(
      const Duration(milliseconds: 650),
      _saveStatusImmediately,
    );
  }

  Future<void> _saveStatusImmediately() async {
    if (_loading) return;
    if (_saving) {
      _statusSaveTimer = Timer(
        const Duration(milliseconds: 350),
        _saveStatusImmediately,
      );
      return;
    }
    setState(() => _saving = true);
    try {
      const table = 'pengaturan_status';
      await widget.api.save(table, {
        'website_active': _websiteActive ? 1 : 0,
        'maintenance_mode': _maintenance ? 1 : 0,
        'maintenance_message': _maintenanceMessage.text.trim(),
      }, id: _settingIds[table]);
      await _loadSetting(table);
      await websiteIdentityController.load(api: widget.api);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status gagal disimpan otomatis: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  ({String table, Map<String, dynamic> data})? _activeSetting() {
    switch (_tab) {
      case 'Identitas':
        return (
          table: 'pengaturan_identitas',
          data: {
            'nama_website': _name.text.trim(),
            'subtitle_brand': _brandSubtitle.text.trim(),
            'judul_browser': _browserTitle.text.trim(),
            'tahun_copyright': _copyright.text.trim(),
            'logo': _logo,
            'favicon': _favicon,
          },
        );
      case 'Tampilan':
        return (
          table: 'pengaturan_tampilan',
          data: {
            'warna_utama': _primaryColor.text.trim().toUpperCase(),
            'warna_sekunder': _secondaryColor.text.trim().toUpperCase(),
            'gambar_fallback': _fallback,
          },
        );
      case 'Login':
        return (
          table: 'pengaturan_login',
          data: {
            'hero_title': _loginHeroTitle.text.trim(),
            'hero_description': _loginHeroDescription.text.trim(),
            'form_title': _loginFormTitle.text.trim(),
            'form_subtitle': _loginFormSubtitle.text.trim(),
            'school_subtitle': _loginSchoolSubtitle.text.trim(),
            'brand_message': _loginBrandMessage.text.trim(),
            'hero_image': _loginHeroImage,
          },
        );
      case 'Footer':
        return (
          table: 'pengaturan_footer',
          data: Map<String, dynamic>.from(_footer),
        );
      case 'SEO Dasar':
        return (
          table: 'pengaturan_seo',
          data: {
            'deskripsi_seo': _seoDescription.text.trim(),
            'kata_kunci_seo': _seoKeywords.text.trim(),
          },
        );
      case 'Status Website':
        return (
          table: 'pengaturan_status',
          data: {
            'website_active': _websiteActive ? 1 : 0,
            'maintenance_mode': _maintenance ? 1 : 0,
            'maintenance_message': _maintenanceMessage.text.trim(),
          },
        );
      default:
        return null;
    }
  }

  Future<void> _pickImage(String target) async {
    final input = html.FileUploadInputElement()
      ..accept = 'image/png,image/jpeg,image/webp,image/x-icon';
    input.click();
    await input.onChange.first;
    final file = input.files?.isNotEmpty == true ? input.files!.first : null;
    if (file == null) return;
    if (file.size > 3 * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ukuran gambar maksimal 3 MB.')),
        );
      }
      return;
    }
    try {
      final uploadTable = target == 'fallback'
          ? 'pengaturan_tampilan'
          : target == 'loginHero'
          ? 'pengaturan_login'
          : 'pengaturan_identitas';
      final filename = await widget.api.uploadFile(uploadTable, file);
      setState(() {
        if (target == 'logo') _logo = filename;
        if (target == 'favicon') _favicon = filename;
        if (target == 'fallback') _fallback = filename;
        if (target == 'loginHero') _loginHeroImage = filename;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar siap digunakan. Klik Simpan Perubahan.'),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload gagal: $error')));
      }
    }
  }

  void _cancel() {
    setState(() => _loading = true);
    _setDefaults();
    _load();
  }

  @override
  void dispose() {
    // Jangan membatalkan perubahan Status Website yang masih menunggu debounce.
    // Jika admin pindah halaman sebelum 650 ms, kirim snapshot terakhir langsung
    // ke API tanpa menyentuh state/widget yang sedang di-dispose.
    if (_statusSaveTimer?.isActive ?? false) {
      _statusSaveTimer?.cancel();
      final statusId = _settingIds['pengaturan_status'];
      final websiteActive = _websiteActive;
      final maintenanceMode = _maintenance;
      final maintenanceMessage = _maintenanceMessage.text.trim();

      unawaited(
        widget.api.save('pengaturan_status', {
          'website_active': websiteActive ? 1 : 0,
          'maintenance_mode': maintenanceMode ? 1 : 0,
          'maintenance_message': maintenanceMessage,
        }, id: statusId),
      );
    } else {
      _statusSaveTimer?.cancel();
    }

    for (final controller in [
      _name,
      _brandSubtitle,
      _browserTitle,
      _copyright,
      _primaryColor,
      _secondaryColor,
      _maintenanceMessage,
      _seoDescription,
      _seoKeywords,
      _loginHeroTitle,
      _loginHeroDescription,
      _loginFormTitle,
      _loginFormSubtitle,
      _loginSchoolSubtitle,
      _loginBrandMessage,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 500,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SettingsHeader(saving: _saving, onCancel: _cancel, onSave: _save),
          const SizedBox(height: 22),
          _SettingsTabs(
            selected: _tab,
            onSelected: (value) => setState(() => _tab = value),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: _tabContent(),
          ),
          const SizedBox(height: 18),
          const _SettingsInfoStrip(),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 10,
              children: [
                OutlinedButton(
                  onPressed: _saving ? null : _cancel,
                  child: const Text('Batal'),
                ),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: const Text('Simpan Perubahan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabContent() {
    switch (_tab) {
      case 'Tampilan':
        return AdminWebsiteAppearanceTab(
          key: const ValueKey('appearance'),
          initialPrimaryHex: _primaryColor.text,
          initialNavigationHex: _secondaryColor.text,
          fallbackImage: _fallback,
          onChanged: (values) {
            _primaryColor.text = values.primaryHex;
            _secondaryColor.text = values.navigationHex;
          },
          onPickFallback: () => _pickImage('fallback'),
        );

      case 'Login':
        return AdminWebsiteLoginTab(
          key: const ValueKey('login'),
          heroTitle: _loginHeroTitle,
          heroDescription: _loginHeroDescription,
          formTitle: _loginFormTitle,
          formSubtitle: _loginFormSubtitle,
          schoolSubtitle: _loginSchoolSubtitle,
          brandMessage: _loginBrandMessage,
          api: widget.api,
          heroImage: _loginHeroImage,
          onPickHeroImage: () => _pickImage('loginHero'),
          onRemoveHeroImage: () => setState(() => _loginHeroImage = ''),
        );

      case 'Footer':
        return AdminWebsiteFooterTab(
          key: const ValueKey('footer'),
          initialValues: _footer,
          onChanged: (values) => _footer = values,
        );

      case 'SEO Dasar':
        return _SeoTab(
          key: const ValueKey('seo'),
          description: _seoDescription,
          keywords: _seoKeywords,
          websiteName: _name.text,
          browserTitle: _browserTitle.text,
        );
      case 'Status Website':
        return AdminWebsiteStatusTab(
          key: const ValueKey('status'),
          initialWebsiteActive: _websiteActive,
          initialMaintenanceMode: _maintenance,
          initialMaintenanceMessage: _maintenanceMessage.text,
          onChanged: _queueStatusSave,
          onOpenWebsite: () => _openAdminPreview(context, const LandingPage()),
          logoAsset: _logo,
          schoolName: _name.text.trim().isEmpty ? 'SMAK' : _name.text.trim(),
          schoolSubtitle: 'Sekolah Menengah Atas Katolik',
        );
      case 'Keamanan & Aktivitas':
        return _SecurityTab(
          key: const ValueKey('security'),
          api: widget.api,
          sessionToken: widget.sessionToken,
        );
      default:
        return AdminWebsiteIdentityTab(
          key: const ValueKey('identity'),
          api: widget.api,
          initialName: _name.text,
          initialBrandSubtitle: _brandSubtitle.text,
          initialBrowserTitle: _browserTitle.text,
          initialCopyrightYear: _copyright.text,
          logoAsset: _logo,
          faviconAsset: _favicon,
          websiteActive: _websiteActive,
          onSave: (values) async {
            _name.text = values['nama_website'] ?? _name.text;
            _brandSubtitle.text = values['subtitle_brand'] ?? _brandSubtitle.text;
            _browserTitle.text = values['judul_browser'] ?? _browserTitle.text;
            _copyright.text = values['tahun_copyright'] ?? _copyright.text;
            await _save();
          },
          onCancel: () {
            _load();
          },
          onPickLogo: () => _pickImage('logo'),
          onPickFavicon: () => _pickImage('favicon'),
          onChanged: (values) {
            _name.text = values['nama_website'] ?? _name.text;
            _brandSubtitle.text = values['subtitle_brand'] ?? _brandSubtitle.text;
            _browserTitle.text = values['judul_browser'] ?? _browserTitle.text;
            _copyright.text = values['tahun_copyright'] ?? _copyright.text;
          },
        );
    }
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({
    required this.saving,
    required this.onCancel,
    required this.onSave,
  });
  final bool saving;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, constraints) {
      final compact = constraints.maxWidth < 650;
      final copy = const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan Website',
            style: TextStyle(
              color: _text,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Kelola identitas, tampilan global, status, dan keamanan website.',
            style: TextStyle(color: _muted),
          ),
        ],
      );
      final actions = Wrap(
        spacing: 10,
        children: [
          OutlinedButton(
            onPressed: saving ? null : onCancel,
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: saving ? null : onSave,
            child: const Text('Simpan Perubahan'),
          ),
        ],
      );
      return compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 16), actions],
            )
          : Row(
              children: [
                Expanded(child: copy),
                actions,
              ],
            );
    },
  );
}

class _SettingsTabs extends StatelessWidget {
  const _SettingsTabs({required this.selected, required this.onSelected});
  final String selected;
  final ValueChanged<String> onSelected;
  static const tabs = [
    'Identitas',
    'Tampilan',
    'Login',
    'Footer',
    'SEO Dasar',
    'Status Website',
    'Keamanan & Aktivitas',
  ];

  @override
  Widget build(BuildContext context) => _SettingCard(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final active = selected == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () => onSelected(tab),
              style: TextButton.styleFrom(
                foregroundColor: active ? _blue : _text,
                backgroundColor: active
                    ? const Color(0xFFEAF2FF)
                    : Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    this.title,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });
  final String? title;
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
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
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              color: _text,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
        ],
        child,
      ],
    ),
  );
}

class _SettingField extends StatelessWidget {
  const _SettingField({
    required this.label,
    required this.controller,
    required this.maxLength,
    this.maxLines = 1,
    this.enabled = true,
  });
  final String label;
  final TextEditingController controller;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: AdminContentFormField(
      controller: controller,
      enabled: enabled,
      constraint: adminConstraintFor(label, maxLines: maxLines, existingMaxCharacters: maxLength),
      maxLines: maxLines,
      validator: (value) => enabled && (value == null || value.trim().isEmpty)
          ? '$label wajib diisi.'
          : null,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

class _ColorField extends StatelessWidget {
  const _ColorField({required this.label, required this.controller});
  final String label;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: AdminContentFormField(
      controller: controller,
      constraint: AdminContentConstraint.color,
      validator: (value) => RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value ?? '')
          ? null
          : 'Gunakan format #RRGGBB.',
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        prefixIcon: Container(
          margin: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: _hexColor(controller.text),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        suffixIcon: const Icon(Icons.palette_outlined),
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

class _UploadRow extends StatelessWidget {
  const _UploadRow({
    required this.label,
    required this.filename,
    required this.api,
    required this.onTap,
    required this.button,
    this.small = false,
    this.wide = false,
  });
  final String label;
  final String filename;
  final SmakApi api;
  final VoidCallback onTap;
  final String button;
  final bool small;
  final bool wide;
  @override
  Widget build(BuildContext context) {
    Widget preview = Container(
      width: wide ? 180 : (small ? 54 : 80),
      height: wide ? 95 : (small ? 54 : 80),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: filename.isEmpty
          ? const Icon(Icons.image_outlined, color: _blue, size: 34)
          : _settingImage(filename, api),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: _text, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(10),
          ),
          child: LayoutBuilder(
            builder: (_, constraints) {
              final compact = constraints.maxWidth < 480;
              final details = Expanded(
                child: Text(
                  filename.isEmpty ? 'Belum ada gambar dipilih' : filename,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted),
                ),
              );
              final action = OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.upload_outlined),
                label: Text(button),
              );
              return compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        preview,
                        const SizedBox(height: 10),
                        Text(
                          filename.isEmpty
                              ? 'Belum ada gambar dipilih'
                              : filename,
                        ),
                        const SizedBox(height: 10),
                        action,
                      ],
                    )
                  : Row(
                      children: [
                        preview,
                        const SizedBox(width: 14),
                        details,
                        const SizedBox(width: 12),
                        action,
                      ],
                    );
            },
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(color: _muted, fontSize: 12)),
          ],
        ),
      ),
      Switch(value: value, onChanged: onChanged),
    ],
  );
}

class _SmallInfo extends StatelessWidget {
  const _SmallInfo({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF2FF),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, color: _blue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(color: _text, fontSize: 12)),
        ),
      ],
    ),
  );
}

class _SettingsInfoStrip extends StatelessWidget {
  const _SettingsInfoStrip();
  @override
  Widget build(BuildContext context) => const _SmallInfo(
    text:
        'Pengaturan ini mengatur identitas, tampilan, dan konten global website.',
  );
}

Color _hexColor(String value) {
  final clean = value.replaceFirst('#', '');
  final parsed = int.tryParse(clean, radix: 16);
  return parsed == null ? _blue : Color(0xFF000000 | parsed);
}

String _assetOrDatabaseValue(dynamic value, String fallback) {
  final text = '${value ?? ''}'.trim();
  return text.isEmpty ? fallback : text;
}

Widget _settingImage(String source, SmakApi api) {
  return websiteContentImage(source, fit: BoxFit.contain);
}
