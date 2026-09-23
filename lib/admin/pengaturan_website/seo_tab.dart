part of '../admin_dashboard_page.dart';

class _SeoTab extends StatefulWidget {
  const _SeoTab({
    super.key,
    required this.description,
    required this.keywords,
    required this.websiteName,
    required this.browserTitle,
  });

  final TextEditingController description;
  final TextEditingController keywords;
  final String websiteName;
  final String browserTitle;

  @override
  State<_SeoTab> createState() => _SeoTabState();
}

class _SeoTabState extends State<_SeoTab> {
  @override
  void initState() {
    super.initState();
    widget.description.addListener(_refresh);
    widget.keywords.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant _SeoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.description != widget.description) {
      oldWidget.description.removeListener(_refresh);
      widget.description.addListener(_refresh);
    }
    if (oldWidget.keywords != widget.keywords) {
      oldWidget.keywords.removeListener(_refresh);
      widget.keywords.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.description.removeListener(_refresh);
    widget.keywords.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<String> get _keywordItems => widget.keywords.text
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toSet()
      .toList();

  int get _score {
    var result = 0;
    final descriptionLength = widget.description.text.trim().length;
    if (descriptionLength >= 70) result += 25;
    if (descriptionLength >= 120 && descriptionLength <= 160) result += 25;
    if (_keywordItems.length >= 3) result += 25;
    if (widget.browserTitle.trim().length >= 20) result += 25;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 880;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SeoSummary(score: _score, compact: compact),
            const SizedBox(height: 14),
            if (compact) ...[
              _SeoEditor(
                description: widget.description,
                keywords: widget.keywords,
                keywordItems: _keywordItems,
              ),
              const SizedBox(height: 14),
              _SeoSearchPreview(
                title: widget.browserTitle,
                description: widget.description.text,
              ),
            ] else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 11,
                      child: _SeoEditor(
                        description: widget.description,
                        keywords: widget.keywords,
                        keywordItems: _keywordItems,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 9,
                      child: _SeoSearchPreview(
                        title: widget.browserTitle,
                        description: widget.description.text,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            _SeoChecklist(
              titleReady: widget.browserTitle.trim().length >= 20,
              descriptionReady:
                  widget.description.text.trim().length >= 120 &&
                  widget.description.text.trim().length <= 160,
              keywordsReady: _keywordItems.length >= 3,
            ),
          ],
        );
      },
    );
  }
}

class _SeoSummary extends StatelessWidget {
  const _SeoSummary({required this.score, required this.compact});

  final int score;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final status = score >= 75 ? 'SEO sudah baik' : 'SEO perlu dilengkapi';
    final statusColor = score >= 75
        ? const Color(0xFF168447)
        : const Color(0xFFB76800);
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 20),
      decoration: _seoCardDecoration(),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SeoHeading(status: status, statusColor: statusColor),
                const SizedBox(height: 16),
                _SeoScore(score: score, color: statusColor),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _SeoHeading(
                    status: status,
                    statusColor: statusColor,
                  ),
                ),
                _SeoScore(score: score, color: statusColor),
              ],
            ),
    );
  }
}

