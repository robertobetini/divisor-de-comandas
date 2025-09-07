import 'package:divisao_contas/db/db_context.dart';
import '../models/people.dart';

class PeopleRepository {
  static final db = DbContext.connect();

  void add(People people) {
    var stmt = db.prepare("INSERT INTO Peoples (name, createdAt, isDeleted) VALUES (?, ?, 0)");
    stmt.execute([people.name, people.createdAt.millisecondsSinceEpoch]);
    stmt.dispose();

    people.id = db.lastInsertRowId;
  }

  void update(People people) {
    var stmt = db.prepare("UPDATE Peoples SET name = ? WHERE rowid = ? AND isDeleted = 0");
    stmt.execute([people.name, people.id]);
    stmt.dispose();
  }

  People? get(int id) {
    return db
      .select("SELECT rowid, * FROM Peoples WHERE rowid = ? AND isDeleted = 0", [id])
      .map<People>((row) {
        return People.fromDb(row["rowid"], row["name"], row["createdAt"]);
      })
      .firstOrNull;
  }

  List<People> getAll({ String? name }) {
    var query = "SELECT rowid, * FROM Peoples WHERE isDeleted = 0 ";
    var queryParams = [];

    if (name != null) {
      query += "AND name LIKE ? ";
      queryParams.add("%$name%");
    }

    query += "ORDER BY createdAt DESC";

    return db
      .select(query, queryParams)
      .map<People>((row) {
        return People.fromDb(row["rowid"], row["name"], row["createdAt"]);
      })
      .toList();
  }

  List<People> find(String substring, { bool isCaseSensitive = false }) {
    if (substring.isEmpty) {
      return getAll();
    }

    return db
      .select("SELECT rowid, * FROM Peoples WHERE name LIKE ? AND isDeleted = 0", ["%$substring%"])
      .map<People>((row) {
        return People.fromDb(row["rowid"], row["name"], row["createdAt"]);
      })
      .toList();
  }

  People? findExactMatch(String name) {
    return db
      .select("SELECT rowid, * FROM Peoples WHERE name = ?", [name])
      .map<People>((row) => People.fromDb(row["rowid"], row["name"], row["createdAt"]))
      .firstOrNull;
  }

  void remove(int id) {
    final stmt = db.prepare("UPDATE Peoples SET isDeleted = 1, name = 'Desconhecido' WHERE rowid = ?");
    stmt.execute([id]);
    stmt.dispose();
  }
}
