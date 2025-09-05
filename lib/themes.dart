import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF181818), // fundo um pouco mais claro
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFCCCCCC), // texto destacado mais suave
    secondary: Color(0xFF999999), // labels
    surface: Color(0xFF222222), // cards/painéis mais claros
    error: Color(0xFFA6A6A6), // cinza intermediário
    onPrimary: Color(0xFF181818),
    onSecondary: Color(0xFF181818),
    onSurface: Color(0xFFCCCCCC),
    onError: Color(0xFF181818),
  ),
  dividerColor: const Color(0xFF2A2A2A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF222222),
    titleTextStyle: TextStyle(color: Color(0xFFCCCCCC), fontSize: 18),
    iconTheme: IconThemeData(color: Color(0xFFCCCCCC)),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFCCCCCC)),
    bodyMedium: TextStyle(color: Color(0xFF999999)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB5B5B5), // menos branco, mais cinza médio
      foregroundColor: const Color(0xFF181818),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFCCCCCC),
      side: const BorderSide(color: Color(0xFFCCCCCC)),
    ),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    backgroundColor: const Color.fromARGB(10, 255, 255, 255), // menos destaque
    collapsedBackgroundColor: Colors.transparent,
  ),
  listTileTheme: const ListTileThemeData(
    leadingAndTrailingTextStyle: TextStyle(fontSize: 14, color: Color(0xFFCCCCCC)),
  ),
);

final ThemeData lightPurpleTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFE6E0EE),
  cardColor: const Color(0xFFE6E0EE),
  splashColor: const Color(0xFFB5A2CC),
  highlightColor: const Color(0x88CEC1DD),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2C2C54),
    secondary: Color(0xFF606090),
    surface: Color(0xFFECECF5),
    error: Color(0xFF8C6FAF),
    onPrimary: Color(0xFFF5F6FA),
    onSecondary: Color(0xFFF5F6FA),
    onSurface: Color(0xFF2C2C54),
    onError: Color(0xFFF5F6FA),
    background: const Color(0xFFE6E0EE),
  ),
  dividerColor: const Color(0xFFD0D0E6),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF8C6FAF),
    titleTextStyle: TextStyle(fontSize: 18),
    iconTheme: IconThemeData(color: Color(0xFFF5F6FA)),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF2C2C54)),
    bodyMedium: TextStyle(color: Color(0xFF606090)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF8C6FAF),
      foregroundColor: const Color(0xFFF5F6FA),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF2C2C54),
      side: const BorderSide(color: Color(0xFF2C2C54)),
    ),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
    backgroundColor: const Color(0xCCB5A2CC),
    collapsedBackgroundColor: const Color(0xBBCEC1DD)
  ),
  listTileTheme: ListTileThemeData(
    selectedColor: Color(0xFF8C6FAF),
    selectedTileColor: Color(0xFF8C6FAF),
    iconColor: const Color(0xFF281D35),
    leadingAndTrailingTextStyle: TextStyle(fontSize: 14, color: Color(0xFF2C2C54)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF8C6FAF),
    foregroundColor: const Color(0xFFF5F6FA),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFFE6E0EE),
    shadowColor: const Color(0xFF1E1627),
    iconColor: const Color(0xFF1E1627)
  )
);
