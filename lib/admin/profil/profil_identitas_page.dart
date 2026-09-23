part of '../admin_dashboard_page.dart';

class AdminIdentitasSekolahPage extends StatelessWidget {
  const AdminIdentitasSekolahPage({
    super.key,
    required this.api,
    required this.module,
  });

  final SmakApi api;
  final AdminModule module;

  static const List<MapEntry<String, String>> _identityFields = [
    MapEntry('Nama Sekolah', 'SMAS KRISTEN MGR S LUMAJANG'),
    MapEntry('NPSN', '20520822'),
    MapEntry('Jenjang Pendidikan', 'SMA'),
    MapEntry('Status Sekolah', 'Swasta'),
    MapEntry('Alamat Sekolah', 'Jl. Diponegoro No. 63 Lumajang'),
    MapEntry('RT / RW', '6 / 4'),
    MapEntry('Kode Pos', '67315'),
    MapEntry('Kelurahan', 'Jogoyudan'),
    MapEntry('Kecamatan', 'Kec. Lumajang'),
    MapEntry('Kabupaten/Kota', 'Kab. Lumajang'),
    MapEntry('Provinsi', 'Jawa Timur'),
    MapEntry('Negara', 'Indonesia'),
    MapEntry('Posisi Geografis', '-8.1335 (Lintang)\n113.2287 (Bujur)'),
  ];

