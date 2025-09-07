import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../custom_widgets/padded_list_view.dart';
import 'order_form_pages/order_form_page.dart';
import 'order_summary_page/order_summary_page.dart';
import '../repositories/order_repository.dart';
import '../models/order.dart';
import 'utils.dart';

var dateFormatter = DateFormat("dd/MM/yyyy — HH:mm");
var orderRepository = OrderRepository();

MaterialPageRoute createOrderRoute(BuildContext context) {
  return OrderPageRoute(builder: (context) => const OrderPage(title: "Comandas"));
}

class OrderPageRoute extends MaterialPageRoute<void> {
  OrderPageRoute({ required super.builder });
}

class OrderPage extends StatefulWidget {
  const OrderPage({ required this.title });

  final String title;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  DateTimeRange? orderDateTimeRange;

  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var orders = orderRepository.getAll(
      deepSearch: true, 
      description: descriptionController.text,
      startDate: orderDateTimeRange?.start,
      endDate: orderDateTimeRange?.end
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            child: Container(
              color: Constants.containerdefaultColor,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search)
                      ),
                      onChanged: (value) => setState(() {}),
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        descriptionController.clear();
                        orderDateTimeRange = null;
                      });
                    }, 
                    icon: Icon(Icons.clear_all)
                  ),
                  IconButton(
                    onPressed: () async {
                      var dateTimeRange = await showDateRangePicker(
                        context: context, 
                        firstDate: DateTime(2000), 
                        lastDate: DateTime.now()
                      );

                      if (dateTimeRange == null) {
                        return;
                      }

                      setState(() => orderDateTimeRange = DateTimeRange(
                        start: dateTimeRange.start, 
                        end: DateTime(dateTimeRange.end.year, dateTimeRange.end.month, dateTimeRange.end.day + 1))
                      );
                    }, 
                    icon: Icon(Icons.date_range)
                  )
                ],
              )
            )
          ),
          
          Expanded(
            child: PaddedListView(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];

                return PaddedListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  leading: resolveStatusIcon(order),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(dateFormatter.format(order.createdAt)),
                      spaceBetweenTextAndIcon,
                      Row(
                        children: [
                          order.hasServiceCharge ? Icon(Icons.percent, size: 18) : Text(""),
                          order.isConciliated() ? Icon(Icons.price_check, size: 18) : Text(""),
                          Icon(Icons.group, size: 18),
                          spaceBetweenTextAndIcon,
                          Text(order.getPayers().length.toString()),
                        ],
                      ),
                      
                    ],
                  ),
                  subtitle: Text(order.description ?? "", maxLines: 4, overflow: TextOverflow.ellipsis,),
                  trailing: Text("\$${order.total().toStringAsFixed(2)}".padLeft(12)),
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
          descriptionController.clear();

          if (result != null) {
            setState(() {
              orderRepository.add(result as Order);
              descriptionController.clear();
            });
          }
        },
        child: const Icon(Icons.format_list_bulleted_add)
      ),
    );
  }
}
