import 'package:divisao_contas/models/people.dart';
import 'package:divisao_contas/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import '../../factories/page_indicator_factory.dart';
import '../../models/order.dart';
import '../../repositories/people_repository.dart';
import '../../caches/cache.dart';
import '../utils.dart';
import 'page_1.dart';
import 'page_2.dart';

final peopleRepository = PeopleRepository();
final orderRepository = OrderRepository();

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
    order = orderCache.get(orderId);
    order ??= orderRepository.get(orderId ?? 0) ?? Order();

    if (order != null) {
      orderCache.set(order!.id, order);
    }
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  int? orderId;
  Order? order;

  @override
  Widget build(BuildContext context) {
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
              optionsBuilder: (textEditingValue) => peopleRepository
                .find(textEditingValue.text)
                .where((people) => order?.getPayers().where((payer) => payer.people.name == people.name).firstOrNull == null),
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

    final appBarTitle = orderId == null ? "Nova comanda" : "Editar comanda";
    final descriptionController = TextEditingController(text: order?.description);
    final pages = [ 
      createPage1(context, order!, setState, descriptionController), 
      createPage2(context, order!, setState, descriptionController)
    ];

    return Scaffold(
      appBar: AppBar(
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
            children: pages,
          ),
          PageIndicatorFactory.create(pages.length, _currentPage),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          switch (_currentPage) {
            case 0:
              var result = await showDialog(
                context: context, 
                builder: _addItemDialogBuilder
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
        child: _currentPage == 0 ? const Icon(Icons.add) : const Icon(Icons.person_add_alt_1)
      )
    );
  }
}

Widget _addItemDialogBuilder(BuildContext context) => addItemDialogBuilder(context, selectedItem);
