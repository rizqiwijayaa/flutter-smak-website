part of '../admin_dashboard_page.dart';

class AdminTopBar extends StatelessWidget {
  const AdminTopBar({
    super.key,
    required this.onMenu,
    required this.adminName,
    required this.adminPhotoUrl,
    this.showMenuButton = false,
  });

  final VoidCallback onMenu;
  final String adminName;
  final String adminPhotoUrl;
  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: showMenuButton ? 14 : 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_navy, Color(0xFF0A3E7C)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x18052A56),
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showMenuButton) ...[
            IconButton(
              tooltip: 'Buka menu',
              onPressed: onMenu,
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Image.asset(
            'assets/images/logo_sekolah.png',
            width: 42,
            height: 42,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const SizedBox(
              width: 42,
              height: 42,
              child: Icon(Icons.school_rounded, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SMAK Mgr. Soegijapranata',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Dashboard Admin',
                style: TextStyle(
                  color: Color(0xFFD4E4F7),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 19,
            backgroundColor: const Color(0xFFEAF2FF),
            child: ClipOval(
              child: adminPhotoUrl.isEmpty
                  ? const Icon(Icons.person_rounded, color: _navy, size: 25)
                  : websiteContentImage(
                      adminPhotoUrl,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 10),
          if (MediaQuery.sizeOf(context).width >= 560) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adminName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
                const Text(
                  'Admin',
                  style: TextStyle(color: Color(0xFFD4E4F7), fontSize: 9.5),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