  static const List<MapEntry<String, String>> _detailFields = [
    MapEntry('SK Pendirian Sekolah', '060/PENG.YK/1983'),
    MapEntry('Tanggal SK Pendirian', '1983-12-31'),
    MapEntry('Status Kepemilikan', 'Yayasan'),
    MapEntry('SK Izin Operasional', '45/14.01.02/02/IV/2025'),
    MapEntry('Tgl SK Izin Operasional', '2025-04-15'),
    MapEntry('Kebutuhan Khusus Dilayani', '-'),
    MapEntry('Nomor Rekening', '0092035905'),
    MapEntry('Nama Bank', 'BPD JAWA TIMUR'),
    MapEntry('Cabang KCP/Unit', 'BPD JAWA TIMUR CABANG LUMAJANG'),
    MapEntry('Rekening Atas Nama', 'SMUKATOLIKMGRSOEGIJAPRANATA'),
    MapEntry('MBS', 'Ya'),
    MapEntry('Iuran Tahunan', '0'),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: api.getTable(module.table),
      builder: (context, snapshot) {
        final rows = snapshot.data ?? const <Map<String, dynamic>>[];
        final profile = rows.isNotEmpty
            ? rows.first
            : const <String, dynamic>{};
        final schoolName = _value(profile, [
          'nama_sekolah',
          'nama',
          'judul',
        ], 'SMAS KRISTEN MGR S LUMAJANG');
        final status = _value(profile, ['status_sekolah', 'status'], 'Swasta');
        final jenjang = _value(profile, ['jenjang_pendidikan'], 'SMA');
        final tahunBerdiri = _value(profile, ['tahun_berdiri'], '1983');
        final yayasan = _value(profile, ['yayasan'], 'Yayasan');
        final akreditasi = _value(profile, ['akreditasi'], 'A');
        final akreditasiDeskripsi = _value(profile, [
          'akreditasi_deskripsi',
          'deskripsi',
        ], 'Akreditasi BAN-S/M');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.home_outlined, size: 15, color: _muted),
                          SizedBox(width: 8),
                          Text(
                            'Profil',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 15,
                              color: _muted,
                            ),
                          ),
                          Text(
                            'Identitas Sekolah',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Identitas Sekolah',
                        style: TextStyle(
                          color: _text,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        rows.isEmpty
                            ? 'Informasi resmi mengenai identitas dan data sekolah.'
                            : 'Informasi resmi mengenai identitas dan data sekolah dari database.',
                        style: const TextStyle(color: _muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => _openAdminEditor(
                    context,
                    api,
                    module,
                    row: rows.isEmpty ? null : rows.first,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(rows.isEmpty ? 'Tambah Data' : 'Edit Data'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: _cardDecoration(radius: 18),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 860;
                  final summary = Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      _ProfileSummaryItem(
                        icon: Icons.school_rounded,
                        label: 'Jenjang',
                        value: jenjang,
                      ),
                      _ProfileSummaryItem(
                        icon: Icons.verified_user_rounded,
                        label: 'Status Sekolah',
                        value: status,
                      ),
                      _ProfileSummaryItem(
                        icon: Icons.calendar_month_rounded,
                        label: 'Tahun Berdiri',
                        value: tahunBerdiri,
                      ),
                      _ProfileSummaryItem(
                        icon: Icons.groups_2_rounded,
                        label: 'Yayasan',
                        value: yayasan,
                      ),
                    ],
                  );

                  if (narrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileSchoolIntro(name: schoolName, status: status),
                        const SizedBox(height: 18),
                        summary,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      const Expanded(flex: 3, child: _ProfileLogoPanel()),
                      Container(
                        width: 1,
                        height: 126,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        color: _line,
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ProfileSchoolIntro(
                              name: schoolName,
                              status: status,
                            ),
                            const SizedBox(height: 20),
                            summary,
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 1080;
                final dataCard = _ProfileInfoCard(
                  title: '1. Identitas Sekolah',
                  leftItems: _identityFields
                      .map(
                        (entry) => _ProfileInfoRow(
                          label: entry.key,
                          value: _value(profile, [
                            _slug(entry.key),
                            entry.key.toLowerCase(),
                          ], entry.value),
                        ),
                      )
                      .toList(),
                  rightItems: _detailFields
                      .map(
                        (entry) => _ProfileInfoRow(
                          label: entry.key,
                          value: _value(profile, [
                            _slug(entry.key),
                            entry.key.toLowerCase(),
                          ], entry.value),
                        ),
                      )
                      .toList(),
                );
                final highlightCards = Column(
                  children: [
                    _ProfileHighlightCard(
                      icon: Icons.calendar_month_rounded,
                      title: 'Tahun Berdiri',
                      value: tahunBerdiri,
                      description:
                          'Berkomitmen mencetak generasi unggul, berkarakter, dan berwawasan global.',
                      highlighted: true,
                    ),
                    const SizedBox(height: 14),
                    _ProfileHighlightCard(
                      icon: Icons.groups_2_rounded,
                      title: 'Yayasan',
                      value: yayasan,
                      description:
                          'Dikelola oleh yayasan dengan nilai-nilai pelayanan dan pendidikan.',
                    ),
                    const SizedBox(height: 14),
                    _ProfileHighlightCard(
                      icon: Icons.workspace_premium_rounded,
                      title: 'Terakreditasi',
                      value: akreditasi,
                      description: akreditasiDeskripsi,
                    ),
                  ],
                );
                if (narrow) {
                  return Column(
                    children: [
                      dataCard,
                      const SizedBox(height: 18),
                      highlightCards,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: dataCard),
                    const SizedBox(width: 18),
                    SizedBox(width: 260, child: highlightCards),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            const _ProfileDocumentCard(),
          ],
        );
      },
    );
  }

  static String _slug(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', '')
        .replaceAll('/', ' ')
        .replaceAll('.', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
  }

  static String _value(
    Map<String, dynamic> row,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final raw = '${row[key] ?? ''}'.trim();
      if (raw.isNotEmpty) return raw;
    }
    return fallback;
  }
}

class _ProfileSchoolIntro extends StatelessWidget {
  const _ProfileSchoolIntro({required this.name, required this.status});

  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            status.toUpperCase(),
            style: const TextStyle(
              color: _blue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileLogoPanel extends StatelessWidget {
  const _ProfileLogoPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 118,
        height: 118,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _line),
        ),
        padding: const EdgeInsets.all(14),
        child: Image.asset(
          'assets/images/logo_sekolah.png',
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.school_rounded, color: _blue, size: 52),
        ),
      ),
    );
  }
}

