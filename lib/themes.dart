import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFE0E0E0), // texto destacado
    secondary: Color(0xFFA0A0A0), // labels
    surface: Color(0xFF1E1E1E),
    background: Color(0xFF121212),
    error: Color(0xFFB0B0B0), // cinza mais claro
    onPrimary: Color(0xFF121212),
    onSecondary: Color(0xFF121212),
    onSurface: Color(0xFFE0E0E0),
    onBackground: Color(0xFFE0E0E0),
    onError: Color(0xFF121212),
  ),
  dividerColor: const Color(0xFF2E2E2E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    titleTextStyle: TextStyle(color: Color(0xFFE0E0E0), fontSize: 18),
    iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
    bodyMedium: TextStyle(color: Color(0xFFA0A0A0)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200), // cinza claro
      foregroundColor: const Color(0xFF121212), // texto escuro
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFE0E0E0),
      side: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    backgroundColor: const Color.fromARGB(15, 255, 255, 255),
    collapsedBackgroundColor: Colors.transparent,
  ),
  listTileTheme: ListTileThemeData(
    leadingAndTrailingTextStyle: TextStyle(fontSize: 14)
  )
);
