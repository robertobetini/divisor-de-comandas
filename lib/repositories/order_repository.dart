import 'package:decimal/decimal.dart';
import 'package:divisao_contas/db/db_context.dart';
import 'package:divisao_contas/models/people.dart';

import '../models/order.dart';

class OrderRepository {
  static final db = DbContext.connect();

  void add(Order order) {
    DbContext.executeInTransaction(() {
      var stmt = db.prepare("INSERT INTO Orders (description, isClosed, hasServiceCharge, subtotal, createdAt) VALUES (?, ?, ?, ?, ?)");
      stmt.execute([order.description, order.isClosed, order.hasServiceCharge, order.subtotal.toStringAsFixed(2), order.createdAt.millisecondsSinceEpoch]);
      stmt.dispose();
      order.id = db.lastInsertRowId;

      for (var orderItem in order.getItems()) {
        stmt = db.prepare("INSERT INTO Products (name, price) VALUES (?, ?)");
        stmt.execute([orderItem.product.name, orderItem.product.price.toStringAsFixed(2)]);
        stmt.dispose();
        orderItem.product.id = db.lastInsertRowId;

        stmt = db.prepare("INSERT INTO OrderItems (quantity, product_id, order_id, isIndividual) VALUES (?, ?, ?, ?)");
        stmt.execute([orderItem.quantity, orderItem.product.id, order.id, orderItem.isIndividual]);
        stmt.dispose();
        orderItem.id = db.lastInsertRowId;
      }

      for (var payer in order.getPayers()) {
        stmt = db.prepare("INSERT INTO Payers (people_id, order_id) VALUES (?, ?)");
        stmt.execute([payer.people.id, order.id]);
        stmt.dispose();
        payer.id = db.lastInsertRowId;
        
        for (var sharing in payer.sharings) {
          stmt = db.prepare("INSERT INTO OrderPayerSharings (quantity, orderItem_id, payer_id) VALUES (?, ?, ?)");
          stmt.execute([sharing.quantity, sharing.orderItem.id, payer.id]);
          stmt.dispose();
          sharing.id = db.lastInsertRowId;
        }
      }
    }, database: db);
  }

  void update(Order order) {
    DbContext.executeInTransaction(() {
      var stmt = db.prepare("UPDATE Orders SET description = ?, isClosed = ?, hasServiceCharge = ?, subtotal = ? WHERE rowid = ?");
      stmt.execute([order.description, order.isClosed, order.hasServiceCharge, order.subtotal.toStringAsFixed(2), order.id]);
      stmt.dispose();

      for (var orderItem in order.getItems()) {
        db.execute("DELETE FROM OrderPayerSharings WHERE orderItem_id = ?", [orderItem.id]);
      }
      for (var payer in order.getPayers()) {
        db.execute("DELETE FROM OrderPayerSharings WHERE payer_id = ?", [payer.id]);
      }
      db.execute("DELETE FROM OrderItems WHERE order_id = ?", [order.id]);
      db.execute("DELETE FROM Payers WHERE order_id = ?", [order.id]);

      for (var orderItem in order.getItems()) {
        stmt = db.prepare("INSERT INTO Products (name, price) VALUES (?, ?)");
        stmt.execute([orderItem.product.name, orderItem.product.price.toStringAsFixed(2)]);
        stmt.dispose();
        orderItem.product.id = db.lastInsertRowId;

        stmt = db.prepare("INSERT INTO OrderItems (quantity, product_id, order_id, isIndividual) VALUES (?, ?, ?, ?)");
        stmt.execute([orderItem.quantity, orderItem.product.id, order.id, orderItem.isIndividual]);
        stmt.dispose();
        orderItem.id = db.lastInsertRowId;
      }

      for (var payer in order.getPayers()) {
        stmt = db.prepare("INSERT INTO Payers (people_id, order_id) VALUES (?, ?)");
        stmt.execute([payer.people.id, order.id]);
        stmt.dispose();
        payer.id = db.lastInsertRowId;
        
        for (var sharing in payer.sharings) {
          stmt = db.prepare("INSERT INTO OrderPayerSharings (quantity, orderItem_id, payer_id) VALUES (?, ?, ?)");
          stmt.execute([sharing.quantity, sharing.orderItem.id, payer.id]);
          stmt.dispose();
          sharing.id = db.lastInsertRowId;
        }
      }
    }, database: db);
  }

