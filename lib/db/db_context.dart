import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';

const String dbName = "app.db";

class DbContext {
  static Database? _db;

  static Database connect() {
    if (_db == null) {
      throw Exception("Db não inicializado!");
    }

    return _db!;
  } 

  static Future<void> initDb() async {
    if (_db == null) {
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, dbName);
      _db = sqlite3.open(path);
    }

    final db = connect();

    db.execute('''
      CREATE TABLE IF NOT EXISTS Peoples (
        name VARCHAR(64),
        qName VARCHAR(64),
        isDeleted INTEGER,
        createdAt TIMESTAMP
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS Products (
        name VARCHAR(32),
        price TEXT
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS Orders (
        description VARCHAR(128),
        isClosed INTEGER,
        hasServiceCharge INTEGER,
        subtotal TEXT,
        createdAt TIMESTAMP
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS OrderItems (
        quantity INTEGER,
        product_id INTEGER,
        order_id INTEGER,

        FOREIGN KEY (product_id) REFERENCES Products(rowid) ON DELETE CASCADE,
        FOREIGN KEY (order_id) REFERENCES Orders(rowid) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS OrderPayerSharings (
        quantity INTEGER,
        orderItem_id INTEGER,
        payer_id INTEGER,

        FOREIGN KEY (orderItem_id) REFERENCES OrderItems(rowid) ON DELETE CASCADE,
        FOREIGN KEY (payer_id) REFERENCES Payers(rowid) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS Payers (
        people_id INTEGER,
        order_id INTEGER,

        FOREIGN KEY (people_id) REFERENCES Peoples(rowid) ON DELETE CASCADE, 
        FOREIGN KEY (order_id) REFERENCES Orders(rowid) ON DELETE CASCADE
      );
    ''');
  }

  static Future<void> resetDb() async {
    final db = connect();

    await executeInTransactionAsync(() async {
      db.execute("DROP TABLE IF EXISTS Peoples");
      db.execute("DROP TABLE IF EXISTS Products");
      db.execute("DROP TABLE IF EXISTS Orders");
      db.execute("DROP TABLE IF EXISTS OrderItems");
      db.execute("DROP TABLE IF EXISTS OrderPayerSharings");
      db.execute("DROP TABLE IF EXISTS Payers");
      await initDb();
    }, database: db);
  }

  static T? executeInTransaction<T>(T Function() func, { Database? database }) {
    final db = database ?? connect();

    try {
      db.execute("BEGIN TRANSACTION");
      var result = func();
      db.execute("COMMIT");
      
      return result;
    } catch(e) {
      db.execute("ROLLBACK");
      print('Erro na transação: $e');
    }

    return null;
  }

  static Future<T?> executeInTransactionAsync<T>(Future<T> Function() func, { Database? database }) async {
    final db = database ?? connect();

    try {
      db.execute("BEGIN TRANSACTION");
      var result = await func();
      db.execute("COMMIT");
      
      return result;
    } catch(e) {
      db.execute("ROLLBACK");
      print('Erro na transação: $e');
    }

    return null;
  }
}
