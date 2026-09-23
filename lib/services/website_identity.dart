import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'smak_api.dart';

final globalWebsiteContent = ValueNotifier<Map<String, dynamic>>({});

class GlobalWebsiteContentScope
    extends InheritedNotifier<ValueNotifier<Map<String, dynamic>>> {
  GlobalWebsiteContentScope({super.key, required super.child})
    : super(notifier: globalWebsiteContent);
}

String globalWebsiteText(BuildContext context, String key, String fallback) {
  final scope = context
      .dependOnInheritedWidgetOfExactType<GlobalWebsiteContentScope>();
  final data = scope?.notifier?.value ?? globalWebsiteContent.value;
  final text = '${data[key] ?? ''}'.trim();
  return text.isEmpty ? fallback : text;
}

String globalWhatsappUrl(BuildContext context) {
  final value = globalWebsiteText(context, 'whatsapp', '628155099445');
  if (value.startsWith('https://') || value.startsWith('http://')) return value;
  var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.startsWith('0')) digits = '62${digits.substring(1)}';
  return 'https://wa.me/$digits';
}

const String defaultWebsiteLogo = 'assets/images/logo_sekolah.png';
const String defaultWebsiteFavicon = 'assets/images/favicon_sekolah.png';
const String defaultWebsiteFallback =
    'assets/images/fallback/fallback_sekolah.png';

class WebsiteIdentity {
  const WebsiteIdentity({
    this.name = 'SMAK Mgr. Soegijapranata',
    this.brandSubtitle = 'Sekolah Menengah Atas Katolik',
    this.browserTitle = 'SMAK Mgr. Soegijapranata Lumajang',
    this.copyrightYear = '2026',
    this.logo = defaultWebsiteLogo,
    this.favicon = defaultWebsiteFavicon,
    this.primaryHex = '#1463E8',
    this.navigationHex = '#082F63',
    this.fallbackImage = defaultWebsiteFallback,
    this.seoDescription =
        'Website resmi SMAK Mgr. Soegijapranata Lumajang. Informasi profil sekolah, akademik, kesiswaan, prestasi, berita, galeri, dan PPDB.',
    this.seoKeywords =
        'SMAK Mgr. Soegijapranata, SMAK Soegijapranata, SMA Katolik Lumajang, sekolah Katolik Lumajang, SMA Lumajang',
    this.websiteActive = true,
    this.maintenanceMode = false,
    this.maintenanceMessage =
        'Website sedang dalam pemeliharaan. Silakan kembali beberapa saat lagi.',
  });

  final String name;
  final String brandSubtitle;
  final String browserTitle;
  final String copyrightYear;
  final String logo;
  final String favicon;
  final String primaryHex;
  final String navigationHex;
  final String fallbackImage;
  final String seoDescription;
  final String seoKeywords;
  final bool websiteActive;
  final bool maintenanceMode;
  final String maintenanceMessage;

  Color get primaryColor =>
      websiteColorFromHex(primaryHex, const Color(0xFF1463E8));
  Color get navigationColor =>
      websiteColorFromHex(navigationHex, const Color(0xFF082F63));

  factory WebsiteIdentity.fromDatabase(Map<String, dynamic> row) {
    String value(String key, String fallback) {
      final result = '${row[key] ?? ''}'.trim();
      return result.isEmpty ? fallback : result;
    }

    return WebsiteIdentity(
      name: value('nama_website', 'SMAK Mgr. Soegijapranata'),
      brandSubtitle: value('subtitle_brand', 'Sekolah Menengah Atas Katolik'),
      browserTitle: value(
        'judul_browser',
        'SMAK Mgr. Soegijapranata Lumajang',
      ),
      copyrightYear: value('tahun_copyright', '2026'),
      logo: value('logo', defaultWebsiteLogo),
      favicon: value('favicon', defaultWebsiteFavicon),
      primaryHex: value('warna_utama', '#1463E8'),
      navigationHex: value('warna_sekunder', '#082F63'),
      fallbackImage: value('gambar_fallback', defaultWebsiteFallback),
      seoDescription: value(
        'deskripsi_seo',
        'Website resmi SMAK Mgr. Soegijapranata Lumajang. Informasi profil sekolah, akademik, kesiswaan, prestasi, berita, galeri, dan PPDB.',
      ),
      seoKeywords: value(
        'kata_kunci_seo',
        'SMAK Mgr. Soegijapranata, SMAK Soegijapranata, SMA Katolik Lumajang, sekolah Katolik Lumajang, SMA Lumajang',
      ),
      websiteActive: value('website_active', '1') != '0',
      maintenanceMode: value('maintenance_mode', '0') == '1',
      maintenanceMessage: value(
        'maintenance_message',
        'Website sedang dalam pemeliharaan. Silakan kembali beberapa saat lagi.',
      ),
    );
  }
}

