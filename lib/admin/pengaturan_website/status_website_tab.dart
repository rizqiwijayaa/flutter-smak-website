part of '../admin_dashboard_page.dart';

/// Konten tab Status Website.
/// Tombol Simpan/Batal tetap dikelola oleh pengaturan_website_page.dart.
class AdminWebsiteStatusTab extends StatefulWidget {
  const AdminWebsiteStatusTab({
    super.key,
    required this.initialWebsiteActive,
    required this.initialMaintenanceMode,
    required this.initialMaintenanceMessage,
    required this.onChanged,
    this.onOpenWebsite,
    this.logoAsset = 'assets/images/logo_sekolah.png',
    this.schoolName = 'SMAK',
    this.schoolSubtitle = 'Sekolah Menengah Atas Katolik',
  });

  final bool initialWebsiteActive;
  final bool initialMaintenanceMode;
  final String initialMaintenanceMessage;
  final ValueChanged<WebsiteStatusValues> onChanged;
  final VoidCallback? onOpenWebsite;
  final String logoAsset;
  final String schoolName;
  final String schoolSubtitle;

  @override
  State<AdminWebsiteStatusTab> createState() => _AdminWebsiteStatusTabState();
}

class WebsiteStatusValues {
  const WebsiteStatusValues({
    required this.websiteActive,
    required this.maintenanceMode,
    required this.maintenanceMessage,
  });

  final bool websiteActive;
  final bool maintenanceMode;
  final String maintenanceMessage;
}

class _AdminWebsiteStatusTabState extends State<AdminWebsiteStatusTab> {
  late bool _websiteActive;
  late bool _maintenanceMode;
  late final TextEditingController _messageController;

  static const int _messageLimit = 200;

  @override
  void initState() {
    super.initState();
    _websiteActive = widget.initialWebsiteActive;
    _maintenanceMode = widget.initialMaintenanceMode;
    _messageController = TextEditingController(
      text: widget.initialMaintenanceMessage,
    );
  }

  @override
  void didUpdateWidget(covariant AdminWebsiteStatusTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialWebsiteActive != widget.initialWebsiteActive) {
      _websiteActive = widget.initialWebsiteActive;
    }
    if (oldWidget.initialMaintenanceMode != widget.initialMaintenanceMode) {
      _maintenanceMode = widget.initialMaintenanceMode;
    }
    if (oldWidget.initialMaintenanceMessage !=
        widget.initialMaintenanceMessage) {
      _messageController.text = widget.initialMaintenanceMessage;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(
      WebsiteStatusValues(
        websiteActive: _websiteActive,
        maintenanceMode: _maintenanceMode,
        maintenanceMessage: _messageController.text.trim(),
      ),
    );
  }

  void _setWebsiteActive(bool value) {
    setState(() {
      _websiteActive = value;
      if (!value) _maintenanceMode = false;
    });
    _notifyChanged();
  }

