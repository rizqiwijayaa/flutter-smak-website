part of '../admin_dashboard_page.dart';

class AdminVisiMisiPage extends StatefulWidget {
  const AdminVisiMisiPage({super.key, required this.api});
  final SmakApi api;

  @override
  State<AdminVisiMisiPage> createState() => _AdminVisiMisiPageState();
}

class _AdminVisiMisiPageState extends State<AdminVisiMisiPage> {
  late Future<List<Map<String, dynamic>>> _future;
  bool _saving = false;
  int? _id;
  final Map<String, Set<int>> _deletedIds = {};

  final _judul = TextEditingController(text: 'Visi & Misi');
  final _deskripsi = TextEditingController(
    text: 'Arah, tujuan, dan nilai yang menuntun perjalanan pendidikan SMAK.',
  );
  final _banner = TextEditingController();
  final _arahJudul = TextEditingController(text: 'Arah Pendidikan SMAK');
  final _arahDeskripsi = TextEditingController(
    text:
        'Visi dan misi kami menjadi kompas yang menuntun setiap langkah pendidikan di SMAK Mgr. Soegijapranata. Berlandaskan nilai-nilai iman Katolik, kami berkomitmen membentuk generasi yang utuh dalam iman, ilmu, dan kasih, siap menghadapi masa depan serta menjadi berkat bagi sesama.',
  );
  final _visi = TextEditingController(
    text:
        'Terwujudnya generasi yang beriman, berilmu, berkarakter, unggul, serta mampu menjadi terang bagi sesama.',
  );
  final _logo = TextEditingController();
  final _fotoKehidupan = TextEditingController();
  final _quote = TextEditingController(
    text:
        'Beriman dalam hati, berilmu dalam pikiran, berkarakter dalam tindakan, dan melayani dengan kasih.',
  );
  final _ctaTitle = TextEditingController(text: 'Bersama Mewujudkan Visi SMAK');
  final _ctaButton1 = TextEditingController(text: 'Lihat Profil Sekolah');
  final _ctaLink1 = TextEditingController(text: '/profil/identitas-sekolah');
  final _ctaButton2 = TextEditingController(text: 'Hubungi Kami');
  final _ctaLink2 = TextEditingController(text: 'https://wa.me/628155099445');

  final List<_VmItem> _makna = [
    _VmItem(
      'Beriman',
      'Berakar dalam iman Katolik dan mengandalkan Tuhan dalam setiap langkah.',
      Icons.favorite_border_rounded,
    ),
    _VmItem(
      'Berilmu',
      'Menguasai ilmu pengetahuan dan teknologi untuk kebaikan hidup.',
      Icons.menu_book_outlined,
    ),
    _VmItem(
      'Berkarakter',
      'Berpribadi luhur, jujur, disiplin, dan bertanggung jawab.',
      Icons.groups_outlined,
    ),
    _VmItem(
      'Unggul',
      'Berprestasi dan kompeten dalam akademik maupun non-akademik.',
      Icons.star_border_rounded,
    ),
    _VmItem(
      'Menjadi Terang',
      'Menginspirasi dan memberi manfaat bagi lingkungan dan sesama.',
      Icons.light_mode_outlined,
    ),
  ];

  final List<_VmItem> _misi = [
    _VmItem(
      'Pendidikan Berlandaskan Iman',
      'Menyelenggarakan pendidikan yang berlandaskan nilai-nilai iman Katolik untuk membentuk pribadi yang beriman, berakhlak, dan berintegritas.',
      Icons.church_outlined,
    ),
    _VmItem(
      'Pembelajaran Berkualitas',
      'Menyediakan pembelajaran yang berkualitas, inovatif, dan relevan untuk mengembangkan kompetensi akademik dan keterampilan abad 21.',
      Icons.menu_book_outlined,
    ),
    _VmItem(
      'Pembentukan Karakter',
      'Menanamkan nilai-nilai karakter positif seperti kejujuran, disiplin, tanggung jawab, dan kepedulian dalam kehidupan sehari-hari.',
      Icons.shield_outlined,
    ),
    _VmItem(
      'Pengembangan Potensi',
      'Mengembangkan potensi dan bakat siswa melalui berbagai kegiatan akademik, ekstrakurikuler, dan pembinaan diri.',
      Icons.auto_awesome_outlined,
    ),
    _VmItem(
      'Kepedulian Sosial',
      'Menumbuhkan kepedulian terhadap sesama dan lingkungan melalui aksi nyata dan pelayanan yang berkelanjutan.',
      Icons.volunteer_activism_outlined,
    ),
    _VmItem(
      'Wawasan Global',
      'Membekali siswa dengan wawasan global dan spiritualitas yang kuat agar siap menjadi warga dunia yang bertanggung jawab.',
      Icons.public_outlined,
    ),
  ];

