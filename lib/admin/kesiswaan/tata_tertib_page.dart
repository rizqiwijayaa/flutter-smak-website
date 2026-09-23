part of '../admin_dashboard_page.dart';

class AdminTataTertibPage extends StatefulWidget {
  const AdminTataTertibPage({
    super.key,
    required this.api,
    required this.module,
  });
  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminTataTertibPage> createState() => _AdminTataTertibPageState();
}

class _AdminTataTertibPageState extends State<AdminTataTertibPage> {
  final _heroTitle = TextEditingController(text: 'Tata Tertib Siswa');
  final _heroSubtitle = TextEditingController(
    text:
        'Pedoman untuk membangun lingkungan belajar yang tertib, aman, disiplin, dan berkarakter.',
  );
  final _heroImage = TextEditingController(text: 'assets/images/IMG_5196.JPG');
  final _introTitle = TextEditingController(text: 'Tata Tertib Siswa');
  final _intro = TextEditingController(
    text:
        'Tata tertib sekolah merupakan pedoman bersama untuk membentuk pribadi yang bertanggung jawab, saling menghormati, dan siap menjadi pembelajar sepanjang hayat.',
  );
  final _year = TextEditingController(text: '2026/2027');
  final _applies = TextEditingController(text: 'Seluruh Siswa');
  final _updated = TextEditingController(text: '10 Agustus 2026');
  final _status = TextEditingController(text: 'Sekolah');
  final _principle = TextEditingController(
    text: 'Disiplin • Tanggung Jawab\nHormat • Peduli',
  );
  final _principleDesc = TextEditingController(
    text:
        'Nilai yang menjadi dasar perilaku dan keputusan warga sekolah dalam mewujudkan karakter unggul.',
  );
  final _guidanceNote = TextEditingController(
    text:
        'Pendekatan sekolah bersifat edukatif dan restoratif untuk membantu siswa bertumbuh menjadi pribadi yang lebih baik.',
  );
  final _violationDesc = TextEditingController(
    text:
        'Pelanggaran serius ditangani sesuai peraturan sekolah dan ketentuan yang berlaku.',
  );
  final _pdf = TextEditingController(text: 'Tata_Tertib_Siswa_2026.pdf');
  final _pdfUrl = TextEditingController();
  final _help = TextEditingController(
    text:
        'Jika ada hal yang belum jelas, silakan hubungi wali kelas atau guru BK untuk memperoleh penjelasan lebih lanjut.',
  );
  final _contact = TextEditingController(text: 'https://wa.me/628155099445');
  final _commitment = TextEditingController(
    text:
        'Mari menciptakan lingkungan sekolah yang tertib, aman, nyaman, dan saling menghargai.',
  );
  final _commitmentSub = TextEditingController(
    text: 'Bersama, kita membentuk generasi berkarakter dan berprestasi.',
  );
  final _labelPrinciple = TextEditingController(text: 'Prinsip Utama');
  final _labelGeneral = TextEditingController(text: 'Ketentuan Umum');
  final _labelRightsDuties = TextEditingController(text: 'Hak dan Kewajiban Siswa');
  final _labelRights = TextEditingController(text: 'Hak Siswa');
  final _labelDuties = TextEditingController(text: 'Kewajiban Siswa');
  final _labelGuidance = TextEditingController(text: 'Pembinaan dan Tindak Lanjut');
  final _labelDocument = TextEditingController(text: 'Dokumen Tata Tertib');
  final _labelHelp = TextEditingController(text: 'Butuh Penjelasan?');
  final _buttonDownload = TextEditingController(text: 'Unduh PDF');
  final _buttonContact = TextEditingController(text: 'Hubungi Sekolah');