  void _setMaintenanceMode(bool value) {
    setState(() {
      _maintenanceMode = value;
      if (value) _websiteActive = true;
    });
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    final publicOnline = _websiteActive && !_maintenanceMode;
    final status = !_websiteActive
        ? _WebsitePublicStatus.offline
        : _maintenanceMode
        ? _WebsitePublicStatus.maintenance
        : _WebsitePublicStatus.online;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusHero(
              status: status,
              onOpenWebsite: publicOnline ? widget.onOpenWebsite : null,
            ),
            const SizedBox(height: 14),
            if (compact) ...[
              _buildSettingsCard(),
              const SizedBox(height: 14),
              _buildMessageCard(),
              const SizedBox(height: 14),
              _MaintenancePreview(
                logoAsset: widget.logoAsset,
                schoolName: widget.schoolName,
                schoolSubtitle: widget.schoolSubtitle,
                message: _messageController.text,
                enabled: _maintenanceMode,
              ),
            ] else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 11,
                      child: Column(
                        children: [
                          _buildSettingsCard(),
                          const SizedBox(height: 14),
                          _buildMessageCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 9,
                      child: _MaintenancePreview(
                        logoAsset: widget.logoAsset,
                        schoolName: widget.schoolName,
                        schoolSubtitle: widget.schoolSubtitle,
                        message: _messageController.text,
                        enabled: _maintenanceMode,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            const _StatusImpactNotice(),
          ],
        );
      },
    );
  }

  Widget _buildSettingsCard() {
    return _StatusCard(
      title: 'Status & Publikasi',
      icon: Icons.public_rounded,
      child: Column(
        children: [
          _StatusSettingRow(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF169B53),
            iconBackground: const Color(0xFFE9F8EF),
            title: 'Website Aktif',
            description: 'Izinkan pengunjung mengakses website publik.',
            statusText: _websiteActive
                ? 'Dapat diakses publik'
                : 'Tidak dipublikasikan',
            statusColor: _websiteActive
                ? const Color(0xFF169B53)
                : const Color(0xFF77859A),
            statusBackground: _websiteActive
                ? const Color(0xFFEAF8EF)
                : const Color(0xFFF0F3F7),
            value: _websiteActive,
            // Maintenance adalah sub-mode dari website yang tetap dipublikasikan.
            // Saat maintenance aktif, Website Aktif harus tetap ON dan tidak
            // boleh dimatikan sampai Mode Pemeliharaan dinonaktifkan.
            enabled: !_maintenanceMode,
            onChanged: _setWebsiteActive,
          ),
          const Divider(height: 1, color: Color(0xFFE8EEF6)),
          _StatusSettingRow(
            icon: Icons.handyman_rounded,
            iconColor: const Color(0xFF60718A),
            iconBackground: const Color(0xFFF0F3F7),
            title: 'Mode Pemeliharaan',
            description:
                'Tampilkan halaman pemeliharaan tanpa menonaktifkan dashboard admin.',
            statusText: _maintenanceMode ? 'Sedang aktif' : 'Tidak aktif',
            statusColor: _maintenanceMode
                ? const Color(0xFFE28A13)
                : const Color(0xFF77859A),
            statusBackground: _maintenanceMode
                ? const Color(0xFFFFF5E5)
                : const Color(0xFFF0F3F7),
            value: _maintenanceMode,
            onChanged: _setMaintenanceMode,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return _StatusCard(
      title: 'Pesan Pemeliharaan',
      icon: Icons.message_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pesan ini hanya tampil ketika Mode Pemeliharaan diaktifkan.',
            style: TextStyle(
              color: _maintenanceMode
                  ? const Color(0xFF60718A)
                  : const Color(0xFF96A2B4),
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          AdminContentTextField(
            controller: _messageController,
            constraint: AdminContentConstraint.shortDescription.copyWith(maxCharacters: _messageLimit),
            enabled: true,
            minLines: 2,
            maxLines: 3,
            onChanged: (_) {
              setState(() {});
              _notifyChanged();
            },
            decoration: InputDecoration(
              hintText:
                  'Website sedang dalam pemeliharaan. Silakan kembali beberapa saat lagi.',
              filled: true,
              fillColor: _maintenanceMode
                  ? Colors.white
                  : const Color(0xFFF7F9FC),
              counterText:
                  '${_messageController.text.characters.length}/$_messageLimit',
              counterStyle: const TextStyle(
                color: Color(0xFF60718A),
                fontSize: 10.5,
              ),
              contentPadding: const EdgeInsets.all(13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFDDE5EF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFDDE5EF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFF1463E8),
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _WebsitePublicStatus { online, maintenance, offline }

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.status, required this.onOpenWebsite});

  final _WebsitePublicStatus status;
  final VoidCallback? onOpenWebsite;

  @override
  Widget build(BuildContext context) {
    final isOnline = status == _WebsitePublicStatus.online;
    final isMaintenance = status == _WebsitePublicStatus.maintenance;
    final color = isOnline
        ? const Color(0xFF169B53)
        : isMaintenance
        ? const Color(0xFFE28A13)
        : const Color(0xFF6C7B90);
    final background = isOnline
        ? const Color(0xFFF0FBF4)
        : isMaintenance
        ? const Color(0xFFFFF8EC)
        : const Color(0xFFF3F6FA);
    final title = isOnline
        ? 'Website Sedang Aktif'
        : isMaintenance
        ? 'Website Dalam Pemeliharaan'
        : 'Website Tidak Dipublikasikan';
    final subtitle = isOnline
        ? 'Website dapat diakses oleh seluruh pengunjung.'
        : isMaintenance
        ? 'Pengunjung akan melihat halaman pemeliharaan sementara.'
        : 'Website publik tidak dapat diakses oleh pengunjung.';
    final badge = isOnline
        ? 'Online'
        : isMaintenance
        ? 'Maintenance'
        : 'Offline';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.28)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOnline
                  ? Icons.language_rounded
                  : isMaintenance
                  ? Icons.handyman_rounded
                  : Icons.public_off_rounded,
              color: color,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 9,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(.35)),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF60718A),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (onOpenWebsite != null) ...[
            const SizedBox(width: 14),
            FilledButton.icon(
              onPressed: onOpenWebsite,
              icon: const Icon(Icons.open_in_new_rounded, size: 17),
              label: const Text('Lihat Website'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1463E8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EEF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF1463E8), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF082E65),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }
}

class _StatusSettingRow extends StatelessWidget {
  const _StatusSettingRow({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.statusText,
    required this.statusColor,
    required this.statusBackground,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String description;
  final String statusText;
  final Color statusColor;
  final Color statusBackground;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .58,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF082E65),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF60718A),
                      fontSize: 10.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: statusBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Switch(value: value, onChanged: enabled ? onChanged : null),
          ],
        ),
      ),
    );
  }
}

class _MaintenancePreview extends StatelessWidget {
  const _MaintenancePreview({
    required this.logoAsset,
    required this.schoolName,
    required this.schoolSubtitle,
    required this.message,
    required this.enabled,
  });

