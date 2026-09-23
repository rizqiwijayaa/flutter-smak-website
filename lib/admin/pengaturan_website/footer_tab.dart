part of '../admin_dashboard_page.dart';

Map<String, String> _defaultFooterValues() => <String, String>{
  'slogan': 'Beriman • Berilmu • Berkarakter',
  'deskripsi': 'Membentuk generasi muda yang cerdas,\nberiman, dan siap berkarya bagi\nmasyarakat.',
  'whatsapp': '628155099445',
  'instagram': 'https://www.instagram.com/soegijapranata_lmj/',
  'alamat': 'V68H+JGC, Jogoyudan, Kec. Lumajang,\nKabupaten Lumajang, Jawa Timur 67315',
  'link_maps': 'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA',
  'telepon': '0815-5099-445',
  'provinsi': 'Jawa Timur',
  'hari_operasional': 'Senin - Jumat',
  'jam_operasional': '07.00 - 15.00 WIB',
  'motto': 'Ora et Labora',
  'arti_motto': 'Berdoa dan Bekerja',
};

class AdminWebsiteFooterTab extends StatefulWidget {
  const AdminWebsiteFooterTab({
    super.key,
    required this.initialValues,
    required this.onChanged,
  });

  final Map<String, String> initialValues;
  final ValueChanged<Map<String, String>> onChanged;

  @override
  State<AdminWebsiteFooterTab> createState() => _AdminWebsiteFooterTabState();
}

class _AdminWebsiteFooterTabState extends State<AdminWebsiteFooterTab> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final defaults = _defaultFooterValues();
    for (final key in defaults.keys) {
      _controllers[key] = TextEditingController(
        text: widget.initialValues[key] ?? defaults[key]!,
      );
    }
  }

  @override
  void didUpdateWidget(covariant AdminWebsiteFooterTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValues != widget.initialValues) {
      for (final entry in widget.initialValues.entries) {
        final controller = _controllers[entry.key];
        if (controller != null && controller.text != entry.value) {
          controller.text = entry.value;
        }
      }
    }
  }

  void _notify() {
    widget.onChanged({
      for (final entry in _controllers.entries) entry.key: entry.value.text.trim(),
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 820;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _footerHeader(),
              const SizedBox(height: 14),
              if (compact) ...[
                _brandCard(),
                const SizedBox(height: 14),
                _contactCard(),
                const SizedBox(height: 14),
                _hoursCard(),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _brandCard()),
                    const SizedBox(width: 14),
                    Expanded(child: _contactCard()),
                  ],
                ),
                const SizedBox(height: 14),
                _hoursCard(),
              ],
              const SizedBox(height: 14),
              _footerNote(),
            ],
          );
        },
      );

  Widget _footerHeader() => _FooterAdminCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: _blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.vertical_align_bottom_rounded,
                  color: Colors.white),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Footer Website',
                      style: TextStyle(
                          color: _text,
                          fontWeight: FontWeight.w800,
                          fontSize: 17)),
                  SizedBox(height: 5),
                  Text(
                    'Kelola informasi yang tampil pada footer global website sekolah.',
                    style: TextStyle(color: _muted, fontSize: 12.5, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _brandCard() => _FooterAdminCard(
        title: 'Identitas Footer',
        subtitle: 'Slogan dan deskripsi singkat sekolah.',
        child: Column(
          children: [
            _field('slogan', 'Slogan', hint: 'Beriman • Berilmu • Berkarakter'),
            const SizedBox(height: 14),
            _field('deskripsi', 'Deskripsi', maxLines: 4),
            const SizedBox(height: 14),
            _field('whatsapp', 'WhatsApp', hint: '628xxxxxxxxxx'),
            const SizedBox(height: 14),
            _field('instagram', 'Instagram', hint: 'https://instagram.com/...'),
          ],
        ),
      );

  Widget _contactCard() => _FooterAdminCard(
        title: 'Kontak Footer',
        subtitle: 'Alamat dan informasi kontak yang ditampilkan di footer.',
        child: Column(
          children: [
            _field('alamat', 'Alamat', maxLines: 4),
            const SizedBox(height: 14),
            _field('link_maps', 'Link Google Maps', hint: 'https://maps.app.goo.gl/...'),
            const SizedBox(height: 14),
            _field('telepon', 'Nomor Telepon'),
            const SizedBox(height: 14),
            _field('provinsi', 'Provinsi'),
          ],
        ),
      );

  Widget _hoursCard() => _FooterAdminCard(
        title: 'Jam Operasional & Motto',
        subtitle: 'Informasi waktu layanan dan motto sekolah.',
        child: Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _sizedField('hari_operasional', 'Hari Operasional'),
            _sizedField('jam_operasional', 'Jam Operasional'),
            _sizedField('motto', 'Motto'),
            _sizedField('arti_motto', 'Arti Motto'),
          ],
        ),
      );

  Widget _sizedField(String key, String label) => SizedBox(
        width: 330,
        child: _field(key, label),
      );

  Widget _field(String key, String label, {String? hint, int maxLines = 1}) =>
      AdminContentFormField(
        controller: _controllers[key],
        maxLines: maxLines,
        onChanged: (_) => _notify(),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: maxLines > 1,
          filled: true,
          fillColor: const Color(0xFFFBFCFE),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _line),
          ),
        ),
      );

  Widget _footerNote() => const _FooterAdminCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, color: _blue, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Logo, nama sekolah, warna footer, dan tahun copyright tetap mengikuti tab Identitas/Tampilan. Tautan Cepat mengikuti navigasi website dan tidak diedit dari sini.',
                style: TextStyle(color: _muted, fontSize: 12.5, height: 1.45),
              ),
            ),
          ],
        ),
      );
}

class _FooterAdminCard extends StatelessWidget {
  const _FooterAdminCard({this.title, this.subtitle, required this.child});
  final String? title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08082E65),
              blurRadius: 16,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!,
                  style: const TextStyle(
                      color: _text, fontWeight: FontWeight.w800, fontSize: 15)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!,
                    style: const TextStyle(color: _muted, fontSize: 11.5)),
              ],
              const SizedBox(height: 16),
            ],
            child,
          ],
        ),
      );
}
