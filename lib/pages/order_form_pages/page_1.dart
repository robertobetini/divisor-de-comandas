import 'package:divisao_contas/custom_widgets/padded_list_view.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import '../../models/order.dart';
import '../utils.dart';

OrderItem? selectedItem;

Widget createPage1(BuildContext context, Order order, Function setState, TextEditingController descriptionController) {
  final orderItems = order.getItems();

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.all(15.0),
        child: TextField(
          controller: descriptionController,
          decoration: const InputDecoration(labelText: "Descrição (opcional)"),
          onChanged: (value) => order.description = value,
        )
      ),
      Row(
        children: [
          Checkbox(
            value: order.hasServiceCharge,
            onChanged: (value) {
              setState(() => order.hasServiceCharge = value ?? false);
            },
          ),
          const Text("Taxa de serviço")
        ],
      ),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: const Text(
            "Itens", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      Expanded(
        child: PaddedListView(
          itemCount: orderItems.length,
          itemBuilder: (context, index) {
            var item = orderItems[index];
            return PaddedListTile(
              leading: Text("${item.quantity}x"),
              title: Text(item.product.name),
              subtitle: Text("\$${item.product.price.toStringAsFixed(2)} / un."),
              trailing: IconButton(
                onPressed: () async { 
                  var isRemovalConfirmed = await showDialog(
                    context: context, 
                    builder: deleteItemDialogBuilder
                  );  

                  if (isRemovalConfirmed == true) {
                    setState(() => order.removeItem(item.product.name));
                  }
                },
                icon: Icon(Icons.delete)
              ),
              onLongPress: () async {
                selectedItem = item;

                var _ = await showDialog(
                  context: context, 
                  builder: addItemDialogBuilder
                );

                selectedItem = null;

                setState(() {
                  order.description = descriptionController.text;
                });
              },
            );
          }
        )
      )
    ]
  );
}

Widget addItemDialogBuilder(BuildContext context) {
  var quantity = selectedItem?.quantity ?? 1;

  var productNameController = TextEditingController(text: selectedItem?.product.name);
  var productPriceController = TextEditingController(text: selectedItem?.product.price.toStringAsFixed(2));

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text(selectedItem == null ? "Adicionar item" : "Editar item"),
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
