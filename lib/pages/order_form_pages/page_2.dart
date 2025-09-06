import 'package:divisao_contas/custom_widgets/padded_list_view.dart';
import 'package:divisao_contas/factories/counter_factory.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/order.dart';
import '../utils.dart';

Widget createPage2(BuildContext context, Order order, Function setState, TextEditingController descriptionController) {
  StatefulBuilder linkDialogBuilder(BuildContext context) {
    return StatefulBuilder(
      builder: (context, dialogSetState) {
        return AlertDialog(
          title: const Text("Relacionar item"),
          content: Autocomplete<OrderItem>(
            displayStringForOption: (item) => item.product.name,
            optionsBuilder: (textEditingValue) => order.findItem(textEditingValue.text),
            onSelected: (item) => Navigator.pop(context, (item)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("Cancelar")
            )
          ],
        );
      }
    );
  }

  final payers = order.getPayers();

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(15.0),
        child: const Text(
          "Pagadores", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ),
      Expanded(
        child: PaddedListView(
          itemCount: payers.length,
          itemBuilder: (context, index) {
            var payer = payers[index];
            List<Widget> children = [];

            for (var sharing in payer.sharings) {
              var item = ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CounterFactory.create(
                      quantity: sharing.quantity,
                      padding: 2,
                      onRemove: () => setState(() {
                        if (sharing.quantity > 1) {
                          sharing.quantity--;
                        }
                      }),
                      onAdd: () => setState(() { 
                        if (sharing.getAvailableQuantity() > 0) {
                          sharing.quantity++;
                        }
                      })
                    ),
                    createItemTitle(sharing.orderItem)
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() => order.removeSharing(sharing));
                  }, 
                  icon: Icon(Icons.delete, color: Constants.dangerColor)
                ),
              );

              children.add(item);
            }

            var addItemLinkButton = ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Constants.dangerColor),
                    onPressed: () async {
                      var result = await showDialog(
                        context: context, 
                        builder: deleteItemDialogBuilder
                      );

                      if (result == true) {
                        setState(() => order.removePayer(payer.id));
                      }
                    }, 
                    child: const Icon(Icons.person_remove, size: 20)
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Constants.soothingColor),
                    onPressed: () async {
                      var result = await showDialog(
                        context: context, 
                        builder: linkDialogBuilder
                      );

                      if (result != null) {
                        var orderItem = result as OrderItem;
                        if (orderItem.getAvailableQuantity() > 0) {
                          setState(() => order.linkPayerToItem(orderItem, payer));
                          return;
                        }

                        if (!context.mounted) {
                          return;
                        }

                        await showDialog(
                          context: context, 
                          builder: (context) => AlertDialog(
                            title: const Text("Erro"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Todas as unidades já foram distribuídas para"),
                                createItemTitle(orderItem)
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context), 
                                child: const Text("OK")
                              )
                            ],
                          )
                        );
                      }
                    }, 
                    child: const Icon(Icons.library_add, size: 20)
                  )
                ],
              )
            );
            children.add(addItemLinkButton);

            return PaddedExpansionTile(
              title: Text(payer.people.name),
              children: children
            );
          }
        )
      )
    ],
  );
}