class _ProfileSummaryItem extends StatelessWidget {
  const _ProfileSummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _blue, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({
    required this.title,
    required this.leftItems,
    required this.rightItems,
  });

  final String title;
  final List<_ProfileInfoRow> leftItems;
  final List<_ProfileInfoRow> rightItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 760) {
                return Column(
                  children: [
                    ...leftItems.map(_buildRow),
                    const SizedBox(height: 6),
                    ...rightItems.map(_buildRow),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(children: leftItems.map(_buildRow).toList()),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(children: rightItems.map(_buildRow).toList()),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRow(_ProfileInfoRow item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: item,
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(':', style: TextStyle(color: _muted)),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: const TextStyle(
              color: _text,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHighlightCard extends StatelessWidget {
  const _ProfileHighlightCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final String description;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF0E4A99) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlighted
              ? const Color(0xFF0E4A99)
              : const Color(0xFFF0F3F8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: highlighted ? Colors.white : _blue),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              color: highlighted ? const Color(0xFFD6E6FF) : _muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: highlighted ? Colors.white : _text,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              color: highlighted ? const Color(0xFFE4EEFF) : _muted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDocumentItemData {
  const _ProfileDocumentItemData({
    required this.icon,
    required this.color,
    required this.title,
    required this.meta,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String meta;
}

class _ProfileSchoolFieldSpec {
  const _ProfileSchoolFieldSpec({
    required this.key,
    required this.label,
    this.hint = '',
    this.maxLines = 1,
  });

  final String key;
  final String label;
  final String hint;
  final int maxLines;
}

class _ProfileEditorFieldGrid extends StatelessWidget {
  const _ProfileEditorFieldGrid({
    required this.fields,
    required this.controllers,
  });

  final List<_ProfileSchoolFieldSpec> fields;
  final Map<String, TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 14.0;
        final columns = constraints.maxWidth < 760 ? 1 : 2;
        final width =
            (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: fields.map((field) {
            return SizedBox(
              width: width,
              child: AdminContentTextField(
                controller: controllers[field.key],
                maxLines: field.maxLines,
                decoration: InputDecoration(
                  labelText: field.label,
                  hintText: field.hint.isEmpty ? null : field.hint,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: field.maxLines > 1,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ProfileEditorSection extends StatelessWidget {
  const _ProfileEditorSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}

class _ProfileDocumentCard extends StatelessWidget {
  const _ProfileDocumentCard();

  @override
  Widget build(BuildContext context) {
    final docs = const [
      _ProfileDocumentItemData(
        icon: Icons.picture_as_pdf_rounded,
        color: Color(0xFFE53935),
        title: 'SK_Pendirian_1983.pdf',
        meta: 'PDF - 1.2 MB',
      ),
      _ProfileDocumentItemData(
        icon: Icons.picture_as_pdf_rounded,
        color: Color(0xFFE53935),
        title: 'SK_Izin_Operasional_2025.pdf',
        meta: 'PDF - 1.5 MB',
      ),
      _ProfileDocumentItemData(
        icon: Icons.table_chart_rounded,
        color: Color(0xFF16A34A),
        title: 'Data_Pokok_Sekolah.xlsx',
        meta: 'XLSX - 45 KB',
      ),
      _ProfileDocumentItemData(
        icon: Icons.description_rounded,
        color: Color(0xFF2563EB),
        title: 'Surat_Yayasan.docx',
        meta: 'DOCX - 210 KB',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '3. Dokumentasi Pendukung',
            style: TextStyle(
              color: _text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = 4;
              if (constraints.maxWidth < 1050) columns = 2;
              if (constraints.maxWidth < 620) columns = 1;
              final width =
                  (constraints.maxWidth - ((columns - 1) * 16)) / columns;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: docs
                    .map(
                      (doc) => SizedBox(
                        width: width,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _line),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(doc.icon, color: doc.color, size: 30),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: _text,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          doc.meta,
                                          style: const TextStyle(
                                            color: _muted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.visibility_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('Lihat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
