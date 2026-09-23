part of '../admin_dashboard_page.dart';

class AdminWebsiteLoginTab extends StatelessWidget {
  const AdminWebsiteLoginTab({
    super.key,
    required this.heroTitle,
    required this.heroDescription,
    required this.formTitle,
    required this.formSubtitle,
    required this.schoolSubtitle,
    required this.brandMessage,
    required this.api,
    required this.heroImage,
    required this.onPickHeroImage,
    required this.onRemoveHeroImage,
  });

  final TextEditingController heroTitle;
  final TextEditingController heroDescription;
  final TextEditingController formTitle;
  final TextEditingController formSubtitle;
  final TextEditingController schoolSubtitle;
  final TextEditingController brandMessage;
  final SmakApi api;
  final String heroImage;
  final VoidCallback onPickHeroImage;
  final VoidCallback onRemoveHeroImage;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final twoColumns = constraints.maxWidth >= 920;
      final gap = 14.0;
      final half = (constraints.maxWidth - gap) / 2;

      final heroCard = _SettingCard(
        title: 'Hero Login',
        child: Column(
          children: [
            _SettingField(
              label: 'Judul Hero',
              controller: heroTitle,
              maxLength: 60,
            ),
            _SettingField(
              label: 'Deskripsi Hero',
              controller: heroDescription,
              maxLength: 180,
              maxLines: 3,
            ),
            _LoginImageSetting(
              label: 'Banner Hero',
              filename: heroImage,
              api: api,
              onPick: onPickHeroImage,
              onRemove: onRemoveHeroImage,
              emptyText: 'Kosong = ilustrasi hero bawaan.',
            ),
          ],
        ),
      );

      final formCard = _SettingCard(
        title: 'Form Login',
        child: Column(
          children: [
            _SettingField(
              label: 'Judul Form',
              controller: formTitle,
              maxLength: 80,
            ),
            _SettingField(
              label: 'Subjudul Form',
              controller: formSubtitle,
              maxLength: 140,
              maxLines: 2,
            ),
            const _SmallInfo(
              text:
                  'Label email, password, tombol masuk, dan aksi lupa password tetap mengikuti sistem Login.',
            ),
          ],
        ),
      );

      final identityCard = _SettingCard(
        title: 'Panel Identitas',
        child: Column(
          children: [
            _SettingField(
              label: 'Subjudul Sekolah',
              controller: schoolSubtitle,
              maxLength: 100,
            ),
            _SettingField(
              label: 'Pesan / Tagline',
              controller: brandMessage,
              maxLength: 220,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const _SmallInfo(
              text: 'Logo dan nama sekolah otomatis mengikuti tab Identitas.',
            ),
          ],
        ),
      );

      if (!twoColumns) {
        return Column(
          children: [
            heroCard,
            const SizedBox(height: 14),
            formCard,
            const SizedBox(height: 14),
            identityCard,
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: half, child: heroCard),
              SizedBox(width: gap),
              SizedBox(width: half, child: formCard),
            ],
          ),
          const SizedBox(height: 14),
          identityCard,
        ],
      );
    },
  );
}

class _LoginImageSetting extends StatelessWidget {
  const _LoginImageSetting({
    required this.label,
    required this.filename,
    required this.api,
    required this.onPick,
    required this.onRemove,
    required this.emptyText,
  });

  final String label;
  final String filename;
  final SmakApi api;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final hasImage = filename.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _line),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 76,
                    height: 58,
                    color: const Color(0xFFEAF2FF),
                    child: hasImage
                        ? websiteContentImage(filename, fit: BoxFit.cover)
                        : const Icon(
                            Icons.image_outlined,
                            color: _blue,
                            size: 25,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasImage ? filename : 'Belum ada gambar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        hasImage
                            ? 'Klik ganti untuk memilih file lain.'
                            : emptyText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.upload_rounded, size: 16),
                  label: Text(hasImage ? 'Ganti' : 'Pilih'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                  ),
                ),
                if (hasImage) ...[
                  const SizedBox(width: 5),
                  IconButton(
                    tooltip: 'Hapus gambar',
                    onPressed: onRemove,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline_rounded, size: 19),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
