part of '../admin_dashboard_page.dart';

class AdminPpdbPage extends StatefulWidget {
  const AdminPpdbPage({super.key, required this.api, required this.module});
  final SmakApi api;
  final AdminModule module;

  @override
  State<AdminPpdbPage> createState() => _AdminPpdbPageState();
}

class _AdminPpdbPageState extends State<AdminPpdbPage> {
  bool _loading = false;
  bool _saving = false;
  int? _id;

  final _tahun = TextEditingController(text: '2026/2027');
  final _judul = TextEditingController(text: 'Penerimaan Peserta Didik Baru');
  final _subjudul = TextEditingController(
    text:
        'Bersama SMAK, tumbuh menjadi pribadi beriman, berkarakter, dan berprestasi.',
  );
  final _status = TextEditingController(text: 'PENDAFTARAN DIBUKA');
  final _heroImage = TextEditingController();
  final _daftarUrl = TextEditingController();
  final _wa = TextEditingController(text: '628155099445');
  final _gelombang = TextEditingController(text: 'Gelombang 1');
  final _periode = TextEditingController(text: '1 Mei - 30 Juni 2026');
  final _kuota = TextEditingController(text: '120 Siswa');
  final _jenjang = TextEditingController(text: 'SMA');
  final _kontak = TextEditingController(text: '(0334) 890123');
  final _whyTitle = TextEditingController(text: 'Mengapa Memilih SMAK?');
  final _whyDesc = TextEditingController(
    text:
        'Lingkungan pendidikan yang mendampingi perkembangan akademik dan karakter putra-putri Anda.',
  );
  final _learnTitle = TextEditingController(
    text: 'Mengenal Lingkungan Belajar SMAK',
  );
  final _learnDesc = TextEditingController(
    text:
        'SMAK menghadirkan lingkungan belajar yang aman, inspiratif, dan mendukung setiap siswa untuk berkembang secara utuh.',
  );
  final _learnImage = TextEditingController();
  final _jadwalCatatan = TextEditingController(
    text:
        'Jadwal dapat berubah sewaktu-waktu. Silakan pantau informasi terbaru di website resmi atau media sosial SMAK.',
  );
  final _biayaDesc = TextEditingController(
    text:
        'SMAK berkomitmen untuk memberikan layanan pendidikan berkualitas dengan biaya yang transparan dan dapat dikonsultasikan langsung dengan panitia.',
  );
  final _callHours = TextEditingController(
    text: 'Senin - Jumat, 08.00 - 15.00 WIB',
  );
  final _ctaLabel = TextEditingController(text: 'PPDB 2026/2027');
  final _ctaTitle = TextEditingController(text: 'Mulai Langkahmu Bersama SMAK');
  final _ctaDesc = TextEditingController(
    text:
        'Bergabunglah dengan SMAK dan raih masa depan cerah bersama komunitas yang beriman, berkarakter, dan berprestasi.',
  );
  final _sectionFlow = TextEditingController(text: 'Alur Pendaftaran');
  final _sectionRequirements = TextEditingController(text: 'Persyaratan Pendaftaran');
  final _sectionDownloads = TextEditingController(text: 'Dokumen yang Dapat Diunduh');
  final _sectionSchedule = TextEditingController(text: 'Jadwal PPDB');
  final _sectionCosts = TextEditingController(text: 'Biaya Pendidikan');
  final _sectionScholarships = TextEditingController(text: 'Beasiswa & Bantuan');
  final _sectionFacilities = TextEditingController(text: 'Fasilitas untuk Mendukung Perkembangan Siswa');
  final _sectionTestimonials = TextEditingController(text: 'Cerita dari Keluarga SMAK');
  final _sectionFaq = TextEditingController(text: 'Pertanyaan yang Sering Diajukan');
  final _buttonRegister = TextEditingController(text: 'Daftar Sekarang');
  final _buttonConsult = TextEditingController(text: 'Konsultasi WhatsApp');
  final _buttonProfile = TextEditingController(text: 'Lihat Profil Sekolah');
  final _buttonDownload = TextEditingController(text: 'Unduh');
  final _buttonCostConsult = TextEditingController(text: 'Konsultasi Biaya & Beasiswa');
  final _buttonChat = TextEditingController(text: 'Chat WhatsApp');
  final _buttonContact = TextEditingController(text: 'Hubungi Panitia');

  late List<Map<String, dynamic>> _why;
  late List<Map<String, dynamic>> _learning;
  late List<Map<String, dynamic>> _flow;
  late List<Map<String, dynamic>> _requirements;
  late List<Map<String, dynamic>> _downloads;
  late List<Map<String, dynamic>> _schedule;
  late List<Map<String, dynamic>> _costs;
  late List<Map<String, dynamic>> _scholarships;
  late List<Map<String, dynamic>> _facilities;
  late List<Map<String, dynamic>> _testimonials;
  late List<Map<String, dynamic>> _faqs;
  Map<String, dynamic> _frontendData = {};

