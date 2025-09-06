import 'package:divisao_contas/custom_widgets/padded_list_view.dart';
import 'package:divisao_contas/factories/counter_factory.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/order.dart';
import '../utils.dart';

var isIndividual = false;

Widget createPage2(BuildContext context, Order order, Function setState, TextEditingController descriptionController) {
  StatefulBuilder linkDialogBuilder(BuildContext context) {
    return StatefulBuilder(
      builder: (context, dialogSetState) {
        return AlertDialog(
          title: const Text("Relacionar item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isIndividual ? const Text("Individual") : const Text("Compartilhado"),
                  Switch(
                    thumbIcon: WidgetStateProperty.resolveWith((states) => 
                      states.contains(WidgetState.selected) 
                        ? Icon(Icons.person)
                        : Icon(Icons.group)
                    ),
                    value: isIndividual,
                    onChanged: (value) {
                      dialogSetState(() => isIndividual = value);
                    },
                  ),
                ],
              ),
              Autocomplete<OrderItem>(
                displayStringForOption: (item) => item.product.name,
                optionsBuilder: (textEditingValue) => order.findItem(textEditingValue.text),
                onSelected: (item) => Navigator.pop(context, (item, isIndividual)),
              ),
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
                        // TODO mover essa lógica do isIndividual para o OrderItem em ver do Sharing
                        if (sharing.quantity < sharing.getAvailableQuantity()) {
                          sharing.quantity++;
                        }
                      })
                    ),
                    Text(sharing.orderItem.product.name),
                    SizedBox(width: 4),
                    resolveSharingTypeButton(sharing.isIndividual)
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
                        var (orderItem, isIndividual) = result as (OrderItem, bool);
                        setState(() => order.linkPayerToItem(orderItem, payer, isIndividual));
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

Icon resolveSharingTypeButton(bool isIndividual) => isIndividual ? const Icon(Icons.person) : const Icon(Icons.group);