class WebsiteIdentityController extends ValueNotifier<WebsiteIdentity> {
  WebsiteIdentityController() : super(const WebsiteIdentity());

  final SmakApi _api = const SmakApi();

  Future<void> load({SmakApi? api}) async {
    try {
      final activeApi = api ?? _api;
      final contact = await _firstSetting(activeApi, 'kontak');
      final footer = await _firstSetting(activeApi, 'pengaturan_footer');
      globalWebsiteContent.value = {
        ...footer,
        'contact_telepon': contact['telepon'],
        'email': contact['email'],
      };
      final sections = await Future.wait([
        _firstSetting(activeApi, 'pengaturan_identitas'),
        _firstSetting(activeApi, 'pengaturan_tampilan'),
        _firstSetting(activeApi, 'pengaturan_seo'),
        _firstSetting(activeApi, 'pengaturan_status'),
      ]);
      final merged = <String, dynamic>{};
      for (final section in sections) {
        merged.addAll(section);
      }
      if (merged.isNotEmpty) updateFromDatabase(merged, api: activeApi);
    } catch (_) {
      // Identitas bawaan tetap dipakai jika API sedang tidak tersedia.
    }
  }

  Future<Map<String, dynamic>> _firstSetting(SmakApi api, String table) async {
    try {
      final rows = await api.getTable(table, limit: 1);
      return rows.isEmpty ? <String, dynamic>{} : rows.first;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  void updateFromDatabase(Map<String, dynamic> row, {SmakApi? api}) {
    value = WebsiteIdentity.fromDatabase(row);
    _applyBrowserIdentity(api ?? _api);
  }

  void _applyBrowserIdentity(SmakApi api) {
    html.document.title = value.browserTitle;
    _upsertMeta(name: 'description', content: value.seoDescription);
    _upsertMeta(name: 'keywords', content: value.seoKeywords);
    _upsertMeta(property: 'og:title', content: value.browserTitle);
    _upsertMeta(property: 'og:description', content: value.seoDescription);
    final faviconUrl = value.favicon.startsWith('assets/')
        ? value.favicon
        : api.getFileUrl(value.favicon);
    final existing = html.document.head?.querySelector("link[rel~='icon']");
    if (existing is html.LinkElement) {
      existing.href = faviconUrl;
    } else {
      html.document.head?.append(
        html.LinkElement()
          ..rel = 'icon'
          ..href = faviconUrl,
      );
    }
  }

  void _upsertMeta({String? name, String? property, required String content}) {
    final attribute = name != null ? 'name' : 'property';
    final key = name ?? property!;
    final selector = 'meta[$attribute="$key"]';
    final existing = html.document.head?.querySelector(selector);
    if (existing is html.MetaElement) {
      existing.content = content;
      return;
    }
    final meta = html.MetaElement()..content = content;
    if (name != null) {
      meta.name = name;
    } else {
      meta.setAttribute('property', property!);
    }
    html.document.head?.append(meta);
  }
}

final websiteIdentityController = WebsiteIdentityController();

bool websiteUsesFallbackImage(String source) {
  final path = source.trim().replaceAll('\\', '/');
  if (path.isEmpty) return true;
  final uri = Uri.tryParse(path);
  final queryFilename = uri?.queryParameters['file']?.trim();
  final filename = (queryFilename != null && queryFilename.isNotEmpty
          ? queryFilename.split('/').last
          : uri != null && uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : path.split('/').last)
      .toLowerCase();

  // Bundled assets and absolute URLs are real sources and must remain visible.
  // The one legacy case-only path is invalid on case-sensitive web hosting.
  if (path == 'assets/images/1030.jpg') return true;
  if (path.startsWith('assets/') ||
      path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('data:image/')) {
    return false;
  }

  // Files uploaded by the current API always use the smak_* basename. A few
  // packaged deployments also contain curated cms/content/landing files.
  // Any other bare media filename is a legacy database placeholder, not an
  // uploaded file, and can go directly to the global fallback without a 404.
  final isBareFilename = queryFilename != null || !path.contains('/');
  final isKnownUpload = RegExp(
    r'^(?:smak_|cms_|content_|landing_banner_).+\.[a-z0-9]+$',
    caseSensitive: false,
  ).hasMatch(filename);
  return isBareFilename && !isKnownUpload;
}

Color websiteColorFromHex(String value, Color fallback) {
  final clean = value.trim().replaceFirst('#', '');
  final parsed = int.tryParse(clean, radix: 16);
  return parsed == null || clean.length != 6
      ? fallback
      : Color(0xFF000000 | parsed);
}

Widget websiteIdentityImage(
  String source, {
  required double width,
  required double height,
  BoxFit fit = BoxFit.contain,
  Color fallbackColor = const Color(0xFF062C64),
}) {
  Widget fallback() =>
      Icon(Icons.school_rounded, color: fallbackColor, size: width * .72);

  if (source.startsWith('assets/')) {
    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => fallback(),
    );
  }
  return Image.network(
    const SmakApi().getFileUrl(source),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, _, _) => fallback(),
  );
}

