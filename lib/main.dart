import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'admin/admin_dashboard_page.dart';
import 'landing_page/landing_page.dart';
import 'landing_page/maintenance/admin_maintenance_login_page.dart';
import 'landing_page/maintenance/maintenance_page.dart';
import 'routing/public_routes.dart';
import 'services/smak_api.dart';
import 'services/website_identity.dart';

final GlobalKey<NavigatorState> _appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  try {
    await websiteIdentityController.load();
  } catch (_) {
    // Tetap gunakan fallback bawaan bila API identitas gagal.
  }
  runApp(const SmakApp());
}

class SmakApp extends StatelessWidget {
  const SmakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WebsiteIdentity>(
      valueListenable: websiteIdentityController,
      builder: (context, identity, _) => MaterialApp(
        navigatorKey: _appNavigatorKey,
        title: identity.browserTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: identity.primaryColor),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),

        builder: (context, child) {
          return _WebKeyboardScroll(
            navigatorKey: _appNavigatorKey,
            child: GlobalWebsiteContentScope(child: child!),
          );
        },

        onGenerateRoute: (settings) => _buildPublicRoute(settings, identity),
        onGenerateInitialRoutes: (initialRoute) => [
          _buildPublicRoute(RouteSettings(name: initialRoute), identity),
        ],
      ),
    );
  }
}

Route<void> _buildPublicRoute(
  RouteSettings settings,
  WebsiteIdentity identity,
) {
  final requestedPath = PublicRoutes.normalize(settings.name);
  final page = PublicRoutes.pageFor(requestedPath);
  final resolvedPath = page == null ? PublicRoutes.home : requestedPath;
  return MaterialPageRoute<void>(
    settings: RouteSettings(name: resolvedPath),
    builder: (_) => _SessionGate(
      identity: identity,
      publicPath: resolvedPath,
      publicPage: page ?? const LandingPage(),
    ),
  );
}

class _WebKeyboardScroll extends StatefulWidget {
  const _WebKeyboardScroll({required this.navigatorKey, required this.child});

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<_WebKeyboardScroll> createState() => _WebKeyboardScrollState();
}

class _WebKeyboardScrollState extends State<_WebKeyboardScroll> {
  late final StreamSubscription<html.KeyboardEvent> _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = html.window.onKeyDown.listen(_handleKeyDown);
  }

  @override
  void dispose() {
    _keySubscription.cancel();
    super.dispose();
  }

  void _handleKeyDown(html.KeyboardEvent event) {
    if (_isEditingText || event.altKey || event.ctrlKey || event.metaKey) return;

    final direction = switch (event.key) {
      'ArrowDown' || 'PageDown' => 1.0,
      'ArrowUp' || 'PageUp' => -1.0,
      _ => null,
    };
    if (direction == null) return;

    final position = _activeVerticalScrollPosition();
    if (position == null) return;

    final isPage = event.key == 'PageDown' || event.key == 'PageUp';
    final distance = isPage ? position.viewportDimension * .85 : 72.0;
    final target = (position.pixels + direction * distance).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (target == position.pixels) return;

    event.preventDefault();
    position.animateTo(
      target.toDouble(),
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
    );
  }

  bool get _isEditingText {
    final element = html.document.activeElement;
    final tag = element?.tagName.toLowerCase();
    return tag == 'input' ||
        tag == 'textarea' ||
        tag == 'select' ||
        tag == 'flt-text-editing-host' ||
        element?.isContentEditable == true;
  }

  ScrollPosition? _activeVerticalScrollPosition() {
    final root = widget.navigatorKey.currentContext;
    if (root == null) return null;

    ScrollPosition? best;
    double bestExtent = -1;

    void visit(Element element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        final state = element.state as ScrollableState;
        final route = ModalRoute.of(element);
        if (state.axisDirection == AxisDirection.down &&
            state.position.hasContentDimensions &&
            state.position.maxScrollExtent > state.position.minScrollExtent &&
            (route == null || route.isCurrent) &&
            TickerMode.of(element)) {
          final extent = state.position.maxScrollExtent;
          if (extent > bestExtent) {
            best = state.position;
            bestExtent = extent;
          }
        }
      }
      element.visitChildElements(visit);
    }

    root.visitChildElements(visit);
    return best;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SessionGate extends StatefulWidget {
  const _SessionGate({
    required this.identity,
    required this.publicPath,
    required this.publicPage,
  });

  final WebsiteIdentity identity;
  final String publicPath;
  final Widget publicPage;

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  String? _sessionToken;
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    final sessionToken = html.window.sessionStorage['smak_admin_session'];
    final localToken = html.window.localStorage['smak_admin_session'];
    if ((sessionToken == null || sessionToken.isEmpty) &&
        (localToken == null || localToken.isEmpty)) {
      _checkingSession = false;
      return;
    }
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final sessionToken = html.window.sessionStorage['smak_admin_session'];
    final localToken = html.window.localStorage['smak_admin_session'];
    final token = sessionToken ?? localToken;

    if (token != null && token.isNotEmpty) {
      try {
        await const SmakApi().getSecurityDashboard(token);
        _sessionToken = token;
      } catch (_) {
        html.window.sessionStorage.remove('smak_admin_session');
        html.window.localStorage.remove('smak_admin_session');
      }
    }

    if (mounted) setState(() => _checkingSession = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_sessionToken != null) {
      return AdminDashboardPage(sessionToken: _sessionToken!);
    }

    if (widget.publicPath == PublicRoutes.login) return widget.publicPage;

    return widget.identity.websiteActive && !widget.identity.maintenanceMode
        ? widget.publicPage
        : MaintenancePage(
            message: widget.identity.maintenanceMessage,
            onAdminLogin: () {
              _appNavigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => const AdminMaintenanceLoginPage(),
                ),
              );
            },
          );
  }
}
