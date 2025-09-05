import 'package:decimal/decimal.dart';
import 'people.dart';

class Order {
  Order();
  Order.fromDb(this.id, this.description, this.hasServiceCharge, this.isClosed, this.subtotal, int timestamp) {
    createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  int id = 0;

  String? description;
  bool hasServiceCharge = false;
  bool isClosed = false;

  Decimal subtotal = Decimal.zero;

  DateTime createdAt = DateTime.now();
  List<OrderItem> _items = [];
  List<Payer> _payers = [];

  List<OrderItem> getItems() => _items.toList();
  List<Payer> getPayers() => _payers.toList();

  void addItem(OrderItem item) {
    _items.add(item);
    updateTotalPrice();
  }

  void addPayer(Payer payer) {
    for (var existingPayer in _payers) {
      if (existingPayer.people.id == payer.people.id) {
        return;
      }
    }

    _payers.add(payer);
  }

  OrderItem createItem(Product product) {
    var item = OrderItem(product);
    addItem(item);

    return item;
  }

  void removePayer(int payerId) {
    _payers.removeWhere((p) => p.id == payerId);

    for (var item in _items) {
      item.sharings.removeWhere((s) => s.payer.id == payerId);
    }
  }

  void removeItem(String productName) {
    _items.removeWhere((i) => i.product.name == productName);

    for (var payer in _payers) {
      payer.sharings.removeWhere((s) => s.orderItem.product.name == productName);
    }
  }

  void removeSharing(int sharingId) {
    for (var payer in _payers) {
      payer.sharings.removeWhere((s) => s.id == sharingId);
    }

    for (var item in _items) {
      item.sharings.removeWhere((s) => s.id == sharingId);
    }
  }

  OrderPayerSharings linkPayerToItem(OrderItem item, Payer payer) {
    var payerFound = false;

    for (int i = 0; i < _payers.length; i++) {
      var existingSharing = payer.sharings.where((sharing) => sharing.orderItem.product.name == item.product.name).firstOrNull;
      if (existingSharing != null) {
        return existingSharing;
      }

      if (payer.people.id == _payers[i].people.id) {
        payerFound = true;
      }
    }
    
    if (!payerFound) {
      throw Exception("Pagador não encontrado na comanda!");
    }

    var orderPayerSharings = OrderPayerSharings(payer, item);

    item.sharings.add(orderPayerSharings);
    payer.sharings.add(orderPayerSharings);

    return orderPayerSharings;
  }

  List<OrderItem> findItem(String substring, { bool isCaseSensitive = false }) {
    if (substring.isEmpty) {
      return _items.toList();
    }

    return _items
      .where((item) => isCaseSensitive 
        ? item.product.name.contains(substring)
        : item.product.name.toLowerCase().contains(substring.toLowerCase())
      )
      .toList();
  }

  Decimal getServiceCharge() {
    return hasServiceCharge 
      ? subtotal * Decimal.parse("0.1")
      : Decimal.zero;
  }

  Decimal total() => subtotal + getServiceCharge();

  void updateTotalPrice() {
    subtotal = Decimal.zero;

    for (var item in _items) {
      subtotal += item.product.price * Decimal.fromInt(item.quantity);
    }
  }
}

class Product {
  Product({ required this.name, required this.price });
  Product.fromDb(this.id, this.name, this.price);

  int id = 0;
  String name;
  Decimal price;
}

class OrderItem {
  OrderItem(this.product, { this.quantity = 1 });
  OrderItem.fromDb(this.id, this.product, this.quantity);

  int id = 0;
  final Product product;
  List<OrderPayerSharings> sharings = [];
  int quantity = 1;
}

class Payer {
  Payer(this.people);
  Payer.fromDb(this.id, this.people);

  int id = 0;
  final People people;
  final List<OrderPayerSharings> sharings = [];

  Decimal getSubtotal() {
    var subtotal = Decimal.zero;

    for (var sharing in sharings) {
      subtotal += sharing.getSharingSubtotal();
    }

    return subtotal;
  }

  Decimal getTotal(bool hasServiceCharge) {
    if (hasServiceCharge) {
      return getSubtotal() + getServiceCharge();
    }

    return getSubtotal();
  }
   
  Decimal getServiceCharge() => getSubtotal() * Decimal.parse("0.1");
}

class OrderPayerSharings {
  OrderPayerSharings(this.payer, this.orderItem);
  OrderPayerSharings.fromDb(this.id, this.payer, this.orderItem, this.quantity);

  int id = 0;
  final Payer payer;
  final OrderItem orderItem;
  bool isIndividual = false;
  int quantity = 1;

  Decimal getSharingSubtotal() {
    Decimal total = Decimal.zero;

    for (int i = 1; i <= quantity; i++) {
      var sharerCount = orderItem.sharings
        .where((sharing) => sharing.quantity >= i)
        .length;

      var totalRational = orderItem.product.price / Decimal.fromInt(sharerCount);
      total += totalRational.toDecimal(scaleOnInfinitePrecision: 3);
    }

    return total; 
  }
}
