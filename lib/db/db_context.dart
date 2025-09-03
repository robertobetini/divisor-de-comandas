import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';

const String dbName = "app.db";

class DbContext {
  static var _db = sqlite3.open("");

  static Database connect() => _db;

  static Future<void> initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, dbName);
    _db = sqlite3.open(path);

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Peoples (
        name VARCHAR(64),
        qName VARCHAR(64),
        isDeleted INTEGER,
        createdAt TIMESTAMP
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Products (
        name VARCHAR(32),
        price TEXT
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Orders (
        description VARCHAR(128),
        isClosed INTEGER,
        hasServiceCharge INTEGER,
        subtotal TEXT,
        createdAt TIMESTAMP
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS OrderItems (
        quantity INTEGER,
        product_id INTEGER,
        order_id INTEGER,

        FOREIGN KEY (product_id) REFERENCES Products(rowid) ON DELETE CASCADE,
        FOREIGN KEY (order_id) REFERENCES Orders(rowid) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS OrderPayerSharings (
        quantity INTEGER,
        orderItem_id INTEGER,
        payer_id INTEGER,

        FOREIGN KEY (orderItem_id) REFERENCES OrderItems(rowid) ON DELETE CASCADE,
        FOREIGN KEY (payer_id) REFERENCES Payers(rowid) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS Payers (
        people_id INTEGER,
        order_id INTEGER,

        FOREIGN KEY (people_id) REFERENCES Peoples(rowid) ON DELETE CASCADE, 
        FOREIGN KEY (order_id) REFERENCES Orders(rowid) ON DELETE CASCADE
      );
    ''');
  }

  static T? executeInTransaction<T>(T Function() func, { Database? database }) {
    try {
      _db.execute("BEGIN TRANSACTION");
      var result = func();
      _db.execute("COMMIT");
      
      return result;
    } catch(e) {
      _db.execute("ROLLBACK");
      print('Erro na transação: $e');
    }

    return null;
  }
}
