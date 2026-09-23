import 'dart:html' as html;

import 'package:flutter/material.dart';
import '../../admin/admin_dashboard_page.dart';
import '../../services/smak_api.dart';
import '../../services/website_identity.dart';
import '../../routing/public_routes.dart';
import '../galeri/galeri_page.dart';
import '../site_chrome.dart';

void _openLoginLink(String url) {
  html.window.open(url, '_blank');
}

_LoginDeviceDetails _detectLoginDevice(String userAgent, String platform) {
  final source = '$userAgent $platform'.toLowerCase();
  final browser = source.contains('edg/')
      ? 'Microsoft Edge'
      : source.contains('opr/') || source.contains('opera')
      ? 'Opera'
      : source.contains('firefox')
      ? 'Firefox'
      : source.contains('chrome')
      ? 'Chrome'
      : source.contains('safari')
      ? 'Safari'
      : 'Browser';
  final operatingSystem = source.contains('windows')
      ? 'Windows'
      : source.contains('android')
      ? 'Android'
      : source.contains('iphone') || source.contains('ipad')
      ? 'iOS'
      : source.contains('mac')
      ? 'macOS'
      : source.contains('linux')
      ? 'Linux'
      : 'Tidak diketahui';
  final deviceType = source.contains('ipad') || source.contains('tablet')
      ? 'tablet'
      : source.contains('mobile') || source.contains('android')
      ? 'mobile'
      : 'desktop';
  return _LoginDeviceDetails(browser, operatingSystem, deviceType);
}

class _LoginDeviceDetails {
  const _LoginDeviceDetails(
    this.browser,
    this.operatingSystem,
    this.deviceType,
  );

  final String browser;
  final String operatingSystem;
  final String deviceType;
}

class _LoginContent {
  const _LoginContent({
    this.heroTitle = 'Login',
    this.heroDescription =
        'Masuk untuk mengakses informasi dan layanan sekolah.',
    this.formTitle = 'Selamat Datang Kembali!',
    this.formSubtitle = 'Silakan masuk untuk melanjutkan',
    this.schoolSubtitle = 'Sekolah Menengah Atas Katolik',
    this.brandMessage =
        'Membentuk generasi unggul, berkarakter, beriman, dan berwawasan global.',
    this.heroImage = '',
  });

  final String heroTitle;
  final String heroDescription;
  final String formTitle;
  final String formSubtitle;
  final String schoolSubtitle;
  final String brandMessage;
  final String heroImage;

