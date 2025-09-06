import 'package:divisao_contas/custom_widgets/padded_list_view.dart';
import 'package:divisao_contas/factories/validation_text_factory.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import '../../constants.dart';
import '../../custom_widgets/constrained_text_field.dart';
import '../../factories/counter_factory.dart';
import '../../factories/edge_insets_factory.dart';
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
        child: ConstrainedTextField(
          descriptionController,
          "Descrição (opcional)",
          Constants.maxOrderDescriptionLength,
          (value) => order.description = value
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
              contentPadding: EdgeInsets.zero,
              leading: CounterFactory.create(
                quantity: item.quantity,
                padding: 2,
                onRemove: () => setState(() {
                  if (item.quantity > Constants.minOrderItemCount) {
                    item.quantity--;

                    for (var sharing in item.sharings) {
                      if (sharing.quantity > item.quantity) {
                        sharing.quantity = item.quantity;
                      }
                    }
                  }
                }),
                onAdd: () => setState(() { 
                  if (item.quantity < Constants.maxOrderItemCount) {
                    item.quantity++;
                  }
                })
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Text(item.product.name),
                ],
              ),
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
                icon: Icon(Icons.delete, color: Constants.dangerColor)
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
      ),
      Padding(
        padding: EdgeInsetsFactory.create(ButtonType.bottomButtom),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Constants.soothingColor),
          onPressed: () {
            order.description = descriptionController.text;
            order.updateTotalPrice();
            Navigator.pop(context, order);
          },
          child: const Text("Salvar")
        )
      )
    ]
  );
}

Widget addItemDialogBuilder(BuildContext context) {
  var quantity = selectedItem?.quantity ?? 1;

  var productNameController = TextEditingController(text: selectedItem?.product.name);
  var productPriceController = TextEditingController(text: selectedItem?.product.price.toStringAsFixed(2));

  var productNameHelperText = "";
  var productPriceHelperText = "";

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text(selectedItem == null ? "Adicionar item" : "Editar item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: "Nome",
                helper: ValidationTextFactory.create(productNameHelperText)
              )
            ),
            TextField(
              controller: productPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Preço",
                helper: ValidationTextFactory.create(productPriceHelperText),
                helperMaxLines: 2
              )
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
              var newPrice = Decimal.tryParse(productPriceController.text);

              newPrice ??= Decimal.zero;

              if (newName.isEmpty) {
                setState(() => productNameHelperText = Constants.productNameValidationError);
                return;
              }
              if (newPrice <= Decimal.zero) {
                setState(() => productPriceHelperText = Constants.productPriceValidationError);
                return;
              }

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
