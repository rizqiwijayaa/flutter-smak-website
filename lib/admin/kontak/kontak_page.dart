part of '../admin_dashboard_page.dart';

class AdminKontakPage extends StatefulWidget {
  const AdminKontakPage({super.key, required this.api, required this.module});

  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminKontakPage> createState() => _AdminKontakPageState();
}

class _AdminKontakPageState extends State<AdminKontakPage> {
  bool _loading = true;
  bool _saving = false;
  int? _id;

  final _nama = TextEditingController();
  final _alamat = TextEditingController();
  final _telepon = TextEditingController();
  final _email = TextEditingController();
  final _jam = TextEditingController();
  final _instagram = TextEditingController();
  final _facebook = TextEditingController();
  final _youtube = TextEditingController();
  final _maps = TextEditingController();
  final _contentFields = <String, TextEditingController>{
    'hero_gambar': TextEditingController(),
    'hero_judul': TextEditingController(),
    'hero_deskripsi': TextEditingController(),
    'form_judul': TextEditingController(),
    'maps_link': TextEditingController(),
    'maps_tombol': TextEditingController(text: 'Buka di Google Maps'),
    'lokasi_judul': TextEditingController(),
    'bantuan_judul': TextEditingController(),
    'bantuan_deskripsi': TextEditingController(),
    'bantuan_link': TextEditingController(),
    'bantuan_tombol': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nama.dispose();
    _alamat.dispose();
    _telepon.dispose();
    _email.dispose();
    _jam.dispose();
    _instagram.dispose();
    _facebook.dispose();
    _youtube.dispose();
    _maps.dispose();
    for (final c in _contentFields.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _s(dynamic value) => '${value ?? ''}'.trim();

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await widget.api.getTable('kontak', limit: 1);
      if (rows.isNotEmpty) {
        final row = rows.first;
        _id = int.tryParse(_s(row['id']));
        _nama.text = _s(row['nama_sekolah']);
        _alamat.text = _s(row['alamat']);
        _telepon.text = _s(row['telepon']);
        _email.text = _s(row['email']);
        _jam.text = _s(row['jam_operasional']);
        _instagram.text = _s(row['instagram']);
        _facebook.text = _s(row['facebook']);
        _youtube.text = _s(row['youtube']);
        _maps.text = _s(row['maps_embed']);
        for (final entry in _contentFields.entries) {
          entry.value.text = _s(row[entry.key]);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data kontak: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickHero() async {
    final input = html.FileUploadInputElement()
      ..accept = 'image/jpeg,image/png,image/webp';
    input.click();
    await input.onChange.first;
    if (input.files?.isEmpty ?? true) return;
    try {
      final name = await widget.api.uploadFile('kontak', input.files!.first);
      if (mounted) setState(() => _contentFields['hero_gambar']!.text = name);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gambar gagal diunggah.')));
    }
  }

  Future<void> _save() async {
    if (_nama.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama sekolah belum diisi.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final data = <String, dynamic>{
        'nama_sekolah': _nama.text.trim(),
        'alamat': _alamat.text.trim(),
        'telepon': _telepon.text.trim(),
        'email': _email.text.trim(),
        'jam_operasional': _jam.text.trim(),
        'instagram': _instagram.text.trim(),
        'facebook': _facebook.text.trim(),
        'youtube': _youtube.text.trim(),
        'maps_embed': _maps.text.trim(),
        for (final entry in _contentFields.entries)
          entry.key: entry.value.text.trim(),
      };

      await widget.api.save('kontak', data, id: _id);
      await websiteIdentityController.load(api: widget.api);
      await _load();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaturan kontak berhasil disimpan.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data kontak: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 18),
          _section(
            number: '0',
            title: 'Konten Halaman Kontak',
            note: 'Konten yang ditampilkan pada halaman Kontak.',
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(_contentFields['maps_tombol']!, 'Teks Tombol Maps', Icons.edit_outlined, maxLines: 1),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['hero_gambar']!,
                    'Gambar Hero',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['hero_judul']!,
                    'Judul Hero',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['hero_deskripsi']!,
                    'Deskripsi Hero',
                    Icons.edit_outlined,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['form_judul']!,
                    'Judul Form',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['maps_link']!,
                    'Link Peta',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['lokasi_judul']!,
                    'Judul Lokasi',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['bantuan_judul']!,
                    'Judul Bantuan',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['bantuan_deskripsi']!,
                    'Deskripsi Bantuan',
                    Icons.edit_outlined,
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['bantuan_link']!,
                    'Link Bantuan',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _field(
                    _contentFields['bantuan_tombol']!,
                    'Teks Tombol Bantuan',
                    Icons.edit_outlined,
                    maxLines: 1,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _pickHero,
                  icon: const Icon(Icons.upload),
                  label: const Text('Pilih Gambar Hero'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _section(
            number: '1',
            title: 'Informasi Sekolah',
            note: 'Informasi utama yang tampil pada kartu kontak di website.',
            child: Column(
              children: [
                _field(_nama, 'Nama Sekolah', Icons.school_outlined),
                const SizedBox(height: 14),
                _field(
                  _alamat,
                  'Alamat Sekolah',
                  Icons.location_on_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(
                        _telepon,
                        'Telepon / WhatsApp',
                        Icons.call_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _field(
                        _email,
                        'Email',
                        Icons.mail_outline_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _section(
            number: '2',
            title: 'Jam Operasional',
            note: 'Boleh ditulis beberapa baris sesuai jadwal sekolah.',
            child: _field(
              _jam,
              'Jam Operasional',
              Icons.schedule_outlined,
              maxLines: 4,
              hint:
                  'Senin - Jumat : 07.00 - 15.00 WIB\nSabtu : 07.00 - 12.00 WIB',
            ),
          ),
          const SizedBox(height: 18),
          _section(
            number: '3',
            title: 'Lokasi Sekolah',
            note:
                'Peta frontend tetap menggunakan OpenStreetMap tanpa API key. Kolom ini menyimpan link/embed lokasi untuk data sekolah.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  _maps,
                  'Link / Embed Peta',
                  Icons.map_outlined,
                  maxLines: 3,
                  hint: 'Tempel link atau embed lokasi sekolah',
                ),
                const SizedBox(height: 10),
                const _AdminKontakHint(
                  icon: Icons.info_outline_rounded,
                  text:
                      'Tidak perlu memasukkan Google Maps API key. Tombol dan peta pada frontend dapat tetap memakai link lokasi serta OpenStreetMap.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _section(
            number: '4',
            title: 'Media Sosial',
            note:
                'Kosongkan platform yang belum digunakan. Data kosong tidak perlu ditampilkan di frontend.',
            child: Column(
              children: [
                _field(
                  _instagram,
                  'Instagram',
                  Icons.camera_alt_outlined,
                  hint: 'https://instagram.com/...',
                ),
                const SizedBox(height: 14),
                _field(
                  _facebook,
                  'Facebook',
                  Icons.facebook_outlined,
                  hint: 'https://facebook.com/...',
                ),
                const SizedBox(height: 14),
                _field(
                  _youtube,
                  'YouTube',
                  Icons.play_circle_outline_rounded,
                  hint: 'https://youtube.com/...',
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _saveBar(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _blue.withOpacity(.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.contact_mail_outlined, color: _blue),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kontak',
                style: TextStyle(
                  color: _text,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kelola informasi kontak dan lokasi yang ditampilkan pada website.',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _openAdminPreview(context, const KontakPage()),
          icon: const Icon(Icons.visibility_outlined),
          label: const Text('Preview Halaman'),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Muat Ulang'),
        ),
      ],
    );
  }

  Widget _section({
    required String number,
    required String title,
    required String note,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      note,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    String? hint,
  }) {
    return AdminContentTextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1 ? Icon(icon, size: 20) : null,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: const Color(0xFFFBFCFE),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _blue, width: 1.4),
        ),
      ),
    );
  }

  Widget _saveBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Simpan perubahan untuk memperbarui data kontak sekolah.',
              style: TextStyle(color: _muted, fontSize: 13),
            ),
          ),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: _blue,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            ),
            icon: _saving
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 19),
            label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
          ),
        ],
      ),
    );
  }
}

class _AdminKontakHint extends StatelessWidget {
  const _AdminKontakHint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _blue.withOpacity(.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _blue.withOpacity(.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _blue, size: 18),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _muted,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
