part of '../admin_dashboard_page.dart';

class AdminKalenderAkademikPage extends StatefulWidget {
  const AdminKalenderAkademikPage({
    super.key,
    required this.api,
    required this.module,
  });
  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminKalenderAkademikPage> createState() =>
      _AdminKalenderAkademikPageState();
}

class _AdminKalenderAkademikPageState extends State<AdminKalenderAkademikPage> {
  final _heroTitle = TextEditingController(text: 'Kalender Akademik');
  final _heroSubtitle = TextEditingController(
    text: 'Agenda dan kegiatan penting SMAK selama tahun ajaran.',
  );
  final _heroImage = TextEditingController();
  final _pageTitle = TextEditingController(text: 'Kalender Akademik');
  final _pageSubtitle = TextEditingController(
    text:
        'Temukan jadwal kegiatan sekolah, ujian, libur, dan agenda penting lainnya.',
  );
  final _updatedAt = TextEditingController(text: '10 Agustus 2026');
  final _infoText = TextEditingController(
    text:
        'Tanggal dan jadwal dapat berubah sewaktu-waktu sesuai kebijakan sekolah atau kondisi tertentu. Pastikan selalu memantau pembaruan resmi dari pihak sekolah.',
  );
  final _reminderText = TextEditingController(
    text:
        'Pantau pembaruan kalender secara berkala agar tidak melewatkan kegiatan penting.',
  );
  final _pdfUrl = TextEditingController();
  final _downloadButton = TextEditingController(text: 'Unduh Kalender PDF');
  final _contactButton = TextEditingController(text: 'Hubungi Sekolah');