  final List<_VmItem> _penerapan = [
    _VmItem(
      'Di Dalam Kelas',
      'Pendidikan terintegrasi nilai iman, ilmu, dan karakter dalam setiap pembelajaran.',
      Icons.school_outlined,
    ),
    _VmItem(
      'Dalam Kegiatan Siswa',
      'Kegiatan ekstrakurikuler dan pembinaan untuk mengembangkan potensi diri.',
      Icons.groups_outlined,
    ),
    _VmItem(
      'Dalam Pelayanan',
      'Melayani sesama melalui karya nyata dan kegiatan sosial yang bermakna.',
      Icons.volunteer_activism_outlined,
    ),
    _VmItem(
      'Dalam Kebersamaan',
      'Membangun komunitas sekolah yang saling menghargai dan mendukung.',
      Icons.people_outline_rounded,
    ),
  ];

  final List<_VmItem> _nilai = [
    _VmItem(
      'Iman',
      'Kepercayaan yang hidup dan menjadi sumber kekuatan dalam bertindak.',
      Icons.church_outlined,
    ),
    _VmItem(
      'Integritas',
      'Kejujuran, konsistensi, dan keteladanan dalam setiap perilaku.',
      Icons.shield_outlined,
    ),
    _VmItem(
      'Disiplin',
      'Taat aturan, menghargai waktu, dan bertanggung jawab.',
      Icons.schedule_outlined,
    ),
    _VmItem(
      'Kasih',
      'Mengasihi Tuhan, sesama, dan alam ciptaan dengan tulus.',
      Icons.favorite_border_rounded,
    ),
    _VmItem(
      'Tanggung Jawab',
      'Menjalankan tugas dengan sungguh-sungguh dan dapat diandalkan.',
      Icons.groups_outlined,
    ),
    _VmItem(
      'Keunggulan',
      'Berusaha memberikan yang terbaik dalam setiap kesempatan.',
      Icons.workspace_premium_outlined,
    ),
  ];

  final List<_VmItem> _tindakan = [
    _VmItem(
      'Memahami',
      'Memahami nilai dan makna dalam kehidupan.',
      Icons.psychology_outlined,
    ),
    _VmItem(
      'Menghayati',
      'Menghayati nilai dan menjadikannya bagian diri.',
      Icons.favorite_border_rounded,
    ),
    _VmItem(
      'Melakukan',
      'Mengamalkan nilai dalam tindakan nyata setiap hari.',
      Icons.volunteer_activism_outlined,
    ),
    _VmItem(
      'Menginspirasi',
      'Menjadi teladan dan menginspirasi orang lain.',
      Icons.star_border_rounded,
    ),
  ];

