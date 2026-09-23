import 'package:flutter/material.dart';

import '../../site_chrome.dart';
import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';
import '../../../routing/public_routes.dart';

const _blue = Color(0xFF0756C8);
const _navy = Color(0xFF082F6B);
const _text = Color(0xFF0D3267);
const _muted = Color(0xFF63758D);
const _background = Color(0xFFF4F8FD);
const _line = Color(0xFFDCE7F4);
const _gold = Color(0xFFD39A19);

class StrukturOrganisasiPage extends StatefulWidget {
  const StrukturOrganisasiPage({super.key});

  @override
  State<StrukturOrganisasiPage> createState() => _StrukturOrganisasiPageState();
}

class _StrukturOrganisasiPageState extends State<StrukturOrganisasiPage> {
  String _teacherFilter = 'Semua';
  late final Future<_StrukturData> _data = _StrukturData.load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SharedSmakNavigationBar(
              profilePages: {},
              academicPages: {},
              studentPages: {},
              initialActive: 'Profil',
            ),
            FutureBuilder<_StrukturData>(
              future: _data,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 520,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final data = snapshot.data!;
                return Column(
                  children: [
                    _OrganizationHero(main: data.main),
                    _PageContent(
                      data: data,
                      teacherFilter: _teacherFilter,
                      onFilterChanged: (value) =>
                          setState(() => _teacherFilter = value),
                    ),
                  ],
                );
              },
            ),
            SharedSmakFooter(
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

class _OrganizationHero extends StatelessWidget {
  const _OrganizationHero({required this.main});

  final Map<String, dynamic> main;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 800;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: compact ? 360 : 280),
      color: _navy,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (!compact)
                  const Expanded(flex: 38, child: ColoredBox(color: _navy)),
                Expanded(
                  flex: compact ? 1 : 62,
                  child: _StructureImage(
                    image: '${main['banner'] ?? ''}',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    fallback: Container(
                      color: const Color(0xFF315F94),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 80),
                      child: const Icon(
                        Icons.groups_rounded,
                        size: 130,
                        color: Color(0x44FFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: compact ? const [0, .7, 1] : const [0, .38, .62, 1],
                  colors: compact
                      ? [
                          _navy.withOpacity(.94),
                          _navy.withOpacity(.72),
                          _navy.withOpacity(.35),
                        ]
                      : [
                          _navy,
                          _navy,
                          _navy.withOpacity(.68),
                          _navy.withOpacity(.12),
                        ],
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 22 : 28,
                  vertical: 34,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${main['breadcrumb'] ?? ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${main['judul'] ?? ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          '${main['deskripsi'] ?? ''}',
                          style: TextStyle(
                            color: Color(0xFFEAF3FF),
                            fontSize: 15,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
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

class _PageContent extends StatelessWidget {
  const _PageContent({
    required this.data,
    required this.teacherFilter,
    required this.onFilterChanged,
  });

  final _StrukturData data;
  final String teacherFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final filteredTeachers = teacherFilter == 'Semua'
        ? data.teachers
        : data.teachers
              .where((person) => person.group == teacherFilter)
              .toList();
    final bagan = data.section('bagan');
    final pimpinan = data.section('pimpinan');
    final guru = data.section('guru');
    final karyawan = data.section('karyawan');

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1220),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 42),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _SectionHeader(
                        title: '${bagan['judul'] ?? ''}',
                        subtitle: '${bagan['deskripsi'] ?? ''}',
                        centered: true,
                      ),
                      const SizedBox(height: 22),
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: _OrganizationChart(nodes: data.nodes),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 38),
              _SectionHeader(
                title: '${pimpinan['judul'] ?? ''}',
                subtitle: '${pimpinan['deskripsi'] ?? ''}',
              ),
              const SizedBox(height: 18),
              _ResponsiveGrid(
                minItemWidth: 330,
                itemAspectRatio: 2.55,
                children: data.leaders
                    .map((person) => _LeaderCard(person: person))
                    .toList(),
              ),
              const SizedBox(height: 42),
              _SectionHeader(
                title: '${guru['judul'] ?? ''}',
                subtitle: '${guru['deskripsi'] ?? ''}',
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: data.filters.map((filter) {
                  final selected = teacherFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) => onFilterChanged(filter),
                    selectedColor: _blue,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: _line),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : _text,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _ResponsiveGrid(
                  key: ValueKey(teacherFilter),
                  minItemWidth: 245,
                  itemAspectRatio: 2.05,
                  children: filteredTeachers
                      .map((person) => _PersonCard(person: person))
                      .toList(),
                ),
              ),
              const SizedBox(height: 42),
              _SectionHeader(
                title: '${karyawan['judul'] ?? ''}',
                subtitle: '${karyawan['deskripsi'] ?? ''}',
              ),
              const SizedBox(height: 18),
              _ResponsiveGrid(
                minItemWidth: 245,
                itemAspectRatio: 2.05,
                children: data.employees
                    .map((person) => _PersonCard(person: person))
                    .toList(),
              ),
              const SizedBox(height: 38),
              _StatisticsStrip(statistics: data.statistics),
              const SizedBox(height: 24),
              _ClosingCallout(cta: data.cta),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrganizationChart extends StatelessWidget {
  const _OrganizationChart({required this.nodes});

  final List<_ChartData> nodes;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;

    return _WhiteCard(
      padding: EdgeInsets.all(compact ? 18 : 28),
      child: Column(
        children: [
          if (nodes.where((node) => node.level == 0).isNotEmpty)
            _ChartPerson(
              name: nodes.firstWhere((node) => node.level == 0).name,
              role: nodes.firstWhere((node) => node.level == 0).role,
              image: nodes.firstWhere((node) => node.level == 0).image,
              featured: true,
            ),
          const _VerticalConnector(),
          _ChartLevel(
            compact: compact,
            people: nodes.where((node) => node.level == 1).toList(),
          ),
          const _VerticalConnector(),
          _ChartLevel(
            compact: compact,
            people: nodes.where((node) => node.level == 2).toList(),
          ),
          const _VerticalConnector(),
          _ChartLevel(
            compact: compact,
            simple: true,
            people: nodes.where((node) => node.level >= 3).toList(),
          ),
        ],
      ),
    );
  }
}

class _ChartLevel extends StatelessWidget {
  const _ChartLevel({
    required this.people,
    required this.compact,
    this.simple = false,
  });

  final List<_ChartData> people;
  final bool compact;
  final bool simple;

  @override
  Widget build(BuildContext context) {
    final cards = people
        .map(
          (person) => simple
              ? _SimpleChartNode(data: person)
              : _ChartPerson(
                  name: person.name,
                  role: person.role,
                  image: person.image,
                ),
        )
        .toList();

    if (compact) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: cards
            .map((card) => SizedBox(width: simple ? 150 : 210, child: card))
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < cards.length; index++) ...[
          Expanded(child: cards[index]),
          if (index != cards.length - 1) const SizedBox(width: 14),
        ],
      ],
    );
  }
}

class _ChartPerson extends StatelessWidget {
  const _ChartPerson({
    required this.name,
    required this.role,
    required this.image,
    this.featured = false,
  });

  final String name;
  final String role;
  final String image;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: featured ? 300 : 250),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: featured ? const Color(0xFFF2F7FF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: featured ? _blue : _line,
          width: featured ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0A326B),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Avatar(image: image, size: featured ? 72 : 58),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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

class _SimpleChartNode extends StatelessWidget {
  const _SimpleChartNode({required this.data});

  final _ChartData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF2FE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon ?? Icons.account_tree_rounded,
              color: _blue,
              size: 23,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            data.role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _text,
              height: 1.25,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalConnector extends StatelessWidget {
  const _VerticalConnector();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 28,
      margin: const EdgeInsets.symmetric(vertical: 3),
      color: const Color(0xFF71A8F5),
    );
  }
}

class _LeaderCard extends StatelessWidget {
  const _LeaderCard({required this.person});

  final _Person person;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          _Avatar(image: person.image, size: 84),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  person.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  person.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({required this.person});

  final _Person person;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _Avatar(image: person.image, size: 72),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  person.role,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _blue,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.image, required this.size});

  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE7F0FC),
        border: Border.all(color: const Color(0xFFBBD3F4), width: 2),
      ),
      child: image.isEmpty
          ? const Icon(Icons.person_rounded, color: _blue)
          : _StructureImage(
              image: image,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              fallback: const Icon(
                Icons.person_rounded,
                color: _blue,
                size: 34,
              ),
            ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({
    super.key,
    required this.children,
    required this.minItemWidth,
    required this.itemAspectRatio,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double itemAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / minItemWidth)
            .floor()
            .clamp(1, 4)
            .toInt();
        return GridView.count(
          crossAxisCount: count,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: itemAspectRatio,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}

class _StatisticsStrip extends StatelessWidget {
  const _StatisticsStrip({required this.statistics});

  final List<_StatisticData> statistics;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runAlignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 20,
        children: statistics
            .map(
              (item) =>
                  _Statistic(item.icon, item.value, item.label, item.color),
            )
            .toList(),
      ),
    );
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic(this.icon, this.value, this.label, this.color);

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: _text,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClosingCallout extends StatelessWidget {
  const _ClosingCallout({required this.cta});

  final Map<String, dynamic> cta;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    final message = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${cta['judul'] ?? ''}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '${cta['deskripsi'] ?? ''}',
          style: TextStyle(color: Color(0xFFE7F1FF), height: 1.5),
        ),
      ],
    );
    final contactButton = OutlinedButton.icon(
      onPressed: () =>
          publicRootNavigator(context).pushNamed(PublicRoutes.contact),
      icon: Icon(Icons.chat_rounded, color: Colors.white),
      label: Text(
        '${cta['teks_tombol'] ?? ''}',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: Colors.white)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_navy, Color(0xFF075ACB)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.diversity_3_rounded, color: Colors.white, size: 46),
                SizedBox(height: 14),
                message,
                SizedBox(height: 18),
                contactButton,
              ],
            )
          : Row(
              children: [
                Icon(Icons.diversity_3_rounded, color: Colors.white, size: 46),
                SizedBox(width: 18),
                Expanded(child: message),
                SizedBox(width: 24),
                contactButton,
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.centered = false,
  });

  final String title;
  final String subtitle;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: centered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              color: _text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: const TextStyle(color: _muted, height: 1.45, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5ECF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C0A2E63),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ChartData {
  const _ChartData(
    this.name,
    this.role,
    this.image, [
    this.icon,
    this.level = 0,
  ]);

  final String name;
  final String role;
  final String image;
  final IconData? icon;
  final int level;

  factory _ChartData.fromRow(Map<String, dynamic> row) => _ChartData(
    '${row['nama'] ?? ''}',
    '${row['jabatan'] ?? ''}',
    '${row['gambar'] ?? ''}',
    _iconFromName('${row['icon'] ?? ''}'),
    int.tryParse('${row['level_bagan'] ?? ''}') ?? 0,
  );
}

