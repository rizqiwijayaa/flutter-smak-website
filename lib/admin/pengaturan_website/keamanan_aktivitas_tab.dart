part of '../admin_dashboard_page.dart';

class _SecurityTab extends StatefulWidget {
  const _SecurityTab({
    super.key,
    required this.api,
    required this.sessionToken,
  });

  final SmakApi api;
  final String sessionToken;

  @override
  State<_SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<_SecurityTab> {
  late Future<Map<String, dynamic>> _request;
  String _activityFilter = 'Semua';
  int _loginLimit = 5;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _request = widget.api.getSecurityDashboard(widget.sessionToken);
  }

  void _refresh() {
    setState(() {
      _request = widget.api.getSecurityDashboard(widget.sessionToken);
    });
  }

  Future<void> _checkNow() async {
    if (_checking) return;
    setState(() => _checking = true);
    try {
      final next = widget.api.getSecurityDashboard(widget.sessionToken);
      setState(() {
        _request = next;
      });
      await next;
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _revokeSession(Map<String, dynamic> session) async {
    final id = int.tryParse('${session['id'] ?? ''}');
    if (id == null) return;
    try {
      await widget.api.revokeSession(id);
      if (mounted) _refresh();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengeluarkan perangkat: $error')),
      );
    }
  }

  Future<void> _reviewAlert(Map<String, dynamic> alert) async {
    final id = int.tryParse('${alert['id'] ?? ''}');
    if (id == null) return;
    try {
      await widget.api.readSecurityAlert(id);
      if (mounted) _refresh();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal meninjau peringatan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
    future: _request,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const _SecurityPanel(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }
      if (snapshot.hasError || snapshot.data == null) {
        return _SecurityPanel(
          child: _SecurityEmpty(
            icon: Icons.cloud_off_rounded,
            title: 'Data keamanan gagal dimuat',
            description: '${snapshot.error ?? 'Respons server tidak tersedia.'}',
            action: OutlinedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ),
        );
      }

      final payload = snapshot.data!;
      final summary = _securityMap(payload['summary']);
      final activities = _securityList(payload['activities']);
      final sessions = _securityList(payload['sessions']);
      final alerts = _securityList(payload['alerts']);
      final attempts = _securityList(payload['attempts']);
      final hasCritical = alerts.any((item) => item['severity'] == 'critical');
      final filteredActivities = activities.where((activity) {
        final action = '${activity['action'] ?? ''}';
        switch (_activityFilter) {
          case 'Login':
            return {'login', 'logout', 'login_failed'}.contains(action);
          case 'Perubahan Data':
            return {
              'create',
              'update',
              'upload',
              'delete',
              'change_password',
            }.contains(action);
          case 'Keamanan':
            return action == 'login_failed' || action == 'change_password';
          default:
            return true;
        }
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SecurityStatusBanner(
            safe: !hasCritical,
            checking: _checking,
            onCheck: _checkNow,
          ),
          const SizedBox(height: 12),
          _SecuritySummaryGrid(summary: summary),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final activityPanel = _ActivityPanel(
                activities: filteredActivities,
                selectedFilter: _activityFilter,
                onFilter: (value) => setState(() => _activityFilter = value),
              );
              final devicePanel = _DevicePanel(
                sessions: sessions,
                alerts: alerts,
                onRevoke: _revokeSession,
                onReviewAlert: _reviewAlert,
              );
              if (constraints.maxWidth < 900) {
                return Column(
                  children: [
                    activityPanel,
                    const SizedBox(height: 12),
                    devicePanel,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: activityPanel),
                  const SizedBox(width: 12),
                  Expanded(flex: 5, child: devicePanel),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _LoginHistoryPanel(
            attempts: attempts.take(_loginLimit).toList(),
            canLoadMore: _loginLimit < attempts.length,
            onLoadMore: () => setState(() => _loginLimit += 5),
          ),
        ],
      );
    },
  );
}

class _SecurityStatusBanner extends StatelessWidget {
  const _SecurityStatusBanner({
    required this.safe,
    required this.checking,
    required this.onCheck,
  });

  final bool safe;
  final bool checking;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    decoration: BoxDecoration(
      color: safe ? const Color(0xFFF4FCF6) : const Color(0xFFFFF8ED),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: safe ? const Color(0xFF8BD6A0) : const Color(0xFFFFC56A),
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final status = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: safe
                    ? const Color(0xFF2EAD56)
                    : const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                safe ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  safe ? 'Status Keamanan: Aman' : 'Status Keamanan: Perlu Ditinjau',
                  style: TextStyle(
                    color: safe
                        ? const Color(0xFF21873D)
                        : const Color(0xFFB56B00),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  safe
                      ? 'Tidak ada ancaman kritis yang terdeteksi'
                      : 'Terdapat peringatan kritis yang perlu diperiksa',
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ],
        );
        final action = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, color: Color(0xFF37B863), size: 8),
            const SizedBox(width: 8),
            const Text(
              'Pemeriksaan terakhir: baru saja',
              style: TextStyle(color: _muted, fontSize: 11),
            ),
            const SizedBox(width: 18),
            OutlinedButton.icon(
              onPressed: checking ? null : onCheck,
              icon: Icon(
                checking ? Icons.hourglass_top_rounded : Icons.refresh_rounded,
                size: 17,
              ),
              label: Text(checking ? 'Memeriksa...' : 'Periksa Sekarang'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _blue,
                side: const BorderSide(color: _blue),
              ),
            ),
          ],
        );
        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [status, const SizedBox(height: 14), action],
          );
        }
        return Row(
          children: [Expanded(child: status), action],
        );
      },
    ),
  );
}