  factory _LoginContent.fromMap(Map<String, dynamic> map) {
    String value(String key, String fallback) {
      final text = '${map[key] ?? ''}'.trim();
      return text.isEmpty ? fallback : text;
    }

    const defaults = _LoginContent();
    return _LoginContent(
      heroTitle: value('hero_title', defaults.heroTitle),
      heroDescription: value('hero_description', defaults.heroDescription),
      formTitle: value('form_title', defaults.formTitle),
      formSubtitle: value('form_subtitle', defaults.formSubtitle),
      schoolSubtitle: value('school_subtitle', defaults.schoolSubtitle),
      brandMessage: value('brand_message', defaults.brandMessage),
      heroImage: '${map['hero_image'] ?? ''}'.trim(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum _LoginView { login, forgotPassword, forgotPasswordSuccess }

class _LoginPageState extends State<LoginPage> {
  static const _rememberedUsernameKey = 'smak_admin_remembered_username';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotPasswordEmailController = TextEditingController();
  _LoginView _view = _LoginView.login;
  bool _showPassword = false;
  bool _rememberMe = false;
  bool _submitting = false;
  _LoginContent _content = const _LoginContent();

  @override
  void initState() {
    super.initState();
    _restoreRememberedUsername();
    _loadLoginContent();
  }

  void _restoreRememberedUsername() {
    final remembered =
        html.window.localStorage[_rememberedUsernameKey]?.trim() ?? '';
    if (remembered.isEmpty) return;
    _emailController.text = remembered;
    _rememberMe = true;
  }

  Future<void> _loadLoginContent() async {
    try {
      final rows = await const SmakApi().getTable('pengaturan_login', limit: 1);
      if (!mounted || rows.isEmpty) return;
      setState(() => _content = _LoginContent.fromMap(rows.first));
    } catch (_) {
      // Default lokal tetap dipakai jika pengaturan belum dimigrasikan.
    }
  }

  Future<void> _submitLogin() async {
    final emailEmpty = _emailController.text.trim().isEmpty;
    final passwordEmpty = _passwordController.text.isEmpty;
    if (emailEmpty || passwordEmpty) {
      final message = emailEmpty && passwordEmpty
          ? 'Email/username dan password wajib diisi.'
          : emailEmpty
          ? 'Email/username wajib diisi.'
          : 'Password wajib diisi.';
      _showLoginError(message);
      return;
    }

    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final userAgent = html.window.navigator.userAgent;
      final platform = html.window.navigator.platform ?? '';
      final details = _detectLoginDevice(userAgent, platform);
      final result = await const SmakApi().login(
        username: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
        userAgent: userAgent,
        browser: details.browser,
        operatingSystem: details.operatingSystem,
        deviceType: details.deviceType,
      );
      final token = '${result['session_token'] ?? ''}';
      if (token.isEmpty) throw Exception('Token sesi tidak diterima.');
      if (_rememberMe) {
        html.window.localStorage['smak_admin_session'] = token;
        html.window.localStorage[_rememberedUsernameKey] = _emailController.text
            .trim();
        html.window.sessionStorage.remove('smak_admin_session');
      } else {
        html.window.sessionStorage['smak_admin_session'] = token;
        html.window.localStorage.remove('smak_admin_session');
        html.window.localStorage.remove(_rememberedUsernameKey);
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AdminDashboardPage(sessionToken: token),
        ),
      );
    } catch (_) {
      if (mounted) {
        _showLoginError('Username/email atau password salah.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showLoginError(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 134,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: _TopError(message: message),
        ),
      ),
    );
    overlay.insert(entry);
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _forgotPasswordEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 800;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SharedSmakNavigationBar(
              profilePages: sharedProfilePages(),
              academicPages: sharedAcademicPages(),
              studentPages: sharedStudentPages(),
              galleryPage: const GaleriPage(),
              initialActive: 'Login',
            ),
            _LoginHero(compact: compact, content: _content),
            Transform.translate(
              offset: const Offset(0, -58),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 54),
                child: switch (_view) {
                  _LoginView.login => _LoginCard(
                    compact: compact,
                    content: _content,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    showPassword: _showPassword,
                    rememberMe: _rememberMe,
                    submitting: _submitting,
                    onPasswordVisibilityChanged: () =>
                        setState(() => _showPassword = !_showPassword),
                    onRememberChanged: (value) =>
                        setState(() => _rememberMe = value ?? false),
                    onLogin: _submitLogin,
                    onForgotPassword: () =>
                        setState(() => _view = _LoginView.forgotPassword),
                  ),
                  _LoginView.forgotPassword => _ForgotPasswordCard(
                    compact: compact,
                    content: _content,
                    emailController: _forgotPasswordEmailController,
                    onBackToLogin: () =>
                        setState(() => _view = _LoginView.login),
                  ),
                  _LoginView.forgotPasswordSuccess =>
                    _ForgotPasswordSuccessCard(
                      compact: compact,
                      content: _content,
                      onBackToLogin: () =>
                          setState(() => _view = _LoginView.login),
                    ),
                },
              ),
            ),
            const _LoginFooter(),
          ],
        ),
      ),
    );
  }
}