  final List<_VmItem> _sasaran = [
    _VmItem(
      'Pribadi Utuh',
      'Membentuk pribadi beriman, berkarakter, sehat, dan seimbang secara intelektual, emosional, sosial, dan spiritual.',
      Icons.person_outline_rounded,
    ),
    _VmItem(
      'Prestasi Berkelanjutan',
      'Meraih prestasi akademik dan non-akademik secara berkelanjutan dengan semangat pantang menyerah dan cinta belajar.',
      Icons.emoji_events_outlined,
    ),
    _VmItem(
      'Kontribusi bagi Masyarakat',
      'Menjadi pribadi yang peduli, melayani, dan memberikan kontribusi positif bagi masyarakat, bangsa, dan dunia.',
      Icons.groups_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final results = await Future.wait([
      widget.api.getTable('visi_utama', limit: 1),
      widget.api.getTable('visi_makna', limit: 100),
      widget.api.getTable('visi_misi', limit: 100),
      widget.api.getTable('visi_penerapan', limit: 100),
      widget.api.getTable('visi_nilai', limit: 100),
      widget.api.getTable('visi_tindakan', limit: 100),
      widget.api.getTable('visi_sasaran', limit: 100),
      widget.api.getTable('visi_cta', limit: 1),
    ]);

    final utama = results[0];
    if (utama.isNotEmpty) {
      final r = utama.first;
      _id = int.tryParse('${r['id'] ?? ''}');
      _setIfPresent(_judul, r, ['judul', 'title']);
      _setIfPresent(_deskripsi, r, ['deskripsi', 'subtitle', 'subjudul']);
      _setIfPresent(_banner, r, ['banner', 'gambar', 'foto']);
      _setIfPresent(_arahJudul, r, ['arah_judul', 'label', 'subjudul']);
      _setIfPresent(_arahDeskripsi, r, [
        'arah_deskripsi',
        'isi',
        'deskripsi_arah',
      ]);
      _setIfPresent(_visi, r, ['visi', 'isi_visi', 'value']);
      _setIfPresent(_logo, r, ['logo', 'lambang']);
      _setIfPresent(_fotoKehidupan, r, ['foto_kehidupan', 'gambar_kehidupan']);
      _setIfPresent(_quote, r, ['quote', 'kutipan']);
    }

    _replaceItems(_makna, results[1], _iconForMakna);
    _replaceItems(_misi, results[2], _iconForMisi);
    _replaceItems(_penerapan, results[3], _iconForPenerapan);
    _replaceItems(_nilai, results[4], _iconForNilai);
    _replaceItems(_tindakan, results[5], _iconForTindakan);
    _replaceItems(_sasaran, results[6], _iconForSasaran);

    final cta = results[7];
    if (cta.isNotEmpty) {
      final r = cta.first;
      _setIfPresent(_ctaTitle, r, ['judul']);
      _setIfPresent(_quote, r, ['deskripsi', 'quote', 'kutipan']);
      _setIfPresent(_ctaButton1, r, ['teks_tombol_1']);
      _setIfPresent(_ctaLink1, r, ['link_tombol_1']);
      _setIfPresent(_ctaButton2, r, ['teks_tombol_2']);
      _setIfPresent(_ctaLink2, r, ['link_tombol_2']);
      if (_logo.text.trim().isEmpty) {
        _setIfPresent(_logo, r, ['gambar', 'logo']);
      }
    }

    return utama;
  }

  void _replaceItems(
    List<_VmItem> target,
    List<Map<String, dynamic>> rows,
    IconData Function(String, int) iconBuilder,
  ) {
    if (rows.isEmpty) return;

    rows.sort((a, b) {
      final ao = int.tryParse('${a['urutan'] ?? 0}') ?? 0;
      final bo = int.tryParse('${b['urutan'] ?? 0}') ?? 0;
      return ao.compareTo(bo);
    });

    target.clear();
    for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      final r = rows[rowIndex];
      final title = _plainText(r['judul'] ?? r['nama'] ?? r['title'] ?? '');
      final description = _plainText(
        r['deskripsi'] ?? r['isi'] ?? r['subtitle'] ?? '',
      );
      final iconKey = '${r['icon'] ?? ''}'.trim();
      final id = int.tryParse('${r['id'] ?? ''}');

      if (title.isNotEmpty) {
        target.add(
          _VmItem(
            title,
            description,
            iconBuilder(iconKey, target.length),
            id: id,
            iconKey: iconKey,
          ),
        );
      }
    }
  }