  @override
  void initState() {
    super.initState();
    _seedFromFrontend();
    _load();
  }

  void _seedFromFrontend() {
    _why = [
      {'judul': 'Akreditasi A', 'deskripsi': 'Terakreditasi BAN-S/M'},
      {
        'judul': 'Pembelajaran Berkualitas',
        'deskripsi': 'Pembelajaran aktif dan terarah',
      },
      {
        'judul': 'Pembentukan Karakter',
        'deskripsi': 'Beriman, disiplin, dan bertanggung jawab',
      },
      {
        'judul': 'Lingkungan Nyaman',
        'deskripsi': 'Aman, suportif, dan kekeluargaan',
      },
    ];
    _learning = [
      {
        'judul': 'Pendampingan Personal',
        'deskripsi':
            'Guru pembimbing mendampingi perkembangan akademik dan karakter.',
      },
      {
        'judul': 'Fasilitas Pendukung',
        'deskripsi':
            'Fasilitas lengkap untuk menunjang proses belajar mengajar.',
      },
      {
        'judul': 'Kegiatan Beragam',
        'deskripsi':
            'Program ekstrakurikuler dan kegiatan rohani yang membentuk pribadi unggul.',
      },
      {
        'judul': 'Komunitas Beriman',
        'deskripsi':
            'Dibentuk dalam nilai kebersamaan, iman Katolik, dan pelayanan.',
      },
    ];
    _flow = [
      {
        'judul': 'Isi Formulir',
        'deskripsi':
            'Isi formulir pendaftaran secara online dengan data yang benar.',
      },
      {
        'judul': 'Unggah Berkas',
        'deskripsi': 'Unggah dokumen persyaratan dalam format yang ditentukan.',
      },
      {
        'judul': 'Verifikasi',
        'deskripsi':
            'Panitia memverifikasi dokumen dan menghubungi jika ada kekurangan.',
      },
      {
        'judul': 'Tes & Wawancara',
        'deskripsi': 'Mengikuti tes akademik dan wawancara sesuai jadwal.',
      },
      {
        'judul': 'Daftar Ulang',
        'deskripsi': 'Calon peserta yang diterima melakukan daftar ulang.',
      },
    ];
    _requirements = [
      {'kategori': 'Dokumen Pribadi', 'judul': 'Fotokopi Kartu Keluarga'},
      {'kategori': 'Dokumen Pribadi', 'judul': 'Fotokopi Akta Kelahiran'},
      {
        'kategori': 'Dokumen Pribadi',
        'judul': 'Pas Foto berwarna 3x4 (2 lembar)',
      },
      {
        'kategori': 'Dokumen Akademik',
        'judul': 'Fotokopi Rapor Semester 1 - 5',
      },
      {
        'kategori': 'Dokumen Akademik',
        'judul': 'Fotokopi ijazah/SKL (jika sudah ada)',
      },
      {
        'kategori': 'Dokumen Pendukung',
        'judul': 'Sertifikat prestasi (jika ada)',
      },
      {
        'kategori': 'Dokumen Pendukung',
        'judul': 'Surat Keterangan Kelakuan Baik dari Sekolah Asal',
      },
    ];
    _downloads = [
      {
        'judul': 'Brosur PPDB 2026/2027',
        'deskripsi': 'Informasi lengkap mengenai PPDB SMAK',
        'file_url': '',
      },
      {
        'judul': 'Formulir Pendaftaran',
        'deskripsi': 'Formulir pendaftaran peserta didik baru',
        'file_url': '',
      },
      {
        'judul': 'Panduan Pendaftaran',
        'deskripsi': 'Panduan lengkap demi langkah pendaftaran',
        'file_url': '',
      },
    ];
    _schedule = [
      {
        'tanggal': '1 Mei - 30 Juni 2026',
        'judul': 'Pendaftaran',
        'deskripsi': 'Pengisian formulir dan unggah berkas pendaftaran.',
      },
      {
        'tanggal': '4 Juli 2026',
        'judul': 'Tes & Wawancara',
        'deskripsi': 'Tes akademik dan wawancara sesuai jadwal.',
      },
      {
        'tanggal': '7 Juli 2026',
        'judul': 'Pengumuman',
        'deskripsi': 'Pengumuman hasil seleksi diterbitkan secara online.',
      },
      {
        'tanggal': '10 - 12 Juli 2026',
        'judul': 'Daftar Ulang',
        'deskripsi': 'Peserta yang diterima melakukan daftar ulang.',
      },
    ];
    _costs = [
      {'judul': 'Biaya Pendaftaran', 'nilai': 'Hubungi Panitia'},
      {'judul': 'Uang Pangkal', 'nilai': 'Hubungi Panitia'},
      {'judul': 'SPP', 'nilai': 'Hubungi Panitia'},
    ];
    _scholarships = [
      {
        'judul': 'Beasiswa Prestasi',
        'deskripsi':
            'Diberikan bagi siswa berprestasi di bidang akademik maupun non-akademik.',
      },
      {
        'judul': 'Beasiswa Akademik',
        'deskripsi': 'Berdasarkan pencapaian nilai akademik yang unggul.',
      },
      {
        'judul': 'Bantuan Pendidikan',
        'deskripsi':
            'Bagi keluarga yang membutuhkan dukungan biaya pendidikan.',
      },
    ];
    _facilities = [
      {
        'judul': 'Laboratorium',
        'deskripsi':
            'Laboratorium IPA yang lengkap mendukung pembelajaran praktikum yang berkualitas.',
      },
      {
        'judul': 'Perpustakaan',
        'deskripsi':
            'Koleksi buku lengkap dan ruang baca nyaman untuk mendukung literasi siswa.',
      },
      {
        'judul': 'Lapangan Olahraga',
        'deskripsi':
            'Fasilitas olahraga memadai untuk mendukung kesehatan dan prestasi siswa.',
      },
      {
        'judul': 'Ruang Komputer',
        'deskripsi':
            'Ruang komputer dengan perangkat modern untuk menunjang pembelajaran digital.',
      },
    ];
    _testimonials = [
      {
        'nama': 'Ibu Maria',
        'peran': 'Orang Tua Siswa Kelas XI',
        'kutipan':
            'SMAK membantu anak saya tumbuh menjadi pribadi yang beriman, disiplin, dan berprestasi.',
      },
      {
        'nama': 'Bapak Antonius',
        'peran': 'Orang Tua Siswa Kelas X',
        'kutipan':
            'Fasilitas lengkap dan kegiatan yang beragam membuat anak saya betah belajar.',
      },
      {
        'nama': 'Ibu Yuliana',
        'peran': 'Orang Tua Siswa Kelas XII',
        'kutipan':
            'Lingkungan yang kekeluargaan sangat membantu karakter anak saya sehari-hari.',
      },
    ];
    _faqs = [
      {
        'pertanyaan': 'Apa saja jalur pendaftaran yang tersedia?',
        'jawaban':
            'SMAK membuka pendaftaran melalui jalur reguler dan jalur prestasi.',
      },
      {
        'pertanyaan': 'Apakah pendaftaran dapat dilakukan secara online?',
        'jawaban':
            'Ya, seluruh proses pendaftaran awal dapat dilakukan secara online.',
      },
      {
        'pertanyaan': 'Bagaimana proses tes dan wawancara?',
        'jawaban':
            'Calon siswa akan mengikuti tes akademik dan wawancara sesuai jadwal.',
      },
      {
        'pertanyaan': 'Apakah tersedia program beasiswa?',
        'jawaban':
            'Tersedia program beasiswa prestasi, akademik, dan bantuan pendidikan.',
      },
      {
        'pertanyaan': 'Bagaimana jika dokumen belum lengkap?',
        'jawaban':
            'Panitia akan menghubungi pendaftar untuk melengkapi dokumen.',
      },
      {
        'pertanyaan': 'Siapa yang dapat saya hubungi?',
        'jawaban':
            'Hubungi panitia PPDB melalui WhatsApp atau telepon sekolah.',
      },
    ];
  }