class _TopError extends StatelessWidget {
  const _TopError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFFD92D20),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.compact, required this.content});
  final bool compact;
  final _LoginContent content;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: compact ? 330 : 390,
    child: Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF052E67), Color(0xFF0752B9), Color(0xFF6DA9D3)],
            ),
          ),
        ),
        if (content.heroImage.isNotEmpty)
          Positioned.fill(
            child: Image.network(
              const SmakApi().getFileUrl(content.heroImage),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Align(
                alignment: Alignment.bottomRight,
                child: _LoginBuilding(compact: compact),
              ),
            ),
          )
        else
          Positioned(
            right: compact ? -130 : 0,
            bottom: 0,
            child: _LoginBuilding(compact: compact),
          ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xDD052E67),
                  const Color(0x99052E67),
                  Colors.transparent,
                ],
                stops: const [.0, .42, 1.0],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 28 : 60),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.heroTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 48 : 64,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content.heroDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x55001F4F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home_rounded, color: Colors.white, size: 17),
                      SizedBox(width: 14),
                      Text('Beranda', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 14),
                      Icon(Icons.chevron_right_rounded, color: Colors.white),
                      SizedBox(width: 14),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _LoginBuilding extends StatelessWidget {
  const _LoginBuilding({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 580 : 780,
      height: 320,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: compact ? 520 : 720,
            height: 210,
            color: const Color(0xFFCBD9E9),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 170,
              height: 300,
              color: const Color(0xFFE7EDF4),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 120,
              height: 92,
              color: const Color(0xFF194A7A),
            ),
          ),
          Positioned(
            bottom: 220,
            child: Container(
              width: 0,
              height: 0,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFB9C9DA), width: 38),
                  left: BorderSide(color: Colors.transparent, width: 100),
                  right: BorderSide(color: Colors.transparent, width: 100),
                ),
              ),
            ),
          ),
          ...List.generate(
            14,
            (index) => Positioned(
              left: 28 + (index % 8) * 82.0,
              bottom: 70 + (index ~/ 8) * 65.0,
              child: Container(
                width: 48,
                height: 32,
                color: const Color(0xFF4C79A5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.compact,
    required this.content,
    required this.emailController,
    required this.passwordController,
    required this.showPassword,
    required this.rememberMe,
    required this.submitting,
    required this.onPasswordVisibilityChanged,
    required this.onRememberChanged,
    required this.onLogin,
    required this.onForgotPassword,
  });
  final bool compact;
  final _LoginContent content;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool showPassword;
  final bool rememberMe;
  final bool submitting;
  final VoidCallback onPasswordVisibilityChanged;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final form = Padding(
      padding: EdgeInsets.all(compact ? 25 : 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFEAF3FF),
              child: Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF0752B9),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              content.formTitle,
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF082E65),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              content.formSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF526178)),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Email / Username',
            style: TextStyle(
              color: Color(0xFF0D2448),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_rounded),
              hintText: 'Masukkan email atau username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Password',
            style: TextStyle(
              color: Color(0xFF0D2448),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passwordController,
            obscureText: !showPassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onLogin(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              hintText: 'Masukkan password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: onPasswordVisibilityChanged,
                icon: Icon(
                  showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Checkbox(value: rememberMe, onChanged: onRememberChanged),
              const Text('Ingat saya'),
              const Spacer(),
              TextButton(
                onPressed: onForgotPassword,
                child: const Text('Lupa Password?'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: submitting ? null : onLogin,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                submitting ? 'Memeriksa...' : 'Masuk',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
    return Card(
      elevation: 12,
      shadowColor: const Color(0x260F172A),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: compact
          ? form
          : Row(
              children: [
                Expanded(child: _LoginBrandPanel(content: content)),
                Expanded(child: form),
              ],
            ),
    );
  }
}

class _ForgotPasswordCard extends StatelessWidget {
  const _ForgotPasswordCard({
    required this.compact,
    required this.content,
    required this.emailController,
    required this.onBackToLogin,
  });

  final bool compact;
  final _LoginContent content;
  final TextEditingController emailController;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    final form = Padding(
      padding: EdgeInsets.all(compact ? 25 : 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFEAF3FF),
              child: Icon(
                Icons.lock_reset_rounded,
                color: Color(0xFF0752B9),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'Lupa Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF082E65),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Masukkan email yang terdaftar. Kami akan mengirimkan password sementara untuk membantu Anda masuk kembali.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF526178), height: 1.45),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Email',
            style: TextStyle(
              color: Color(0xFF0D2448),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              hintText: 'Masukkan email terdaftar',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              // Frontend-only tahap 1. Diaktifkan setelah endpoint forgot_password tersedia.
              onPressed: null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Kirim Password Sementara',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: TextButton.icon(
              onPressed: onBackToLogin,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Kembali ke Login'),
            ),
          ),
        ],
      ),
    );

    return Card(
      elevation: 12,
      shadowColor: const Color(0x260F172A),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: compact
          ? form
          : Row(
              children: [
                Expanded(child: _LoginBrandPanel(content: content)),
                Expanded(child: form),
              ],
            ),
    );
  }
}

