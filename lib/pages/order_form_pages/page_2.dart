import 'package:divisao_contas/custom_widgets/padded_list_view.dart';
import 'package:flutter/material.dart';
import '../../factories/edge_insets_factory.dart';
import '../../models/order.dart';
import '../utils.dart';

Widget createPage2(BuildContext context, Order order, Function setState, TextEditingController descriptionController) {
  Widget linkDialogBuilder(BuildContext context) {
    return AlertDialog(
      title: const Text("Relacionar item"),
      content: Autocomplete<OrderItem>(
        displayStringForOption: (item) => item.product.name,
        optionsBuilder: (textEditingValue) => order.findItem(textEditingValue.text),
        onSelected: (item) => Navigator.pop(context, item),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Cancelar")
        )
      ],
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => setState(() {
                            if (sharing.quantity > 0) {
                              sharing.quantity--;
                            }
                          }),
                        ),
                        Text("${sharing.quantity}"),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => setState(() { 
                            if (sharing.quantity < sharing.orderItem.quantity) {
                              sharing.quantity++;
                            }
                          }),
                        ),
                      ],
                    ),
                    Text(sharing.orderItem.product.name)
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() => order.removeSharing(sharing.id));
                  }, 
                  icon: Icon(Icons.delete_outline)
                ),
              );

              children.add(item);
            }

            var addItemLinkButton = ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        var result = await showDialog(
                          context: context, 
                          builder: deleteItemDialogBuilder
                        );

                        if (result == true) {
                          setState(() => order.removePayer(payer.id));
                        }
                      }, 
                      child: const Text("Deletar pagador")
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        var result = await showDialog(
                          context: context, 
                          builder: linkDialogBuilder
                        );

                        if (result != null) {
                          setState(() => order.linkPayerToItem(result as OrderItem, payer));
                        }
                      }, 
                      child: const Text("Relacionar item")
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
      ),
      Padding(
        padding: EdgeInsetsFactory.create(ButtonType.bottomButtom),
        child: ElevatedButton(
          onPressed: () {
            order.description = descriptionController.text;
            order.updateTotalPrice();
            Navigator.pop(context, order);
          },
          child: const Text("Salvar")
        )
      )
    ],
  );
}

