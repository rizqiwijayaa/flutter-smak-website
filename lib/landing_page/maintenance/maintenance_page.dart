import 'package:flutter/material.dart';

const Color _maintenanceNavy = Color(0xFF082F63);
const Color _maintenanceBlue = Color(0xFF1463E8);
const Color _maintenanceText = Color(0xFF102B55);
const Color _maintenanceMuted = Color(0xFF60718A);

/// Halaman publik yang ditampilkan ketika mode pemeliharaan aktif.
///
/// Data pesan dapat diambil dari pengaturan website lalu dikirim melalui
/// [message]. Navigasi sengaja memakai callback agar tidak bergantung pada
/// nama route di proyek.
class MaintenancePage extends StatefulWidget {
  const MaintenancePage({
    super.key,
    this.message =
        'Website sedang dalam pemeliharaan. Silakan kembali beberapa saat lagi.',
    this.schoolName = 'SMAK Mgr. Soegijapranata',
    this.schoolSubtitle = 'Sekolah Menengah Atas Katolik',
    this.logoAsset = 'assets/images/logo_sekolah.png',
    this.onRetry,
    this.onAdminLogin,
  });

  final String message;
  final String schoolName;
  final String schoolSubtitle;
  final String logoAsset;
  final Future<void> Function()? onRetry;
  final VoidCallback? onAdminLogin;

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  bool _checking = false;

