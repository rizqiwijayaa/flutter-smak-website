import 'smak_api.dart';

/// Membaca data publik dari tabel yang sama dengan dashboard admin.
class ProfileContentApi {
  const ProfileContentApi(this._api);

  final SmakApi _api;

  Future<Map<String, dynamic>> first(String table) async {
    final rows = await _api.getTable(table, limit: 1);
    return rows.isEmpty ? <String, dynamic>{} : rows.first;
  }
}