class _ForgotPasswordSuccessCard extends StatelessWidget {
  const _ForgotPasswordSuccessCard({
    required this.compact,
    required this.content,
    required this.onBackToLogin,
  });

  final bool compact;
  final _LoginContent content;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    final form = Padding(
      padding: EdgeInsets.all(compact ? 25 : 52),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Color(0xFFEAF3FF),
            child: Icon(
              Icons.mark_email_read_outlined,
              color: Color(0xFF0752B9),
              size: 34,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Permintaan Berhasil Dikirim',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF082E65),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jika email yang Anda masukkan terdaftar, password sementara telah dikirim ke email tersebut.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF526178), height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Silakan periksa kotak masuk atau folder spam, lalu gunakan password sementara untuk login.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF526178), height: 1.5),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onBackToLogin,
              icon: const Icon(Icons.login_rounded),
              label: const Text(
                'Kembali ke Login',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );

    return Card(
      elevation: 12,
      shadowColor: const Color(0x260F172A),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: compact
          ? form
          : Row(
              children: [
                Expanded(child: _LoginBrandPanel(content: content)),
                Expanded(child: form),
              ],
            ),
    );
  }
}

class _LoginBrandPanel extends StatelessWidget {
  const _LoginBrandPanel({required this.content});

  final _LoginContent content;
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<WebsiteIdentity>(
    valueListenable: websiteIdentityController,
    builder: (context, identity, _) => Container(
      color: const Color(0xFFEAF3FF),
      constraints: const BoxConstraints(minHeight: 600),
      padding: const EdgeInsets.all(35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          websiteIdentityImage(identity.logo, width: 120, height: 130),
          const SizedBox(height: 12),
          Text(
            identity.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 38,
              color: Color(0xFF082E65),
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            content.schoolSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF082E65),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Container(width: 52, height: 3, color: const Color(0xFF0756C8)),
          const SizedBox(height: 20),
          Text(
            content.brandMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF203B60),
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ],
      ),
    ),
  );
}