class _SecuritySummaryGrid extends StatelessWidget {
  const _SecuritySummaryGrid({required this.summary});

  final Map<String, dynamic> summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Sesi Aktif', '${summary['active_sessions'] ?? 0}', Icons.devices_rounded, _blue),
      ('Login Gagal Hari Ini', '${summary['failed_today'] ?? 0}', Icons.gpp_bad_rounded, Colors.red),
      ('Aktivitas Hari Ini', '${summary['activities_today'] ?? 0}', Icons.trending_up_rounded, Colors.green),
      ('Peringatan Belum Dibaca', '${summary['unread_alerts'] ?? 0}', Icons.notifications_none_rounded, Colors.orange),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 580 ? 2 : 4;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map(
                (item) => SizedBox(
                  width: width,
                  child: _SecurityMetric(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _SecurityMetric extends StatelessWidget {
  const _SecurityMetric({required this.item});

  final (String, String, IconData, Color) item;

  @override
  Widget build(BuildContext context) => _SecurityPanel(
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: item.$4.withOpacity(.09),
            shape: BoxShape.circle,
          ),
          child: Icon(item.$3, color: item.$4, size: 25),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.$1, style: const TextStyle(color: _muted, fontSize: 11)),
              Text(
                item.$2,
                style: const TextStyle(
                  color: _text,
                  fontSize: 22,
                  height: 1.05,
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

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({
    required this.activities,
    required this.selectedFilter,
    required this.onFilter,
  });

  final List<Map<String, dynamic>> activities;
  final String selectedFilter;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) => _SecurityPanel(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                'Aktivitas Terbaru',
                style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
            for (final filter in const ['Semua', 'Login', 'Perubahan Data', 'Keamanan'])
              _SecurityFilterChip(
                label: filter,
                selected: selectedFilter == filter,
                onTap: () => onFilter(filter),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (activities.isEmpty)
          const _SecurityEmpty(
            icon: Icons.history_rounded,
            title: 'Tidak ada aktivitas',
            description: 'Belum ada aktivitas pada kategori ini.',
          )
        else
          ...List.generate(
            activities.length > 6 ? 6 : activities.length,
            (index) => _ActivityTimelineRow(
              activity: activities[index],
              last: index == (activities.length > 6 ? 5 : activities.length - 1),
            ),
          ),
      ],
    ),
  );
}

class _SecurityFilterChip extends StatelessWidget {
  const _SecurityFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEAF2FF) : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? _blue : _line),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? _blue : _muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _ActivityTimelineRow extends StatelessWidget {
  const _ActivityTimelineRow({required this.activity, required this.last});

  final Map<String, dynamic> activity;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final appearance = _securityActionAppearance('${activity['action'] ?? ''}');
    final detail = activity['source'] == 'login_attempt'
        ? '${activity['browser'] ?? 'Browser'} di ${activity['operating_system'] ?? 'Perangkat'}'
        : 'Oleh ${activity['nama'] ?? 'Administrator'} - Modul ${_securityTitle(activity['module'])}';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 46,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!last)
                  Positioned(
                    top: 34,
                    bottom: 0,
                    child: Container(width: 1, color: _line),
                  ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: appearance.$2.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(appearance.$1, color: appearance.$2, size: 19),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${activity['description'] ?? 'Aktivitas admin'}',
                          style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(detail, style: const TextStyle(color: _muted, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _securityTime(activity['created_at']),
                    style: const TextStyle(color: _muted, fontSize: 10),
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

class _DevicePanel extends StatelessWidget {
  const _DevicePanel({
    required this.sessions,
    required this.alerts,
    required this.onRevoke,
    required this.onReviewAlert,
  });

  final List<Map<String, dynamic>> sessions;
  final List<Map<String, dynamic>> alerts;
  final ValueChanged<Map<String, dynamic>> onRevoke;
  final ValueChanged<Map<String, dynamic>> onReviewAlert;

  @override
  Widget build(BuildContext context) => _SecurityPanel(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perangkat Aktif',
          style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        if (sessions.isEmpty)
          const _SecurityEmpty(
            icon: Icons.devices_rounded,
            title: 'Tidak ada perangkat aktif',
            description: 'Sesi aktif akan tampil di sini.',
          )
        else
          ...sessions.map(
            (session) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ActiveDeviceRow(
                session: session,
                onRevoke: () => onRevoke(session),
              ),
            ),
          ),
        if (alerts.isNotEmpty) ...[
          const SizedBox(height: 2),
          ...alerts.map(
            (alert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AlertReviewRow(
                alert: alert,
                onReview: () => onReviewAlert(alert),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

class _ActiveDeviceRow extends StatelessWidget {
  const _ActiveDeviceRow({required this.session, required this.onRevoke});

  final Map<String, dynamic> session;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final current = session['current'] == true;
    final mobile = session['device_type'] == 'mobile';
    final location = _securityLocation(session);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Icon(
            mobile ? Icons.phone_android_rounded : Icons.desktop_windows_rounded,
            color: _blue,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${session['browser'] ?? 'Browser'} di ${session['operating_system'] ?? 'Perangkat'}',
                  style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
                ),
                Text(location, style: const TextStyle(color: _muted, fontSize: 11)),
                Text('IP ${session['ip_address'] ?? '-'}', style: const TextStyle(color: _muted, fontSize: 10)),
              ],
            ),
          ),
          if (current) ...[
            const Icon(Icons.circle, color: Color(0xFF37B863), size: 8),
            const SizedBox(width: 6),
            const Text('Aktif sekarang', style: TextStyle(color: _muted, fontSize: 10)),
            const SizedBox(width: 12),
            const _SecurityBadge(
              label: 'Perangkat Ini',
              foreground: Color(0xFF21873D),
              background: Color(0xFFEAF8EE),
            ),
          ] else ...[
            Text(
              _securityLastActive(session['last_seen_at']),
              textAlign: TextAlign.right,
              style: const TextStyle(color: _muted, fontSize: 10),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: onRevoke,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Keluarkan'),
            ),
          ],
        ],
      ),
    );
  }
}

class _AlertReviewRow extends StatelessWidget {
  const _AlertReviewRow({required this.alert, required this.onReview});

  final Map<String, dynamic> alert;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9F0),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFFFC873)),
    ),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 27),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${alert['title'] ?? 'Peringatan keamanan'}',
                style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
              ),
              Text(
                'IP ${alert['ip_address'] ?? '-'} - ${_securityTime(alert['created_at'])}',
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: onReview,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange.shade800,
            side: const BorderSide(color: Colors.orange),
            visualDensity: VisualDensity.compact,
          ),
          child: const Text('Tinjau'),
        ),
      ],
    ),
  );
}

