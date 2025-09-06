import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import '../../factories/edge_insets_factory.dart';
import '../../models/order.dart';

var dateFormatter = DateFormat("dd/MM/yyyy  —  HH:mm");

Widget createPage1(BuildContext context, Order order) {
  var summary = buildSummary(context, order);

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Text(dateFormatter.format(order.createdAt))
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(order.description ?? "")
      ),
      Divider(),
      Expanded(
        child: ListView.builder(
          itemCount: summary.length,
          itemBuilder: (context, index) => summary[index]
        )
      ),
      Padding(
        padding: EdgeInsetsFactory.create(ButtonType.bottomButtom),
        child: ElevatedButton(
          onPressed: resolveCloseOrderButtonHandler(context, order), 
          child: const Text("Fechar comanda")
        )
      )
    ],
  );
}

List<Widget> buildSummary(BuildContext context, Order order) {
  final orderItems = order.getItems();

  List<Widget> summary = orderItems
      .map<Widget>((item) {
        var totalItemPrice = Decimal.fromInt(item.quantity) * item.product.price;

        return ListTile(
          leading: Text("${item.quantity}x"),
          title: Text(item.product.name),
          subtitle: Text("\$${item.product.price.toStringAsFixed(2)} / un."),
          trailing: Text("\$${totalItemPrice.toStringAsFixed(2)}")
        );
      })
      .toList();

    if (order.hasServiceCharge) {
      summary.add(
        ListTile(
          leading: const Text("1x"),
          title: const Text("Taxa de serviço (10%)"),
          trailing: Text("\$${order.getServiceCharge().toStringAsFixed(2)}")
        )
      );
    }

    summary.add(Divider());

    summary.add(
      ListTile(
        leading: const Text(""),
        title: const Text("Total"),
        trailing: Text("\$${order.total().toStringAsFixed(2)}")
      )
    );

    return summary;
}

VoidCallback? resolveCloseOrderButtonHandler(BuildContext context, Order order) {
  if (order.isClosed) {
    return null;
  }

  return () async {
    var result = await showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Deseja fechar a comanda?"),
          content: const Text("Após fechada, a comanda não poderá ser mais alterada"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), 
              child: const Text("Cancelar")
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), 
              child: const Text("OK")
            )
          ],
        );
      }
    );

    if (result as bool == true) {
      order.isClosed = true;

      if (context.mounted) {
        Navigator.of(context).pop(order);
      }
    }
  };
}