class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 900;
      return Container(
        width: double.infinity,
        color: const Color(0xFF102D4D),
        padding: EdgeInsets.fromLTRB(
          compact ? 28 : 52,
          36,
          compact ? 28 : 52,
          22,
        ),
        child: Column(
          children: [
            if (compact)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LoginFooterBrand(),
                  SizedBox(height: 32),
                  _LoginFooterLinks(),
                  SizedBox(height: 32),
                  _LoginFooterContact(),
                  SizedBox(height: 32),
                  _LoginFooterHours(),
                ],
              )
            else
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _LoginFooterBrand()),
                  SizedBox(width: 42),
                  Expanded(flex: 4, child: _LoginFooterLinks()),
                  SizedBox(width: 42),
                  Expanded(flex: 6, child: _LoginFooterContact()),
                  SizedBox(width: 42),
                  Expanded(flex: 4, child: _LoginFooterHours()),
                ],
              ),
            const SizedBox(height: 30),
            Container(height: 1, color: const Color(0xFF54708E)),
            const SizedBox(height: 20),
            ValueListenableBuilder<WebsiteIdentity>(
              valueListenable: websiteIdentityController,
              builder: (context, identity, _) => Text(
                'Copyright ${identity.copyrightYear} ${identity.name}. All rights reserved.',
                style: const TextStyle(color: Color(0xFFE5EEF7), fontSize: 12),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _LoginFooterBrand extends StatelessWidget {
  const _LoginFooterBrand();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<WebsiteIdentity>(
                valueListenable: websiteIdentityController,
                builder: (context, identity, _) => websiteIdentityImage(
                  identity.logo,
                  width: 46,
                  height: 52,
                  fallbackColor: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<WebsiteIdentity>(
                      valueListenable: websiteIdentityController,
                      builder: (context, identity, _) => Text(
                        identity.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      globalWebsiteText(
                        context,
                        'slogan',
                        'Beriman • Berilmu • Berkarakter',
                      ),
                      style: TextStyle(color: Color(0xFFD5E2F0), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            globalWebsiteText(
              context,
              'deskripsi',
              'Membentuk generasi muda yang cerdas,\nberiman, dan siap berkarya bagi\nmasyarakat.',
            ),
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _LoginSocialIcon(
                'https://img.icons8.com/color/48/whatsapp--v1.png',
                onTap: () => _openLoginLink(globalWhatsappUrl(context)),
              ),
              SizedBox(width: 12),
              _LoginSocialIcon(
                'https://img.icons8.com/color/48/instagram-new--v1.png',
                onTap: () => _openLoginLink(
                  globalWebsiteText(
                    context,
                    'instagram',
                    'https://www.instagram.com/soegijapranata_lmj/',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoginSocialIcon extends StatelessWidget {
  const _LoginSocialIcon(this.imageUrl, {required this.onTap});
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    ),
  );
}

class _LoginFooterLinks extends StatelessWidget {
  const _LoginFooterLinks();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tautan Cepat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        _LoginFooterLink(
          'Beranda',
          onTap: () => publicRootNavigator(context).pushNamedAndRemoveUntil(
            PublicRoutes.home,
            (route) => false,
          ),
        ),
        _LoginFooterLink(
          'Profil',
          onTap: () => publicRootNavigator(
            context,
          ).pushNamed(PublicRoutes.profileIdentity),
        ),
        _LoginFooterLink(
          'Akademik',
          onTap: () => publicRootNavigator(
            context,
          ).pushNamed(PublicRoutes.academicCurriculum),
        ),
        _LoginFooterLink(
          'Kesiswaan',
          onTap: () => publicRootNavigator(
            context,
          ).pushNamed(PublicRoutes.studentRules),
        ),
        _LoginFooterLink(
          'Berita',
          onTap: () => publicRootNavigator(context).pushNamed(PublicRoutes.news),
        ),
        _LoginFooterLink(
          'Galeri',
          onTap: () =>
              publicRootNavigator(context).pushNamed(PublicRoutes.gallery),
        ),
        _LoginFooterLink(
          'PPDB',
          onTap: () =>
              publicRootNavigator(context).pushNamed(PublicRoutes.admissions),
        ),
        _LoginFooterLink(
          'Kontak',
          onTap: () =>
              publicRootNavigator(context).pushNamed(PublicRoutes.contact),
        ),
      ],
    ),
  );
}

class _LoginFooterContact extends StatelessWidget {
  const _LoginFooterContact();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 290,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kontak Kami',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        _LoginFooterActionRow(
          Icons.location_on_rounded,
          globalWebsiteText(
            context,
            'alamat',
            'V68H+JGC, Jogoyudan, Kec. Lumajang,\nKabupaten Lumajang, Jawa Timur 67315',
          ),
          () => _openLoginLink(
            globalWebsiteText(
              context,
              'link_maps',
              'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA',
            ),
          ),
        ),
        const SizedBox(height: 12),
        _LoginFooterActionRow(
          Icons.phone_rounded,
          globalWebsiteText(context, 'telepon', '0815-5099-445'),
          () => _openLoginLink(globalWhatsappUrl(context)),
        ),
        const SizedBox(height: 12),
        _LoginFooterActionRow(
          Icons.flag_rounded,
          globalWebsiteText(context, 'provinsi', 'Jawa Timur'),
        ),
      ],
    ),
  );
}

class _LoginFooterLink extends StatelessWidget {
  const _LoginFooterLink(this.label, {required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class _LoginFooterActionRow extends StatelessWidget {
  const _LoginFooterActionRow(this.icon, this.text, [this.onTap]);
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: onTap == null ? MouseCursor.defer : SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, height: 1.5),
            ),
          ),
        ],
      ),
    ),
  );
}

class _LoginFooterHours extends StatelessWidget {
  const _LoginFooterHours();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 190,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jam Operasional',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 14),
        Text(
          '${globalWebsiteText(context, 'hari_operasional', 'Senin – Jumat')}\n${globalWebsiteText(context, 'jam_operasional', '07.00 – 15.00 WIB')}',
          style: TextStyle(color: Colors.white, height: 1.5),
        ),
        SizedBox(height: 20),
        Text(
          '“${globalWebsiteText(context, 'motto', 'Ora et Labora')}\n(${globalWebsiteText(context, 'arti_motto', 'Berdoa dan Bekerja')})”',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
