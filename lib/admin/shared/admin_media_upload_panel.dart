part of '../admin_dashboard_page.dart';

/// Shared media surface for admin forms that are not using the Gallery editor.
class _AdminMediaUploadPanel extends StatelessWidget {
  const _AdminMediaUploadPanel({
    required this.title,
    required this.pickLabel,
    required this.emptyLabel,
    required this.onPick,
    this.preview,
    this.fileName = '',
    this.isDocument = false,
    this.onClear,
    this.onOpen,
    this.urlField,
  });

  final String title;
  final String pickLabel;
  final String emptyLabel;
  final String fileName;
  final bool isDocument;
  final VoidCallback onPick;
  final VoidCallback? onClear;
  final VoidCallback? onOpen;
  final Widget? preview;
  final Widget? urlField;

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName.trim().isNotEmpty;
    final displayName = hasFile
        ? fileName.trim().split('?').first.split('/').last
        : emptyLabel;
    final icon = isDocument ? Icons.description_outlined : Icons.cloud_upload_outlined;
    final mediaLabel = isDocument ? 'dokumen' : 'gambar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF123A75), fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        if (urlField != null) ...[urlField!, const SizedBox(height: 10)],
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 142,
            decoration: BoxDecoration(
              color: const Color(0xFFFBFDFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC9D7E8), width: 1.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF1463E8), size: 38),
                const SizedBox(height: 8),
                Text('Klik untuk memilih $mediaLabel', style: const TextStyle(color: Color(0xFF123A75), fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(isDocument ? 'PDF atau dokumen pendukung' : 'JPG, PNG, atau WEBP', style: const TextStyle(color: Color(0xFF6B7D99), fontSize: 11)),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onPick,
                  icon: Icon(isDocument ? Icons.upload_file_rounded : Icons.folder_open_rounded, size: 17),
                  label: Text(pickLabel),
                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF1463E8)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text('Preview', style: TextStyle(color: Color(0xFF123A75), fontSize: 13, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 96),
          padding: EdgeInsets.all(preview == null ? 12 : 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFFBFCFE),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD7E0EB)),
          ),
          child: preview ?? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isDocument ? Icons.insert_drive_file_outlined : Icons.image_outlined, color: const Color(0xFFB3C0CF), size: 30),
              const SizedBox(height: 6),
              Text(emptyLabel, style: const TextStyle(color: Color(0xFF6B7D99), fontSize: 11.5)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6B7D99), fontSize: 11.5)),
        if (hasFile) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: [
              if (onOpen != null) TextButton.icon(onPressed: onOpen, icon: const Icon(Icons.open_in_new_rounded, size: 16), label: const Text('Lihat File')),
              if (onClear != null) TextButton.icon(onPressed: onClear, icon: const Icon(Icons.delete_outline_rounded, size: 16), label: const Text('Hapus'), style: TextButton.styleFrom(foregroundColor: Colors.redAccent)),
            ],
          ),
        ],
      ],
    );
  }
}
