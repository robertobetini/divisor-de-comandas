import 'package:flutter/material.dart';

class CounterFactory {
  static Widget create({ required int quantity, required void Function() onRemove, required void Function() onAdd, int padding = 1 }) {
    String paddedQuantity = quantity.toString().padLeft(padding, " ");
    String paddedShadow = quantity.toString().padLeft(padding, "0");
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onRemove,
          onLongPress: () { return; },
        ),
        Stack(
          children: [
            Text(paddedShadow, style: TextStyle(fontFamily: "monospace", color: Color(0x993B2B4F))),
            Text(paddedQuantity, style: TextStyle(fontFamily: "monospace")),
          ],
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: onAdd,
          onLongPress: () { return; },
        ),
      ],
    );
  }
}