class _LoginHistoryPanel extends StatelessWidget {
  const _LoginHistoryPanel({
    required this.attempts,
    required this.canLoadMore,
    required this.onLoadMore,
  });

  final List<Map<String, dynamic>> attempts;
  final bool canLoadMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) => _SecurityPanel(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Login',
          style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        if (attempts.isEmpty)
          const _SecurityEmpty(
            icon: Icons.login_rounded,
            title: 'Belum ada riwayat login',
            description: 'Riwayat login berhasil dan gagal akan tampil di sini.',
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 700) {
                return Column(
                  children: attempts
                      .map((attempt) => _LoginHistoryMobileRow(attempt: attempt))
                      .toList(),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowHeight: 38,
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 54,
                    horizontalMargin: 12,
                    columnSpacing: 32,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF7F9FC)),
                    columns: const [
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Perangkat')),
                      DataColumn(label: Text('Lokasi')),
                      DataColumn(label: Text('Alamat IP')),
                      DataColumn(label: Text('Waktu')),
                    ],
                    rows: attempts.map(_loginDataRow).toList(),
                  ),
                ),
              );
            },
          ),
        if (canLoadMore)
          Center(
            child: TextButton.icon(
              onPressed: onLoadMore,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              label: const Text('Muat Lebih Banyak'),
            ),
          ),
      ],
    ),
  );
}

