part of '../admin_dashboard_page.dart';

class AdminModuleCard extends StatelessWidget {
  const AdminModuleCard({super.key, required this.module, required this.onTap});
  final AdminModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2EAF4)),
        ),
        child: Row(
          children: [
            Icon(module.icon, color: const Color(0xFF0756C8), size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    module.title,
                    style: const TextStyle(
                      color: Color(0xFF082E65),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    module.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF60718A),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF8BA0B8),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminModule {
  const AdminModule(this.title, this.description, this.icon, this.table);
  final String title;
  final String description;
  final IconData icon;
  final String table;
}

