import 'package:flutter/material.dart';

import '../../../services/profile_content_api.dart';
import '../../../services/smak_api.dart';
import '../../../services/website_identity.dart';

import '../../akademik/jadwal_pelajaran/jadwal_pelajaran_page.dart';
import '../../akademik/kalender_akademik/kalender_akademik_page.dart';
import '../../akademik/kurikulum/kurikulum_page.dart';
import '../../akademik/prestasi_akademik/prestasi_akademik_page.dart';
import '../../berita/berita_page.dart';
import '../../galeri/galeri_page.dart';
import '../../kesiswaan/ekstrakurikuler/ekstrakurikuler_page.dart';
import '../../kesiswaan/osis/osis_page.dart';
import '../../kesiswaan/prestasi_siswa/prestasi_siswa_page.dart';
import '../../kesiswaan/tata_tertib/tata_tertib_page.dart';
import '../../landing_page.dart';
import '../../login/login_page.dart';
import '../../kontak_page.dart';
import '../../ppdb_page.dart';
import '../../site_chrome.dart';
import '../sambutan_kepala_sekolah/sambutan_kepala_sekolah_page.dart';
import '../sarana_prasarana/sarana_prasarana_page.dart';
import '../sejarah_sekolah/sejarah_sekolah_page.dart';
import '../struktur_organisasi/struktur_organisasi_page.dart';
import '../visi_misi/visi_misi_page.dart';

class IdentitasSekolahPage extends StatelessWidget {
  const IdentitasSekolahPage({super.key});

  static const Color primaryBlue = Color(0xFF0756C8);
  static const Color darkBlue = Color(0xFF06377F);
  static const Color textBlue = Color(0xFF082E65);
  static const Color pageBackground = Color(0xFFF5F8FC);

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
    future: const ProfileContentApi(SmakApi()).first('profil_identitas'),
    builder: (context, snapshot) => _buildPage(context, snapshot.data ?? {}),
  );

  Widget _buildPage(BuildContext context, Map<String, dynamic> identity) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 900;

    final cards = <Widget>[
      _InfoCard(
        icon: Icons.workspace_premium_rounded,
        title: 'Terakreditasi',
        value: _value(identity, 'akreditasi'),
        description: 'Akreditasi BAN-S/M',
        highlighted: true,
      ),
      _InfoCard(
        icon: Icons.account_circle_outlined,
        title: 'Kepala Sekolah',
        value: _value(identity, 'kepala_sekolah'),
        description: 'Pimpinan ${_value(identity, 'nama_sekolah')}',
      ),
      _InfoCard(
        icon: Icons.star_outline_rounded,
        title: 'Motto Sekolah',
        value: _value(identity, 'motto_sekolah'),
        description: 'Nilai yang mendasari pendidikan dan pelayanan sekolah.',
      ),
    ];

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SharedSmakNavigationBar(
                profilePages: sharedProfilePages(),
                academicPages: sharedAcademicPages(),
                studentPages: sharedStudentPages(),
                initialActive: 'Profil',
              ),
              const _IdentityHero(),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 18 : 80,
                  24,
                  compact ? 18 : 80,
                  30,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        _IdentitySummaryCard(identity: identity),
                        const SizedBox(height: 18),
                        if (compact)
                          Column(
                            children: [
                              _IdentityTable(identity: identity),
                              const SizedBox(height: 18),
                              ...cards.map(
                                (card) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: card,
                                ),
                              ),
                              _IdentityDocuments(identity: identity),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: _IdentityTable(identity: identity),
                                  ),
                                  const SizedBox(width: 18),
                                  SizedBox(
                                    width: 250,
                                    child: Column(
                                      children: cards
                                          .map(
                                            (card) => Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: card,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              _IdentityDocuments(identity: identity),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const _IdentityFooter(),
            ],
          ),
        ),
      ),
    );
  }

  String _value(Map<String, dynamic> identity, String key) {
    final value = '${identity[key] ?? ''}'.trim();
    return value.isEmpty ? '-' : value;
  }
}

String _identityValue(Map<String, dynamic> identity, String key) {
  final value = '${identity[key] ?? ''}'.trim();
  return value.isEmpty ? '-' : value;
}

class _IdentityTopBar extends StatelessWidget {
  const _IdentityTopBar();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;

