import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../admin/admin_dashboard_page.dart';
import '../../services/smak_api.dart';
import '../../services/website_identity.dart';

class AdminMaintenanceLoginPage extends StatefulWidget {
  const AdminMaintenanceLoginPage({super.key});

  @override
  State<AdminMaintenanceLoginPage> createState() =>
      _AdminMaintenanceLoginPageState();
}

class _AdminMaintenanceLoginPageState
    extends State<AdminMaintenanceLoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _rememberMe = false;
  bool _submitting = false;

  Future<void> _submitLogin() async {
    final usernameEmpty = _usernameController.text.trim().isEmpty;
    final passwordEmpty = _passwordController.text.isEmpty;
    if (usernameEmpty || passwordEmpty) {
      final message = usernameEmpty && passwordEmpty
          ? 'Username dan password wajib diisi.'
          : usernameEmpty
          ? 'Username wajib diisi.'
          : 'Password wajib diisi.';
      _showError(message);
      return;
    }

    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final userAgent = html.window.navigator.userAgent;
      final platform = html.window.navigator.platform ?? '';
      final details = _detectDevice(userAgent, platform);
      final result = await const SmakApi().login(
        username: _usernameController.text.trim(),
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
        html.window.sessionStorage.remove('smak_admin_session');
      } else {
        html.window.sessionStorage['smak_admin_session'] = token;
        html.window.localStorage.remove('smak_admin_session');
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AdminDashboardPage(sessionToken: token),
        ),
      );
    } catch (_) {
      if (mounted) {
        _showError('Username atau password salah.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 760;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      body: Stack(
        children: [
          const Positioned.fill(child: _MaintenanceLoginBackground()),
          SafeArea(
            child: ValueListenableBuilder<WebsiteIdentity>(
              valueListenable: websiteIdentityController,
              builder: (context, identity, _) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 20 : 28,
                    vertical: compact ? 20 : 26,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _BrandHeader(
                              identity: identity,
                              compact: compact,
                            ),
                          ),
                          SizedBox(height: compact ? 28 : 38),
                          _MaintenanceLoginCard(
                            identity: identity,
                            compact: compact,
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                            showPassword: _showPassword,
                            rememberMe: _rememberMe,
                            submitting: _submitting,
                            onTogglePassword: () => setState(
                              () => _showPassword = !_showPassword,
                            ),
                            onRememberChanged: (value) => setState(
                              () => _rememberMe = value ?? false,
                            ),
                            onLogin: _submitLogin,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          SizedBox(height: compact ? 24 : 28),
                          Text(
                            'Halaman ini hanya dapat diakses oleh administrator resmi.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF51637E),
                              fontSize: compact ? 12 : 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '© ${identity.copyrightYear} ${identity.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF6E7F98),
                              fontSize: compact ? 12 : 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.identity, required this.compact});

  final WebsiteIdentity identity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        websiteIdentityImage(
          identity.logo,
          width: compact ? 48 : 62,
          height: compact ? 54 : 70,
          fallbackColor: identity.navigationColor,
        ),
        SizedBox(width: compact ? 12 : 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              identity.name,
              style: TextStyle(
                color: identity.navigationColor,
                fontSize: compact ? 20 : 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sekolah Menengah Atas Katolik',
              style: TextStyle(
                color: const Color(0xFF566A86),
                fontSize: compact ? 12 : 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MaintenanceLoginCard extends StatelessWidget {
  const _MaintenanceLoginCard({
    required this.identity,
    required this.compact,
    required this.usernameController,
    required this.passwordController,
    required this.showPassword,
    required this.rememberMe,
    required this.submitting,
    required this.onTogglePassword,
    required this.onRememberChanged,
    required this.onLogin,
    required this.onBack,
  });

  final WebsiteIdentity identity;
  final bool compact;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool showPassword;
  final bool rememberMe;
  final bool submitting;
  final VoidCallback onTogglePassword;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback onLogin;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: compact ? double.infinity : 530,
        padding: EdgeInsets.fromLTRB(
          compact ? 20 : 40,
          compact ? 24 : 34,
          compact ? 20 : 40,
          compact ? 20 : 30,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE3EAF7)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16082F63),
              blurRadius: 40,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 5,
                width: compact ? 150 : 180,
                margin: const EdgeInsets.only(bottom: 26),
                decoration: BoxDecoration(
                  color: identity.primaryColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            _SecurityBadge(color: identity.primaryColor, compact: compact),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 16,
                    color: identity.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AKSES KHUSUS ADMINISTRATOR',
                    style: TextStyle(
                      color: identity.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Masuk ke Dashboard Admin',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: identity.navigationColor,
                fontSize: compact ? 28 : 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Website sedang dalam pemeliharaan.\nSilakan masuk untuk mengelola website dan pengaturan sistem.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF60718A),
                fontSize: compact ? 13 : 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3D9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.build_circle_outlined,
                    color: Color(0xFFC68500),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Mode pemeliharaan sedang aktif',
                    style: TextStyle(
                      color: Color(0xFFB06E00),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            _MaintenanceLoginField(
              label: 'Username',
              hintText: 'Masukkan username',
              controller: usernameController,
              prefixIcon: Icons.person_rounded,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 18),
            _MaintenanceLoginField(
              label: 'Password',
              hintText: 'Masukkan password',
              controller: passwordController,
              prefixIcon: Icons.lock_rounded,
              obscureText: !showPassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onLogin(),
              suffix: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF7284A0),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Checkbox(value: rememberMe, onChanged: onRememberChanged),
                const Text(
                  'Ingat saya',
                  style: TextStyle(color: Color(0xFF536682)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: submitting ? null : onLogin,
                icon: submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.lock_open_rounded),
                label: Text(
                  submitting ? 'Memeriksa...' : 'Masuk ke Dashboard',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: identity.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  'Kembali ke Halaman Pemeliharaan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: identity.primaryColor,
                  side: BorderSide(color: identity.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

class _MaintenanceLoginField extends StatelessWidget {
  const _MaintenanceLoginField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.suffix,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF0A2B5F),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF7384A0)),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E0F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E0F0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF1463E8), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  const _SecurityBadge({required this.color, required this.compact});

  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 112 : 128,
      height: compact ? 112 : 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: compact ? 108 : 124,
            height: compact ? 108 : 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.08),
            ),
          ),
          Container(
            width: compact ? 84 : 96,
            height: compact ? 84 : 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE6EDFA)),
            ),
            child: Icon(
              Icons.shield_rounded,
              size: compact ? 48 : 56,
              color: color,
            ),
          ),
          Positioned(
            left: 10,
            top: 24,
            child: Icon(Icons.auto_awesome, color: color, size: 10),
          ),
          const Positioned(
            right: 8,
            top: 18,
            child: Icon(Icons.auto_awesome, color: Color(0xFFF5B82E), size: 10),
          ),
          Positioned(
            right: 20,
            top: 48,
            child: Icon(Icons.auto_awesome, color: color, size: 8),
          ),
          Positioned(
            left: 18,
            bottom: 20,
            child: Icon(Icons.auto_awesome, color: color, size: 8),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceLoginBackground extends StatelessWidget {
  const _MaintenanceLoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ColoredBox(color: Color(0xFFF6F8FE)),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [
                  Colors.white,
                  const Color(0xFFF6F8FE),
                ],
              ),
            ),
          ),
        ),
        const Positioned(top: -120, right: -120, child: _BigRing(size: 360)),
        const Positioned(bottom: -140, left: -140, child: _BigRing(size: 340)),
        const Positioned(top: 250, left: 110, child: _DotGrid()),
        const Positioned(bottom: 190, right: 120, child: _DotGrid()),
        Positioned(
          left: 96,
          bottom: 180,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB9D1FF), width: 3),
            ),
          ),
        ),
        Positioned(
          right: 140,
          top: 290,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC9DBFF), width: 3),
            ),
          ),
        ),
      ],
    );
  }
}

class _BigRing extends StatelessWidget {
  const _BigRing({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1463E8).withOpacity(.03),
        border: Border.all(
          color: const Color(0xFF1463E8).withOpacity(.10),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: size * .78,
          height: size * .78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1463E8).withOpacity(.18),
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  const _DotGrid();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          16,
          (_) => Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFC7D9FB),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

_MaintenanceLoginDevice _detectDevice(String userAgent, String platform) {
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
  return _MaintenanceLoginDevice(browser, operatingSystem, deviceType);
}

class _MaintenanceLoginDevice {
  const _MaintenanceLoginDevice(
    this.browser,
    this.operatingSystem,
    this.deviceType,
  );

  final String browser;
  final String operatingSystem;
  final String deviceType;
}