  late List<Map<String, dynamic>> _events;
  int? _mainId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _events = [
      _event(
        '2026-07-13',
        'Masa Pengenalan Lingkungan Sekolah (MPLS)',
        'MPLS',
        'Lingkungan sekolah',
        'Akademik',
      ),
      _event(
        '2026-08-03',
        'Awal Tahun Ajaran',
        'Awal Tahun Ajaran',
        'Kegiatan Sekolah',
        'Akademik',
      ),
      _event(
        '2026-08-08',
        'Pertemuan Orang Tua',
        'Pertemuan Orang Tua',
        'Aula',
        'Kegiatan Sekolah',
      ),
      _event(
        '2026-08-17',
        'Upacara Kemerdekaan',
        'Hari Kemerdekaan',
        'Lapangan',
        'Libur Nasional',
      ),
      _event(
        '2026-08-24',
        'Penilaian Tengah Semester',
        'PTS',
        'Kelas',
        'Ujian/Penilaian',
      ),
      _event(
        '2026-08-31',
        'Rekoleksi Siswa',
        'Rekoleksi',
        'Aula',
        'Kegiatan Sekolah',
      ),
      _event(
        '2026-09-14',
        'Penilaian Tengah Semester (PTS)',
        'PTS Ganjil',
        'Ruang kelas',
        'Ujian/Penilaian',
      ),
      _event(
        '2026-10-26',
        'Retret dan Rekoleksi Siswa',
        'Retret',
        'Rumah retret',
        'Kegiatan Sekolah',
      ),
      _event(
        '2026-11-10',
        'Upacara Hari Pahlawan',
        'Hari Pahlawan',
        'Lapangan',
        'Kegiatan Sekolah',
      ),
      _event(
        '2026-12-07',
        'Penilaian Akhir Semester (PAS)',
        'PAS',
        'Ruang kelas',
        'Ujian/Penilaian',
      ),
      _event(
        '2026-12-18',
        'Pembagian Rapor Semester Ganjil',
        'Pembagian Rapor',
        'Ruang kelas',
        'Akademik',
      ),
      _event(
        '2027-01-04',
        'Awal Semester Genap',
        'Semester Genap',
        'Sekolah',
        'Akademik',
      ),
      _event(
        '2027-02-13',
        'Kegiatan Bakti Sosial',
        'Bakti Sosial',
        'Masyarakat',
        'Kegiatan Sekolah',
      ),
      _event(
        '2027-03-08',
        'Penilaian Tengah Semester Genap',
        'PTS Genap',
        'Ruang kelas',
        'Ujian/Penilaian',
      ),
      _event(
        '2027-04-02',
        'Libur Jumat Agung',
        'Jumat Agung',
        'Libur sekolah',
        'Libur Nasional',
      ),
      _event(
        '2027-05-10',
        'Ujian Sekolah Kelas XII',
        'Ujian Sekolah',
        'Ruang kelas',
        'Ujian/Penilaian',
      ),
      _event(
        '2027-06-14',
        'Penilaian Akhir Tahun',
        'PAT',
        'Ruang kelas',
        'Ujian/Penilaian',
      ),
    ];
    _loadDatabase();
  }

  String _s(dynamic value) => '${value ?? ''}'.trim();

  Future<void> _loadDatabase() async {
    try {
      final result = await Future.wait([widget.api.getTable('kalender_utama', limit: 1), widget.api.getTable('kalender_agenda', limit: 100)]);
      if (result[0].isNotEmpty) {
        final row = result[0].first;
        final data = jsonDecode(_s(row['data_json']));
        if (data is Map) {
          _mainId = int.tryParse(_s(row['id']));
          final hero = data['hero'] as Map? ?? const {}; final intro = data['pengantar'] as Map? ?? const {};
          _heroTitle.text = _s(hero['judul']).isEmpty ? _heroTitle.text : _s(hero['judul']); _heroSubtitle.text = _s(hero['deskripsi']).isEmpty ? _heroSubtitle.text : _s(hero['deskripsi']); _heroImage.text = _s(hero['gambar']);
          _pageTitle.text = _s(intro['judul']).isEmpty ? _pageTitle.text : _s(intro['judul']); _pageSubtitle.text = _s(intro['deskripsi']).isEmpty ? _pageSubtitle.text : _s(intro['deskripsi']);
          _updatedAt.text = _s(data['diperbarui']).isEmpty ? _updatedAt.text : _s(data['diperbarui']); _infoText.text = _s(data['informasi']).isEmpty ? _infoText.text : _s(data['informasi']); _reminderText.text = _s(data['pengingat']).isEmpty ? _reminderText.text : _s(data['pengingat']); _pdfUrl.text = _s(data['pdf_url']);
          if (_s(data['teks_tombol_unduh']).isNotEmpty) _downloadButton.text = _s(data['teks_tombol_unduh']);
          if (_s(data['teks_tombol_kontak']).isNotEmpty) _contactButton.text = _s(data['teks_tombol_kontak']);
        }
      }
      if (result[1].isNotEmpty) _events = result[1].map((row) => Map<String, dynamic>.from(row)).toList();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _saveDatabase() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final data = {'hero': {'judul': _heroTitle.text.trim(), 'deskripsi': _heroSubtitle.text.trim(), 'gambar': _heroImage.text.trim()}, 'pengantar': {'judul': _pageTitle.text.trim(), 'deskripsi': _pageSubtitle.text.trim()}, 'diperbarui': _updatedAt.text.trim(), 'informasi': _infoText.text.trim(), 'pengingat': _reminderText.text.trim(), 'pdf_url': _pdfUrl.text.trim(), 'teks_tombol_unduh': _downloadButton.text.trim(), 'teks_tombol_kontak': _contactButton.text.trim()};
      await widget.api.save('kalender_utama', {'judul': _heroTitle.text.trim(), 'data_json': jsonEncode(data), 'status': 'aktif'}, id: _mainId);
      final existing = await widget.api.getTable('kalender_agenda', limit: 100);
      for (final row in existing) { final id = int.tryParse(_s(row['id'])); if (id != null) await widget.api.delete('kalender_agenda', id); }
      for (var i = 0; i < _events.length; i++) { final e = _events[i]; await widget.api.save('kalender_agenda', {'tanggal': _s(e['tanggal']), 'judul': _s(e['judul']), 'judul_pendek': _s(e['judul_pendek']), 'lokasi': _s(e['lokasi']), 'kategori': _s(e['kategori']), 'urutan': i, 'status': 'aktif'}); }
      await _loadDatabase(); if (mounted) _toast('Perubahan Kalender Akademik berhasil disimpan.');
    } catch (e) { if (mounted) _toast('Gagal menyimpan: $e'); }
    if (mounted) setState(() => _saving = false);
  }

  Map<String, dynamic> _event(
    String date,
    String title,
    String shortTitle,
    String location,
    String type,
  ) => {
    'tanggal': date,
    'judul': title,
    'judul_pendek': shortTitle,
    'lokasi': location,
    'kategori': type,
  };

  @override
  void dispose() {
    for (final c in [
      _heroTitle,
      _heroSubtitle,
      _heroImage,
      _pageTitle,
      _pageSubtitle,
      _updatedAt,
      _infoText,
      _reminderText,
      _pdfUrl,
      _downloadButton,
      _contactButton,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _pickHeroImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    final file = input.files!.first;
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;
    if (!mounted) return;
    setState(() => _heroImage.text = '${reader.result ?? ''}');
  }

  Future<void> _pickPdf() async {
    final input = html.FileUploadInputElement()..accept = '.pdf,application/pdf';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    try {
      final filename = await widget.api.uploadFile('kalender_utama', input.files!.first);
      if (mounted) setState(() => _pdfUrl.text = filename);
    } catch (error) {
      if (mounted) _toast('Gagal mengunggah PDF: $error');
    }
  }

  String _documentUrl(String value) => widget.api.getFileUrl(value.trim());

  String _documentName(String value) {
    final path = value.trim();
    return path.isEmpty ? 'Belum ada file dipilih' : path.split('?').first.split('/').last;
  }

  Widget _pdfActions() => ValueListenableBuilder<TextEditingValue>(
    valueListenable: _pdfUrl,
    builder: (_, __, ___) => _AdminMediaUploadPanel(
      title: 'Dokumen Kalender PDF',
      pickLabel: _pdfUrl.text.trim().isEmpty ? 'Pilih PDF' : 'Ganti PDF',
      emptyLabel: 'Belum ada PDF dipilih',
      fileName: _pdfUrl.text.trim(),
      isDocument: true,
      onPick: _pickPdf,
      onOpen: () => html.window.open(_documentUrl(_pdfUrl.text), '_blank'),
      onClear: () => setState(_pdfUrl.clear),
    ),
  );

  Widget _imagePreview(String raw) {
    final value = raw.trim();
    if (value.isEmpty)
      return const Center(
        child: Icon(Icons.image_outlined, size: 62, color: Color(0xFF9AAAC0)),
      );
    final Widget image = websiteContentImage(value, fit: BoxFit.cover);
    return SizedBox.expand(child: image);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 24),
          _section(
            1,
            'Banner / Hero Kalender Akademik',
            'Atur gambar dan teks utama yang tampil paling atas pada halaman Kalender Akademik.',
            _heroEditor(),
          ),
          _section(
            2,
            'Pengantar Halaman',
            'Judul dan deskripsi sebelum area filter kalender.',
            _introEditor(),
          ),
          _section(
            3,
            'Informasi Kalender',
            'Informasi pembaruan kalender dan file PDF resmi sekolah.',
            _calendarSettings(),
          ),
          _section(
            4,
            'Agenda Kalender Akademik',
            'Tambah, edit, atau hapus agenda. Kartu di bawah mengikuti data yang akan tampil pada kalender frontend.',
            _eventManager(),
          ),
          _section(
            5,
            'Informasi & Pengingat',
            'Atur keterangan perubahan jadwal dan pesan pengingat di bagian bawah halaman.',
            _bottomEditor(),
          ),
        ],
      ),
    );
  }

  Widget _header() => LayoutBuilder(
    builder: (context, c) {
      final compact = c.maxWidth < 720;
      final title = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kalender Akademik',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: _text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kelola banner, agenda, kategori, informasi kalender, dan file kalender sekolah.',
            style: TextStyle(color: _muted, fontSize: 14),
          ),
        ],
      );
      final actions = Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          OutlinedButton.icon(
            onPressed: () => _openAdminPreview(context, sharedAcademicPages()['kalender']!),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Preview Halaman'),
          ),
          ElevatedButton.icon(
            onPressed: _saving ? null : _saveDatabase,
            icon: const Icon(Icons.save_rounded),
            label: Text(_saving ? 'Menyimpan...' : 'Simpan Perubahan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
      return compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [title, const SizedBox(height: 16), actions],
            )
          : Row(
              children: [
                Expanded(child: title),
                actions,
              ],
            );
    },
  );

  Widget _section(int number, String title, String subtitle, Widget child) =>
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 22),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D082F63),
              blurRadius: 20,
              offset: Offset(0, 8),
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
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(color: _muted, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            child,
          ],
        ),
      );

  Widget _heroEditor() => LayoutBuilder(
    builder: (context, c) {
      final preview = _AdminMediaUploadPanel(
        title: 'Gambar Hero Kalender',
        pickLabel: _heroImage.text.trim().isEmpty ? 'Pilih Gambar' : 'Ganti Gambar',
        emptyLabel: 'Belum ada gambar hero dipilih',
        fileName: _heroImage.text.trim(),
        onPick: _pickHeroImage,
        onClear: () => setState(_heroImage.clear),
        preview: SizedBox(
          height: 190,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _imagePreview(_heroImage.text),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xC9073979), Color(0x22073979)]))),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_heroTitle.text.isEmpty ? 'Kalender Akademik' : _heroTitle.text, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(_heroSubtitle.text, style: const TextStyle(color: Colors.white, height: 1.4)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      final fields = Column(
        children: [
          _field('Judul Hero', _heroTitle, onChanged: (_) => setState(() {})),
          const SizedBox(height: 14),
          _field(
            'Subtitle Hero',
            _heroSubtitle,
            lines: 3,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          _field(
            'Sumber / Nama File Banner',
            _heroImage,
            onChanged: (_) => setState(() {}),
          ),
        ],
      );

      return c.maxWidth < 900
          ? Column(children: [preview, const SizedBox(height: 18), fields])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: preview),
                const SizedBox(width: 22),
                Expanded(flex: 6, child: fields),
              ],
            );
    },
  );

  Widget _introEditor() => Column(
    children: [
      _field('Judul Halaman', _pageTitle),
      const SizedBox(height: 14),
      _field('Deskripsi', _pageSubtitle, lines: 3),
    ],
  );

  Widget _calendarSettings() => LayoutBuilder(
    builder: (context, c) {
      final a = _field('Terakhir Diperbarui', _updatedAt);
      final b = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field('URL / File Kalender PDF', _pdfUrl, hint: 'URL eksternal atau file PDF yang di-upload'),
          const SizedBox(height: 10),
          _pdfActions(),
        ],
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          c.maxWidth < 760
              ? Column(children: [a, const SizedBox(height: 14), b])
              : Row(
                  children: [
                    Expanded(child: a),
                    const SizedBox(width: 16),
                    Expanded(child: b),
                  ],
                ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: _blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tahun ajaran dan semester pada frontend tetap dinamis. Agenda ditentukan dari tanggal masing-masing data.',
                    style: TextStyle(color: _text, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );

  Widget _eventManager() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: () => _editEvent(null),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Agenda'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _blue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final width = c.maxWidth < 680
              ? c.maxWidth
              : (c.maxWidth < 1050
                    ? (c.maxWidth - 14) / 2
                    : (c.maxWidth - 28) / 3);
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              for (int i = 0; i < _events.length; i++)
                SizedBox(width: width, child: _eventCard(i)),
            ],
          );
        },
      ),
    ],
  );

  Widget _eventCard(int index) {
    final e = _events[index];
    final category = '${e['kategori']}';
    final icon = category == 'Ujian/Penilaian'
        ? Icons.fact_check_rounded
        : category == 'Libur Nasional'
        ? Icons.beach_access_rounded
        : category == 'Kegiatan Sekolah'
        ? Icons.groups_rounded
        : Icons.school_rounded;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _blue),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') _editEvent(index);
                  if (v == 'delete') setState(() => _events.removeAt(index));
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${e['tanggal']}',
            style: const TextStyle(color: _blue, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '${e['judul']}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text('${e['lokasi']}', style: const TextStyle(color: _muted)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6FA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editEvent(int? index) async {
    final source = index == null ? null : _events[index];
    final date = TextEditingController(text: '${source?['tanggal'] ?? ''}');
    final title = TextEditingController(text: '${source?['judul'] ?? ''}');
    final shortTitle = TextEditingController(
      text: '${source?['judul_pendek'] ?? ''}',
    );
    final location = TextEditingController(text: '${source?['lokasi'] ?? ''}');
    String category = '${source?['kategori'] ?? 'Akademik'}';
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(index == null ? 'Tambah Agenda' : 'Edit Agenda'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _field('Tanggal', date, hint: 'YYYY-MM-DD'),
                  const SizedBox(height: 12),
                  _field('Judul Agenda', title),
                  const SizedBox(height: 12),
                  _field('Judul Pendek', shortTitle),
                  const SizedBox(height: 12),
                  _field('Lokasi', location),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        const [
                              'Akademik',
                              'Kegiatan Sekolah',
                              'Ujian/Penilaian',
                              'Libur Nasional',
                            ]
                            .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            )
                            .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => category = v);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (date.text.trim().isEmpty || title.text.trim().isEmpty)
                  return;
                Navigator.pop(
                  dialogContext,
                  _event(
                    date.text.trim(),
                    title.text.trim(),
                    shortTitle.text.trim(),
                    location.text.trim(),
                    category,
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    date.dispose();
    title.dispose();
    shortTitle.dispose();
    location.dispose();
    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _events.add(result);
        _events.sort((a, b) => '${a['tanggal']}'.compareTo('${b['tanggal']}'));
      } else {
        _events[index] = result;
      }
    });
  }

  Widget _bottomEditor() => Column(
    children: [
      _field('Teks Informasi Kalender', _infoText, lines: 4),
      const SizedBox(height: 14),
      _field('Teks Pengingat', _reminderText, lines: 3),
      const SizedBox(height: 12),
      _field('Teks Tombol Unduh', _downloadButton),
      const SizedBox(height: 12),
      _field('Teks Tombol Kontak', _contactButton),
    ],
  );

  Widget _field(
    String label,
    TextEditingController controller, {
    int lines = 1,
    String? hint,
    ValueChanged<String>? onChanged,
  }) => AdminContentTextField(
    controller: controller,
    maxLines: lines,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: lines > 1,
      filled: true,
      fillColor: const Color(0xFFF9FBFE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _line),
      ),
    ),
  );
}