    return Container(
      width: double.infinity,
      color: IdentitasSekolahPage.darkBlue,
      padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 80, vertical: 9),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          compact
              ? '(0334) 890123 • info@smaklumajang.sch.id'
              : '☎  (0334) 890123     ✉  info@smaklumajang.sch.id     f    ◎    ▶',
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class _IdentityHero extends StatelessWidget {
  const _IdentityHero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 165),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 18 : 80,
        vertical: 34,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF062C64), Color(0xFF0B559C)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identitas Sekolah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Beranda   ›   Profil   ›   Identitas Sekolah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IdentitySummaryCard extends StatelessWidget {
  const _IdentitySummaryCard({required this.identity});

  final Map<String, dynamic> identity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EDF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D082751),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;

          final school = Row(
            children: [
              Container(
                width: compact ? 78 : 92,
                height: compact ? 78 : 92,
                padding: const EdgeInsets.all(5),
                child: ValueListenableBuilder<WebsiteIdentity>(
                  valueListenable: websiteIdentityController,
                  builder: (context, identity, _) => websiteIdentityImage(
                    identity.logo,
                    width: compact ? 78 : 92,
                    height: compact ? 78 : 92,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _identityValue(identity, 'nama_sekolah'),
                      style: const TextStyle(
                        color: IdentitasSekolahPage.textBlue,
                        fontSize: 18,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    _SchoolStatusBadge(
                      status: _identityValue(identity, 'status_sekolah'),
                    ),
                  ],
                ),
              ),
            ],
          );

          final stats = Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _SummaryStat(
                icon: Icons.school_outlined,
                label: 'Jenjang',
                value: _identityValue(identity, 'jenjang_pendidikan'),
              ),
              _SummaryStat(
                icon: Icons.verified_user_outlined,
                label: 'Status Sekolah',
                value: _identityValue(identity, 'status_sekolah'),
              ),
              _SummaryStat(
                icon: Icons.calendar_month_outlined,
                label: 'Tahun Berdiri',
                value: _identityValue(identity, 'tahun_berdiri'),
              ),
              _SummaryStat(
                icon: Icons.groups_outlined,
                label: 'Yayasan',
                value: _identityValue(identity, 'yayasan'),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                school,
                const SizedBox(height: 18),
                const Divider(color: Color(0xFFE5EBF3)),
                const SizedBox(height: 14),
                stats,
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 4, child: school),
              Container(
                width: 1,
                height: 82,
                margin: const EdgeInsets.symmetric(horizontal: 22),
                color: const Color(0xFFE5EBF3),
              ),
              Expanded(flex: 7, child: stats),
            ],
          );
        },
      ),
    );
  }
}

class _SchoolStatusBadge extends StatelessWidget {
  const _SchoolStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF3FF),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      status.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF0865D7),
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: .35,
      ),
    ),
  );
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 140,
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF0969DA), size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF6E809A),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: IdentitasSekolahPage.textBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _IdentityTable extends StatelessWidget {
  const _IdentityTable({required this.identity});

  final Map<String, dynamic> identity;

  List<MapEntry<String, String>> _items(List<(String, String)> fields) => fields
      .map((field) => MapEntry(field.$1, _identityValue(identity, field.$2)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                color: IdentitasSekolahPage.primaryBlue,
              ),
              SizedBox(width: 10),
              Text(
                'Identitas Sekolah',
                style: TextStyle(
                  color: IdentitasSekolahPage.textBlue,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final leftItems = _items([
                ('Nama Sekolah', 'nama_sekolah'),
                ('NPSN', 'npsn'),
                ('NSS', 'nss'),
                ('Jenjang Pendidikan', 'jenjang_pendidikan'),
                ('Kurikulum', 'kurikulum'),
                ('Status Sekolah', 'status_sekolah'),
                ('Alamat Sekolah', 'alamat'),
                ('RT / RW', 'rt_rw'),
                ('Kode Pos', 'kode_pos'),
                ('Kelurahan', 'kelurahan'),
                ('Kecamatan', 'kecamatan'),
                ('Kabupaten/Kota', 'kabupaten_kota'),
                ('Provinsi', 'provinsi'),
                ('Negara', 'negara'),
                ('Posisi Geografis', 'posisi_geografis'),
                ('Website', 'website'),
                ('Jam Operasional', 'jam_operasional'),
              ]);
              final rightItems = _items([
                ('SK Pendirian Sekolah', 'sk_pendirian_sekolah'),
                ('Tanggal SK Pendirian', 'tanggal_sk_pendirian'),
                ('Status Kepemilikan', 'status_kepemilikan'),
                ('Kementerian', 'kementerian'),
                ('SK Izin Operasional', 'sk_izin_operasional'),
                ('Tgl SK Izin Operasional', 'tgl_sk_izin_operasional'),
                ('Kebutuhan Khusus Dilayani', 'kebutuhan_khusus_dilayani'),
                ('Nomor Rekening', 'nomor_rekening'),
                ('Nama Bank', 'nama_bank'),
                ('Cabang KCP/Unit', 'cabang_kcp_unit'),
                ('Rekening Atas Nama', 'rekening_atas_nama'),
                ('MBS', 'mbs'),
                ('Iuran Tahunan', 'iuran_tahunan'),
              ]);
              final twoColumns = constraints.maxWidth >= 700;
              if (!twoColumns) {
                return Column(
                  children: [...leftItems, ...rightItems]
                      .map(
                        (item) =>
                            _IdentityRow(label: item.key, value: item.value),
                      )
                      .toList(),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _IdentityColumn(items: leftItems)),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: const Color(0xFFE5EAF2),
                  ),
                  Expanded(child: _IdentityColumn(items: rightItems)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _IdentityColumn extends StatelessWidget {
  const _IdentityColumn({required this.items});

  final List<MapEntry<String, String>> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((item) => _IdentityRow(label: item.key, value: item.value))
          .toList(),
    );
  }
}

class _IdentityDocuments extends StatelessWidget {
  const _IdentityDocuments({required this.identity});

  final Map<String, dynamic> identity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: IdentitasSekolahPage.primaryBlue,
                size: 22,
              ),
              SizedBox(width: 9),
              Text(
                'Lokasi & Kontak Sekolah',
                style: TextStyle(
                  color: IdentitasSekolahPage.textBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ContactItems(identity: identity),
        ],
      ),
    );
  }
}

