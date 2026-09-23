import 'dart:convert';

import 'package:flutter/material.dart';

import '../../services/website_identity.dart';
import '../site_chrome.dart';

class GaleriDetailPage extends StatelessWidget {
  const GaleriDetailPage({super.key, required this.gallery});

  final Map<String, dynamic> gallery;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    final title = '${gallery['judul'] ?? 'Galeri Kegiatan'}';
    final category = '${gallery['kategori'] ?? 'Kegiatan'}';
    final description =
        '${gallery['deskripsi'] ?? 'Dokumentasi kegiatan sekolah.'}';
    final date = _formatDate('${gallery['tanggal'] ?? ''}');
    final imageUrl = '${gallery['gambar'] ?? ''}'.trim();

    final albumPhotos = _albumPhotos(gallery);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SharedSmakNavigationBar(
              profilePages: {},
              academicPages: {},
              studentPages: {},
              initialActive: 'Galeri',
            ),
            _DetailHero(title: title, imageUrl: imageUrl),
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 18 : 78,
                28,
                compact ? 18 : 78,
                42,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Kembali ke Galeri'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0756C8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (compact)
                    Column(
                      children: [
                        _AboutCard(
                          title: title,
                          category: category,
                          date: date,
                          description: description,
                          photoCount: albumPhotos.length,
                        ),
                        const SizedBox(height: 24),
                        _PhotoContent(
                          title: title,
                          imageUrl: imageUrl,
                          photos: albumPhotos,
                        ),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 340,
                          child: _AboutCard(
                            title: title,
                            category: category,
                            date: date,
                            description: description,
                            photoCount: albumPhotos.length,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: _PhotoContent(
                            title: title,
                            imageUrl: imageUrl,
                            photos: albumPhotos,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SharedSmakFooter(
              profilePages: {},
              academicPages: {},
              studentPages: {},
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _albumPhotos(Map<String, dynamic> selected) {
    final photos = <Map<String, dynamic>>[selected];
    final raw = '${selected['gambar_lain'] ?? ''}'.trim();
    if (raw.isEmpty) return photos;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        for (final item in decoded) {
          final image = '$item'.trim();
          if (image.isNotEmpty) photos.add({'gambar': image});
        }
      }
    } catch (_) {
      // Galeri lama tetap aman walaupun belum memiliki format multi-foto.
    }
    return photos;
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 170,
    width: double.infinity,
    child: Stack(
      fit: StackFit.expand,
      children: [
        websiteContentImage(imageUrl, fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xF0062C64), Color(0xB0063F88)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 78),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Galeri Kegiatan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Beranda   ›   Galeri   ›   $title',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({
    required this.title,
    required this.category,
    required this.date,
    required this.description,
    required this.photoCount,
  });
  final String title;
  final String category;
  final String date;
  final String description;
  final int photoCount;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x100F172A),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tentang Kegiatan',
          style: TextStyle(
            color: Color(0xFF082E65),
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 20),
        _AboutRow(Icons.title_rounded, 'Judul', title),
        _AboutRow(Icons.sell_outlined, 'Kategori', category),
        _AboutRow(Icons.calendar_month_rounded, 'Tanggal', date),
        _AboutRow(
          Icons.photo_library_outlined,
          'Jumlah Foto',
          '$photoCount Foto',
        ),
        _AboutRow(Icons.edit_note_rounded, 'Deskripsi', description),
        const Divider(height: 30),
        const Text(
          'Bagikan Album',
          style: TextStyle(
            color: Color(0xFF082E65),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            _ShareButton(icon: Icons.facebook, color: Color(0xFF1263E5)),
            SizedBox(width: 10),
            _ShareButton(icon: Icons.chat_rounded, color: Color(0xFF19BA63)),
            SizedBox(width: 10),
            _ShareButton(icon: Icons.link_rounded, color: Color(0xFF35485F)),
          ],
        ),
      ],
    ),
  );
}

class _AboutRow extends StatelessWidget {
  const _AboutRow(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFEAF2FF),
          child: Icon(icon, color: const Color(0xFF0756C8), size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF082E65),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(color: Color(0xFF526178), height: 1.45),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PhotoContent extends StatelessWidget {
  const _PhotoContent({
    required this.title,
    required this.imageUrl,
    required this.photos,
  });
  final String title;
  final String imageUrl;
  final List<Map<String, dynamic>> photos;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF082E65),
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${photos.length} Foto  •  Dokumentasi kegiatan sekolah',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 2.25,
          child: websiteContentImage(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
      const SizedBox(height: 14),
      LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth > 800 ? 3 : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: photos.length > 1 ? photos.length - 1 : 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 1.38,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final photo = photos[index + 1];
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: websiteContentImage(
                  '${photo['gambar'] ?? ''}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          );
        },
      ),
    ],
  );
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 20,
    backgroundColor: color,
    child: Icon(icon, color: Colors.white, size: 20),
  );
}

String _formatDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value.isEmpty ? '-' : value;
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