  Order? get(int id) {
    final order = db
      .select("SELECT rowid, * FROM Orders WHERE rowid = ?", [id])
      .map<Order>((row) => Order.fromDb(
          row["rowid"],
          row["description"], 
          row["hasServiceCharge"] == 1, 
          row["isClosed"] == 1, 
          Decimal.parse(row["subtotal"]), 
          row["createdAt"]
        )
      )
      .firstOrNull;
    
    if (order == null) {
      return null;
    }

    final orderItems = db
        .select('''
          SELECT oi.rowid AS orderItem_rowid, p.rowid AS product_rowid, * 
          FROM OrderItems oi
          LEFT JOIN Products p ON p.rowid = oi.product_id
          WHERE oi.order_id = ?
        ''', [id]);
      
      for (var row in orderItems) {
        final product = Product.fromDb(
          row["product_rowid"],
          row["name"], 
          Decimal.parse(row["price"])
        );

        final orderItem = OrderItem.fromDb(row["orderItem_rowid"], product, row["quantity"], row["isIndividual"] == 1);
        order.addItem(orderItem);
      }

      final payers = db
        .select('''
          SELECT pa.rowid AS payer_rowid, pe.rowid AS person_rowid, * 
          FROM Payers pa
          LEFT JOIN Peoples pe ON pe.rowid = pa.people_id
          WHERE pa.order_id = ?
        ''', [order.id]);

      for (var row in payers) {
        final people = People.fromDb(row["person_rowid"], row["name"], row["createdAt"]);
        final payer = Payer.fromDb(row["payer_rowid"], people);
        order.addPayer(payer);
      }

      final orderPayerSharings = db
        .select('''
          SELECT ops.rowid AS orderPayerSharings_rowid, ops.quantity AS orderPayerSharings_quantity, * 
          FROM Orders o
          LEFT JOIN OrderItems oi ON o.rowid = oi.order_id
          LEFT JOIN OrderPayerSharings ops ON oi.rowid = ops.orderItem_id
          WHERE o.rowid = ?
        ''', [order.id]);

      for (var row in orderPayerSharings) {
        final payer = order.getPayers().where((p) => p.id == row["payer_id"]).firstOrNull;
        final orderItem = order.getItems().where((i) => i.id == row["orderItem_id"]).firstOrNull;

        if (payer == null || orderItem == null) {
          continue;
        }

        final orderPayerSharings = OrderPayerSharings.fromDb(
          row["orderPayerSharings_rowid"], 
          payer, 
          orderItem,
          row["orderPayerSharings_quantity"]
        );

        payer.sharings.add(orderPayerSharings);
        orderItem.sharings.add(orderPayerSharings);
      }

      return order;
  }

  List<Order> getAll({ bool deepSearch = false, String? description, DateTime? startDate, DateTime? endDate, bool isOrderByAsc = false }) {
    var query = "SELECT rowid, * FROM Orders ";
    List<(String queryString, Object queryParam)> whereClauses = [];

    if (description != null) {
      whereClauses.add(
        ("description LIKE ?", "%$description%")
      );
    }

    if (startDate != null && endDate != null) {
      whereClauses.addAll([
        ("createdAt >= ?", startDate.millisecondsSinceEpoch),
        ("createdAt < ?", endDate.millisecondsSinceEpoch)
      ]);
    }

    if (whereClauses.isNotEmpty) {
      query += "WHERE ${whereClauses.map((clause) => clause.$1).join('AND')}";
    }

    if (isOrderByAsc) {
      query += "ORDER BY createdAt ASC";
    } else {
      query += "ORDER BY createdAt DESC";
    }
    
    final orders = db
      .select(query, whereClauses.map((clause) => clause.$2).toList())
      .map<Order>((row) => Order.fromDb(
          row["rowid"],
          row["description"], 
          row["hasServiceCharge"] == 1, 
          row["isClosed"] == 1, 
          Decimal.parse(row["subtotal"]), 
          row["createdAt"]
        )
      )
      .toList();

    if (!deepSearch) {
      return orders;
    }

    for (var order in orders) {
      final orderItems = db
        .select('''
          SELECT oi.rowid AS orderItem_rowid, p.rowid AS product_rowid, * 
          FROM OrderItems oi
          LEFT JOIN Products p ON p.rowid = oi.product_id
          WHERE oi.order_id = ?
        ''', [order.id]);
      
      for (var row in orderItems) {
        final product = Product.fromDb(
          row["product_rowid"],
          row["name"], 
          Decimal.parse(row["price"])
        );

        final orderItem = OrderItem.fromDb(row["orderItem_rowid"], product, row["quantity"], row["isIndividual"] == 1);
        order.addItem(orderItem);
      }

      final payers = db
        .select('''
          SELECT pa.rowid AS payer_rowid, pe.rowid AS person_rowid, * 
          FROM Payers pa
          LEFT JOIN Peoples pe ON pe.rowid = pa.people_id
          WHERE pa.order_id = ?
        ''', [order.id]);

      for (var row in payers) {
        final people = People.fromDb(row["person_rowid"], row["name"], row["createdAt"]);
        final payer = Payer.fromDb(row["payer_rowid"], people);
        order.addPayer(payer);
      }

      final orderPayerSharings = db
        .select('''
          SELECT ops.rowid AS orderPayerSharings_rowid, ops.quantity AS orderPayerSharings_quantity, * 
          FROM Orders o
          LEFT JOIN OrderItems oi ON o.rowid = oi.order_id
          LEFT JOIN OrderPayerSharings ops ON oi.rowid = ops.orderItem_id
          WHERE o.rowid = ?
        ''', [order.id]);

      for (var row in orderPayerSharings) {
        final payer = order.getPayers().where((p) => p.id == row["payer_id"]).firstOrNull;
        final orderItem = order.getItems().where((i) => i.id == row["orderItem_id"]).firstOrNull;

        if (payer == null || orderItem == null) {
          continue;
        }

        final orderPayerSharings = OrderPayerSharings.fromDb(
          row["orderPayerSharings_rowid"], 
          payer, 
          orderItem,
          row["orderPayerSharings_quantity"]
        );

        payer.sharings.add(orderPayerSharings);
        orderItem.sharings.add(orderPayerSharings);
      }
    }

    return orders;
  }
}