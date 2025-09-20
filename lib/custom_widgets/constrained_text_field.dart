import 'package:flutter/material.dart';

class ConstrainedTextField extends StatefulWidget {
  ConstrainedTextField(this.controller, this.labelText, this.maxTextLength, { this.onChanged, this.enabled = true });
  ConstrainedTextField.from(this.controller, this.labelText, this.maxTextLength, { this.onChanged, this.enabled = true });

  final TextEditingController controller;
  final String labelText;
  final int maxTextLength;
  final void Function(String)? onChanged;
  final bool enabled;

  @override
  State<ConstrainedTextField> createState() => _ConstrainedTextField(controller, labelText, maxTextLength, onChanged: onChanged, enabled: enabled);
}

class _ConstrainedTextField extends State<ConstrainedTextField> {
  _ConstrainedTextField(this.controller, this.labelText, this.maxTextLength, { this.onChanged, this.enabled = true });

  final TextEditingController controller;
  final String labelText;
  final int maxTextLength;
  final void Function(String)? onChanged;
  final bool enabled;

  String buildHelperText() => "${controller.text.length}/$maxTextLength";

  @override
  Widget build(BuildContext context) {
    var helperText = buildHelperText();
    
    return TextField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText, 
        helperText: helperText
      ),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }

        if (value.length > maxTextLength) {
          controller.text = value.substring(0, maxTextLength);
        }

        setState(() => helperText = buildHelperText());
      }
    );
  }
}