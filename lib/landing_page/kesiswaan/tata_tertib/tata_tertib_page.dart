import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../site_chrome.dart';

const _blue = Color(0xFF0756C8);
const _navy = Color(0xFF083A7C);
const _text = Color(0xFF0B326B);
const _muted = Color(0xFF63748E);
const _background = Color(0xFFF5F8FD);
const _line = Color(0xFFE2EAF4);
const _gold = Color(0xFFF2B313);
const _green = Color(0xFF2E9B4B);

class TataTertibPage extends StatefulWidget {
  const TataTertibPage({super.key});

  @override
  State<TataTertibPage> createState() => _TataTertibPageState();
}

class _TataTertibPageState extends State<TataTertibPage> {
  int _selectedCategory = 0;
  Map<String, dynamic> _data = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await const SmakApi().getTable('tatib_konten', limit: 1);
      if (rows.isEmpty || !mounted) return;
      final data = jsonDecode('${rows.first['data_json'] ?? '{}'}');
      if (data is Map<String, dynamic>) setState(() => _data = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: _TatibDataScope(
        data: _data,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SharedSmakNavigationBar(
                profilePages: sharedProfilePages(),
                academicPages: sharedAcademicPages(),
                studentPages: sharedStudentPages(),
                initialActive: 'Kesiswaan',
              ),
              const _RulesHero(),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 760;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          compact ? 18 : 34,
                          compact ? 34 : 48,
                          compact ? 18 : 34,
                          compact ? 42 : 56,
                        ),
                        child: Column(
                          children: [
                            const _PageIntroduction(),
                            const SizedBox(height: 30),
                            const _SummaryStrip(),
                            const SizedBox(height: 28),
                            const _GeneralAndPrincipleSection(),
                            const SizedBox(height: 38),
                            _CategorySection(
                              selectedIndex: _selectedCategory,
                              onSelected: (index) =>
                                  setState(() => _selectedCategory = index),
                            ),
                            const SizedBox(height: 42),
                            const _RightsAndDutiesSection(),
                            const SizedBox(height: 44),
                            const _GuidanceSection(),
                            const SizedBox(height: 34),
                            const _SeriousViolationNotice(),
                            const SizedBox(height: 28),
                            const _DocumentAndHelpSection(),
                            const SizedBox(height: 24),
                            const _CommitmentStrip(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SharedSmakFooter(
                profilePages: sharedProfilePages(),
                academicPages: sharedAcademicPages(),
                studentPages: sharedStudentPages(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TatibDataScope extends InheritedWidget {
  const _TatibDataScope({required this.data, required super.child});
  final Map<String, dynamic> data;
  static Map<String, dynamic> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TatibDataScope>()?.data ??
      const {};
  @override
  bool updateShouldNotify(_TatibDataScope oldWidget) => data != oldWidget.data;
}

String _tatib(BuildContext context, String key, String fallback) {
  final value = _TatibDataScope.of(context)[key];
  return value == null || '$value'.trim().isEmpty ? fallback : '$value';
}

List<String> _tatibStrings(
  BuildContext context,
  String key,
  List<String> fallback,
) {
  final value = _TatibDataScope.of(context)[key];
  if (value is! List || value.isEmpty) return fallback;
  return value.map((item) => '$item').toList();
}

List<Map<String, dynamic>> _tatibMaps(BuildContext context, String key) {
  final value = _TatibDataScope.of(context)[key];
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

class _RulesHero extends StatelessWidget {
  const _RulesHero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return SizedBox(
      width: double.infinity,
      height: compact ? 310 : 290,
      child: Stack(
        fit: StackFit.expand,
        children: [
          websiteContentImage(
            _tatib(context, 'hero_image', ''),
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xF2083A7C),
                  Color(0xD6083A7C),
                  Color(0x66083A7C),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 24 : 46),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 590,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beranda  ›  Kesiswaan  ›  Tata Tertib',
                          style: TextStyle(
                            color: Color(0xFFDCE9FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          _tatib(context, 'hero_title', 'Tata Tertib Siswa'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            height: 1.08,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 11),
                        SizedBox(
                          width: 54,
                          child: Divider(color: _gold, thickness: 3),
                        ),
                        SizedBox(height: 12),
                        Text(
                          _tatib(
                            context,
                            'hero_subtitle',
                            'Pedoman untuk membangun lingkungan belajar yang tertib, aman, disiplin, dan berkarakter.',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.65,
                          ),
                        ),
                      ],
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

class _PageIntroduction extends StatelessWidget {
  const _PageIntroduction();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        _tatib(context, 'intro_title', 'Tata Tertib Siswa'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _text,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 10),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Text(
          _tatib(
            context,
            'intro',
            'Tata tertib sekolah merupakan pedoman bersama untuk membentuk pribadi yang bertanggung jawab, saling menghormati, dan siap menjadi pembelajar sepanjang hayat.',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, height: 1.65),
        ),
      ),
    ],
  );
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip();

  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryData(
        Icons.calendar_month_rounded,
        'Tahun Ajaran',
        _tatib(context, 'year', '2026/2027'),
        _blue,
      ),
      _SummaryData(
        Icons.groups_rounded,
        'Berlaku untuk',
        _tatib(context, 'applies', 'Seluruh Siswa'),
        _green,
      ),
      _SummaryData(
        Icons.update_rounded,
        'Pembaruan',
        _tatib(context, 'updated', '10 Agustus 2026'),
        Color(0xFFD89700),
      ),
      _SummaryData(
        Icons.verified_user_rounded,
        'Dokumen Resmi',
        _tatib(context, 'status', 'Sekolah'),
        _blue,
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: _whiteCard(radius: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 620
              ? 1
              : constraints.maxWidth < 900
              ? 2
              : 4;
          final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
          return Wrap(
            spacing: 12,
            runSpacing: 16,
            children: items
                .map(
                  (item) => SizedBox(
                    width: width,
                    child: _SummaryItem(data: item),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _GeneralAndPrincipleSection extends StatelessWidget {
  const _GeneralAndPrincipleSection();

  @override
  Widget build(BuildContext context) {
    final rules = _tatibStrings(context, 'general', const [
      'Hadir tepat waktu sesuai jadwal kegiatan sekolah.',
      'Memakai seragam sesuai ketentuan yang berlaku.',
      'Menjaga kesopanan, sopan santun, dan menghormati sesama.',
      'Mengikuti pembelajaran dengan tertib dan penuh tanggung jawab.',
      'Menjaga kebersihan, kerapian, dan kelestarian fasilitas sekolah.',
      'Membawa perlengkapan belajar sesuai kebutuhan.',
    ]);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final general = Container(
          padding: const EdgeInsets.all(24),
          decoration: _whiteCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleWithIcon(
                icon: Icons.description_rounded,
                title: _tatib(context, 'label_general', 'Ketentuan Umum'),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                rules.length,
                (index) => _NumberedRule(number: index + 1, text: rules[index]),
              ),
            ],
          ),
        );
        const principle = _PrincipleCard();
        if (compact) {
          return Column(
            children: [general, const SizedBox(height: 18), principle],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: general),
            const SizedBox(width: 18),
            const Expanded(flex: 4, child: principle),
          ],
        );
      },
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(26),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_navy, _blue],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _tatib(context, 'label_principle', 'Prinsip Utama'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        websiteLogoImage(
          width: 82,
          height: 82,
        ),
        const SizedBox(height: 18),
        Text(
          _tatib(
            context,
            'principle',
            'Disiplin  •  Tanggung Jawab\nHormat  •  Peduli',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            height: 1.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _tatib(
            context,
            'principle_desc',
            'Nilai yang menjadi dasar perilaku dan keputusan warga sekolah dalam mewujudkan karakter unggul.',
          ),
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFDCE9FF), height: 1.55),
        ),
      ],
    ),
  );
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const fallbackCategories = [
    _CategoryData(
      Icons.event_available_rounded,
      'Kehadiran',
      [
        'Siswa hadir minimal 10 menit sebelum pelajaran dimulai.',
        'Keterlambatan wajib dilaporkan kepada guru piket.',
        'Mengikuti apel pagi dan kegiatan wajib sekolah.',
      ],
      'Prosedur Izin/Tidak Hadir',
      [
        'Sampaikan izin kepada wali kelas sebelum kegiatan dimulai.',
        'Orang tua mengirimkan keterangan resmi.',
        'Izin lebih dari tiga hari dilengkapi surat keterangan.',
      ],
    ),
    _CategoryData(
      Icons.checkroom_rounded,
      'Seragam & Kerapian',
      [
        'Memakai seragam sesuai jadwal dan ketentuan sekolah.',
        'Menjaga kebersihan serta kerapian diri.',
        'Menggunakan atribut sekolah secara lengkap.',
      ],
      'Penampilan Siswa',
      [
        'Rambut ditata rapi dan tidak berlebihan.',
        'Tidak menggunakan aksesori yang mengganggu pembelajaran.',
        'Sepatu dan perlengkapan disesuaikan dengan kegiatan.',
      ],
    ),
    _CategoryData(
      Icons.handshake_rounded,
      'Perilaku & Etika',
      [
        'Bersikap santun kepada guru, karyawan, dan sesama siswa.',
        'Menjaga ucapan serta perilaku di sekolah maupun media sosial.',
        'Menghargai perbedaan dan tidak melakukan perundungan.',
      ],
      'Etika Pergaulan',
      [
        'Menyelesaikan perbedaan melalui komunikasi yang baik.',
        'Menjaga nama baik diri, keluarga, dan sekolah.',
        'Mengutamakan kejujuran serta tanggung jawab.',
      ],
    ),
    _CategoryData(
      Icons.auto_stories_rounded,
      'Kegiatan Belajar',
      [
        'Mengikuti pelajaran dengan aktif dan tertib.',
        'Mengerjakan tugas dengan jujur dan tepat waktu.',
        'Membawa buku serta perlengkapan sesuai jadwal.',
      ],
      'Penggunaan Perangkat',
      [
        'Perangkat digital digunakan atas izin guru.',
        'Tidak mengakses konten di luar kebutuhan belajar.',
        'Menjaga perangkat dan fasilitas pembelajaran.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rows = _tatibMaps(context, 'categories');
    final categories = rows.isEmpty
        ? fallbackCategories
        : List.generate(rows.length, (index) {
            final row = rows[index];
            List<String> list(String key) => row[key] is List
                ? (row[key] as List).map((item) => '$item').toList()
                : const [];
            return _CategoryData(
              const [
                Icons.event_available_rounded,
                Icons.checkroom_rounded,
                Icons.handshake_rounded,
                Icons.auto_stories_rounded,
              ][index % 4],
              '${row['title'] ?? ''}',
              list('a'),
              '${row['secondary'] ?? ''}',
              list('b'),
            );
          });
    final selected = categories[selectedIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Tata Tertib',
          style: TextStyle(
            color: _text,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                categories.length,
                (index) => _CategoryTab(
                  data: categories[index],
                  active: index == selectedIndex,
                  onTap: () => onSelected(index),
                ),
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _CategoryDetail(key: ValueKey(selectedIndex), data: selected),
        ),
      ],
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.data,
    required this.active,
    required this.onTap,
  });
  final _CategoryData data;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      constraints: const BoxConstraints(minWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: active ? _blue : Colors.white,
        border: Border.all(color: active ? _blue : _line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(data.icon, color: active ? Colors.white : _blue, size: 21),
          const SizedBox(width: 9),
          Text(
            data.title,
            style: TextStyle(
              color: active ? Colors.white : _text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _CategoryDetail extends StatelessWidget {
  const _CategoryDetail({super.key, required this.data});
  final _CategoryData data;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFF8BB8F3)),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(14),
        bottomRight: Radius.circular(14),
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final left = _RuleList(
          title: data.title,
          items: data.primaryRules,
          icon: data.icon,
        );
        final right = _RuleList(
          title: data.secondaryTitle,
          items: data.secondaryRules,
          icon: Icons.info_outline_rounded,
        );
        if (compact) {
          return Column(children: [left, const SizedBox(height: 22), right]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 30),
            Expanded(child: right),
          ],
        );
      },
    ),
  );
}

class _RightsAndDutiesSection extends StatelessWidget {
  const _RightsAndDutiesSection();

  @override
  Widget build(BuildContext context) {
    final rights = _tatibStrings(context, 'rights', const [
      'Memperoleh pembelajaran yang berkualitas.',
      'Mendapat rasa aman dan nyaman di sekolah.',
      'Memperoleh bimbingan dan konseling.',
      'Menggunakan fasilitas sekolah dengan layak.',
      'Menyampaikan pendapat dengan santun.',
    ]);
    final duties = _tatibStrings(context, 'duties', const [
      'Menaati semua peraturan sekolah.',
      'Menjaga nama baik diri, keluarga, dan sekolah.',
      'Mengikuti kegiatan sekolah dengan sungguh-sungguh.',
      'Merawat fasilitas sekolah dengan tanggung jawab.',
      'Menghargai seluruh warga sekolah.',
    ]);
    return Column(
      children: [
        _SectionHeading(title: _tatib(context, 'label_rights_duties', 'Hak dan Kewajiban Siswa')),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            final rightCard = _ChecklistCard(
              title: _tatib(context, 'label_rights', 'Hak Siswa'),
              icon: Icons.verified_user_rounded,
              color: _blue,
              items: rights,
            );
            final dutyCard = _ChecklistCard(
              title: _tatib(context, 'label_duties', 'Kewajiban Siswa'),
              icon: Icons.assignment_turned_in_rounded,
              color: _green,
              items: duties,
            );
            if (compact) {
              return Column(
                children: [rightCard, const SizedBox(height: 18), dutyCard],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: rightCard),
                const SizedBox(width: 18),
                Expanded(child: dutyCard),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _GuidanceSection extends StatelessWidget {
  const _GuidanceSection();

  @override
  Widget build(BuildContext context) {
    const fallbackItems = [
      _GuidanceData(
        Icons.notifications_active_rounded,
        'Pengingat',
        'Nasihat persuasif oleh guru atau piket.',
      ),
      _GuidanceData(
        Icons.person_rounded,
        'Pembinaan Wali Kelas',
        'Pendampingan untuk memahami dan memperbaiki diri.',
      ),
      _GuidanceData(
        Icons.volunteer_activism_rounded,
        'Pendampingan BK',
        'Mencari solusi serta menguatkan karakter siswa.',
      ),
      _GuidanceData(
        Icons.groups_rounded,
        'Koordinasi Orang Tua',
        'Kerja sama demi perkembangan siswa yang optimal.',
      ),
    ];
    final rows = _tatibMaps(context, 'guidance');
    final items = rows.isEmpty
        ? fallbackItems
        : List.generate(
            rows.length,
            (index) => _GuidanceData(
              const [
                Icons.notifications_active_rounded,
                Icons.person_rounded,
                Icons.volunteer_activism_rounded,
                Icons.groups_rounded,
              ][index % 4],
              '${rows[index]['title'] ?? ''}',
              '${rows[index]['desc'] ?? ''}',
            ),
          );
    return Column(
      children: [
        _SectionHeading(title: _tatib(context, 'label_guidance', 'Pembinaan dan Tindak Lanjut')),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return Column(
                children: List.generate(
                  items.length,
                  (index) => _MobileGuidancePoint(
                    data: items[index],
                    showLine: index != items.length - 1,
                  ),
                ),
              );
            }
            return SizedBox(
              height: 172,
              child: Stack(
                children: [
                  Positioned(
                    left: constraints.maxWidth / 8,
                    right: constraints.maxWidth / 8,
                    top: 40,
                    child: Container(height: 3, color: const Color(0xFFB9D4FA)),
                  ),
                  Row(
                    children: items
                        .map(
                          (item) => Expanded(child: _GuidancePoint(data: item)),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            _tatib(
              context,
              'guidance_note',
              'Pendekatan sekolah bersifat edukatif dan restoratif untuk membantu siswa bertumbuh menjadi pribadi yang lebih baik.',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: _text, fontSize: 12.5),
          ),
        ),
      ],
    );
  }
}

class _SeriousViolationNotice extends StatelessWidget {
  const _SeriousViolationNotice();

  @override
  Widget build(BuildContext context) {
    final items = _tatibStrings(context, 'violations', const [
      'Perundungan dalam bentuk apa pun.',
      'Kekerasan fisik maupun verbal.',
      'Merokok, narkoba, dan minuman beralkohol.',
      'Membawa benda berbahaya.',
      'Merusak fasilitas sekolah.',
      'Tindakan yang mencemarkan nama sekolah.',
    ]);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1CC67)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final title = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFD89700),
                size: 45,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pelanggaran yang Perlu Dihindari',
                      style: TextStyle(
                        color: _text,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _tatib(
                        context,
                        'violation_desc',
                        'Pelanggaran serius ditangani sesuai peraturan sekolah dan ketentuan yang berlaku.',
                      ),
                      style: TextStyle(color: _muted, height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          );
          final rules = Wrap(
            spacing: 18,
            runSpacing: 10,
            children: items
                .map(
                  (item) => SizedBox(
                    width: compact
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 18) / 2,
                    child: _WarningItem(text: item),
                  ),
                )
                .toList(),
          );
          if (compact) {
            return Column(children: [title, const SizedBox(height: 18), rules]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: title),
              const SizedBox(width: 28),
              Expanded(flex: 6, child: rules),
            ],
          );
        },
      ),
    );
  }
}

class _DocumentAndHelpSection extends StatelessWidget {
  const _DocumentAndHelpSection();

  @override
  Widget build(BuildContext context) {
    final data = _TatibDataScope.of(context);
    final documentPath = '${data['pdf_url'] ?? data['pdf'] ?? ''}'.trim();
    final document = _InfoCard(
      icon: Icons.description_rounded,
      title: _tatib(context, 'label_document', 'Dokumen Tata Tertib'),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _line),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.red,
              size: 38,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    documentPath.isEmpty
                        ? 'Dokumen Tata Tertib'
                        : documentPath.split('/').last,
                    style: TextStyle(color: _text, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'PDF • Dokumen resmi sekolah',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (documentPath.isNotEmpty)
              FilledButton.icon(
                onPressed: () {
                  final url =
                      documentPath.startsWith('http://') ||
                          documentPath.startsWith('https://')
                      ? documentPath
                      : const SmakApi().getFileUrl(documentPath);
                  html.window.open(url, '_blank');
                },
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text(_tatib(context, 'button_download', 'Unduh PDF')),
              ),
          ],
        ),
      ),
    );
    final help = _InfoCard(
      icon: Icons.support_agent_rounded,
      title: _tatib(context, 'label_help', 'Butuh Penjelasan?'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tatib(
              context,
              'help',
              'Jika ada hal yang belum jelas, silakan hubungi wali kelas atau guru BK untuk memperoleh penjelasan lebih lanjut.',
            ),
            style: TextStyle(color: _muted, height: 1.55),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => openSharedLink(
              _tatib(context, 'contact', 'https://wa.me/628155099445'),
            ),
            icon: const Icon(Icons.call_rounded),
            label: Text(_tatib(context, 'button_contact', 'Hubungi Sekolah')),
            style: OutlinedButton.styleFrom(
              foregroundColor: _blue,
              side: const BorderSide(color: _blue),
            ),
          ),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 820) {
          return Column(children: [document, const SizedBox(height: 18), help]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: document),
            const SizedBox(width: 18),
            Expanded(child: help),
          ],
        );
      },
    );
  }
}

class _CommitmentStrip extends StatelessWidget {
  const _CommitmentStrip();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F1FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        websiteLogoImage(
          width: 52,
          height: 52,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _tatib(
                  context,
                  'commitment',
                  'Mari menciptakan lingkungan sekolah yang tertib, aman, nyaman, dan saling menghargai.',
                ),
                style: TextStyle(
                  color: _text,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _tatib(
                  context,
                  'commitment_sub',
                  'Bersama, kita membentuk generasi berkarakter dan berprestasi.',
                ),
                style: TextStyle(color: _muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.data});
  final _SummaryData data;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      children: [
        Icon(data.icon, color: data.color, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
              const SizedBox(height: 3),
              Text(
                data.value,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TitleWithIcon extends StatelessWidget {
  const _TitleWithIcon({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: _blue),
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(
          color: _text,
          fontSize: 21,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}

class _NumberedRule extends StatelessWidget {
  const _NumberedRule({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 25,
          height: 25,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
          child: Text(
            '$number',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: const TextStyle(color: _text, height: 1.45),
            ),
          ),
        ),
      ],
    ),
  );
}

class _RuleList extends StatelessWidget {
  const _RuleList({
    required this.title,
    required this.items,
    required this.icon,
  });
  final String title;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: _blue),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: _blue, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      ...items.map((item) => _BulletText(text: item)),
    ],
  );
}

class _BulletText extends StatelessWidget {
  const _BulletText({required this.text, this.color = _blue});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: _muted, height: 1.45),
          ),
        ),
      ],
    ),
  );
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: _whiteCard(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 62),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(color: _text, height: 1.4),
                        ),
                      ),
                    ],
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

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _text,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        width: 52,
        height: 3,
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    ],
  );
}

