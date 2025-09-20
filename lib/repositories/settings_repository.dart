import 'package:divisao_contas/models/pix_type.dart';

import '../db/db_context.dart';

class SettingsRepository {
  static final db = DbContext.connect();

  void setPreference<T>(String key, T value) {
    var valueType = T.toString().toLowerCase();

    final stmt = db.prepare('''
      INSERT INTO Settings (key, valueType, value) VALUES (?, ?, ?)
      ON CONFLICT(key) DO UPDATE SET valueType = excluded.valueType, value = excluded.value
    ''');
    stmt.execute([key, valueType, value.toString()]);
    stmt.dispose();
  } 
  
  T? getPreference<T>(String key) {
    final row = db
      .select("SELECT * FROM Settings WHERE key = ?", [key])
      .firstOrNull;

    return _parseValue<T>(row?["value"]);
  }

  T? _parseValue<T>(String? value) {
    if (value == null) {
      return null;
    }

    var valueType = T.toString().toLowerCase();
    switch (valueType) {
      case "bool":
        return bool.parse(value) as T;
      case "string":
        return value as T;
      case "int":
        return int.parse(value) as T;
      case "double":
        return double.parse(value) as T;
      case "pixtype":
        return PixType.values.where((type) => type.toString() == value).firstOrNull as T?;
      default:
        return null;
    }
  }
}
