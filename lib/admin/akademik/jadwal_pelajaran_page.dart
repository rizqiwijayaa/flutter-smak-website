part of '../admin_dashboard_page.dart';

class AdminJadwalPelajaranPage extends StatefulWidget {
  const AdminJadwalPelajaranPage({
    super.key,
    required this.api,
    required this.module,
  });

  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminJadwalPelajaranPage> createState() =>
      _AdminJadwalPelajaranPageState();
}

class _AdminJadwalPelajaranPageState extends State<AdminJadwalPelajaranPage> {
  final _heroTitle = TextEditingController(text: 'Jadwal Pelajaran');
  final _heroSubtitle = TextEditingController(
    text:
        'Informasi jadwal kegiatan belajar mengajar SMAK Mgr. Soegijapranata.',
  );
  final _heroImage = TextEditingController(text: 'assets/images/1030.JPG');
  final _pageTitle = TextEditingController(text: 'Jadwal Pelajaran');
  final _pageSubtitle = TextEditingController(
    text:
        'Pilih tahun ajaran, tingkat, dan kelas untuk melihat jadwal pelajaran.',
  );
  final _infoText = TextEditingController(
    text:
        'Perubahan jadwal pelajaran akan diinformasikan oleh wali kelas melalui pengumuman resmi sekolah. Pastikan untuk selalu memeriksa informasi terbaru.',
  );
  final _reminderText = TextEditingController(
    text:
        'Pastikan selalu memeriksa pembaruan jadwal sebelum kegiatan belajar dimulai.',
  );
  final _pdfUrl = TextEditingController();

  String _year = '2026/2027';
  String _semester = 'Semester Ganjil';
  String _level = 'Kelas X';
  String _className = 'X-A';
  String _day = 'Senin';
  final _homeroom = TextEditingController(text: 'Maria Magdalena, S.Pd.');
  final _updatedAt = TextEditingController(text: '10 Agustus 2026');
  final _schoolStart = TextEditingController(text: '07.00 WIB');
  final _break1 = TextEditingController(text: '09.15 WIB');
  final _break2 = TextEditingController(text: '11.45 WIB');
  final _finish = TextEditingController(text: '13.00 WIB');
  int? _contentId;
  bool _loading = true;

  final List<String> _years = ['2026/2027', '2025/2026', '2024/2025'];
  final List<String> _levels = ['Kelas X', 'Kelas XI', 'Kelas XII'];
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  final Map<String, List<String>> _classes = {
    'Kelas X': ['X-A', 'X-B'],
    'Kelas XI': ['XI-A', 'XI-B'],
    'Kelas XII': ['XII-A', 'XII-B'],
  };

  late List<Map<String, dynamic>> _lessons;

