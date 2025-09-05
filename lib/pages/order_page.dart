import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../custom_widgets/padded_list_view.dart';
import 'order_form_pages/order_form_page.dart';
import 'order_summary_page/order_summary_page.dart';
import '../repositories/order_repository.dart';
import '../models/order.dart';

var dateFormatter = DateFormat("dd/MM/yyyy - HH:mm");
var orderRepository = OrderRepository();

MaterialPageRoute createOrderRoute(BuildContext context) {
  return OrderPageRoute(builder: (context) => const OrderPage(title: "Comandas"));
}

class OrderPageRoute extends MaterialPageRoute<void> {
  OrderPageRoute({required super.builder});
}

class OrderPage extends StatefulWidget {
  const OrderPage({ required this.title });

  final String title;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    var orders = orderRepository.getAll();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: PaddedListView(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];

                return PaddedListTile(
                  leading: order.isClosed ? Icon(Icons.check_circle_outline) : const Text(""),
                  title: Text(dateFormatter.format(order.createdAt)),
                  subtitle: Text(order.description ?? ""),
                  trailing: Text("\$${order.total().toStringAsFixed(2)}", textAlign: TextAlign.end, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  onTap: () async {
                    var route = createOrderSummaryRoute(context, order.id);
                    var result = await Navigator.of(context).push(route);

                    if (result != null) {
                      setState(() => orderRepository.update(result as Order));
                    }
                  },
                  onLongPress: order.isClosed ? null : () async {
                    var route = createOrderFormRoute(context, orderId: order.id);
                    var result = await Navigator.of(context).push(route);

                    if (result != null) {
                      setState(() => orderRepository.update(result as Order));
                    }
                  }
                );
              },
            )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var route = createOrderFormRoute(context);
          var result = await Navigator.of(context).push(route);

          if (result != null) {
            setState(() => orderRepository.add(result as Order));
          }
        },
        child: const Icon(Icons.add)
      ),
    );
  }
}