class _ContactItems extends StatelessWidget {
  const _ContactItems({required this.identity});

  final Map<String, dynamic> identity;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final items = [
          _ContactItem(
            icon: Icons.location_on_outlined,
            text: _identityValue(identity, 'alamat'),
          ),
          _ContactItem(
            icon: Icons.phone_outlined,
            text: _identityValue(identity, 'telepon'),
          ),
          _ContactItem(
            icon: Icons.mail_outline_rounded,
            text: _identityValue(identity, 'email'),
          ),
        ];

        if (constraints.maxWidth < 680) {
          return Column(
            children: [
              _ContactItem(
                icon: Icons.location_on_outlined,
                text: _identityValue(identity, 'alamat'),
              ),
              const Divider(height: 24, color: Color(0xFFE5EAF2)),
              _ContactItem(
                icon: Icons.phone_outlined,
                text: _identityValue(identity, 'telepon'),
              ),
              const Divider(height: 24, color: Color(0xFFE5EAF2)),
              _ContactItem(
                icon: Icons.mail_outline_rounded,
                text: _identityValue(identity, 'email'),
              ),
            ],
          );
        }

        return Row(
          children: [
            for (var index = 0; index < items.length; index++) ...[
              Expanded(child: items[index]),
              if (index < items.length - 1)
                Container(
                  width: 1,
                  height: 38,
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  color: const Color(0xFFE5EAF2),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: IdentitasSekolahPage.primaryBlue, size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: IdentitasSekolahPage.textBlue,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _IdentityFooter extends StatelessWidget {
  const _IdentityFooter();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 850;

    final columns = <Widget>[
      _FooterBlock(
        title: websiteIdentityController.value.name,
        lines: [
          globalWebsiteText(
            context,
            'slogan',
            'Beriman • Berilmu • Berkarakter',
          ),
        ],
      ),
      _FooterBlock(
        title: 'Tautan Cepat',
        lines: ['Beranda', 'Profil', 'Akademik', 'Berita', 'PPDB'],
      ),
      _FooterBlock(
        title: 'Kontak Kami',
        lines: [
          globalWebsiteText(
            context,
            'alamat',
            'Jl. Diponegoro No. 63 Lumajang, Jogoyudan, Kec. Lumajang, Kab. Lumajang, 67315',
          ),
          globalWebsiteText(context, 'telepon', '(0334) 890123'),
          globalWebsiteText(context, 'email', 'info@smaklumajang.sch.id'),
        ],
      ),
      _FooterBlock(
        title: 'Jam Operasional',
        lines: [
          globalWebsiteText(context, 'hari_operasional', 'Senin – Jumat'),
          globalWebsiteText(context, 'jam_operasional', '07.00 – 15.00 WIB'),
        ],
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        compact ? 18 : 80,
        30,
        compact ? 18 : 80,
        24,
      ),
      color: IdentitasSekolahPage.darkBlue,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            spacing: 50,
            runSpacing: 28,
            alignment: WrapAlignment.spaceBetween,
            children: columns,
          ),
        ),
      ),
    );
  }
}

class _FooterBlock extends StatelessWidget {
  _FooterBlock({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                line,
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5EAF2))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF526178),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(':', style: TextStyle(color: Color(0xFF526178))),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                color: IdentitasSekolahPage.textBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
      padding: EdgeInsets.symmetric(
        horizontal: 22,
        vertical: highlighted ? 24 : 20,
      ),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF073B86) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: highlighted
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: highlighted
                ? Colors.white
                : IdentitasSekolahPage.primaryBlue,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: highlighted ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: highlighted ? Colors.white : IdentitasSekolahPage.textBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: highlighted ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: highlighted ? Colors.white : IdentitasSekolahPage.textBlue,
              fontSize: highlighted ? 40 : 20,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          SizedBox(height: highlighted ? 10 : 8),
          Text(
            description,
            textAlign: highlighted ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color: highlighted
                  ? const Color(0xFFE2EDFF)
                  : const Color(0xFF526178),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
