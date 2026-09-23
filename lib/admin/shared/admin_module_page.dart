part of '../admin_dashboard_page.dart';

class AdminModulePage extends StatelessWidget {
  const AdminModulePage({super.key, required this.api, required this.module});
  final SmakApi api;
  final AdminModule module;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                module.title,
                style: const TextStyle(
                  color: Color(0xFF082E65),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openAdminEditor(context, api, module),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Data'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          module.description,
          style: const TextStyle(color: Color(0xFF60718A)),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: api.getTable(module.table),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final rows = snapshot.data ?? const <Map<String, dynamic>>[];
              if (rows.isEmpty) {
                return const Text('Belum ada data dari database.');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rows.length} data ditemukan',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  ...rows
                      .take(8)
                      .map(
                        (row) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.circle,
                            size: 9,
                            color: Color(0xFF0756C8),
                          ),
                          title: Text(
                            '${row['judul'] ?? row['nama'] ?? row['title'] ?? 'Data'}',
                          ),
                          subtitle: Text(
                            row.entries
                                .take(3)
                                .map((entry) => '${entry.key}: ${entry.value}')
                                .join(' • '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _openAdminEditor(
                                  context,
                                  api,
                                  module,
                                  row: row,
                                ),
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  color: Color(0xFF1463E8),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final id = (row['id'] as num?)?.toInt();
                                  if (id == null) return;
                                  await api.delete(module.table, id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Data berhasil dihapus. Buka ulang modul untuk melihat perubahan.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFFD92D20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
