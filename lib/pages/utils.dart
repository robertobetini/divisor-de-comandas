import 'package:flutter/material.dart';

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
