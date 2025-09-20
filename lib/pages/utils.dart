import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../factories/validation_text_factory.dart';
import '../models/order.dart';

SizedBox spaceBetweenTextAndIcon = SizedBox(width: 4);
Icon warningIcon = Icon(Icons.warning_amber, size: 20, color: Constants.warningColor);
Icon resolveSharingTypeButton(bool isIndividual) => isIndividual ? const Icon(Icons.person, size: 20) : const Icon(Icons.group, size: 20);
Icon resolveStatusIcon(Order order) => order.isClosed ? const Icon(Icons.paid) : const Icon(Icons.pending_actions);

Row createItemTitle(OrderItem item, { bool showConciliationStatus = false }) { 
  var children = [
    resolveSharingTypeButton(item.isIndividual),
    spaceBetweenTextAndIcon,
    Text(item.product.name)
  ];

  if (showConciliationStatus && !item.isConciliated()) {
    children.insert(1, warningIcon);
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: children
  );
}

Widget deleteItemDialogBuilder(BuildContext context) {
  return AlertDialog(
    title: const Text("Remover"),
    content: const Text("Deseja remover o item selecionado?"),
    actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text("Cancelar")
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("OK")
          )
        ],
  );
}

Widget addItemDialogBuilder(BuildContext context, OrderItem? orderItem) {
  var quantity = orderItem?.quantity ?? 1;
  var isIndividual = orderItem?.isIndividual ?? false;

  var productNameController = TextEditingController(text: orderItem?.product.name);
  var productPriceController = TextEditingController(text: orderItem?.product.price.toStringAsFixed(2));

  var productNameHelperText = "";
  var productPriceHelperText = "";

  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text(orderItem == null ? "Adicionar item" : "Editar item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isIndividual == true ? const Text("Individual") : const Text("Compartilhado"),
                Switch(
                  thumbIcon: WidgetStateProperty.resolveWith((states) => 
                    states.contains(WidgetState.selected) 
                      ? Icon(Icons.person)
                      : Icon(Icons.group)
                  ),
                  value: isIndividual,
                  onChanged: (value) {
                    setState(() => isIndividual = value);
                  },
                ),
              ],
            ),
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

              if (orderItem == null) {
                var product = Product(name: newName, price: newPrice);
                var orderItem = OrderItem(product, quantity: quantity, isIndividual: isIndividual);

                Navigator.pop(context, orderItem);
                return;
              }
              
              orderItem.product.name = productNameController.text;
              orderItem.product.price = newPrice;
              orderItem.quantity = quantity;
              orderItem.isIndividual = isIndividual;

              Navigator.pop(context);
            } , 
            child: const Text("Salvar")
          )
        ],
      );
    }
  );
}