  IconData _iconForMakna(String key, int i) => switch (key) {
    'favorite' || 'favorite_border' => Icons.favorite_border_rounded,
    'book' || 'menu_book' => Icons.menu_book_rounded,
    'groups' || 'diversity_3' => Icons.diversity_3_rounded,
    'star' || 'star_border' => Icons.star_border_rounded,
    'light_mode' => Icons.light_mode_outlined,
    _ => const [
      Icons.favorite_border_rounded,
      Icons.menu_book_rounded,
      Icons.diversity_3_rounded,
      Icons.star_border_rounded,
      Icons.light_mode_outlined,
    ][i % 5],
  };

  IconData _iconForMisi(String key, int i) => switch (key) {
    'church' => Icons.church_rounded,
    'book' || 'menu_book' || 'school' => Icons.menu_book_rounded,
    'shield' || 'verified_user' => Icons.verified_user_outlined,
    'auto_awesome' => Icons.auto_awesome_rounded,
    'volunteer_activism' => Icons.volunteer_activism_rounded,
    'public' => Icons.public_rounded,
    _ => const [
      Icons.church_rounded,
      Icons.menu_book_rounded,
      Icons.verified_user_outlined,
      Icons.auto_awesome_rounded,
      Icons.volunteer_activism_rounded,
      Icons.public_rounded,
    ][i % 6],
  };

  IconData _iconForPenerapan(String key, int i) => Icons.school_rounded;

  IconData _iconForNilai(String key, int i) => switch (key) {
    'add' || 'church' => Icons.add_rounded,
    'shield' || 'verified_user' => Icons.verified_user_outlined,
    'schedule' => Icons.schedule_rounded,
    'favorite' || 'favorite_border' => Icons.favorite_border_rounded,
    'groups' => Icons.groups_rounded,
    'workspace_premium' => Icons.workspace_premium_rounded,
    _ => const [
      Icons.add_rounded,
      Icons.verified_user_outlined,
      Icons.schedule_rounded,
      Icons.favorite_border_rounded,
      Icons.groups_rounded,
      Icons.workspace_premium_rounded,
    ][i % 6],
  };

  IconData _iconForTindakan(String key, int i) => switch (key) {
    'psychology' || 'psychology_alt' => Icons.psychology_alt_rounded,
    'favorite' || 'favorite_border' => Icons.favorite_border_rounded,
    'volunteer_activism' => Icons.volunteer_activism_rounded,
    'star' || 'star_outline' => Icons.star_outline_rounded,
    _ => const [
      Icons.psychology_alt_rounded,
      Icons.favorite_border_rounded,
      Icons.volunteer_activism_rounded,
      Icons.star_outline_rounded,
    ][i % 4],
  };

  IconData _iconForSasaran(String key, int i) => switch (key) {
    'person' || 'person_outline' => Icons.person_outline_rounded,
    'emoji_events' => Icons.emoji_events_outlined,
    'groups' => Icons.groups_rounded,
    _ => const [
      Icons.person_outline_rounded,
      Icons.emoji_events_outlined,
      Icons.groups_rounded,
    ][i % 3],
  };