class _Person {
  const _Person({
    required this.name,
    required this.role,
    required this.image,
    this.detail = '',
    this.group = 'Guru Mata Pelajaran',
  });

  final String name;
  final String role;
  final String image;
  final String detail;
  final String group;

  factory _Person.fromLeaderRow(Map<String, dynamic> row) => _Person(
    name: '${row['nama'] ?? ''}',
    role: '${row['jabatan'] ?? ''}',
    detail: '${row['keterangan'] ?? ''}',
    image: '${row['gambar'] ?? ''}',
  );

  factory _Person.fromTeacherRow(Map<String, dynamic> row) => _Person(
    name: '${row['nama'] ?? ''}',
    role: '${row['mata_pelajaran'] ?? ''}',
    group: '${row['kategori'] ?? ''}',
    image: '${row['gambar'] ?? ''}',
  );

  factory _Person.fromEmployeeRow(Map<String, dynamic> row) => _Person(
    name: '${row['nama'] ?? ''}',
    role: '${row['jabatan'] ?? ''}',
    image: '${row['gambar'] ?? ''}',
  );
}

class _StatisticData {
  const _StatisticData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  factory _StatisticData.fromRow(Map<String, dynamic> row) => _StatisticData(
    label: '${row['label'] ?? ''}',
    value: '${row['nilai'] ?? ''}',
    icon: _iconFromName('${row['icon'] ?? ''}'),
    color: '${row['warna']}' == 'gold' ? _gold : _blue,
  );
}

