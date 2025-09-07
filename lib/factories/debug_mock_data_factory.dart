import 'package:decimal/decimal.dart';
import 'package:faker/faker.dart';
import '../constants.dart';
import '../models/order.dart';
import '../models/people.dart';
import '../repositories/people_repository.dart';

final peopleRepository = PeopleRepository();

class DebugMockDataFactory {
  static List<Order> createManyOrders(int count) => List.generate(count, (index) => createOrder(random.boolean()));

  static Order createOrder(bool ensureConciliated, { int maxItems = 5, int maxPayers = 5 }) {
    var order = Order();

    order.hasServiceCharge = random.boolean();
    order.isClosed = random.boolean();
    order.description = faker.lorem.sentence();

    if (order.description!.length > Constants.maxOrderDescriptionLength) {
      order.description = order.description!.substring(0, Constants.maxOrderDescriptionLength);
    }

    var items = createManyItems(maxItems);
    var payers = createManyPayers(maxPayers);

    for (var item in items) {
      order.addItem(item);
    }
    for (var payer in payers) {
      order.addPayer(payer);
    }

    _addCommonItemForAllPayers(order);

    for (var item in items) {
      if (item.isIndividual) {
        var itemQuantityToRemainUnlinked = ensureConciliated ? 0 : random.integer(item.quantity, min: 1);

        while (item.getAvailableQuantity() > itemQuantityToRemainUnlinked) {
          var randomIndex = random.integer(payers.length);
          var randomPayer = payers[randomIndex];

          var sharing = order.linkPayerToItem(item, randomPayer, quantity: 0);
          sharing?.quantity++;
        }

        continue;
      }

      var itemQuantityToRemainUnlinked = ensureConciliated ? 0 : random.integer(item.quantity, min: 1);
      var quantities = List.generate(
        payers.length, 
        (index) => random.integer(item.quantity - itemQuantityToRemainUnlinked)
      );

      if (!quantities.any((q) => q == item.quantity)) {
        var randomQuantityIndex = random.integer(quantities.length);
        quantities[randomQuantityIndex] = item.quantity;
      }
    }
    
    return order;
  }
  
  static List<OrderItem> createManyItems(int max) {
    return List.generate(
      random.integer(max, min: 1), 
      (index) {
        var product = Product(name: faker.food.cuisine(), price: Decimal.parse(random.decimal(scale: 100).toStringAsFixed(2)));
        product.id = index;
        var orderItem = OrderItem(product, isIndividual: random.boolean(), quantity: random.integer(6, min: 1));
        orderItem.id = index;

        return orderItem;
      }
    );
  }

  static List<Payer> createManyPayers(int max) {
    return List.generate(
      random.integer(max, min: 1), 
      (index) {

        var people = People(faker.person.name());
        peopleRepository.add(people);

        var payer = Payer(people);
        payer.id = index;

        return payer;
      }
    );
  }

  static void _addCommonItemForAllPayers(Order order) {
    var payers = order.getPayers();

    var commonIndividualProduct = Product(name: "Coxinha", price: Decimal.parse("6.99"));
    var commonIndividualItem = OrderItem(commonIndividualProduct, isIndividual: true, quantity: payers.length);
    order.addItem(commonIndividualItem);

    for (var payer in payers) {
      var sharing = order.linkPayerToItem(commonIndividualItem, payer);
      sharing?.quantity = 1;
    }
  }
}