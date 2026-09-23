import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import '../services/smak_api.dart';
import '../services/website_identity.dart';
import 'site_chrome.dart';

const _contactBlue = Color(0xFF0B57D0);
const _contactNavy = Color(0xFF0A2F66);
const _contactText = Color(0xFF123A73);
const _contactMuted = Color(0xFF5F718A);
const _contactBg = Color(0xFFF4F8FD);
const _contactLine = Color(0xFFE3EBF5);
const _defaultMapEmbed =
    'https://www.openstreetmap.org/export/embed.html?bbox=113.2245%2C-8.1365%2C113.2328%2C-8.1305&layer=mapnik&marker=-8.133488698715732%2C113.22867187116394';
const _defaultMapsLink = 'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA';

class KontakPage extends StatefulWidget {
  const KontakPage({super.key});

  @override
  State<KontakPage> createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  String _need = 'Informasi Umum';
  Map<String, dynamic> _content = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _loadContent().then((value) {
      if (mounted) setState(() => _content = value);
    });
  }

  Future<Map<String, dynamic>> _loadContent() async {
    try {
      final rows = await const SmakApi().getTable('kontak', limit: 1);
      return rows.isEmpty ? <String, dynamic>{} : rows.first;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pesan berhasil disiapkan. Silakan lanjutkan melalui WhatsApp atau email.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _contactBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SharedSmakNavigationBar(
              profilePages: {},
              academicPages: {},
              studentPages: {},
              initialActive: 'Kontak',
            ),
            _ContactHero(data: _content),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 980;
                      final form = _ContactFormCard(
                        data: _content,
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        messageController: _messageController,
                        need: _need,
                        onNeedChanged: (value) {
                          if (value != null) setState(() => _need = value);
                        },
                        onSubmit: _submit,
                      );
                      if (compact) {
                        return Column(
                          children: [
                            form,
                            const SizedBox(height: 18),
                            _ContactInfoColumn(data: _content),
                            const SizedBox(height: 18),
                            _ContactMapCard(data: _content),
                            const SizedBox(height: 18),
                            _ContactHelpCard(data: _content),
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                form,
                                const SizedBox(height: 18),
                                _ContactMapCard(data: _content),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                _ContactInfoColumn(data: _content),
                                const SizedBox(height: 18),
                                _ContactHelpCard(data: _content),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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
}

class _ContactHero extends StatelessWidget {
  const _ContactHero({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 960;
    final imagePath = _contactValue(data, 'hero_gambar', '');
    return Container(
      width: double.infinity,
      height: compact ? 240 : 210,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(imagePath, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _contactNavy,
                  _contactNavy.withOpacity(.9),
                  _contactNavy.withOpacity(.18),
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1220),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 20 : 24,
                      compact ? 26 : 24,
                      compact ? 20 : 24,
                      compact ? 30 : 24,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 420,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _contactValue(
                                data,
                                'breadcrumb',
                                'Beranda   ›   Kontak',
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              _contactValue(data, 'hero_judul', 'Hubungi Kami'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _contactValue(
                                data,
                                'hero_deskripsi',
                                'Kami siap membantu menjawab pertanyaan\ndan kebutuhan informasi Anda.',
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactFormCard extends StatelessWidget {
  const _ContactFormCard({
    required this.data,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.messageController,
    required this.need,
    required this.onNeedChanged,
    required this.onSubmit,
  });

  final Map<String, dynamic> data;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final String need;
  final ValueChanged<String?> onNeedChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 720;
    return _ContactPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _contactValue(data, 'form_judul', 'Kirim Pesan'),
            style: TextStyle(
              color: _contactText,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          if (compact) ...[
            _ContactField(
              label: 'Nama Lengkap',
              child: TextField(
                controller: nameController,
                decoration: _contactInput('Masukkan nama lengkap Anda'),
              ),
            ),
            const SizedBox(height: 14),
            _ContactField(
              label: 'Email',
              child: TextField(
                controller: emailController,
                decoration: _contactInput('Masukkan email Anda'),
              ),
            ),
            const SizedBox(height: 14),
            _ContactField(
              label: 'Nomor WhatsApp',
              child: TextField(
                controller: phoneController,
                decoration: _contactInput('08xxxxxxxxxx'),
              ),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: _ContactField(
                    label: 'Nama Lengkap',
                    child: TextField(
                      controller: nameController,
                      decoration: _contactInput('Masukkan nama lengkap Anda'),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ContactField(
                    label: 'Email',
                    child: TextField(
                      controller: emailController,
                      decoration: _contactInput('Masukkan email Anda'),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ContactField(
                    label: 'Nomor WhatsApp',
                    child: TextField(
                      controller: phoneController,
                      decoration: _contactInput('08xxxxxxxxxx'),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 14),
          _ContactField(
            label: 'Pilih Keperluan',
            child: DropdownButtonFormField<String>(
              initialValue: need,
              decoration: _contactInput('Pilih keperluan Anda'),
              items: const [
                DropdownMenuItem(
                  value: 'Informasi Umum',
                  child: Text('Informasi Umum'),
                ),
                DropdownMenuItem(value: 'PPDB', child: Text('PPDB')),
                DropdownMenuItem(
                  value: 'Kerja Sama',
                  child: Text('Kerja Sama'),
                ),
                DropdownMenuItem(
                  value: 'Layanan Siswa',
                  child: Text('Layanan Siswa'),
                ),
              ],
              onChanged: onNeedChanged,
            ),
          ),
          const SizedBox(height: 14),
          _ContactField(
            label: 'Pesan',
            child: TextField(
              controller: messageController,
              maxLines: 4,
              decoration: _contactInput('Tulis pesan Anda di sini...'),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('Kirim Pesan'),
            style: FilledButton.styleFrom(
              backgroundColor: _contactBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactField extends StatelessWidget {
  const _ContactField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _contactText,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ContactInfoColumn extends StatelessWidget {
  const _ContactInfoColumn({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactInfoCard(
          icon: Icons.location_on_rounded,
          title: 'Alamat Sekolah',
          lines: [
            _contactValue(data, 'nama_sekolah', 'SMAK Mgr. Soegijapranata'),
            _contactValue(data, 'alamat', 'Jl. Diponegoro No. 63, Lumajang'),
          ],
        ),
        const SizedBox(height: 14),
        _ContactInfoCard(
          icon: Icons.call_rounded,
          title: 'Telepon',
          lines: [_contactValue(data, 'telepon', '(0334) 890123')],
        ),
        const SizedBox(height: 14),
        _ContactInfoCard(
          icon: Icons.mail_rounded,
          title: 'Email',
          lines: [_contactValue(data, 'email', 'info@smaklumajang.sch.id')],
        ),
        const SizedBox(height: 14),
        _ContactInfoCard(
          icon: Icons.schedule_rounded,
          title: 'Jam Operasional',
          lines: _contactValue(
            data,
            'jam_operasional',
            'Senin - Jumat : 07.00 - 15.00 WIB\nSabtu : 07.00 - 12.00 WIB',
          ).split('\n'),
        ),
        const SizedBox(height: 14),
        _ContactSocialLinks(data: data),
      ],
    );
  }
}

class _ContactSocialLinks extends StatelessWidget {
  const _ContactSocialLinks({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final links = [
      (
        Icons.camera_alt_outlined,
        'Instagram',
        '${data['instagram'] ?? ''}'.trim(),
      ),
      (Icons.facebook_outlined, 'Facebook', '${data['facebook'] ?? ''}'.trim()),
      (
        Icons.play_circle_outline_rounded,
        'YouTube',
        '${data['youtube'] ?? ''}'.trim(),
      ),
    ].where((item) => item.$3.isNotEmpty).toList();
    if (links.isEmpty) return const SizedBox.shrink();
    return _ContactPanel(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final link in links)
            OutlinedButton.icon(
              onPressed: () => openSharedLink(link.$3),
              icon: Icon(link.$1),
              label: Text(link.$2),
            ),
        ],
      ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  const _ContactInfoCard({
    required this.icon,
    required this.title,
    required this.lines,
  });

  final IconData icon;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return _ContactPanel(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _contactBlue, size: 31),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _contactText,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                ...lines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      line,
                      style: const TextStyle(
                        color: _contactMuted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactMapCard extends StatefulWidget {
  const _ContactMapCard({required this.data});

  final Map<String, dynamic> data;

  @override
  State<_ContactMapCard> createState() => _ContactMapCardState();
}

class _ContactMapCardState extends State<_ContactMapCard> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'smak-osm-map-${identityHashCode(this)}';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = _contactValue(widget.data, 'maps_embed', _defaultMapEmbed)
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..setAttribute('loading', 'lazy')
        ..setAttribute('title', 'Lokasi SMAK Mgr. Soegijapranata');
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ContactPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _contactValue(
              widget.data,
              'lokasi_judul',
              'Lokasi SMAK Mgr. Soegijapranata',
            ),
            style: TextStyle(
              color: _contactText,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF6F8FB),
              border: Border.all(color: _contactLine),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: HtmlElementView(viewType: _viewType),
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => openSharedLink(
              _contactValue(widget.data, 'maps_link', _defaultMapsLink),
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(_contactValue(widget.data, 'maps_tombol', 'Buka di Google Maps')),
            style: OutlinedButton.styleFrom(
              foregroundColor: _contactBlue,
              side: const BorderSide(color: _contactBlue),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactHelpCard extends StatelessWidget {
  const _ContactHelpCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1263E5), Color(0xFF0A49B4)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _contactValue(data, 'bantuan_judul', 'Butuh Jawaban Cepat?'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _contactValue(
              data,
              'bantuan_deskripsi',
              'Hubungi kami langsung melalui WhatsApp untuk mendapatkan respon lebih cepat.',
            ),
            style: TextStyle(
              color: Color(0xFFE4EDFF),
              fontSize: 14,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () => openSharedLink(
              _contactValue(data, 'bantuan_link', 'https://wa.me/628155099445'),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1A9E44),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  'https://img.icons8.com/color/48/whatsapp--v1.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.phone_in_talk_rounded,
                    size: 18,
                    color: Color(0xFF1A9E44),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _contactValue(data, 'bantuan_tombol', 'Hubungi via WhatsApp'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

String _contactValue(Map<String, dynamic> data, String key, String fallback) {
  final value = '${data[key] ?? ''}'.trim();
  return value.isEmpty ? fallback : value;
}

class _ContactPanel extends StatelessWidget {
  const _ContactPanel({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _contactLine),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

InputDecoration _contactInput(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF97A5B7), fontSize: 13),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _contactLine),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _contactBlue, width: 1.3),
    ),
  );
}