class _StrukturData {
  const _StrukturData({
    required this.main,
    required this.sections,
    required this.nodes,
    required this.leaders,
    required this.teachers,
    required this.employees,
    required this.filters,
    required this.statistics,
    required this.cta,
  });

  final Map<String, dynamic> main;
  final List<Map<String, dynamic>> sections;
  final List<_ChartData> nodes;
  final List<_Person> leaders;
  final List<_Person> teachers;
  final List<_Person> employees;
  final List<String> filters;
  final List<_StatisticData> statistics;
  final Map<String, dynamic> cta;

  Map<String, dynamic> section(String code) => sections.firstWhere(
    (item) => '${item['kode']}' == code,
    orElse: () => const {},
  );

  static Future<_StrukturData> load() async {
    const api = SmakApi();
    final rows = await Future.wait([
      api.getTable('struktur_utama', limit: 1),
      api.getTable('struktur_bagian', limit: 20),
      api.getTable('struktur_bagan', limit: 100),
      api.getTable('struktur_pimpinan', limit: 100),
      api.getTable('struktur_guru', limit: 100),
      api.getTable('struktur_karyawan', limit: 100),
      api.getTable('struktur_kategori_guru', limit: 20),
      api.getTable('struktur_statistik', limit: 20),
      api.getTable('struktur_cta', limit: 1),
    ]);
    return _StrukturData(
      main: rows[0].isEmpty ? const {} : rows[0].first,
      sections: rows[1],
      nodes: rows[2].map(_ChartData.fromRow).toList(),
      leaders: rows[3].map(_Person.fromLeaderRow).toList(),
      teachers: rows[4].map(_Person.fromTeacherRow).toList(),
      employees: rows[5].map(_Person.fromEmployeeRow).toList(),
      filters: rows[6].map((row) => '${row['nama'] ?? ''}').toList(),
      statistics: rows[7].map(_StatisticData.fromRow).toList(),
      cta: rows[8].isEmpty ? const {} : rows[8].first,
    );
  }
}

