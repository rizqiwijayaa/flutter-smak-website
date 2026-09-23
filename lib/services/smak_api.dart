import 'dart:convert';
import 'dart:html' as html;

class SmakApi {
  const SmakApi({String? baseUrl}) : _baseUrl = baseUrl;

  final String? _baseUrl;

  String get baseUrl {
    const configuredUrl = String.fromEnvironment(
      'SMAK_API_URL',
      defaultValue: 'api/index.php',
    );
    final documentBase = html.document.baseUri ?? html.window.location.href;
    return Uri.parse(documentBase).resolve(_baseUrl ?? configuredUrl).toString();
  }

  String getFileUrl(String filename) {
    final clean = filename.trim().replaceAll('\\', '/');

    if (clean.isEmpty) return '';

    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return clean;
    }

    final source = Uri.tryParse(clean);
    final name = source?.queryParameters['file'] ?? clean.split('/').last;
    return Uri.parse(baseUrl).replace(queryParameters: {'file': name}).toString();
  }

  Future<List<Map<String, dynamic>>> getTable(
    String table, {
    int limit = 50,
    int offset = 0,
  }) async {
    final t = DateTime.now().millisecondsSinceEpoch;
    final uri = Uri.parse(
      '$baseUrl?table=$table&limit=$limit&offset=$offset&_t=$t',
    );
    final sessionToken = _sessionToken;
    final response = await html.HttpRequest.request(
      uri.toString(),
      method: 'GET',
      requestHeaders: {
        if (sessionToken.isNotEmpty) 'Authorization': 'Bearer $sessionToken',
      },
    );

    if (response.status != 200) {
      throw Exception('API mengembalikan status ${response.status}.');
    }

    final rawResponse = response.responseText ?? '{}';
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(rawResponse) as Map<String, dynamic>;
    } catch (_) {
      throw Exception(
        'API mengembalikan error server. Salin folder api terbaru ke Laragon.',
      );
    }
    if (payload['success'] != true) {
      throw Exception(payload['message'] ?? 'Gagal mengambil data.');
    }

    return (payload['data'] as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> save(String table, Map<String, dynamic> data, {int? id}) async {
    await _send({
      'action': 'save',
      'table': table,
      'data': data,
      if (id != null) 'id': id,
    });
  }

  Future<void> delete(String table, int id) async {
    await _send({'action': 'delete', 'table': table, 'id': id});
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required bool rememberMe,
    required String userAgent,
    required String browser,
    required String operatingSystem,
    required String deviceType,
  }) {
    return _sendForPayload({
      'action': 'login',
      'username': username,
      'password': password,
      'remember_me': rememberMe,
      'user_agent': userAgent,
      'browser': browser,
      'operating_system': operatingSystem,
      'device_type': deviceType,
    });
  }

  Future<void> logout(String sessionToken) async {
    try {
      await _sendForPayload({
        'action': 'logout',
        'session_token': sessionToken,
      });
    } finally {
      html.window.localStorage.remove('smak_admin_session');
      html.window.sessionStorage.remove('smak_admin_session');
    }
  }

  Future<void> revokeSession(int sessionId) async {
    await _sendForPayload({
      'action': 'revoke_session',
      'session_id': sessionId,
    });
  }

  Future<void> readSecurityAlert(int alertId) async {
    await _sendForPayload({'action': 'read_alert', 'alert_id': alertId});
  }

  Future<Map<String, dynamic>> getSecurityDashboard(String sessionToken) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'action': 'security_dashboard',
        '_t': '${DateTime.now().millisecondsSinceEpoch}',
      },
    );
    final response = await html.HttpRequest.request(
      uri.toString(),
      method: 'GET',
      requestHeaders: {
        if (sessionToken.isNotEmpty) 'Authorization': 'Bearer $sessionToken',
      },
    );
    final payload = _decodeResponse(response.responseText);
    if (response.status != 200 || payload['success'] != true) {
      throw Exception(payload['message'] ?? 'Data keamanan gagal dimuat.');
    }
    return payload;
  }

  Future<String> uploadFile(String table, html.File file) async {
    final sessionToken = _sessionToken;
    final formData = html.FormData();
    formData.append('table', table);
    formData.append('session_token', _sessionToken);
    formData.appendBlob('file', file, file.name);
    final response = await html.HttpRequest.request(
      baseUrl,
      method: 'POST',
      sendData: formData,
      requestHeaders: {
        if (sessionToken.isNotEmpty) 'Authorization': 'Bearer $sessionToken',
      },
    );
    final payload = _decodeResponse(response.responseText);
    if (response.status != 200 || payload['success'] != true) {
      throw Exception(payload['message'] ?? 'Upload file gagal.');
    }
    return '${payload['filename']}';
  }

  Future<void> _send(Map<String, dynamic> body) async {
    await _sendForPayload(body);
  }

  Future<Map<String, dynamic>> _sendForPayload(
    Map<String, dynamic> body,
  ) async {
    if (body['action'] != 'login' && !body.containsKey('session_token')) {
      body['session_token'] = _sessionToken;
    }
    final sessionToken = '${body['session_token'] ?? ''}';
    final response = await html.HttpRequest.request(
      baseUrl,
      method: 'POST',
      sendData: jsonEncode(body),
      requestHeaders: {
        'Content-Type': 'application/json',
        if (sessionToken.isNotEmpty) 'Authorization': 'Bearer $sessionToken',
      },
    );
    final payload = _decodeResponse(response.responseText);
    if (response.status != 200 || payload['success'] != true) {
      throw Exception(payload['message'] ?? 'Permintaan API gagal.');
    }
    return payload;
  }

  String get _sessionToken =>
      html.window.sessionStorage['smak_admin_session'] ??
      html.window.localStorage['smak_admin_session'] ??
      '';

  Map<String, dynamic> _decodeResponse(String? rawResponse) {
    try {
      return jsonDecode(rawResponse ?? '{}') as Map<String, dynamic>;
    } catch (_) {
      throw Exception(
        'API mengembalikan error server. Salin folder api terbaru ke Laragon.',
      );
    }
  }
}
