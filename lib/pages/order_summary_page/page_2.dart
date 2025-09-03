import 'package:flutter/material.dart';
import '../../models/order.dart';

Widget createPage2(BuildContext context, Order order) {
  var payers = order
    .getPayers()
    .map<Widget>((payer) {
      var summaryDetails = payer.sharings
        .map<Widget>((sharing) {
          var sharingTotal = sharing.getSharingSubtotal();

          return ListTile(
            leading: Text("${sharing.quantity}x"),
            title: Text(sharing.orderItem.product.name),
            subtitle: Text("\$${sharing.orderItem.product.price.toStringAsFixed(2)} / un"),
            trailing: Text("\$${sharingTotal.toStringAsFixed(2)}")
          );
        })
        .toList();

      if (order.hasServiceCharge) {
        summaryDetails.add(
          ListTile(
            leading: const Text("1x"),
            title: const Text("Taxa de serviço (10%)"),
            trailing: Text("\$${payer.getServiceCharge().toStringAsFixed(2)}")
          )
        );
      }

      summaryDetails.add(
        Divider(
          thickness: 3, 
          indent: 30, 
          endIndent: 30, 
          radius: BorderRadiusGeometry.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.secondary
        )
      );

      summaryDetails.add(
        ListTile(
          leading: const Text(""),
          title: const Text("Total"),
          trailing: Text("\$${payer.getTotal().toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
        )
      );

      return ExpansionTile(
        title: Text(payer.people.name),
        children: summaryDetails,
      );
    })
    .toList();

  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          itemCount: payers.length,
          itemBuilder: (context, index) {
            return payers[index];
          }
        )
      )
    ],
  );
}