  @override
  void initState() {
    super.initState();
    _lessons = [
      _lesson(
        'Senin',
        '1',
        '07.00-07.45',
        'Pendidikan Agama',
        'Y. Daniel, S.Pd.',
        'X-A',
      ),
      _lesson(
        'Senin',
        '2',
        '07.45-08.30',
        'Matematika',
        'Antonius W., S.Pd.',
        'X-A',
      ),
      _lesson(
        'Senin',
        '3',
        '08.30-09.15',
        'Bahasa Indonesia',
        'Maria Cecilia, S.Pd.',
        'X-A',
      ),
      _lesson(
        'Senin',
        'Istirahat',
        '09.15-09.30',
        'Waktu istirahat peserta didik',
        '-',
        '-',
        isBreak: true,
      ),
      _lesson(
        'Senin',
        '4',
        '09.30-10.15',
        'Fisika',
        'Fransiskus D., S.Si.',
        'Lab IPA',
      ),
      _lesson(
        'Senin',
        '5',
        '10.15-11.00',
        'Bahasa Inggris',
        'Theresia Indah, S.Pd.',
        'X-A',
      ),
      _lesson(
        'Senin',
        '6',
        '11.00-11.45',
        'Informatika',
        'Agnes Viviana, S.Kom.',
        'Lab Komputer',
      ),
      _lesson(
        'Senin',
        'Istirahat',
        '11.45-12.15',
        'Waktu istirahat peserta didik',
        '-',
        '-',
        isBreak: true,
      ),
      _lesson(
        'Senin',
        '7',
        '12.15-13.00',
        'PJOK',
        'Yohanes Daniel, S.Pd.',
        'Lapangan',
      ),
      _lesson(
        'Selasa',
        '1',
        '07.00-07.45',
        'Biologi',
        'Sr. Natalia, S.Pd.',
        'Lab IPA',
      ),
      _lesson(
        'Selasa',
        '2',
        '07.45-08.30',
        'Matematika',
        'Antonius W., S.Pd.',
        'X-A',
      ),
      _lesson(
        'Rabu',
        '1',
        '07.00-07.45',
        'Kimia',
        'Paulus K., S.Si.',
        'Lab IPA',
      ),
      _lesson(
        'Kamis',
        '1',
        '07.00-07.45',
        'Bahasa Inggris',
        'Theresia Indah, S.Pd.',
        'X-A',
      ),
      _lesson(
        'Jumat',
        '1',
        '07.00-07.45',
        'Doa Pagi dan Refleksi',
        'Wali Kelas',
        'X-A',
      ),
    ];
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      final results = await Future.wait([
        widget.api.getTable('jadwal_konten'),
        widget.api.getTable('jadwal_pelajaran', limit: 1000),
      ]);
      final contentRows = results[0];
      final lessonRows = results[1];
      if (!mounted) return;

      setState(() {
        if (contentRows.isNotEmpty) {
          final row = contentRows.first;
          _contentId = int.tryParse('${row['id'] ?? ''}');
          final content = _decodeContent(row['data_json']);
          _heroTitle.text = content['hero_title'] ?? _heroTitle.text;
          _heroSubtitle.text = content['hero_subtitle'] ?? _heroSubtitle.text;
          _heroImage.text = content['hero_image'] ?? _heroImage.text;
          _pageTitle.text = content['page_title'] ?? _pageTitle.text;
          _pageSubtitle.text = content['page_subtitle'] ?? _pageSubtitle.text;
          _infoText.text = content['information_text'] ?? _infoText.text;
          _reminderText.text = content['reminder_text'] ?? _reminderText.text;
          _pdfUrl.text = content['pdf_url'] ?? _pdfUrl.text;
        }
        if (lessonRows.isNotEmpty) {
          _lessons = lessonRows.map((row) => Map<String, dynamic>.from(row)).toList();
          _syncSelectedScheduleDetails();
        }
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      _toast('Data database belum dapat dimuat. Menampilkan data cadangan.');
    }
  }

  Map<String, String> _decodeContent(dynamic raw) {
    try {
      final decoded = jsonDecode('${raw ?? '{}'}');
      if (decoded is Map<String, dynamic>) {
        return decoded.map((key, value) => MapEntry(key, '${value ?? ''}'));
      }
    } catch (_) {}
    return const {};
  }

  List<Map<String, dynamic>> get _selectedLessons => _lessons
      .where(
        (row) =>
            row['tahun_ajaran'] == _year &&
            row['tingkat'] == _level &&
            row['kelas'] == _className,
      )
      .toList();

  void _syncSelectedScheduleDetails() {
    final rows = _selectedLessons;
    if (rows.isEmpty) return;
    final first = rows.first;
    _semester = '${first['semester'] ?? _semester}';
    _homeroom.text = '${first['wali_kelas'] ?? _homeroom.text}';
    _updatedAt.text = '${first['diperbarui_pada'] ?? _updatedAt.text}';
    _schoolStart.text = '${first['jam_masuk'] ?? _schoolStart.text}';
    _break1.text = '${first['istirahat_1'] ?? _break1.text}';
    _break2.text = '${first['istirahat_2'] ?? _break2.text}';
    _finish.text = '${first['selesai'] ?? _finish.text}';
  }

  Future<void> _saveSettings() async {
    final content = {
      'breadcrumb': 'Beranda  >  Akademik  >  Jadwal Pelajaran',
      'hero_title': _heroTitle.text.trim(),
      'hero_subtitle': _heroSubtitle.text.trim(),
      'hero_image': _heroImage.text.trim(),
      'page_title': _pageTitle.text.trim(),
      'page_subtitle': _pageSubtitle.text.trim(),
      'schedule_note': 'Catatan: Jadwal dapat berubah sewaktu-waktu sesuai kebijakan sekolah.',
      'timing_title': 'Keterangan Jam Pelajaran',
      'information_title': 'Informasi Jadwal',
      'information_text': _infoText.text.trim(),
      'pdf_button_label': 'Unduh Jadwal PDF',
      'contact_button_label': 'Hubungi Sekolah',
      'reminder_text': _reminderText.text.trim(),
      'pdf_url': _pdfUrl.text.trim(),
    };
    try {
      await widget.api.save('jadwal_konten', {
        'judul': 'Jadwal Pelajaran',
        'data_json': jsonEncode(content),
        'status': 'aktif',
      }, id: _contentId);
      for (final row in _selectedLessons) {
        final id = int.tryParse('${row['id'] ?? ''}');
        if (id == null) continue;
        await widget.api.save('jadwal_pelajaran', {
          ...row,
          'semester': _semester,
          'wali_kelas': _homeroom.text.trim(),
          'diperbarui_pada': _updatedAt.text.trim(),
          'jam_masuk': _schoolStart.text.trim(),
          'istirahat_1': _break1.text.trim(),
          'istirahat_2': _break2.text.trim(),
          'selesai': _finish.text.trim(),
        }, id: id);
      }
      await _loadDatabase();
      if (mounted) _toast('Perubahan jadwal berhasil disimpan ke database.');
    } catch (_) {
      if (mounted) _toast('Perubahan gagal disimpan. Periksa koneksi database.');
    }
  }

  Map<String, dynamic> _lesson(
    String day,
    String period,
    String time,
    String subject,
    String teacher,
    String room, {
    bool isBreak = false,
  }) => {
    'hari': day,
    'jam_ke': period,
    'waktu': time,
    'mata_pelajaran': subject,
    'guru': teacher,
    'ruang': room,
    'is_break': isBreak,
  };

  @override
  void dispose() {
    for (final c in [
      _heroTitle,
      _heroSubtitle,
      _heroImage,
      _pageTitle,
      _pageSubtitle,
      _infoText,
      _reminderText,
      _pdfUrl,
      _homeroom,
      _updatedAt,
      _schoolStart,
      _break1,
      _break2,
      _finish,
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
    final reader = html.FileReader();
    reader.readAsDataUrl(input.files!.first);
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
      final filename = await widget.api.uploadFile('jadwal_konten', input.files!.first);
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

  Widget _pdfEditor() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _field('File / URL Jadwal PDF', _pdfUrl),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton.icon(
            onPressed: _pickPdf,
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text('Pilih PDF'),
          ),
          if (_pdfUrl.text.trim().isNotEmpty)
            TextButton.icon(
              onPressed: () => html.window.open(_documentUrl(_pdfUrl.text), '_blank'),
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Lihat File'),
            ),
        ],
      ),
      Text('File tersimpan: ${_documentName(_pdfUrl.text)}', style: const TextStyle(color: _muted, fontSize: 12)),
    ],
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
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(28, 26, 28, 60),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 24),
        _section(
          1,
          'Banner / Hero Jadwal Pelajaran',
          'Atur gambar dan teks utama yang tampil di bagian paling atas halaman.',
          _heroEditor(),
        ),
        _section(
          2,
          'Pengantar Halaman',
          'Atur judul dan deskripsi sebelum pilihan jadwal.',
          _introEditor(),
        ),
        _section(
          3,
          'Pengaturan Jadwal Kelas',
          'Pilih tahun ajaran, semester, tingkat, kelas, wali kelas, dan informasi pembaruan.',
          _scheduleSettings(),
        ),
        _section(
          4,
          'Keterangan Jam Pelajaran',
          'Atur jam masuk, waktu istirahat, dan waktu selesai sekolah.',
          _timingEditor(),
        ),
        _section(
          5,
          'Jadwal Pelajaran',
          'Kelola mata pelajaran per hari. Gunakan tab hari untuk mempermudah pengeditan.',
          _lessonManager(),
        ),
        _section(
          6,
          'Informasi Jadwal',
          'Atur pemberitahuan yang tampil di kartu Informasi Jadwal pada frontend.',
          _field('Teks Informasi Jadwal', _infoText, lines: 4),
        ),
        _section(
          7,
          'File Jadwal PDF',
          'Siapkan nama file atau URL PDF resmi yang akan dipakai tombol Unduh Jadwal PDF.',
          _pdfEditor(),
        ),
        _section(
          8,
          'Pengingat',
          'Atur pesan pengingat pada strip paling bawah halaman Jadwal Pelajaran.',
          _field('Teks Pengingat', _reminderText, lines: 3),
        ),
      ],
    ),
  );

  Widget _header() => LayoutBuilder(
    builder: (context, c) {
      final compact = c.maxWidth < 720;
      final title = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal Pelajaran',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: _text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kelola banner, kelas, jam belajar, mata pelajaran, guru, ruang, dan informasi jadwal.',
            style: TextStyle(color: _muted, fontSize: 14),
          ),
        ],
      );
      final actions = Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          OutlinedButton.icon(
            onPressed: () => _openAdminPreview(context, sharedAcademicPages()['jadwal']!),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Preview Halaman'),
          ),
          ElevatedButton.icon(
            onPressed: _loading ? null : _saveSettings,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Simpan Perubahan'),
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
      final preview = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _line),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _imagePreview(_heroImage.text),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xC9073979), Color(0x22073979)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _heroTitle.text.isEmpty
                              ? 'Jadwal Pelajaran'
                              : _heroTitle.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _heroSubtitle.text,
                          style: const TextStyle(
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _pickHeroImage,
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Ganti Foto'),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _heroImage.clear()),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Hapus'),
              ),
            ],
          ),
        ],
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
      _field('Deskripsi Halaman', _pageSubtitle, lines: 3),
    ],
  );

  Widget _scheduleSettings() => Column(
    children: [
      LayoutBuilder(
        builder: (context, c) {
          final fields = [
            _dropdown(
              'Tahun Ajaran',
              _year,
              _years,
              (v) => setState(() {
                _year = v!;
                _syncSelectedScheduleDetails();
              }),
            ),
            _dropdown('Semester', _semester, const [
              'Semester Ganjil',
              'Semester Genap',
            ], (v) => setState(() => _semester = v!)),
            _dropdown(
              'Tingkat',
              _level,
              _levels,
              (v) => setState(() {
                _level = v!;
                _className = _classes[_level]!.first;
                _syncSelectedScheduleDetails();
              }),
            ),
            _dropdown(
              'Kelas',
              _className,
              _classes[_level]!,
              (v) => setState(() {
                _className = v!;
                _syncSelectedScheduleDetails();
              }),
            ),
          ];
          return c.maxWidth < 850
              ? Column(
                  children: [
                    for (final f in fields) ...[f, const SizedBox(height: 14)],
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < fields.length; i++) ...[
                      Expanded(child: fields[i]),
                      if (i < fields.length - 1) const SizedBox(width: 12),
                    ],
                  ],
                );
        },
      ),
      const SizedBox(height: 4),
      LayoutBuilder(
        builder: (context, c) => c.maxWidth < 700
            ? Column(
                children: [
                  _field('Wali Kelas', _homeroom),
                  const SizedBox(height: 14),
                  _field('Terakhir Diperbarui', _updatedAt),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _field('Wali Kelas', _homeroom)),
                  const SizedBox(width: 14),
                  Expanded(child: _field('Terakhir Diperbarui', _updatedAt)),
                ],
              ),
      ),
    ],
  );

  Widget _timingEditor() => LayoutBuilder(
    builder: (context, c) {
      final items = [
        _timingCard(Icons.login_rounded, 'Jam Masuk', _schoolStart),
        _timingCard(Icons.free_breakfast_rounded, 'Istirahat I', _break1),
        _timingCard(Icons.restaurant_rounded, 'Istirahat II', _break2),
        _timingCard(Icons.logout_rounded, 'Selesai', _finish),
      ];
      if (c.maxWidth < 760)
        return Column(
          children: [
            for (final x in items) ...[x, const SizedBox(height: 12)],
          ],
        );
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: items[i]),
            if (i < items.length - 1) const SizedBox(width: 12),
          ],
        ],
      );
    },
  );

  Widget _timingCard(
    IconData icon,
    String label,
    TextEditingController controller,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFD),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _blue),
        const SizedBox(height: 10),
        _field(label, controller),
      ],
    ),
  );

  Widget _lessonManager() {
    final rows = _selectedLessons.where((e) => e['hari'] == _day).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final tabs = Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final d in _days)
                  ChoiceChip(
                    label: Text(d),
                    selected: d == _day,
                    onSelected: (_) => setState(() => _day = d),
                  ),
              ],
            );
            final add = ElevatedButton.icon(
              onPressed: () => _editLesson(null),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Jadwal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
              ),
            );
            return c.maxWidth < 720
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [tabs, const SizedBox(height: 14), add],
                  )
                : Row(
                    children: [
                      Expanded(child: tabs),
                      add,
                    ],
                  );
          },
        ),
        const SizedBox(height: 18),
        if (rows.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _line),
            ),
            child: const Text(
              'Belum ada jadwal pada hari ini.',
              style: TextStyle(color: _muted),
            ),
          )
        else
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _lessonCard(row),
            ),
          ),
      ],
    );
  }

  Widget _lessonCard(Map<String, dynamic> row) {
    final isBreak = row['is_break'] == true;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBreak ? const Color(0xFFFFF9E9) : const Color(0xFFF9FBFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isBreak ? const Color(0xFFF0D98E) : _line),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final content = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isBreak
                      ? const Color(0xFFFFF0B8)
                      : const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isBreak
                      ? Icons.free_breakfast_rounded
                      : Icons.menu_book_rounded,
                  color: isBreak ? const Color(0xFF9A7512) : _blue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${row['jam_ke']} • ${row['waktu']}',
                            style: const TextStyle(
                              color: _text,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (isBreak) ...[
                          const SizedBox(width: 8),
                          const Chip(
                            label: Text('ISTIRAHAT'),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${row['mata_pelajaran']}',
                      style: const TextStyle(
                        color: _text,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${row['guru']}  •  ${row['ruang']}',
                      style: const TextStyle(color: _muted, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          );
          final actions = Wrap(
            spacing: 4,
            children: [
              IconButton(
                tooltip: 'Edit',
                onPressed: () => _editLesson(row),
                icon: const Icon(Icons.edit_outlined, color: _blue),
              ),
              IconButton(
                tooltip: 'Hapus',
                onPressed: () => _deleteLesson(row),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          );
          return c.maxWidth < 650
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [content, const SizedBox(height: 8), actions],
                )
              : Row(
                  children: [
                    Expanded(child: content),
                    actions,
                  ],
                );
        },
      ),
    );
  }

  Future<void> _editLesson(Map<String, dynamic>? source) async {
    final period = TextEditingController(text: '${source?['jam_ke'] ?? ''}');
    final time = TextEditingController(text: '${source?['waktu'] ?? ''}');
    final subject = TextEditingController(
      text: '${source?['mata_pelajaran'] ?? ''}',
    );
    final teacher = TextEditingController(text: '${source?['guru'] ?? ''}');
    final room = TextEditingController(text: '${source?['ruang'] ?? ''}');
    var day = '${source?['hari'] ?? _day}';
    var isBreak = '${source?['is_break']}' == '1' || source?['is_break'] == true;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(source == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dropdown(
                    'Hari',
                    day,
                    _days,
                    (v) => setDialogState(() => day = v!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _field('Jam Ke', period)),
                      const SizedBox(width: 12),
                      Expanded(child: _field('Waktu', time)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _field('Mata Pelajaran / Keterangan', subject),
                  const SizedBox(height: 12),
                  _field('Guru', teacher),
                  const SizedBox(height: 12),
                  _field('Ruang', room),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tandai sebagai waktu istirahat'),
                    value: isBreak,
                    onChanged: (v) => setDialogState(() => isBreak = v),
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
              onPressed: () => Navigator.pop(
                dialogContext,
                _lesson(
                  day,
                  period.text.trim(),
                  time.text.trim(),
                  subject.text.trim(),
                  teacher.text.trim(),
                  room.text.trim(),
                  isBreak: isBreak,
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    period.dispose();
    time.dispose();
    subject.dispose();
    teacher.dispose();
    room.dispose();
    if (result == null || !mounted) return;
    final record = {
      ...?source,
      ...result,
      'tahun_ajaran': _year,
      'tingkat': _level,
      'kelas': _className,
      'semester': _semester,
      'urutan_hari': _days.indexOf('${result['hari']}') + 1,
      'urutan_jam': _selectedLessons
              .where((row) => row['hari'] == result['hari'])
              .length +
          1,
      'wali_kelas': _homeroom.text.trim(),
      'diperbarui_pada': _updatedAt.text.trim(),
      'jam_masuk': _schoolStart.text.trim(),
      'istirahat_1': _break1.text.trim(),
      'istirahat_2': _break2.text.trim(),
      'selesai': _finish.text.trim(),
    };
    try {
      final id = int.tryParse('${source?['id'] ?? ''}');
      await widget.api.save('jadwal_pelajaran', record, id: id);
      await _loadDatabase();
      if (mounted) setState(() => _day = '${result['hari']}');
      if (mounted) _toast('Baris jadwal berhasil disimpan.');
    } catch (_) {
      if (mounted) _toast('Baris jadwal gagal disimpan.');
    }
  }

  Future<void> _deleteLesson(Map<String, dynamic> row) async {
    final id = int.tryParse('${row['id'] ?? ''}');
    if (id == null) {
      setState(() => _lessons.remove(row));
      return;
    }
    try {
      await widget.api.delete('jadwal_pelajaran', id);
      if (!mounted) return;
      setState(() => _lessons.remove(row));
      _toast('Baris jadwal berhasil dihapus.');
    } catch (_) {
      if (mounted) _toast('Baris jadwal gagal dihapus.');
    }
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: _text, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _line),
          ),
        ),
        items: items
            .map((x) => DropdownMenuItem(value: x, child: Text(x)))
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );

  Widget _field(
    String label,
    TextEditingController controller, {
    int lines = 1,
    ValueChanged<String>? onChanged,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: _text, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      AdminContentTextField(
        controller: controller,
        maxLines: lines,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _line),
          ),
        ),
      ),
    ],
  );
}