class _GuidancePoint extends StatelessWidget {
  const _GuidancePoint({required this.data});
  final _GuidanceData data;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_navy, _blue]),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Icon(data.icon, color: Colors.white, size: 35),
        ),
        const SizedBox(height: 12),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _blue, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _muted, height: 1.4, fontSize: 11.5),
        ),
      ],
    ),
  );
}

class _MobileGuidancePoint extends StatelessWidget {
  const _MobileGuidancePoint({required this.data, required this.showLine});
  final _GuidanceData data;
  final bool showLine;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 58,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: _blue,
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, color: Colors.white),
            ),
            if (showLine)
              Container(width: 3, height: 56, color: const Color(0xFFB9D4FA)),
          ],
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: _blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                data.description,
                style: const TextStyle(color: _muted, height: 1.45),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _WarningItem extends StatelessWidget {
  const _WarningItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.cancel_rounded, color: Color(0xFFE64747), size: 18),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text, style: const TextStyle(color: _text, height: 1.4)),
      ),
    ],
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: _whiteCard(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleWithIcon(icon: icon, title: title),
        const SizedBox(height: 18),
        child,
      ],
    ),
  );
}

class _SummaryData {
  const _SummaryData(this.icon, this.label, this.value, this.color);
  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _CategoryData {
  const _CategoryData(
    this.icon,
    this.title,
    this.primaryRules,
    this.secondaryTitle,
    this.secondaryRules,
  );
  final IconData icon;
  final String title;
  final List<String> primaryRules;
  final String secondaryTitle;
  final List<String> secondaryRules;
}

class _GuidanceData {
  const _GuidanceData(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

BoxDecoration _whiteCard({double radius = 16}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: _line),
  boxShadow: const [
    BoxShadow(color: Color(0x0D0B326B), blurRadius: 16, offset: Offset(0, 6)),
  ],
);