  final List<String> _general = [
    'Hadir tepat waktu sesuai jadwal kegiatan sekolah.',
    'Memakai seragam sesuai ketentuan yang berlaku.',
    'Menjaga kesopanan, sopan santun, dan menghormati sesama.',
    'Mengikuti pembelajaran dengan tertib dan penuh tanggung jawab.',
    'Menjaga kebersihan, kerapian, dan kelestarian fasilitas sekolah.',
    'Membawa perlengkapan belajar sesuai kebutuhan.',
  ];
  final List<String> _rights = [
    'Memperoleh pembelajaran yang berkualitas.',
    'Mendapat rasa aman dan nyaman di sekolah.',
    'Memperoleh bimbingan dan konseling.',
    'Menggunakan fasilitas sekolah dengan layak.',
    'Menyampaikan pendapat dengan santun.',
  ];
  final List<String> _duties = [
    'Menaati semua peraturan sekolah.',
    'Menjaga nama baik diri, keluarga, dan sekolah.',
    'Mengikuti kegiatan sekolah dengan sungguh-sungguh.',
    'Merawat fasilitas sekolah dengan tanggung jawab.',
    'Menghargai seluruh warga sekolah.',
  ];
  final List<String> _violations = [
    'Perundungan dalam bentuk apa pun.',
    'Kekerasan fisik maupun verbal.',
    'Merokok, narkoba, dan minuman beralkohol.',
    'Membawa benda berbahaya.',
    'Merusak fasilitas sekolah.',
    'Tindakan yang mencemarkan nama sekolah.',
  ];
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Kehadiran',
      'secondary': 'Prosedur Izin/Tidak Hadir',
      'a': [
        'Siswa hadir minimal 10 menit sebelum pelajaran dimulai.',
        'Keterlambatan wajib dilaporkan kepada guru piket.',
        'Mengikuti apel pagi dan kegiatan wajib sekolah.',
      ],
      'b': [
        'Sampaikan izin kepada wali kelas sebelum kegiatan dimulai.',
        'Orang tua mengirimkan keterangan resmi.',
        'Izin lebih dari tiga hari dilengkapi surat keterangan.',
      ],
    },
    {
      'title': 'Seragam & Kerapian',
      'secondary': 'Penampilan Siswa',
      'a': [
        'Memakai seragam sesuai jadwal dan ketentuan sekolah.',
        'Menjaga kebersihan serta kerapian diri.',
        'Menggunakan atribut sekolah secara lengkap.',
      ],
      'b': [
        'Rambut ditata rapi dan tidak berlebihan.',
        'Tidak menggunakan aksesori yang mengganggu pembelajaran.',
        'Sepatu dan perlengkapan disesuaikan dengan kegiatan.',
      ],
    },
    {
      'title': 'Perilaku & Etika',
      'secondary': 'Etika Pergaulan',
      'a': [
        'Bersikap santun kepada guru, karyawan, dan sesama siswa.',
        'Menjaga ucapan serta perilaku di sekolah maupun media sosial.',
        'Menghargai perbedaan dan tidak melakukan perundungan.',
      ],
      'b': [
        'Menyelesaikan perbedaan melalui komunikasi yang baik.',
        'Menjaga nama baik diri, keluarga, dan sekolah.',
        'Mengutamakan kejujuran serta tanggung jawab.',
      ],
    },
    {
      'title': 'Kegiatan Belajar',
      'secondary': 'Penggunaan Perangkat',
      'a': [
        'Mengikuti pelajaran dengan aktif dan tertib.',
        'Mengerjakan tugas dengan jujur dan tepat waktu.',
        'Membawa buku serta perlengkapan sesuai jadwal.',
      ],
      'b': [
        'Perangkat digital digunakan atas izin guru.',
        'Tidak mengakses konten di luar kebutuhan belajar.',
        'Menjaga perangkat dan fasilitas pembelajaran.',
      ],
    },
  ];
  final List<Map<String, String>> _guidance = [
    {'title': 'Pengingat', 'desc': 'Nasihat persuasif oleh guru atau piket.'},
    {
      'title': 'Pembinaan Wali Kelas',
      'desc': 'Pendampingan untuk memahami dan memperbaiki diri.',
    },
    {
      'title': 'Pendampingan BK',
      'desc': 'Mencari solusi serta menguatkan karakter siswa.',
    },
    {
      'title': 'Koordinasi Orang Tua',
      'desc': 'Kerja sama demi perkembangan siswa yang optimal.',
    },
  ];
  int? _contentId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      final rows = await widget.api.getTable('tatib_konten', limit: 1);
      if (rows.isEmpty || !mounted) return;
      final row = rows.first;
      final data = jsonDecode('${row['data_json'] ?? '{}'}') as Map<String, dynamic>;
      setState(() {
        _contentId = int.tryParse('${row['id'] ?? ''}');
        final controllers = <String, TextEditingController>{
          'hero_title': _heroTitle, 'hero_subtitle': _heroSubtitle, 'hero_image': _heroImage,
          'intro_title': _introTitle, 'intro': _intro, 'year': _year, 'applies': _applies,
          'updated': _updated, 'status': _status, 'principle': _principle, 'principle_desc': _principleDesc,
          'guidance_note': _guidanceNote, 'violation_desc': _violationDesc, 'pdf': _pdf,
          'pdf_url': _pdfUrl, 'help': _help, 'contact': _contact, 'commitment': _commitment,
          'commitment_sub': _commitmentSub,
          'label_principle': _labelPrinciple, 'label_general': _labelGeneral,
          'label_rights_duties': _labelRightsDuties, 'label_rights': _labelRights,
          'label_duties': _labelDuties, 'label_guidance': _labelGuidance,
          'label_document': _labelDocument, 'label_help': _labelHelp,
          'button_download': _buttonDownload, 'button_contact': _buttonContact,
        };
        for (final entry in controllers.entries) {
          if (data[entry.key] != null) entry.value.text = '${data[entry.key]}';
        }
        void replaceStrings(String key, List<String> target) {
          if (data[key] is List && (data[key] as List).isNotEmpty) {
            target..clear()..addAll((data[key] as List).map((e) => '$e'));
          }
        }
        replaceStrings('general', _general); replaceStrings('rights', _rights);
        replaceStrings('duties', _duties); replaceStrings('violations', _violations);
        if (data['categories'] is List && (data['categories'] as List).isNotEmpty) {
          _categories..clear()..addAll((data['categories'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
        }
        if (data['guidance'] is List && (data['guidance'] as List).isNotEmpty) {
          _guidance..clear()..addAll((data['guidance'] as List).map((e) => Map<String, String>.from((e as Map).map((k, v) => MapEntry('$k', '$v')))));
        }
      });
    } catch (_) {}
  }

  Map<String, dynamic> _payload() => {
    'hero_title': _heroTitle.text.trim(), 'hero_subtitle': _heroSubtitle.text.trim(), 'hero_image': _heroImage.text.trim(),
    'intro_title': _introTitle.text.trim(), 'intro': _intro.text.trim(), 'year': _year.text.trim(), 'applies': _applies.text.trim(), 'updated': _updated.text.trim(), 'status': _status.text.trim(),
    'principle': _principle.text.trim(), 'principle_desc': _principleDesc.text.trim(), 'guidance_note': _guidanceNote.text.trim(), 'violation_desc': _violationDesc.text.trim(),
    'pdf': _pdf.text.trim(), 'pdf_url': _pdfUrl.text.trim(), 'help': _help.text.trim(), 'contact': _contact.text.trim(), 'commitment': _commitment.text.trim(), 'commitment_sub': _commitmentSub.text.trim(),
    'general': _general, 'rights': _rights, 'duties': _duties, 'violations': _violations, 'categories': _categories, 'guidance': _guidance,
    'label_principle': _labelPrinciple.text.trim(), 'label_general': _labelGeneral.text.trim(), 'label_rights_duties': _labelRightsDuties.text.trim(), 'label_rights': _labelRights.text.trim(), 'label_duties': _labelDuties.text.trim(), 'label_guidance': _labelGuidance.text.trim(), 'label_document': _labelDocument.text.trim(), 'label_help': _labelHelp.text.trim(), 'button_download': _buttonDownload.text.trim(), 'button_contact': _buttonContact.text.trim(),
  };

  Future<void> _saveDatabase() async {
    setState(() => _saving = true);
    try {
      await widget.api.save('tatib_konten', {'judul': _heroTitle.text.trim(), 'data_json': jsonEncode(_payload()), 'status': 'aktif'}, id: _contentId);
      await _loadDatabase();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perubahan Tata Tertib berhasil disimpan.')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perubahan Tata Tertib gagal disimpan.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickHero() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    final r = html.FileReader();
    r.readAsDataUrl(input.files!.first);
    await r.onLoad.first;
    if (mounted) setState(() => _heroImage.text = r.result?.toString() ?? '');
  }

  Future<void> _pickPdf() async {
    final input = html.FileUploadInputElement()..accept = '.pdf,application/pdf';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return;
    try {
      final filename = await widget.api.uploadFile('tatib_konten', input.files!.first);
      if (mounted) {
        setState(() {
          _pdf.text = filename.split('/').last;
          _pdfUrl.text = filename;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengunggah PDF.')));
      }
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
      _field('Nama File PDF', _pdf),
      const SizedBox(height: 12),
      _field('File / URL PDF', _pdfUrl),
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
          if ((_pdfUrl.text.trim().isNotEmpty || _pdf.text.trim().isNotEmpty))
            TextButton.icon(
              onPressed: () => html.window.open(
                _documentUrl(_pdfUrl.text.trim().isEmpty ? _pdf.text : _pdfUrl.text),
                '_blank',
              ),
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Lihat File'),
            ),
        ],
      ),
      Text('File tersimpan: ${_documentName(_pdfUrl.text.trim().isEmpty ? _pdf.text : _pdfUrl.text)}', style: const TextStyle(color: _muted, fontSize: 12)),
    ],
  );

  Widget _image(String value) {
    if (value.isEmpty)
      return const ColoredBox(
        color: Color(0xFFF1F4F8),
        child: Center(
          child: Icon(Icons.image_outlined, size: 52, color: Color(0xFF9AA9BC)),
        ),
      );
    return websiteContentImage(value, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 24, 28, 50),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 24),
          _section(1, 'Banner / Hero Tata Tertib', _hero()),
          _section(
            2,
            'Pengantar Halaman',
            Column(
              children: [
                _field('Judul Halaman', _introTitle),
                const SizedBox(height: 12),
                _field('Deskripsi', _intro, lines: 4),
              ],
            ),
          ),
          _section(3, 'Ringkasan Dokumen', _summary()),
          _section(4, 'Ketentuan Umum', _list(_general, 'Tambah Ketentuan')),
          _section(
            5,
            'Prinsip Utama',
            Column(
              children: [
                _field('Nilai Utama', _principle, lines: 2),
                const SizedBox(height: 12),
                _field('Deskripsi', _principleDesc, lines: 3),
              ],
            ),
          ),
          _section(6, 'Kategori Tata Tertib', _categoryCards()),
          _section(7, 'Hak dan Kewajiban Siswa', _twoLists()),
          _section(8, 'Pembinaan dan Tindak Lanjut', _guidanceCards()),
          _section(
            9,
            'Pelanggaran yang Perlu Dihindari',
            Column(
              children: [
                _field('Deskripsi', _violationDesc, lines: 3),
                const SizedBox(height: 14),
                _list(_violations, 'Tambah Pelanggaran'),
              ],
            ),
          ),
          _section(
            10,
            'Dokumen Tata Tertib & Bantuan',
            Column(
              children: [
                _pdfEditor(),
                const SizedBox(height: 18),
                _field('Teks Bantuan', _help, lines: 3),
                const SizedBox(height: 12),
                _field('Link Kontak / WhatsApp', _contact),
                const SizedBox(height: 12),
                _field('Judul Dokumen', _labelDocument),
                const SizedBox(height: 12),
                _field('Judul Bantuan', _labelHelp),
                const SizedBox(height: 12),
                _field('Teks Tombol Unduh', _buttonDownload),
                const SizedBox(height: 12),
                _field('Teks Tombol Hubungi', _buttonContact),
              ],
            ),
          ),
          _section(
            11,
            'Komitmen Bersama',
            Column(
              children: [
                _field('Judul Komitmen', _commitment, lines: 2),
                const SizedBox(height: 12),
                _field('Subtitle', _commitmentSub, lines: 2),
                const SizedBox(height: 12),
                _field('Judul Prinsip', _labelPrinciple),
                const SizedBox(height: 12),
                _field('Judul Ketentuan Umum', _labelGeneral),
                const SizedBox(height: 12),
                _field('Judul Hak dan Kewajiban', _labelRightsDuties),
                const SizedBox(height: 12),
                _field('Judul Hak', _labelRights),
                const SizedBox(height: 12),
                _field('Judul Kewajiban', _labelDuties),
                const SizedBox(height: 12),
                _field('Judul Pembinaan', _labelGuidance),
              ],
            ),
          ),
        ],
    ),
  );

  Widget _header() => Row(
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tata Tertib',
              style: TextStyle(
                color: _text,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Kelola tata tertib, pembinaan, dan aturan siswa',
              style: TextStyle(color: _muted),
            ),
          ],
        ),
      ),
      OutlinedButton.icon(
        onPressed: () => _openAdminPreview(context, sharedStudentPages()['tata']!),
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('Preview Halaman'),
      ),
      const SizedBox(width: 10),
      FilledButton.icon(
        onPressed: _saving ? null : _saveDatabase,
        icon: const Icon(Icons.save_rounded),
        label: const Text('Simpan Perubahan'),
      ),
    ],
  );

  Widget _section(int n, String title, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$n',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    ),
  );

  Widget _hero() => LayoutBuilder(
    builder: (context, c) {
      final preview = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 235,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _line),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _image(_heroImage.text),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xE6083A7C), Color(0x66083A7C)],
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
                          _heroTitle.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
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
                onPressed: _pickHero,
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
          const SizedBox(height: 12),
          _field(
            'Subtitle Hero',
            _heroSubtitle,
            lines: 3,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
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

  Widget _summary() => LayoutBuilder(
    builder: (context, c) {
      final w = c.maxWidth < 760 ? c.maxWidth : (c.maxWidth - 14) / 2;
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          SizedBox(width: w, child: _field('Tahun Ajaran', _year)),
          SizedBox(width: w, child: _field('Berlaku untuk', _applies)),
          SizedBox(width: w, child: _field('Pembaruan', _updated)),
          SizedBox(width: w, child: _field('Status Dokumen', _status)),
        ],
      );
    },
  );

  Widget _categoryCards() => Column(
    children: [
      ..._categories.asMap().entries.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _card(
            Icons.rule_rounded,
            e.value['title'] as String,
            '${(e.value['a'] as List).length} aturan utama • ${(e.value['b'] as List).length} aturan ${(e.value['secondary'] as String)}',
            [
              IconButton(
                onPressed: () => _editCategory(e.key),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => setState(() => _categories.removeAt(e.key)),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editCategory(null),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Kategori'),
        ),
      ),
    ],
  );

  Widget _twoLists() => LayoutBuilder(
    builder: (context, c) {
      final a = _listCard('Hak Siswa', _rights);
      final b = _listCard('Kewajiban Siswa', _duties);
      return c.maxWidth < 800
          ? Column(children: [a, const SizedBox(height: 14), b])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: a),
                const SizedBox(width: 14),
                Expanded(child: b),
              ],
            );
    },
  );

  Widget _guidanceCards() => Column(
    children: [
      ..._guidance.asMap().entries.map(
        (e) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _card(
                Icons.volunteer_activism_outlined,
                e.value['title']!,
                e.value['desc']!,
                [
                  IconButton(
                    onPressed: () => _editGuidance(e.key),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _guidance.removeAt(e.key)),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ),
            ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editGuidance(null),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Tahapan'),
        ),
      ),
      const SizedBox(height: 16),
      _field('Catatan Pendekatan', _guidanceNote, lines: 3),
    ],
  );

  Widget _listCard(String title, List<String> data) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FBFE),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _addString(data, title),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...data.asMap().entries.map(
          (e) => Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 17,
                color: _blue,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(e.value)),
              IconButton(
                onPressed: () => _editString(data, e.key),
                icon: const Icon(Icons.edit_outlined, size: 18),
              ),
              IconButton(
                onPressed: () => setState(() => data.removeAt(e.key)),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _list(List<String> data, String addLabel) => Column(
    children: [
      ...data.asMap().entries.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: _card(Icons.drag_indicator_rounded, e.value, null, [
            IconButton(
              onPressed: () => _editString(data, e.key),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => setState(() => data.removeAt(e.key)),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ]),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _addString(data, addLabel),
          icon: const Icon(Icons.add_rounded),
          label: Text(addLabel),
        ),
      ),
    ],
  );

  Widget _card(
    IconData icon,
    String title,
    String? sub,
    List<Widget> actions,
  ) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FBFE),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: _line),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: _blue),
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
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (sub != null) ...[
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(color: _muted)),
              ],
            ],
          ),
        ),
        ...actions,
      ],
    ),
  );

  Widget _field(
    String label,
    TextEditingController c, {
    int lines = 1,
    ValueChanged<String>? onChanged,
  }) => AdminContentTextField(
    controller: c,
    maxLines: lines,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      alignLabelWithHint: lines > 1,
      filled: true,
      fillColor: const Color(0xFFFBFCFE),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _line),
      ),
    ),
  );

  Future<void> _editString(List<String> data, int i) async {
    final c = TextEditingController(text: data[i]);
    final v = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Edit Konten'),
        content: AdminContentTextField(controller: c, maxLines: 4, decoration: const InputDecoration(labelText: 'Isi aturan')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, c.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    c.dispose();
    if (v != null && v.isNotEmpty && mounted) setState(() => data[i] = v);
  }

  Future<void> _addString(List<String> data, String title) async {
    final c = TextEditingController();
    final v = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(title),
        content: AdminContentTextField(controller: c, maxLines: 4, decoration: const InputDecoration(labelText: 'Isi aturan')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, c.text.trim()),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    c.dispose();
    if (v != null && v.isNotEmpty && mounted) setState(() => data.add(v));
  }

  Future<void> _editGuidance(int? i) async {
    final t = TextEditingController(
      text: i == null ? '' : _guidance[i]['title'],
    );
    final d = TextEditingController(
      text: i == null ? '' : _guidance[i]['desc'],
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (x) => AlertDialog(
        title: Text(i == null ? 'Tambah Tahapan' : 'Edit Tahapan'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminContentTextField(
                controller: t,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              const SizedBox(height: 12),
              AdminContentTextField(
                controller: d,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(x, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(x, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true && t.text.trim().isNotEmpty && mounted)
      setState(() {
        final v = {'title': t.text.trim(), 'desc': d.text.trim()};
        if (i == null)
          _guidance.add(v);
        else
          _guidance[i] = v;
      });
    t.dispose();
    d.dispose();
  }

  Future<void> _editCategory(int? i) async {
    final s = i == null ? null : _categories[i];
    final t = TextEditingController(text: s?['title'] ?? '');
    final st = TextEditingController(text: s?['secondary'] ?? '');
    final a = TextEditingController(
      text: s == null ? '' : (s['a'] as List).join('\n'),
    );
    final b = TextEditingController(
      text: s == null ? '' : (s['b'] as List).join('\n'),
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (x) => AlertDialog(
        title: Text(i == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: SizedBox(
          width: 620,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdminContentTextField(
                  controller: t,
                  decoration: const InputDecoration(labelText: 'Nama Kategori'),
                ),
                const SizedBox(height: 10),
                AdminContentTextField(
                  controller: a,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Aturan Utama (satu per baris)',
                  ),
                ),
                const SizedBox(height: 10),
                AdminContentTextField(
                  controller: st,
                  decoration: const InputDecoration(
                    labelText: 'Judul Bagian Kedua',
                  ),
                ),
                const SizedBox(height: 10),
                AdminContentTextField(
                  controller: b,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Aturan Bagian Kedua (satu per baris)',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(x, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(x, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true && t.text.trim().isNotEmpty && mounted)
      setState(() {
        final v = <String, dynamic>{
          'title': t.text.trim(),
          'secondary': st.text.trim(),
          'a': a.text
              .split('\n')
              .map((x) => x.trim())
              .where((x) => x.isNotEmpty)
              .toList(),
          'b': b.text
              .split('\n')
              .map((x) => x.trim())
              .where((x) => x.isNotEmpty)
              .toList(),
        };
        if (i == null)
          _categories.add(v);
        else
          _categories[i] = v;
      });
    t.dispose();
    st.dispose();
    a.dispose();
    b.dispose();
  }
}
