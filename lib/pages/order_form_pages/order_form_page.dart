import 'package:decimal/decimal.dart';
import 'package:divisao_contas/models/people.dart';
import 'package:divisao_contas/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../repositories/people_repository.dart';
import 'page_1.dart';
import 'page_2.dart';

PeopleRepository peopleRepository = PeopleRepository();
OrderRepository orderRepository = OrderRepository();

MaterialPageRoute createOrderFormRoute(BuildContext context, { int? orderId }) {
  return OrderFormPageRoute(builder: (context) => OrderFormPage(title: "Nova Conta", orderId: orderId) );
}

class OrderFormPageRoute extends MaterialPageRoute<void> {
  OrderFormPageRoute({required super.builder});
}

class OrderFormPage extends StatefulWidget {
  const OrderFormPage({ required this.title, this.orderId });

  final String title;
  final int? orderId;

  @override
  State<OrderFormPage> createState() => _OrderFormPageState(orderId);
}

class _OrderFormPageState extends State<OrderFormPage> {
  _OrderFormPageState(this.orderId) {
    order = orderRepository.get(orderId ?? 0) ?? Order();
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  int? orderId;
  Order? order;

  @override
  Widget build(BuildContext context) {
    final appBarTitle = orderId == null ? "Nova comanda" : "Editar comanda";
    

    final descriptionController = TextEditingController(text: order?.description);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(appBarTitle)
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              createPage1(context, order!, setState, descriptionController),
              createPage2(context, order!, setState, descriptionController)
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.black87 : Colors.black54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          switch (_currentPage) {
            case 0:
              var result = await showDialog(
                context: context, 
                builder: addItemDialogBuilder
              );
              
              if (result != null) {
                setState(() {
                  order?.description = descriptionController.text;
                  order?.addItem(result as OrderItem);
                });
              }

              break;
            case 1:
              var result = await showDialog(
                context: context, 
                builder: addPeopleDialogBuilder
              );

              if (result != null) {
                final payer = Payer(result as People);
                setState(() => order?.addPayer(payer));
              }

              break;
            default:
              return;
          }
        },
        child: const Icon(Icons.add)
      ),
    );
  }
}

Widget addItemDialogBuilder(BuildContext context) {
  var quantity = selectedItem?.quantity ?? 1;

  var productNameController = TextEditingController(text: selectedItem?.product.name);
  var productPriceController = TextEditingController(text: selectedItem?.product.price.toStringAsFixed(2));

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: const Text("Adicionar item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: const InputDecoration(labelText: "Nome")
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: productPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Preço")
                  )
                ), 
                SizedBox(width: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => setState(() {
                            if (quantity > 0) {
                              quantity--;
                            }
                          }),
                        ),
                        Text("$quantity"),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancelar")
          ),
          TextButton(
            onPressed: () {
              var newName = productNameController.text;
              var newPrice = Decimal.parse(productPriceController.text);

              if (selectedItem == null) {
                var product = Product(name: newName, price: newPrice);
                var orderItem = OrderItem(product, quantity: quantity);

                Navigator.pop(context, orderItem);
                return;
              }
              
              selectedItem?.product.name = productNameController.text;
              selectedItem?.product.price = newPrice;
              selectedItem?.quantity = quantity;

              Navigator.pop(context);
            } , 
            child: const Text("Salvar")
          )
        ],
      );
    }
  );
}

Widget addPeopleDialogBuilder(BuildContext context) {
  return AlertDialog(
    title: const Text("Adicionar pagador"),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Selecione um pagador existente"),
        Autocomplete<People>(  
          displayStringForOption: (people) => people.name,
          optionsBuilder: (textEditingValue) => peopleRepository.find(textEditingValue.text),
          onSelected: (people) => Navigator.pop(context, people),
        )
      ],
    ),
    actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancelar")
          )
        ],
  );
}