DataRow _loginDataRow(Map<String, dynamic> attempt) {
  final success = attempt['status'] == 'success';
  final mobile = attempt['device_type'] == 'mobile';
  return DataRow(
    cells: [
      DataCell(
        _SecurityBadge(
          label: success ? 'Berhasil' : 'Gagal',
          foreground: success ? const Color(0xFF21873D) : Colors.red,
          background: success ? const Color(0xFFEAF8EE) : const Color(0xFFFFECEC),
        ),
      ),
      DataCell(
        Row(
          children: [
            Icon(mobile ? Icons.phone_android_rounded : Icons.desktop_windows_rounded, color: _blue, size: 20),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${attempt['browser'] ?? 'Browser'} di ${attempt['operating_system'] ?? 'Perangkat'}'),
                Text('${attempt['device_type'] ?? 'unknown'}', style: const TextStyle(color: _muted, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
      DataCell(Text(_securityLocation(attempt))),
      DataCell(Text('${attempt['ip_address'] ?? '-'}')),
      DataCell(Text(_securityTime(attempt['attempted_at']))),
    ],
  );
}

class _LoginHistoryMobileRow extends StatelessWidget {
  const _LoginHistoryMobileRow({required this.attempt});

  final Map<String, dynamic> attempt;

  @override
  Widget build(BuildContext context) {
    final success = attempt['status'] == 'success';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            attempt['device_type'] == 'mobile'
                ? Icons.phone_android_rounded
                : Icons.desktop_windows_rounded,
            color: _blue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${attempt['browser'] ?? 'Browser'} di ${attempt['operating_system'] ?? 'Perangkat'}',
                  style: const TextStyle(color: _text, fontWeight: FontWeight.w800),
                ),
                Text('${attempt['ip_address'] ?? '-'} - ${_securityTime(attempt['attempted_at'])}', style: const TextStyle(color: _muted, fontSize: 10)),
              ],
            ),
          ),
          _SecurityBadge(
            label: success ? 'Berhasil' : 'Gagal',
            foreground: success ? const Color(0xFF21873D) : Colors.red,
            background: success ? const Color(0xFFEAF8EE) : const Color(0xFFFFECEC),
          ),
        ],
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  const _SecurityBadge({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: foreground.withOpacity(.18)),
    ),
    child: Text(
      label,
      style: TextStyle(color: foreground, fontSize: 10, fontWeight: FontWeight.w700),
    ),
  );
}

class _SecurityPanel extends StatelessWidget {
  const _SecurityPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _line),
      boxShadow: const [
        BoxShadow(color: Color(0x08082E65), blurRadius: 14, offset: Offset(0, 4)),
      ],
    ),
    child: child,
  );
}

class _SecurityEmpty extends StatelessWidget {
  const _SecurityEmpty({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: Center(
      child: Column(
        children: [
          Icon(icon, size: 38, color: const Color(0xFF9AB2CF)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: _text, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(color: _muted, fontSize: 11)),
          if (action != null) ...[const SizedBox(height: 8), action!],
        ],
      ),
    ),
  );
}

Map<String, dynamic> _securityMap(dynamic value) =>
    Map<String, dynamic>.from(value as Map? ?? {});

List<Map<String, dynamic>> _securityList(dynamic value) =>
    (value as List? ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

(IconData, Color) _securityActionAppearance(String action) {
  switch (action) {
    case 'login':
      return (Icons.login_rounded, Colors.green);
    case 'login_failed':
      return (Icons.gpp_bad_outlined, Colors.red);
    case 'logout':
      return (Icons.logout_rounded, Colors.orange);
    case 'upload':
      return (Icons.photo_library_outlined, Colors.purple);
    case 'delete':
      return (Icons.delete_outline_rounded, Colors.red);
    case 'change_password':
      return (Icons.password_rounded, Colors.orange);
    case 'create':
      return (Icons.add_circle_outline_rounded, Colors.green);
    default:
      return (Icons.settings_outlined, _blue);
  }
}

String _securityTitle(dynamic value) {
  final text = '${value ?? 'Admin'}'.replaceAll('_', ' ').trim();
  if (text.isEmpty) return 'Admin';
  return text
      .split(' ')
      .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

String _securityTime(dynamic value) {
  final date = DateTime.tryParse('${value ?? ''}');
  if (date == null) return '-';
  final now = DateTime.now();
  final day = date.year == now.year && date.month == now.month && date.day == now.day
      ? 'Hari ini'
      : now.difference(date).inDays == 1
      ? 'Kemarin'
      : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  return '$day, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} WIB';
}

String _securityLastActive(dynamic value) {
  final date = DateTime.tryParse('${value ?? ''}');
  if (date == null) return 'Terakhir aktif';
  final minutes = DateTime.now().difference(date).inMinutes;
  if (minutes <= 1) return 'Baru saja';
  if (minutes < 60) return 'Terakhir aktif\n$minutes menit lalu';
  return 'Terakhir aktif\n${minutes ~/ 60} jam lalu';
}

String _securityLocation(Map<String, dynamic> item) {
  final parts = [item['city'], item['region'], item['country']]
      .map((value) => '${value ?? ''}'.trim())
      .where((value) => value.isNotEmpty)
      .toList();
  return parts.isEmpty ? 'Lokasi tidak tersedia' : parts.join(', ');
}