  String _plainText(dynamic raw) {
    var text = '${raw ?? ''}';
    if (text.trim().isEmpty) return '';

    // Data lama hasil migrasi pernah menyimpan rich-text/HTML di kolom teks.
    // Admin Visi & Misi memakai TextField biasa, jadi ubah menjadi plain text.
    text = text
        .replaceAll(RegExp(r'<br\\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p\\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</h[1-6]\\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), '• ')
        .replaceAll(RegExp(r'</li\\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    return text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n')
        .trim();
  }

  void _setIfPresent(
    TextEditingController c,
    Map<String, dynamic> row,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = row[key];
      if (value != null && '$value'.trim().isNotEmpty) {
        c.text = _plainText(value);
        return;
      }
    }
  }

  void _reload() {
    final nextFuture = _load();
    setState(() {
      _future = nextFuture;
    });
  }

  void _refreshEditor(VoidCallback change) {
    if (!mounted) return;
    setState(change);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.api.save('visi_utama', {
        'judul': _plainText(_judul.text),
        'deskripsi': _plainText(_deskripsi.text),
        'subjudul': _plainText(_deskripsi.text),
        'banner': _banner.text.trim(),
        'gambar': _banner.text.trim(),
        'arah_judul': _plainText(_arahJudul.text),
        'arah_deskripsi': _plainText(_arahDeskripsi.text),
        'visi': _plainText(_visi.text),
        'logo': _logo.text.trim(),
        'foto_kehidupan': _fotoKehidupan.text.trim(),
        'quote': _plainText(_quote.text),
        'status': 'aktif',
      }, id: _id);

      await _saveItems('visi_makna', _makna);
      await _saveItems('visi_misi', _misi);
      await _saveItems('visi_penerapan', _penerapan);
      await _saveItems('visi_nilai', _nilai);
      await _saveItems('visi_tindakan', _tindakan);
      await _saveItems('visi_sasaran', _sasaran);

      final ctaRows = await widget.api.getTable('visi_cta', limit: 1);
      final ctaId = ctaRows.isEmpty
          ? null
          : int.tryParse('${ctaRows.first['id'] ?? ''}');
      await widget.api.save('visi_cta', {
        'judul': _ctaTitle.text.trim(),
        'deskripsi': _plainText(_quote.text),
        'gambar': _logo.text.trim(),
        'teks_tombol_1': _ctaButton1.text.trim(),
        'link_tombol_1': _ctaLink1.text.trim(),
        'teks_tombol_2': _ctaButton2.text.trim(),
        'link_tombol_2': _ctaLink2.text.trim(),
        'status': 'aktif',
      }, id: ctaId);

      for (final entry in _deletedIds.entries) {
        for (final id in entry.value) {
          await widget.api.delete(entry.key, id);
        }
      }
      _deletedIds.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visi & Misi berhasil disimpan ke database.'),
        ),
      );
      _reload();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveItems(String table, List<_VmItem> items) async {
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      await widget.api.save(table, {
        'judul': _plainText(item.title),
        'nama': _plainText(item.title),
        'deskripsi': _plainText(item.description),
        'isi': _plainText(item.description),
        'icon': item.iconKey,
        'urutan': i + 1,
        'status': 'aktif',
      }, id: item.id);
    }
  }

  void _markDeleted(String table, _VmItem item) {
    if (item.id == null) return;
    (_deletedIds[table] ??= <int>{}).add(item.id!);
  }

  @override
  void dispose() {
    for (final c in [
      _judul,
      _deskripsi,
      _banner,
      _arahJudul,
      _arahDeskripsi,
      _visi,
      _logo,
      _fotoKehidupan,
      _quote,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: OutlinedButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
              ),
            );
          }
          return _VisiMisiEditor(state: this);
        },
      );
}

class _VisiMisiEditor extends StatelessWidget {
  const _VisiMisiEditor({required this.state});
  final _AdminVisiMisiPageState state;

