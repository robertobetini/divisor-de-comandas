import 'package:flutter/material.dart';
import '../../custom_widgets/padded_list_view.dart';
import '../../constants.dart';
import '../../custom_widgets/constrained_text_field.dart';
import '../../factories/counter_factory.dart';
import '../../factories/edge_insets_factory.dart';
import '../../factories/padded_list_tile_factory.dart';
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
            return PaddedListTileFactory.create(
              contentPadding: EdgeInsets.zero,
              leading: CounterFactory.create(
                quantity: item.quantity,
                padding: 2,
                onRemove: () => setState(() {
                  if (item.quantity > Constants.minOrderItemCount) {
                    item.quantity--;

                    if (item.isIndividual) {
                      if (item.getAvailableQuantity() < 0) {
                        item.clearSharings();
                      }
                    }

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
              title: createItemTitle(item, showConciliationStatus: true),
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
                  builder: _addItemDialogBuilder
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


Widget _addItemDialogBuilder(BuildContext context) => addItemDialogBuilder(context, selectedItem);
