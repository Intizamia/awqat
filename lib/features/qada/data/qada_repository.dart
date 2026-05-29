import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/qada_data.dart';

class QadaRepository {
  static const _key = 'qada_data';

  Future<QadaData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return QadaData.empty();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final entries = QadaPrayer.values.map((p) {
        final pData = map[p.name] as Map<String, dynamic>?;
        if (pData == null) return QadaEntry(prayer: p, count: 0);
        final ts = pData['updatedAt'] as String?;
        return QadaEntry(
          prayer: p,
          count: (pData['count'] as num?)?.toInt() ?? 0,
          updatedAt: ts != null ? DateTime.tryParse(ts) : null,
        );
      }).toList();
      return QadaData(entries: entries);
    } catch (_) {
      return QadaData.empty();
    }
  }

  Future<void> save(QadaData data) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      for (final e in data.entries)
        e.prayer.name: {
          'count': e.count,
          'updatedAt': e.updatedAt?.toIso8601String(),
        },
    };
    await prefs.setString(_key, jsonEncode(map));
  }
}