  InputDecoration _decoration(String label, {IconData? icon}) =>
      InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        prefixIcon: icon == null ? null : Icon(icon, color: _blue, size: 19),
        filled: true,
        fillColor: const Color(0xFFF9FBFE),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _blue, width: 1.4),
        ),
      );

  Widget _field(
    TextEditingController c,
    String label, {
    int lines = 1,
    IconData? icon,
  }) => AdminContentTextField(
    controller: c,
    minLines: lines,
    maxLines: lines,
    decoration: _decoration(label, icon: icon),
  );

  Widget _section({
    required String number,
    required String title,
    required String info,
    required Widget child,
    Widget? action,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info,
                    style: const TextStyle(color: _muted, fontSize: 11.5),
                  ),
                ],
              ),
            ),
            if (action != null) action,
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );

  Widget _media(
    TextEditingController c,
    String empty, {
    double height = 135,
    IconData icon = Icons.image_outlined,
  }) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: c,
    builder: (context, value, _) => Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _blue, size: 34),
          const SizedBox(height: 7),
          Text(
            value.text.trim().isEmpty ? empty : value.text.trim(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );

  Future<void> _editItem(
    BuildContext context,
    List<_VmItem> list, {
    required String table,
    int? index,
  }) async {
    final old = index == null ? null : list[index];
    final title = TextEditingController(text: old?.title ?? '');
    final desc = TextEditingController(text: old?.description ?? '');
    final result = await showDialog<_VmItem>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Tambah Item' : 'Edit Item'),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdminContentTextField(controller: title, decoration: _decoration('Judul')),
              const SizedBox(height: 12),
              AdminContentTextField(
                controller: desc,
                minLines: 3,
                maxLines: 4,
                decoration: _decoration('Deskripsi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (title.text.trim().isEmpty) return;
              Navigator.pop(
                context,
                _VmItem(
                  title.text.trim(),
                  desc.text.trim(),
                  old?.icon ?? Icons.auto_awesome_outlined,
                  id: old?.id,
                  iconKey: old?.iconKey ?? '',
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    title.dispose();
    desc.dispose();
    if (result == null || !state.mounted) return;
    state._refreshEditor(() {
      if (index == null) {
        list.add(result);
      } else {
        list[index] = result;
      }
    });
  }

  Widget _cards(
    BuildContext context,
    List<_VmItem> items, {
    required String table,
    int columns = 3,
  }) => LayoutBuilder(
    builder: (context, c) {
      final cols = c.maxWidth < 600 ? 1 : (c.maxWidth < 900 ? 2 : columns);
      final width = (c.maxWidth - (cols - 1) * 10) / cols;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(items.length, (i) {
          final item = items[i];
          return SizedBox(
            width: width,
            child: Container(
              constraints: const BoxConstraints(minHeight: 112),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFEFF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _line),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: _blue, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 10.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            _editItem(context, items, table: table, index: i),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.edit_outlined,
                            color: _blue,
                            size: 16,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => state._refreshEditor(() {
                          state._markDeleted(table, item);
                          items.removeAt(i);
                        }),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFE53935),
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      );
    },
  );

  Widget _addButton(
    BuildContext context,
    String text,
    List<_VmItem> list,
    String table,
  ) => FilledButton.icon(
    onPressed: () => _editItem(context, list, table: table),
    style: FilledButton.styleFrom(backgroundColor: _blue),
    icon: const Icon(Icons.add_rounded, size: 17),
    label: Text(text),
  );

  Widget _imageActions(TextEditingController controller, String label) => Row(
    children: [
      Expanded(
        child: FilledButton(
          onPressed: state._saving
              ? null
              : () async {
                  final picker = html.FileUploadInputElement()
                    ..accept = 'image/jpeg,image/png,image/webp';
                  picker.click();
                  await picker.onChange.first;
                  final files = picker.files;
                  if (files == null || files.isEmpty) return;
                  state._refreshEditor(() => state._saving = true);
                  try {
                    final filename = await state.widget.api.uploadFile(
                      'visi_utama',
                      files.first,
                    );
                    controller.text = filename;
                  } catch (error) {
                    if (state.mounted) {
                      ScaffoldMessenger.of(state.context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal mengunggah gambar: $error'),
                        ),
                      );
                    }
                  } finally {
                    if (state.mounted) {
                      state._refreshEditor(() => state._saving = false);
                    }
                  }
                },
          child: Text(label),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: OutlinedButton(
          onPressed: () => controller.clear(),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE53935),
          ),
          child: const Text('Hapus'),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final s = state;
    final wide = MediaQuery.sizeOf(context).width > 1000;

    final hero = _section(
      number: '1',
      title: 'Banner / Hero',
      info: 'Atur tampilan bagian pembuka halaman.',
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _media(
                        s._banner,
                        'Belum ada gambar banner',
                        height: 150,
                        icon: Icons.panorama_outlined,
                      ),
                      const SizedBox(height: 9),
                      _imageActions(s._banner, 'Ganti Foto'),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 30,
                  child: Column(
                    children: [
                      _field(s._judul, 'Judul'),
                      const SizedBox(height: 10),
                      _field(s._deskripsi, 'Deskripsi', lines: 3),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gambar Banner',
                        style: TextStyle(
                          color: _text,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _media(s._banner, 'Preview banner', height: 100),
                      const SizedBox(height: 8),
                      _imageActions(s._banner, 'Ganti Foto'),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _media(s._banner, 'Belum ada gambar banner', height: 150),
                const SizedBox(height: 10),
                _imageActions(s._banner, 'Ganti Foto'),
                const SizedBox(height: 12),
                _field(s._judul, 'Judul'),
                const SizedBox(height: 10),
                _field(s._deskripsi, 'Deskripsi', lines: 3),
              ],
            ),
    );

    final direction = _section(
      number: '2',
      title: 'Arah Pendidikan SMAK',
      info: 'Deskripsi singkat arah pendidikan sekolah.',
      child: wide
          ? Row(
              children: [
                SizedBox(width: 250, child: _field(s._arahJudul, 'Judul')),
                const SizedBox(width: 16),
                Expanded(
                  child: _field(s._arahDeskripsi, 'Deskripsi', lines: 3),
                ),
              ],
            )
          : Column(
              children: [
                _field(s._arahJudul, 'Judul'),
                const SizedBox(height: 10),
                _field(s._arahDeskripsi, 'Deskripsi', lines: 3),
              ],
            ),
    );

    final vision = _section(
      number: '3',
      title: 'Visi Sekolah',
      info: 'Kelola visi utama sekolah.',
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 210,
                  child: Column(
                    children: [
                      _media(
                        s._logo,
                        'Logo / Lambang',
                        height: 115,
                        icon: Icons.shield_outlined,
                      ),
                      const SizedBox(height: 8),
                      _imageActions(s._logo, 'Ganti Logo'),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(child: _field(s._visi, 'Teks Visi', lines: 4)),
              ],
            )
          : Column(
              children: [
                _media(s._logo, 'Logo / Lambang', height: 110),
                const SizedBox(height: 8),
                _imageActions(s._logo, 'Ganti Logo'),
                const SizedBox(height: 12),
                _field(s._visi, 'Teks Visi', lines: 4),
              ],
            ),
    );

    final sections = <Widget>[
      hero,
      direction,
      vision,
      _section(
        number: '4',
        title: 'Makna dari Visi Kami',
        info: 'Kelola daftar makna atau nilai turunan dari visi.',
        action: _addButton(context, 'Tambah Makna', s._makna, 'visi_makna'),
        child: _cards(context, s._makna, table: 'visi_makna', columns: 5),
      ),
      _section(
        number: '5',
        title: 'Misi Sekolah',
        info: 'Kelola daftar misi sekolah.',
        action: _addButton(context, 'Tambah Misi', s._misi, 'visi_misi'),
        child: _cards(context, s._misi, table: 'visi_misi', columns: 2),
      ),
      _section(
        number: '6',
        title: 'Visi & Misi dalam Kehidupan Sekolah',
        info: 'Kelola penerapan visi & misi dalam kehidupan sekolah.',
        action: _addButton(
          context,
          'Tambah Penerapan',
          s._penerapan,
          'visi_penerapan',
        ),
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 320,
                    child: Column(
                      children: [
                        _media(
                          s._fotoKehidupan,
                          'Foto Kegiatan',
                          height: 145,
                          icon: Icons.photo_outlined,
                        ),
                        const SizedBox(height: 8),
                        _imageActions(s._fotoKehidupan, 'Ganti Foto'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _cards(
                      context,
                      s._penerapan,
                      table: 'visi_penerapan',
                      columns: 1,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _media(s._fotoKehidupan, 'Foto Kegiatan', height: 145),
                  const SizedBox(height: 8),
                  _imageActions(s._fotoKehidupan, 'Ganti Foto'),
                  const SizedBox(height: 12),
                  _cards(
                    context,
                    s._penerapan,
                    table: 'visi_penerapan',
                    columns: 1,
                  ),
                ],
              ),
      ),
      _section(
        number: '7',
        title: 'Nilai-Nilai Utama',
        info: 'Kelola nilai-nilai utama yang dipegang oleh sekolah.',
        action: _addButton(context, 'Tambah Nilai', s._nilai, 'visi_nilai'),
        child: _cards(context, s._nilai, table: 'visi_nilai', columns: 3),
      ),
      _section(
        number: '8',
        title: 'Dari Nilai Menjadi Tindakan',
        info: 'Kelola alur tindakan dari nilai.',
        action: _addButton(
          context,
          'Tambah Langkah',
          s._tindakan,
          'visi_tindakan',
        ),
        child: _cards(context, s._tindakan, table: 'visi_tindakan', columns: 4),
      ),
      _section(
        number: '9',
        title: 'Sasaran Pendidikan',
        info: 'Kelola sasaran pendidikan sekolah.',
        action: _addButton(
          context,
          'Tambah Sasaran',
          s._sasaran,
          'visi_sasaran',
        ),
        child: _cards(context, s._sasaran, table: 'visi_sasaran', columns: 3),
      ),
      _section(
        number: '10',
        title: 'Quote / Komitmen Sekolah',
        info: 'Atur quote atau komitmen penutup sekolah.',
        child: wide
            ? Row(
                children: [
                  SizedBox(
                    width: 210,
                    child: Column(
                      children: [
                        _media(
                          s._logo,
                          'Logo',
                          height: 90,
                          icon: Icons.shield_outlined,
                        ),
                        const SizedBox(height: 8),
                        _imageActions(s._logo, 'Ganti Logo'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Column(children: [
                    _field(s._ctaTitle, 'Judul CTA'),
                    const SizedBox(height: 10),
                    _field(s._quote, 'Teks Komitmen', lines: 3, icon: Icons.format_quote_rounded),
                    const SizedBox(height: 10),
                    Row(children: [Expanded(child: _field(s._ctaButton1, 'Teks Tombol 1')), const SizedBox(width: 10), Expanded(child: _field(s._ctaLink1, 'Link Tombol 1'))]),
                    const SizedBox(height: 10),
                    Row(children: [Expanded(child: _field(s._ctaButton2, 'Teks Tombol 2')), const SizedBox(width: 10), Expanded(child: _field(s._ctaLink2, 'Link Tombol 2'))]),
                  ])),
                ],
              )
            : Column(
                children: [
                  _field(s._ctaTitle, 'Judul CTA'),
                  const SizedBox(height: 10),
                  _field(s._quote, 'Teks Komitmen', lines: 3, icon: Icons.format_quote_rounded),
                  const SizedBox(height: 10),
                  _field(s._ctaButton1, 'Teks Tombol 1'),
                  const SizedBox(height: 10),
                  _field(s._ctaLink1, 'Link Tombol 1'),
                  const SizedBox(height: 10),
                  _field(s._ctaButton2, 'Teks Tombol 2'),
                  const SizedBox(height: 10),
                  _field(s._ctaLink2, 'Link Tombol 2'),
                ],
              ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final compact = c.maxWidth < 720;
            final heading = const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visi & Misi Sekolah',
                  style: TextStyle(
                    color: _text,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Profil Sekolah  ›  Visi & Misi Sekolah',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Kelola konten halaman Visi & Misi Sekolah yang ditampilkan di website.',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            );
            final actions = Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      _openAdminPreview(context, sharedProfilePages()['visi']!),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview Halaman'),
                ),
                FilledButton.icon(
                  onPressed: s._saving ? null : s._save,
                  icon: s._saving
                      ? const SizedBox.square(
                          dimension: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(s._saving ? 'Menyimpan...' : 'Simpan Perubahan'),
                ),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [heading, const SizedBox(height: 12), actions],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: heading),
                actions,
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < sections.length; i++) ...[
          sections[i],
          if (i != sections.length - 1) const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _line),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: _blue, size: 18),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Pastikan semua data sudah sesuai sebelum menyimpan perubahan.',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 285,
            child: FilledButton.icon(
              onPressed: s._saving ? null : s._save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan Semua Perubahan'),
            ),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _VmItem {
  _VmItem(
    this.title,
    this.description,
    this.icon, {
    this.id,
    this.iconKey = '',
  });

  final String title;
  final String description;
  final IconData icon;
  final int? id;
  final String iconKey;
}
