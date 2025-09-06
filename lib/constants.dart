import 'package:flutter/material.dart';

class Constants {
  static const String settingsIsDarkModeOnParam = "isDarkModeOn";

  static const int maxOrderDescriptionLength = 128;
  static const int maxOrderItemCount = 99;
  static const int minOrderItemCount = 1;

  static const String peopleEmptyNameValidationError = "Nome não pode ser vazio";
  static const String peopleNameConflictValidationError = "Nome já utilizado";
  static const String productNameValidationError = "Nome do produto não pode estar vazio";
  static const String productPriceValidationError = "Preço deve ser um número maior do que zero";

  static const Color dangerColor = Color(0xFFEF5350);
  static const Color soothingColor = Color(0xFF4CAF50);
}
