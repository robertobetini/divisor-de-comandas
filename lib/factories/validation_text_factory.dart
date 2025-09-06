import 'package:flutter/material.dart';

class ValidationTextFactory {
  static Text create(String validationText) => Text(
    validationText, 
    style: TextStyle(color: Color(0xFFEF5350), fontSize: 12, fontStyle: FontStyle.italic)
  );
}
