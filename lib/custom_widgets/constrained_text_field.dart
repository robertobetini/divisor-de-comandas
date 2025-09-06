import 'package:flutter/material.dart';

class ConstrainedTextField extends StatefulWidget {
  ConstrainedTextField(this.controller, this.labelText, this.maxTextLength, this.onChanged);
  ConstrainedTextField.from(this.controller, this.labelText, this.maxTextLength, this.onChanged);

  final TextEditingController controller;
  final String labelText;
  final int maxTextLength;
  final void Function(String) onChanged;

  @override
  State<ConstrainedTextField> createState() => _ConstrainedTextField(controller, labelText, maxTextLength, onChanged);
}

class _ConstrainedTextField extends State<ConstrainedTextField> {
  _ConstrainedTextField(this.controller, this.labelText, this.maxTextLength, this.onChanged);

  final TextEditingController controller;
  final String labelText;
  final int maxTextLength;
  final void Function(String) onChanged;

  String buildHelperText() => "${controller.text.length}/$maxTextLength";

  @override
  Widget build(BuildContext context) {
    var helperText = buildHelperText();
    
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText, 
        helperText: helperText
      ),
      onChanged: (value) {
        onChanged(value);
        if (value.length > maxTextLength) {
          controller.text = value.substring(0, maxTextLength);
        }

        setState(() => helperText = buildHelperText());
      }
    );
  }
}