  Future<void> _retry() async {
    if (_checking) return;
    setState(() => _checking = true);

    try {
      if (widget.onRetry != null) {
        await widget.onRetry!();
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 760;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: Stack(
        children: [
          const Positioned.fill(child: _MaintenanceBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 20 : 44,
                    vertical: compact ? 22 : 26,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - (compact ? 44 : 52),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SchoolBrand(
                          logoAsset: widget.logoAsset,
                          schoolName: widget.schoolName,
                          schoolSubtitle: widget.schoolSubtitle,
                          compact: compact,
                        ),
                        SizedBox(height: compact ? 32 : 54),
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1080),
                            child: _MaintenanceCard(
                              compact: compact,
                              message: widget.message,
                              checking: _checking,
                              onRetry: _retry,
                              onAdminLogin: widget.onAdminLogin,
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 25 : 30),
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'Terima kasih atas pengertian dan kesabaran Anda.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _maintenanceText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                '© ${DateTime.now().year} ${widget.schoolName}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _maintenanceMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({
    required this.compact,
    required this.message,
    required this.checking,
    required this.onRetry,
    required this.onAdminLogin,
  });

  final bool compact;
  final String message;
  final bool checking;
  final VoidCallback onRetry;
  final VoidCallback? onAdminLogin;

  @override
  Widget build(BuildContext context) {
    final content = _MaintenanceContent(
      compact: compact,
      message: message,
      checking: checking,
      onRetry: onRetry,
      onAdminLogin: onAdminLogin,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 18 : 20),
        border: Border.all(color: const Color(0xFFE2EAF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16082F63),
            blurRadius: 34,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 6,
            width: double.infinity,
            child: ColoredBox(color: _maintenanceBlue),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 24 : 42),
            child: compact
                ? Column(
                    children: [
                      const _MaintenanceIllustration(compact: true),
                      const SizedBox(height: 28),
                      content,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 10,
                        child: _MaintenanceIllustration(compact: false),
                      ),
                      Container(
                        width: 1,
                        height: 345,
                        margin: const EdgeInsets.symmetric(horizontal: 42),
                        color: const Color(0xFFE6ECF4),
                      ),
                      Expanded(flex: 11, child: content),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceContent extends StatelessWidget {
  const _MaintenanceContent({
    required this.compact,
    required this.message,
    required this.checking,
    required this.onRetry,
    required this.onAdminLogin,
  });

  final bool compact;
  final String message;
  final bool checking;
  final VoidCallback onRetry;
  final VoidCallback? onAdminLogin;

  @override
  Widget build(BuildContext context) {
    final displayedMessage = message.trim().isEmpty
        ? 'Website sedang dalam pemeliharaan. Silakan kembali beberapa saat lagi.'
        : message.trim();

    return Column(
      crossAxisAlignment: compact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: _maintenanceBlue,
                child: Icon(
                  Icons.handyman_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'SEDANG DALAM PEMELIHARAAN',
                style: TextStyle(
                  color: _maintenanceBlue,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Kami Segera Kembali',
          textAlign: compact ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: _maintenanceNavy,
            fontSize: compact ? 30 : 38,
            height: 1.12,
            fontWeight: FontWeight.w900,
            letterSpacing: -.5,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          displayedMessage,
          textAlign: compact ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: _maintenanceMuted,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F7FC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE4EBF4)),
          ),
          child: const Row(
            children: [
              Icon(Icons.schedule_rounded, size: 20, color: _maintenanceBlue),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Proses pemeliharaan sedang berlangsung',
                  style: TextStyle(
                    color: Color(0xFF4D607A),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (compact)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buttons(),
          )
        else
          Wrap(spacing: 12, runSpacing: 10, children: _buttons()),
      ],
    );
  }

  List<Widget> _buttons() {
    return [
      SizedBox(
        height: 48,
        child: FilledButton.icon(
          onPressed: checking ? null : onRetry,
          icon: checking
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.refresh_rounded, size: 20),
          label: Text(checking ? 'Memeriksa...' : 'Periksa Lagi'),
          style: FilledButton.styleFrom(
            backgroundColor: _maintenanceBlue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF8BB3F1),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ),
      if (compact) const SizedBox(height: 10),
      SizedBox(
        height: 48,
        child: OutlinedButton.icon(
          onPressed: onAdminLogin,
          icon: const Icon(Icons.admin_panel_settings_outlined, size: 20),
          label: const Text('Login Admin'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _maintenanceNavy,
            side: const BorderSide(color: Color(0xFF8AA7CD)),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ),
    ];
  }
}

class _SchoolBrand extends StatelessWidget {
  const _SchoolBrand({
    required this.logoAsset,
    required this.schoolName,
    required this.schoolSubtitle,
    required this.compact,
  });

  final String logoAsset;
  final String schoolName;
  final String schoolSubtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: compact ? 48 : 58,
          height: compact ? 48 : 58,
          child: Image.asset(
            logoAsset,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFFFF4D4),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school_rounded, color: Color(0xFFB88112)),
            ),
          ),
        ),
        const SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schoolName,
              style: TextStyle(
                color: _maintenanceNavy,
                fontSize: compact ? 16 : 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              schoolSubtitle,
              style: TextStyle(
                color: _maintenanceMuted,
                fontSize: compact ? 10 : 11.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Ilustrasi dibuat dari widget Material sehingga tidak membutuhkan asset
/// tambahan selain logo sekolah.
class _MaintenanceIllustration extends StatelessWidget {
  const _MaintenanceIllustration({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 235 : 345,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: compact ? 24 : 44,
            left: 5,
            child: const _DecorativeDots(),
          ),
          Positioned(
            right: 10,
            top: compact ? 28 : 38,
            child: const Icon(
              Icons.add_rounded,
              color: _maintenanceBlue,
              size: 19,
            ),
          ),
          Container(
            width: compact ? 250 : 330,
            height: compact ? 178 : 232,
            padding: EdgeInsets.only(top: compact ? 30 : 38),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: compact ? 188 : 240,
                  height: compact ? 132 : 168,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _maintenanceNavy,
                      width: compact ? 5 : 7,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: compact ? 23 : 29,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: const BoxDecoration(
                          color: _maintenanceNavy,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: const Row(
                          children: [
                            _WindowDot(color: Color(0xFF63A4FF)),
                            _WindowDot(color: Color(0xFFF3B931)),
                            _WindowDot(color: Colors.white),
                          ],
                        ),
                      ),
                      const Expanded(child: _SchoolBuilding()),
                    ],
                  ),
                ),
                Positioned(
                  left: compact ? 17 : 25,
                  bottom: compact ? 8 : 12,
                  child: Icon(
                    Icons.settings_rounded,
                    size: compact ? 62 : 82,
                    color: _maintenanceBlue,
                  ),
                ),
                Positioned(
                  right: compact ? 12 : 19,
                  bottom: compact ? 7 : 9,
                  child: Transform.rotate(
                    angle: -.48,
                    child: Icon(
                      Icons.build_rounded,
                      size: compact ? 62 : 84,
                      color: _maintenanceNavy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: compact ? 10 : 18,
            child: Container(
              width: compact ? 174 : 225,
              height: compact ? 34 : 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF5B82E),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BarrierStripe(),
                  _BarrierStripe(),
                  _BarrierStripe(),
                  _BarrierStripe(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SchoolBuilding extends StatelessWidget {
  const _SchoolBuilding();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_rounded,
            color: _maintenanceBlue,
            size: 48,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (_) => Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: const Color(0xFF91BDF8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _BarrierStripe extends StatelessWidget {
  const _BarrierStripe();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.5,
      child: Container(width: 13, height: 28, color: Colors.white),
    );
  }
}

class _DecorativeDots extends StatelessWidget {
  const _DecorativeDots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(
          16,
          (_) => Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFBAD5FA),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _MaintenanceBackground extends StatelessWidget {
  const _MaintenanceBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ColoredBox(color: Color(0xFFF7FAFE)),
        Positioned(
          top: -150,
          right: -130,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1463E8).withOpacity(.075),
              border: Border.all(
                color: const Color(0xFF1463E8).withOpacity(.16),
                width: 2,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -190,
          left: -170,
          child: Container(
            width: 420,
            height: 420,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1463E8).withOpacity(.065),
              border: Border.all(
                color: const Color(0xFF1463E8).withOpacity(.14),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