  String _s(dynamic v) => '${v ?? ''}'.trim();

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await widget.api.getTable('ppdb', limit: 1);
      if (rows.isNotEmpty) {
        final r = rows.first;
        _id = int.tryParse(_s(r['id']));
        _put(_tahun, r, ['tahun_ajaran', 'tahun']);
        _put(_judul, r, ['judul', 'hero_judul']);
        _put(_subjudul, r, ['deskripsi', 'hero_deskripsi', 'subtitle']);
        _put(_status, r, ['status_pendaftaran', 'status']);
        _put(_daftarUrl, r, ['link_pendaftaran', 'url_pendaftaran']);
        _put(_wa, r, ['whatsapp', 'nomor_whatsapp']);
        _put(_gelombang, r, ['gelombang']);
        _put(_periode, r, ['periode', 'tanggal_pendaftaran']);
        _put(_kuota, r, ['kuota']);
        _put(_jenjang, r, ['jenjang']);
        _put(_kontak, r, ['kontak_ppdb', 'telepon']);
        _readFrontendData(r['frontend_data']);
      }
    } catch (_) {
      // DB PPDB mungkin belum selesai dimigrasikan; UI admin tetap bisa dibuka.
    }
    if (mounted) setState(() => _loading = false);
  }

  void _readFrontendData(dynamic value) {
    try {
      final decoded = jsonDecode(_s(value));
      if (decoded is! Map) return;
      _frontendData = Map<String, dynamic>.from(decoded);
      _put(_heroImage, _frontendData['hero'], ['gambar']);
      final text = _frontendData['teks_bagian'];
      if (text is Map) {
        final sections = Map<String, dynamic>.from(text);
        _put(_whyTitle, sections['mengapa_memilih'], ['judul']);
        _put(_whyDesc, sections['mengapa_memilih'], ['deskripsi']);
        _put(_learnTitle, sections['lingkungan_belajar'], ['judul']);
        _put(_learnDesc, sections['lingkungan_belajar'], ['deskripsi']);
        _put(_learnImage, sections['lingkungan_belajar'], ['gambar']);
        _put(_jadwalCatatan, sections['jadwal'], ['catatan']);
        _put(_biayaDesc, sections['biaya'], ['deskripsi']);
        _put(_callHours, sections['tanya_panitia'], ['jam_layanan']);
        _put(_ctaLabel, sections['cta_bawah'], ['label']);
        _put(_ctaTitle, sections['cta_bawah'], ['judul']);
        _put(_ctaDesc, sections['cta_bawah'], ['deskripsi']);
        _put(_sectionFlow, sections['label'], ['alur']);
        _put(_sectionRequirements, sections['label'], ['persyaratan']);
        _put(_sectionDownloads, sections['label'], ['dokumen']);
        _put(_sectionSchedule, sections['label'], ['jadwal']);
        _put(_sectionCosts, sections['label'], ['biaya']);
        _put(_sectionScholarships, sections['label'], ['beasiswa']);
        _put(_sectionFacilities, sections['label'], ['fasilitas']);
        _put(_sectionTestimonials, sections['label'], ['testimoni']);
        _put(_sectionFaq, sections['label'], ['faq']);
        _put(_buttonRegister, sections['tombol'], ['daftar']);
        _put(_buttonConsult, sections['tombol'], ['konsultasi']);
        _put(_buttonProfile, sections['tombol'], ['profil']);
        _put(_buttonDownload, sections['tombol'], ['unduh']);
        _put(_buttonCostConsult, sections['tombol'], ['konsultasi_biaya']);
        _put(_buttonChat, sections['tombol'], ['chat']);
        _put(_buttonContact, sections['tombol'], ['hubungi']);
      }
      _mergeList(_why, _frontendData['mengapa_memilih']);
      _mergeList(_learning, _frontendData['lingkungan_belajar']);
      _mergeList(_flow, _frontendData['alur_pendaftaran']);
      _mergeList(_requirements, _frontendData['persyaratan']);
      _mergeList(_downloads, _frontendData['dokumen_unduhan']);
      _mergeList(_schedule, _frontendData['jadwal']);
      _mergeList(_costs, _frontendData['biaya']);
      _mergeList(_scholarships, _frontendData['beasiswa']);
      _mergeList(_facilities, _frontendData['fasilitas']);
      _mergeList(_testimonials, _frontendData['testimoni']);
      _mergeList(_faqs, _frontendData['faq']);
    } catch (_) {
      // Payload lama atau kosong tetap memakai data frontend yang sudah ada.
    }
  }

  void _mergeList(List<Map<String, dynamic>> target, dynamic source) {
    if (source is! List) return;
    for (var i = 0; i < source.length; i++) {
      if (source[i] is! Map) continue;
      final next = Map<String, dynamic>.from(source[i] as Map);
      final key = ['judul', 'nama', 'pertanyaan', 'tanggal']
          .map((k) => _s(next[k]))
          .firstWhere((v) => v.isNotEmpty, orElse: () => '');
      var index = key.isEmpty
          ? -1
          : target.indexWhere(
              (item) => ['judul', 'nama', 'pertanyaan', 'tanggal']
                  .any((k) => _s(item[k]) == key),
            );
      if (index < 0 && i < target.length) index = i;
      if (index < 0) {
        target.add(next);
      } else {
        next.forEach((k, v) {
          if (_s(v).isNotEmpty) target[index][k] = v;
        });
      }
    }
  }

  Map<String, dynamic> _payload() {
    final text = Map<String, dynamic>.from(
      (_frontendData['teks_bagian'] as Map?) ?? const {},
    );
    text['mengapa_memilih'] = {
      'judul': _whyTitle.text.trim(), 'deskripsi': _whyDesc.text.trim(),
    };
    text['lingkungan_belajar'] = {
      'judul': _learnTitle.text.trim(), 'deskripsi': _learnDesc.text.trim(),
      'gambar': _learnImage.text.trim(),
    };
    text['jadwal'] = {'catatan': _jadwalCatatan.text.trim()};
    text['biaya'] = {'deskripsi': _biayaDesc.text.trim()};
    text['tanya_panitia'] = {
      'jam_layanan': _callHours.text.trim(),
    };
    text['cta_bawah'] = {
      'label': _ctaLabel.text.trim(), 'judul': _ctaTitle.text.trim(),
      'deskripsi': _ctaDesc.text.trim(),
    };
    text['label'] = {'alur': _sectionFlow.text.trim(), 'persyaratan': _sectionRequirements.text.trim(), 'dokumen': _sectionDownloads.text.trim(), 'jadwal': _sectionSchedule.text.trim(), 'biaya': _sectionCosts.text.trim(), 'beasiswa': _sectionScholarships.text.trim(), 'fasilitas': _sectionFacilities.text.trim(), 'testimoni': _sectionTestimonials.text.trim(), 'faq': _sectionFaq.text.trim()};
    text['tombol'] = {'daftar': _buttonRegister.text.trim(), 'konsultasi': _buttonConsult.text.trim(), 'profil': _buttonProfile.text.trim(), 'unduh': _buttonDownload.text.trim(), 'konsultasi_biaya': _buttonCostConsult.text.trim(), 'chat': _buttonChat.text.trim(), 'hubungi': _buttonContact.text.trim()};
    return {
      ..._frontendData,
      'hero': {
        'label': 'PPDB ${_tahun.text.trim()}', 'judul': _judul.text.trim(),
        'deskripsi': _subjudul.text.trim(), 'status': _status.text.trim(),
        'gambar': _heroImage.text.trim(),
      },
      'ringkasan': {
        'judul': 'PPDB Tahun Ajaran ${_tahun.text.trim()}',
        'gelombang': _gelombang.text.trim(), 'periode': _periode.text.trim(),
        'kuota': _kuota.text.trim(), 'jenjang': _jenjang.text.trim(),
        'kontak': _kontak.text.trim(),
      },
      'teks_bagian': text,
      'mengapa_memilih': _why,
      'lingkungan_belajar': _learning,
      'alur_pendaftaran': _flow,
      'persyaratan': _requirements,
      'dokumen_unduhan': _downloads,
      'jadwal': _schedule,
      'biaya': _costs,
      'beasiswa': _scholarships,
      'fasilitas': _facilities,
      'testimoni': _testimonials,
      'faq': _faqs,
    };
  }

  void _put(
    TextEditingController c,
    Map<String, dynamic> r,
    List<String> keys,
  ) {
    for (final k in keys) {
      if (_s(r[k]).isNotEmpty) {
        c.text = _s(r[k]);
        return;
      }
    }
  }

  Future<void> _saveMain() async {
    setState(() => _saving = true);
    try {
      await widget.api.save('ppdb', {
        'tahun_ajaran': _tahun.text.trim(),
        'judul': _judul.text.trim(),
        'deskripsi': _subjudul.text.trim(),
        'status_pendaftaran': _status.text.trim(),
        'link_pendaftaran': _daftarUrl.text.trim(),
        'whatsapp': _wa.text.trim(),
        'gelombang': _gelombang.text.trim(),
        'periode': _periode.text.trim(),
        'kuota': _kuota.text.trim(),
        'jenjang': _jenjang.text.trim(),
        'kontak_ppdb': _kontak.text.trim(),
        'frontend_data': jsonEncode(_payload()),
      }, id: _id);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengaturan utama PPDB berhasil disimpan.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan PPDB: $e')));
      }
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 22),
          _section(
            '1',
            'Hero & Status PPDB',
            'Status, tahun ajaran, tombol daftar, dan WhatsApp pada hero.',
            Column(
              children: [
                _responsiveFields([
                  _field(_tahun, 'Tahun Ajaran'),
                  _field(_status, 'Status Pendaftaran'),
                ]),
                const SizedBox(height: 14),
                _field(_judul, 'Judul Hero'),
                const SizedBox(height: 14),
                _field(_subjudul, 'Deskripsi Hero', maxLines: 3),
                const SizedBox(height: 14),
                _imagePicker(_heroImage, title: 'Gambar Hero PPDB'),
                const SizedBox(height: 14),
                _responsiveFields([
                  _field(_daftarUrl, 'Link Pendaftaran'),
                  _field(_wa, 'WhatsApp Panitia'),
                ]),
              ],
            ),
          ),
          _gap(),
          _section(
            '2',
            'Ringkasan PPDB',
            'Gelombang, periode, kuota, jenjang, dan kontak PPDB.',
            Column(
              children: [
                _responsiveFields([
                  _field(_gelombang, 'Gelombang'),
                  _field(_periode, 'Periode'),
                ]),
                const SizedBox(height: 14),
                _responsiveFields([
                  _field(_kuota, 'Kuota'),
                  _field(_jenjang, 'Jenjang'),
                  _field(_kontak, 'Kontak PPDB'),
                ]),
              ],
            ),
          ),
          _gap(),
          _section(
            '3',
            'Mengapa Memilih SMAK?',
            'Judul, pengantar, dan kartu keunggulan.',
            Column(
              children: [
                _field(_whyTitle, 'Judul Section'),
                const SizedBox(height: 12),
                _field(_whyDesc, 'Deskripsi', maxLines: 2),
                const SizedBox(height: 16),
                _list('Keunggulan', _why, ['judul', 'deskripsi']),
              ],
            ),
          ),
          _gap(),
          _section(
            '4',
            'Lingkungan Belajar',
            'Konten section foto besar dan poin lingkungan belajar.',
            Column(
              children: [
                _field(_learnTitle, 'Judul'),
                const SizedBox(height: 12),
                _field(_learnDesc, 'Deskripsi', maxLines: 3),
                const SizedBox(height: 12),
                _imagePicker(_learnImage),
                const SizedBox(height: 16),
                _list('Poin Lingkungan', _learning, ['judul', 'deskripsi']),
              ],
            ),
          ),
          _gap(),
          _section(
            '5',
            'Alur Pendaftaran',
            'Tahapan pendaftaran mengikuti urutan daftar.',
            _list('Tahap', _flow, ['judul', 'deskripsi'], numbered: true),
          ),
          _gap(),
          _section(
            '6',
            'Persyaratan Pendaftaran',
            'Kelompok dokumen dan item persyaratan.',
            _list('Persyaratan', _requirements, ['kategori', 'judul']),
          ),
          _gap(),
          _section(
            '7',
            'Dokumen yang Dapat Diunduh',
            'Brosur, formulir, panduan, dan file PPDB.',
            _list('Dokumen', _downloads, ['judul', 'deskripsi', 'file_url']),
          ),
          _gap(),
          _section(
            '8',
            'Jadwal PPDB',
            'Timeline jadwal dan catatan perubahan jadwal.',
            Column(
              children: [
                _list('Jadwal', _schedule, [
                  'tanggal',
                  'judul',
                  'deskripsi',
                ], numbered: true),
                const SizedBox(height: 14),
                _field(_jadwalCatatan, 'Catatan Jadwal', maxLines: 2),
              ],
            ),
          ),
          _gap(),
          _section(
            '9',
            'Biaya & Beasiswa',
            'Biaya pendidikan dan program bantuan.',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(_biayaDesc, 'Pengantar Biaya', maxLines: 3),
                const SizedBox(height: 16),
                _sub('Biaya Pendidikan'),
                _list('Biaya', _costs, ['judul', 'nilai']),
                const SizedBox(height: 18),
                _sub('Beasiswa & Bantuan'),
                _list('Beasiswa', _scholarships, ['judul', 'deskripsi']),
              ],
            ),
          ),
          _gap(),
          _section(
            '10',
            'Fasilitas',
            'Fasilitas pendukung yang muncul pada halaman PPDB.',
            _list('Fasilitas', _facilities, ['judul', 'deskripsi']),
          ),
          _gap(),
          _section(
            '11',
            'Cerita dari Keluarga SMAK',
            'Testimoni. Jika belum ada data asli, section ini nantinya bisa dikosongkan.',
            _list('Testimoni', _testimonials, ['nama', 'peran', 'kutipan']),
          ),
          _gap(),
          _section(
            '12',
            'FAQ & Kontak Bantuan',
            'Pertanyaan umum dan jam layanan call center.',
            Column(
              children: [
                _list('FAQ', _faqs, ['pertanyaan', 'jawaban']),
                const SizedBox(height: 14),
                _field(_callHours, 'Jam Layanan Call Center'),
              ],
            ),
          ),
          _gap(),
          _section(
            '13',
            'CTA Penutup',
            'Ajakan mendaftar di bagian paling bawah.',
            Column(
              children: [
                _field(_ctaLabel, 'Label'),
                const SizedBox(height: 12),
                _field(_ctaTitle, 'Judul CTA'),
                const SizedBox(height: 12),
              _field(_ctaDesc, 'Deskripsi CTA', maxLines: 3),
              const SizedBox(height: 12),
              _field(_sectionFlow, 'Judul Section Alur'),
              const SizedBox(height: 12),
              _field(_sectionRequirements, 'Judul Section Persyaratan'),
              const SizedBox(height: 12),
              _field(_sectionDownloads, 'Judul Section Dokumen'),
              const SizedBox(height: 12),
              _field(_sectionSchedule, 'Judul Section Jadwal'),
              const SizedBox(height: 12),
              _field(_sectionCosts, 'Judul Section Biaya'),
              const SizedBox(height: 12),
              _field(_sectionScholarships, 'Judul Section Beasiswa'),
              const SizedBox(height: 12),
              _field(_sectionFacilities, 'Judul Section Fasilitas'),
              const SizedBox(height: 12),
              _field(_sectionTestimonials, 'Judul Section Testimoni'),
              const SizedBox(height: 12),
              _field(_sectionFaq, 'Judul Section FAQ'),
              const SizedBox(height: 12),
              _field(_buttonRegister, 'Teks Tombol Daftar'),
              const SizedBox(height: 12),
              _field(_buttonConsult, 'Teks Tombol Konsultasi'),
              const SizedBox(height: 12),
              _field(_buttonProfile, 'Teks Tombol Profil'),
              const SizedBox(height: 12),
              _field(_buttonDownload, 'Teks Tombol Unduh'),
              const SizedBox(height: 12),
              _field(_buttonCostConsult, 'Teks Tombol Konsultasi Biaya'),
              const SizedBox(height: 12),
              _field(_buttonChat, 'Teks Tombol Chat'),
              const SizedBox(height: 12),
              _field(_buttonContact, 'Teks Tombol Hubungi'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _saveBar(),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 18);

  Widget _responsiveFields(List<Widget> fields) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 680) {
        return Column(
          children: [
            for (var index = 0; index < fields.length; index++) ...[
              fields[index],
              if (index != fields.length - 1) const SizedBox(height: 14),
            ],
          ],
        );
      }
      return Row(
        children: [
          for (var index = 0; index < fields.length; index++) ...[
            Expanded(child: fields[index]),
            if (index != fields.length - 1) const SizedBox(width: 14),
          ],
        ],
      );
    },
  );

  Widget _header() => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 760;
      final title = Row(children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _blue.withOpacity(.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.how_to_reg_rounded, color: _blue),
      ),
      const SizedBox(width: 14),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PPDB',
              style: TextStyle(
                color: _text,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Kelola seluruh konten Penerimaan Peserta Didik Baru.',
              style: TextStyle(color: _muted, fontSize: 13),
            ),
          ],
        ),
      ),
      ]);
      final actions = Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [OutlinedButton.icon(
        onPressed: () => _openAdminPreview(context, const PpdbPage()),
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('Preview Halaman'),
      ),
      OutlinedButton.icon(
        onPressed: _load,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Muat Ulang'),
      ),
      ]);
      return compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [title, const SizedBox(height: 14), actions],
            )
          : Row(children: [Expanded(child: title), actions]);
    },
  );

  Widget _section(String n, String title, String note, Widget child) =>
      Container(
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
                    n,
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

  Widget _field(TextEditingController c, String label, {int maxLines = 1}) =>
      AdminContentTextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFFBFCFE),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

  Future<String?> _pickAndUploadFile({required bool image}) async {
    final input = html.FileUploadInputElement()
      ..accept = image
          ? 'image/jpeg,image/png,image/webp'
          : '.pdf,application/pdf,.doc,.docx,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    input.click();
    await input.onChange.first;
    if (input.files == null || input.files!.isEmpty) return null;
    return widget.api.uploadFile('ppdb', input.files!.first);
  }

  String _fileUrl(String value) {
    final path = value.trim();
    if (path.startsWith('assets/')) return path;
    return widget.api.getFileUrl(path);
  }

  String _fileName(String value) {
    final path = value.trim();
    if (path.isEmpty) return 'Belum ada file dipilih';
    return path.split('?').first.split('/').last;
  }

  Widget _imagePicker(
    TextEditingController controller, {
    String title = 'Gambar Lingkungan Belajar',
  }) => _AdminMediaUploadPanel(
    title: title,
    pickLabel: controller.text.trim().isEmpty ? 'Pilih Gambar' : 'Ganti Gambar',
    emptyLabel: 'Belum ada gambar dipilih',
    fileName: controller.text.trim(),
    onPick: () async {
      final filename = await _pickAndUploadFile(image: true);
      if (filename != null && mounted) setState(() => controller.text = filename);
    },
    onClear: () => setState(controller.clear),
    preview: controller.text.trim().isEmpty
        ? null
        : websiteContentImage(controller.text.trim(), fit: BoxFit.cover),
  );

  Widget _documentPicker(
    TextEditingController controller,
    void Function(void Function()) modalSetState,
  ) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: controller,
    builder: (_, __, ___) => _AdminMediaUploadPanel(
      title: 'Dokumen Unduhan',
      pickLabel: controller.text.trim().isEmpty ? 'Pilih File' : 'Ganti File',
      emptyLabel: 'Belum ada file dipilih',
      fileName: controller.text.trim(),
      isDocument: true,
      urlField: AdminContentTextField(controller: controller, constraint: AdminContentConstraint.url, decoration: const InputDecoration(labelText: 'Link / File', hintText: 'URL eksternal atau file yang di-upload', border: OutlineInputBorder())),
      onPick: () async {
        final filename = await _pickAndUploadFile(image: false);
        if (filename != null) modalSetState(() => controller.text = filename);
      },
      onOpen: () => html.window.open(_fileUrl(controller.text), '_blank'),
      onClear: () => modalSetState(controller.clear),
    ),
  );

  Widget _sub(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(
        color: _text,
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
    ),
  );

  Widget _list(
    String name,
    List<Map<String, dynamic>> list,
    List<String> fields, {
    bool numbered = false,
  }) => Column(
    children: [
      for (var i = 0; i < list.length; i++) ...[
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFCFE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _line),
          ),
          child: Row(
            children: [
              if (numbered) ...[
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(list[i], fields),
                      style: const TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (_subtitle(list[i], fields).isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _subtitle(list[i], fields),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _editor(name, list, fields, row: list[i]),
                icon: const Icon(Icons.edit_outlined, color: _blue),
              ),
              IconButton(
                onPressed: () => setState(() => list.remove(list[i])),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
      ],
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => _editor(name, list, fields),
          icon: const Icon(Icons.add_rounded),
          label: Text('Tambah $name'),
        ),
      ),
    ],
  );

  Future<void> _editor(
    String name,
    List<Map<String, dynamic>> list,
    List<String> fields, {
    Map<String, dynamic>? row,
  }) async {
    final item = row == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(row);
    final cs = {
      for (final f in fields) f: TextEditingController(text: _s(item[f])),
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, modalSetState) => AlertDialog(
          title: Text(row == null ? 'Tambah $name' : 'Edit $name'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < fields.length; i++) ...[
                    if (fields[i] == 'file_url')
                      _documentPicker(cs[fields[i]]!, modalSetState)
                    else
                      AdminContentTextField(
                        controller: cs[fields[i]],
                        maxLines: ['deskripsi', 'kutipan', 'jawaban'].contains(fields[i]) ? 4 : 1,
                        decoration: InputDecoration(
                          labelText: _label(fields[i]),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    if (i < fields.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Simpan')),
          ],
        ),
      ),
    );
    if (ok == true) {
      for (final f in fields) item[f] = cs[f]!.text.trim();
      setState(() {
        if (row == null)
          list.add(item);
        else {
          final i = list.indexOf(row);
          if (i >= 0) list[i] = item;
        }
      });
    }
    for (final c in cs.values) c.dispose();
  }

  String _label(String f) =>
      const {
        'judul': 'Judul',
        'deskripsi': 'Deskripsi',
        'kategori': 'Kategori',
        'file_url': 'Link / File',
        'tanggal': 'Tanggal',
        'nilai': 'Nilai / Keterangan',
        'nama': 'Nama',
        'peran': 'Peran',
        'kutipan': 'Testimoni',
        'pertanyaan': 'Pertanyaan',
        'jawaban': 'Jawaban',
      }[f] ??
      f;

  String _title(Map<String, dynamic> r, List<String> f) {
    for (final k in ['judul', 'pertanyaan', 'nama', 'kategori', 'tanggal'])
      if (f.contains(k) && _s(r[k]).isNotEmpty) return _s(r[k]);
    return 'Data';
  }

  String _subtitle(Map<String, dynamic> r, List<String> f) {
    final title = _title(r, f);
    for (final k in [
      'deskripsi',
      'jawaban',
      'kutipan',
      'nilai',
      'peran',
      'judul',
    ])
      if (f.contains(k) && _s(r[k]).isNotEmpty && _s(r[k]) != title)
        return _s(r[k]);
    return '';
  }

  Widget _saveBar() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _line),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        const message = Text(
          'Struktur admin mengikuti frontend PPDB terbaru yang kamu kirim.',
          style: TextStyle(color: _muted, fontSize: 13),
        );
        final button = FilledButton.icon(
          onPressed: _saving ? null : _saveMain,
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
        );
        return constraints.maxWidth < 600
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [message, const SizedBox(height: 14), button],
              )
            : Row(children: [const Expanded(child: message), button]);
      },
    ),
  );
}