Widget websiteFallbackImage({
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  return ValueListenableBuilder<WebsiteIdentity>(
    valueListenable: websiteIdentityController,
    builder: (context, identity, _) {
      final source = identity.fallbackImage;
      Widget error() => Container(
        width: width,
        height: height,
        color: const Color(0xFFEAF2FD),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: identity.primaryColor,
          size: 42,
        ),
      );
      if (websiteUsesFallbackImage(source)) return error();
      if (source.startsWith('assets/')) {
        return Image.asset(
          source,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => error(),
        );
      }
      return Image.network(
        const SmakApi().getFileUrl(source),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => error(),
      );
    },
  );
}

Widget websiteContentImage(
  String source, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  if (source.trim().isEmpty || websiteUsesFallbackImage(source)) {
    return websiteFallbackImage(fit: fit, width: width, height: height);
  }
  if (source.startsWith('data:image/')) {
    return Image.network(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) =>
          websiteFallbackImage(fit: fit, width: width, height: height),
    );
  }
  if (source.startsWith('assets/')) {
    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) =>
          websiteFallbackImage(fit: fit, width: width, height: height),
    );
  }
  return Image.network(
    const SmakApi().getFileUrl(source),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, _, _) =>
        websiteFallbackImage(fit: fit, width: width, height: height),
  );
}

/// School logo from Admin > Pengaturan Website > Identitas. The bundled logo
/// remains a safe fallback for an empty/invalid database value.
Widget websiteLogoImage({
  double? width,
  double? height,
  BoxFit fit = BoxFit.contain,
}) => ValueListenableBuilder<WebsiteIdentity>(
  valueListenable: websiteIdentityController,
  builder: (context, identity, _) {
    final source = identity.logo.trim();
    Widget fallback() => Image.asset(
      'assets/images/logo_sekolah.png',
      width: width,
      height: height,
      fit: fit,
    );
    if (source.isEmpty || source == 'assets/images/logo_sekolah.png') {
      return fallback();
    }
    if (source.startsWith('assets/')) {
      return Image.asset(source, width: width, height: height, fit: fit,
          errorBuilder: (_, _, _) => fallback());
    }
    return Image.network(const SmakApi().getFileUrl(source),
        width: width, height: height, fit: fit,
        errorBuilder: (_, _, _) => fallback());
  },
);