class _StructureImage extends StatelessWidget {
  const _StructureImage({
    required this.image,
    required this.fit,
    required this.alignment,
    required this.fallback,
  });

  final String image;
  final BoxFit fit;
  final Alignment alignment;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    if (websiteUsesFallbackImage(image)) {
      return websiteFallbackImage(fit: fit);
    }
    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    return Image.network(
      const SmakApi().getFileUrl(image),
      fit: fit,
      alignment: alignment,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

IconData _iconFromName(String value) {
  switch (value) {
    case 'school':
      return Icons.school_rounded;
    case 'work':
      return Icons.work_rounded;
    case 'workspace_premium':
      return Icons.workspace_premium_rounded;
    case 'groups':
      return Icons.groups_rounded;
    case 'psychology':
      return Icons.psychology_rounded;
    case 'science':
      return Icons.science_rounded;
    case 'menu_book':
      return Icons.menu_book_rounded;
    case 'diversity_3':
      return Icons.diversity_3_rounded;
    default:
      return Icons.account_tree_rounded;
  }
}

const _filters = [
  'Semua',
  'Guru Mata Pelajaran',
  'Wali Kelas',
  'Bimbingan Konseling',
];

const _leaders = <_Person>[
  _Person(
    name: 'Drs. Andreas Prasetyo',
    role: 'Kepala Sekolah',
    detail: 'Manajemen Pendidikan',
    image: 'assets/images/staff/kepala_sekolah.jpg',
  ),
  _Person(
    name: 'Maria Magdalena, S.Pd.',
    role: 'Komite Sekolah',
    detail: 'Pendidikan Katolik',
    image: 'assets/images/staff/komite_sekolah.jpg',
  ),
  _Person(
    name: 'Stefanus Budi, S.E.',
    role: 'Kepala Tata Usaha',
    detail: 'Manajemen Administrasi',
    image: 'assets/images/staff/kepala_tu.jpg',
  ),
  _Person(
    name: 'Lucia Handayani, S.Pd.',
    role: 'Waka Kurikulum',
    detail: 'Kurikulum & Pembelajaran',
    image: 'assets/images/staff/waka_kurikulum.jpg',
  ),
  _Person(
    name: 'Yohanes Ardi, S.Pd.',
    role: 'Waka Kesiswaan',
    detail: 'Kesiswaan & Pembinaan',
    image: 'assets/images/staff/waka_kesiswaan.jpg',
  ),
  _Person(
    name: 'Veronika Lestari, S.S.',
    role: 'Waka Humas',
    detail: 'Hubungan Masyarakat',
    image: 'assets/images/staff/waka_humas.jpg',
  ),
];

const _teachers = <_Person>[
  _Person(
    name: 'Maria Cecilia, S.Pd.',
    role: 'Bahasa Indonesia',
    image: 'assets/images/staff/guru_01.jpg',
  ),
  _Person(
    name: 'Antonius Wibowo, S.Pd.',
    role: 'Matematika',
    image: 'assets/images/staff/guru_02.jpg',
  ),
  _Person(
    name: 'Theresia Indah, S.Pd.',
    role: 'Bahasa Inggris',
    image: 'assets/images/staff/guru_03.jpg',
    group: 'Wali Kelas',
  ),
  _Person(
    name: 'Fransiskus Dimas, S.Si.',
    role: 'Fisika',
    image: 'assets/images/staff/guru_04.jpg',
  ),
  _Person(
    name: 'Bernadeta Ayu, S.Pd.',
    role: 'Biologi',
    image: 'assets/images/staff/guru_05.jpg',
  ),
  _Person(
    name: 'Ignatius Rangga, S.Pd.',
    role: 'Kimia',
    image: 'assets/images/staff/guru_06.jpg',
  ),
  _Person(
    name: 'Monika Sari, S.Pd.',
    role: 'Ekonomi',
    image: 'assets/images/staff/guru_07.jpg',
    group: 'Wali Kelas',
  ),
  _Person(
    name: 'Petrus Yudha, S.Pd.',
    role: 'Sejarah',
    image: 'assets/images/staff/guru_08.jpg',
  ),
  _Person(
    name: 'Agnes Viviana, S.Kom.',
    role: 'Informatika',
    image: 'assets/images/staff/guru_09.jpg',
  ),
  _Person(
    name: 'Paulus Kumino, S.Ag.',
    role: 'Pendidikan Agama',
    image: 'assets/images/staff/guru_10.jpg',
  ),
  _Person(
    name: 'Yohanes Daniel, S.Pd.',
    role: 'PJOK',
    image: 'assets/images/staff/guru_11.jpg',
    group: 'Bimbingan Konseling',
  ),
  _Person(
    name: 'Elisabeth Wulan, S.Sn.',
    role: 'Seni Budaya',
    image: 'assets/images/staff/guru_12.jpg',
  ),
];

const _employees = <_Person>[
  _Person(
    name: 'Rina Susanti',
    role: 'Tata Usaha',
    image: 'assets/images/staff/karyawan_01.jpg',
  ),
  _Person(
    name: 'Dewi Lestari, A.Md.',
    role: 'Administrasi Akademik',
    image: 'assets/images/staff/karyawan_02.jpg',
  ),
  _Person(
    name: 'Bagus Prayoga',
    role: 'Operator Sekolah',
    image: 'assets/images/staff/karyawan_03.jpg',
  ),
  _Person(
    name: 'Yohana Fitri, S.I.Pust.',
    role: 'Pustakawan',
    image: 'assets/images/staff/karyawan_04.jpg',
  ),
  _Person(
    name: 'Alfonsus Joko',
    role: 'Laboran',
    image: 'assets/images/staff/karyawan_05.jpg',
  ),
  _Person(
    name: 'Slamet Riyadi',
    role: 'Keamanan',
    image: 'assets/images/staff/karyawan_06.jpg',
  ),
  _Person(
    name: 'Siti Aminah',
    role: 'Kebersihan',
    image: 'assets/images/staff/karyawan_07.jpg',
  ),
  _Person(
    name: 'Eko Budi Santoso',
    role: 'Teknisi',
    image: 'assets/images/staff/karyawan_08.jpg',
  ),
];