  final String logoAsset;
  final String schoolName;
  final String schoolSubtitle;
  final String message;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final previewMessage = message.trim().isEmpty
        ? 'Website sedang dalam pemeliharaan. Silakan kembali beberapa saat lagi.'
        : message.trim();

    return _StatusCard(
      title: 'Pratinjau Halaman',
      icon: Icons.visibility_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            enabled
                ? 'Tampilan yang sedang dilihat pengunjung.'
                : 'Tampilan ketika Mode Pemeliharaan diaktifkan.',
            style: const TextStyle(color: Color(0xFF60718A), fontSize: 11.5),
          ),
          const SizedBox(height: 11),
          SizedBox(
            height: 260,
            child: Container(
              constraints: const BoxConstraints(minHeight: 240),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDDE6F1)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -32,
                    right: -38,
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1463E8).withOpacity(.04),
                        border: Border.all(
                          color: const Color(0xFF1463E8).withOpacity(.14),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: -44,
                    child: Container(
                      width: 126,
                      height: 126,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1463E8).withOpacity(.03),
                        border: Border.all(
                          color: const Color(0xFF1463E8).withOpacity(.12),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: websiteIdentityImage(
                                logoAsset,
                                width: 22,
                                height: 22,
                                fallbackColor: const Color(0xFFB88112),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  schoolName,
                                  style: const TextStyle(
                                    color: Color(0xFF082F63),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11.5,
                                  ),
                                ),
                                Text(
                                  schoolSubtitle,
                                  style: const TextStyle(
                                    color: Color(0xFF60718A),
                                    fontSize: 7.6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 14,
                                      left: 12,
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: List.generate(
                                            16,
                                            (_) => Container(
                                              width: 3,
                                              height: 3,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFBAD5FA),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 18,
                                      top: 14,
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: const Color(0xFF1463E8),
                                        size: 14,
                                      ),
                                    ),
                                    Container(
                                      width: 118,
                                      height: 90,
                                      padding: const EdgeInsets.only(top: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F9FF),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 86,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xFF082F63),
                                                width: 3,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 12,
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFF082F63),
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            6,
                                                          ),
                                                        ),
                                                  ),
                                                  child: const Row(
                                                    children: [
                                                      _PreviewWindowDot(
                                                        color: Color(
                                                          0xFF63A4FF,
                                                        ),
                                                      ),
                                                      _PreviewWindowDot(
                                                        color: Color(
                                                          0xFFF3B931,
                                                        ),
                                                      ),
                                                      _PreviewWindowDot(
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Expanded(
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .account_balance_rounded,
                                                      size: 22,
                                                      color: Color(0xFF1463E8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Positioned(
                                            left: 12,
                                            bottom: 8,
                                            child: Icon(
                                              Icons.settings_rounded,
                                              size: 28,
                                              color: Color(0xFF1463E8),
                                            ),
                                          ),
                                          Positioned(
                                            right: 12,
                                            bottom: 8,
                                            child: Transform.rotate(
                                              angle: -.48,
                                              child: const Icon(
                                                Icons.build_rounded,
                                                size: 30,
                                                color: Color(0xFF082F63),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      child: Container(
                                        width: 68,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5B82E),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _PreviewBarrierStripe(),
                                            _PreviewBarrierStripe(),
                                            _PreviewBarrierStripe(),
                                            _PreviewBarrierStripe(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                color: const Color(0xFFE6ECF4),
                              ),
                              Expanded(
                                flex: 11,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF3FF),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Color(0xFF1463E8),
                                            child: Icon(
                                              Icons.handyman_rounded,
                                              color: Colors.white,
                                              size: 11,
                                            ),
                                          ),
                                          SizedBox(width: 7),
                                          Text(
                                            'SEDANG DALAM PEMELIHARAAN',
                                            style: TextStyle(
                                              color: Color(0xFF1463E8),
                                              fontSize: 8.2,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: .35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Kami Segera Kembali',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF082F63),
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w900,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      previewMessage,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF60718A),
                                        fontSize: 10.2,
                                        height: 1.45,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F7FC),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFE4EBF4),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.schedule_rounded,
                                            size: 14,
                                            color: Color(0xFF1463E8),
                                          ),
                                          SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              'Proses pemeliharaan sedang berlangsung',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Color(0xFF4D607A),
                                                fontSize: 9.7,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewWindowDot extends StatelessWidget {
  const _PreviewWindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _PreviewBarrierStripe extends StatelessWidget {
  const _PreviewBarrierStripe();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.5,
      child: Container(width: 5, height: 10, color: Colors.white),
    );
  }
}

class _StatusImpactNotice extends StatelessWidget {
  const _StatusImpactNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4E5FB)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF1463E8), size: 19),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Mengubah status website akan memengaruhi akses seluruh pengunjung, tetapi dashboard admin tetap dapat digunakan.',
              style: TextStyle(
                color: Color(0xFF35567E),
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