class _SeoHeading extends StatelessWidget {
  const _SeoHeading({required this.status, required this.statusColor});

  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.manage_search_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 27,
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SEO Dasar Website',
              style: TextStyle(
                color: _text,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Optimalkan tampilan website pada hasil pencarian.',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _SeoScore extends StatelessWidget {
  const _SeoScore({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 150,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: .22)),
    ),
    child: Row(
      children: [
        SizedBox.square(
          dimension: 37,
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 5,
            color: color,
            backgroundColor: color.withValues(alpha: .12),
          ),
        ),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$score/100',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const Text(
              'Skor SEO',
              style: TextStyle(color: _muted, fontSize: 10.5),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SeoEditor extends StatelessWidget {
  const _SeoEditor({
    required this.description,
    required this.keywords,
    required this.keywordItems,
  });

  final TextEditingController description;
  final TextEditingController keywords;
  final List<String> keywordItems;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: _seoCardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SeoSectionTitle(
          icon: Icons.edit_note_rounded,
          title: 'Informasi Mesin Pencari',
          subtitle: 'Data ini digunakan pada meta tag halaman publik.',
        ),
        const SizedBox(height: 18),
        _SeoTextField(
          label: 'Deskripsi Website',
          helper: 'Disarankan 120-160 karakter.',
          controller: description,
          maxLength: 160,
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        _SeoTextField(
          label: 'Kata Kunci',
          helper: 'Pisahkan setiap kata kunci dengan tanda koma.',
          controller: keywords,
          maxLength: 200,
          maxLines: 3,
        ),
        if (keywordItems.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: keywordItems
                .map(
                  (keyword) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      keyword,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    ),
  );
}

class _SeoTextField extends StatelessWidget {
  const _SeoTextField({
    required this.label,
    required this.helper,
    required this.controller,
    required this.maxLength,
    required this.maxLines,
  });

  final String label;
  final String helper;
  final TextEditingController controller;
  final int maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '${controller.text.length}/$maxLength',
            style: TextStyle(
              color: controller.text.length > maxLength
                  ? Colors.red
                  : _muted,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
      const SizedBox(height: 7),
      AdminContentFormField(
        controller: controller,
        constraint: AdminContentConstraint.description.copyWith(maxCharacters: maxLength),
        maxLines: maxLines,
        minLines: maxLines,
        decoration: InputDecoration(
          counterText: '',
          hintText: helper,
          hintStyle: const TextStyle(color: Color(0xFF98A6BA), fontSize: 11),
          filled: true,
          fillColor: const Color(0xFFFBFCFE),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFFD7E0EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFFD7E0EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.4,
            ),
          ),
        ),
        validator: (value) {
          if ((value ?? '').trim().isEmpty) return '$label wajib diisi.';
          return null;
        },
      ),
      const SizedBox(height: 5),
      Text(helper, style: const TextStyle(color: _muted, fontSize: 10.5)),
    ],
  );
}

class _SeoSearchPreview extends StatelessWidget {
  const _SeoSearchPreview({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: _seoCardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SeoSectionTitle(
          icon: Icons.travel_explore_rounded,
          title: 'Pratinjau Google',
          subtitle: 'Perkiraan tampilan pada hasil pencarian.',
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo_sekolah.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SMAK Mgr. Soegijapranata',
                          style: TextStyle(color: _text, fontSize: 11),
                        ),
                        Text(
                          'https://smaklumajang.sch.id',
                          style: TextStyle(color: _muted, fontSize: 9.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(
                title.isEmpty ? 'Judul Website' : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF1A0DAB),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                description.isEmpty
                    ? 'Deskripsi website akan tampil di bagian ini.'
                    : description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF4D5156),
                  fontSize: 11.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: _blue, size: 19),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Mesin pencari dapat memotong teks sesuai perangkat dan kata pencarian pengguna.',
                  style: TextStyle(color: _muted, fontSize: 10.5, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SeoChecklist extends StatelessWidget {
  const _SeoChecklist({
    required this.titleReady,
    required this.descriptionReady,
    required this.keywordsReady,
  });

  final bool titleReady;
  final bool descriptionReady;
  final bool keywordsReady;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: _seoCardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SeoSectionTitle(
          icon: Icons.fact_check_outlined,
          title: 'Pemeriksaan SEO',
          subtitle: 'Pastikan informasi dasar berikut sudah lengkap.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SeoCheckItem(
              ready: titleReady,
              label: 'Judul browser tersedia',
            ),
            _SeoCheckItem(
              ready: descriptionReady,
              label: 'Deskripsi 120-160 karakter',
            ),
            _SeoCheckItem(
              ready: keywordsReady,
              label: 'Minimal 3 kata kunci',
            ),
            const _SeoCheckItem(
              ready: true,
              label: 'Meta tag terhubung ke publik',
            ),
          ],
        ),
      ],
    ),
  );
}

class _SeoCheckItem extends StatelessWidget {
  const _SeoCheckItem({required this.ready, required this.label});

  final bool ready;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = ready ? const Color(0xFF168447) : const Color(0xFFB76800);
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          Icon(
            ready ? Icons.check_circle_rounded : Icons.info_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeoSectionTitle extends StatelessWidget {
  const _SeoSectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 37,
        height: 37,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF2FF),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _blue, size: 20),
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
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: _muted, fontSize: 10.5),
            ),
          ],
        ),
      ),
    ],
  );
}

BoxDecoration _seoCardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: _line),
  boxShadow: const [
    BoxShadow(color: Color(0x08082F63), blurRadius: 18, offset: Offset(0, 6)),
  ],
);
