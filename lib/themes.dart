import 'package:flutter/material.dart';

late ThemeData currentTheme;

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1A1A1A),
  cardColor: const Color(0xFF1A1A1A),
  splashColor: const Color(0xFF3A3A3A),
  highlightColor: const Color(0x55FFFFFF),
  disabledColor: const Color(0x22FFFFFF),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFDADADA), // texto principal
    secondary: Color(0xFFA0A0A0), // texto secundário
    surface: Color(0xFF222222), // cards
    error: Color(0xFFB86F6F), // erro em tom de vermelho acinzentado
    onPrimary: Color(0xFF1A1A1A),
    onSecondary: Color(0xFF1A1A1A),
    onSurface: Color(0xFFDADADA),
    onError: Color(0xFF1A1A1A),
  ),
  dividerTheme: DividerThemeData(
    color: const Color(0xFF444444),
    thickness: 2,
    indent: 30,
    endIndent: 30,
    radius: const BorderRadius.all(Radius.circular(12)),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF222222),
    titleTextStyle: TextStyle(fontSize: 18, color: Color(0xFFDADADA)),
    iconTheme: IconThemeData(color: Color(0xFFDADADA)),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFDADADA)),
    bodyMedium: TextStyle(color: Color(0xFFA0A0A0)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF444444),
      foregroundColor: const Color(0xFFDADADA),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFDADADA),
      side: const BorderSide(color: Color(0xFFDADADA)),
    ),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    textColor: const Color(0xFFDADADA),
    collapsedTextColor: const Color(0xFFDADADA),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    backgroundColor: const Color(0x14FFFFFF),
    collapsedBackgroundColor: const Color(0x09FFFFFF),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: Color(0xFFDADADA),
    selectedColor: Color(0xFF666666),
    selectedTileColor: Color(0xFF333333),
    iconColor: Color(0xFFAAAAAA),
    leadingAndTrailingTextStyle: TextStyle(
      fontSize: 16,
      color: Color(0xFFDADADA),
      fontWeight: FontWeight.bold,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF444444),
    foregroundColor: Color(0xFFDADADA)
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    shadowColor: Color(0xFF000000),
    iconColor: Color(0xFFDADADA),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateColor.resolveWith((_) => const Color(0xFFDADADA)),
    trackColor: WidgetStateColor.resolveWith((_) => const Color(0x773A3A3A)),
    overlayColor: WidgetStateColor.resolveWith((_) => const Color(0xFF555555)),
    trackOutlineColor: WidgetStateColor.resolveWith((_) => const Color(0xFF888888)),
    trackOutlineWidth: WidgetStateProperty.resolveWith((_) => 2),
  ),
  hintColor: const Color(0x66FFFFFF)
);


final ThemeData lightPurpleTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFE6E0EE),
  cardColor: const Color(0xFFE6E0EE),
  splashColor: const Color(0xFFB5A2CC),
  highlightColor: const Color(0xFF9966CC),
  disabledColor: const Color(0x999966CC),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF9966CC),       // novo roxo primário
    secondary: Color(0xFF7D55A3),     // secundário mais escuro para contraste
    surface: Color(0xFFECECF5),       // mantém o claro para cards/painéis
    error: Color(0xFFD46FAF),         // erro em tom compatível com roxo
    onPrimary: Color(0xFFF5F6FA),     // texto claro sobre primary
    onSecondary: Color(0xFFF5F6FA),   // texto claro sobre secondary
    onSurface: Color(0xFF2C2C54),     // texto escuro sobre surface
    onError: Color(0xFFF5F6FA),       // texto claro sobre error
  ),
  dividerTheme: DividerThemeData(
    color: const Color(0xAAB06FA7),
    thickness: 2,
    indent: 30,
    endIndent: 30,
    radius: BorderRadius.all(Radius.circular(12))
  ),
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
    textColor: const Color(0xFF3B2B4F),
    collapsedTextColor: const Color(0xFF3B2B4F),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
    backgroundColor: const Color(0xCCB5A2CC),
    collapsedBackgroundColor: const Color(0xBBCEC1DD)
  ),
  listTileTheme: ListTileThemeData(
    textColor: const Color(0xFF3B2B4F),
    selectedColor: Color(0xFF8C6FAF),
    selectedTileColor: Color(0xFF8C6FAF),
    iconColor: const Color(0xFF45335C),
    leadingAndTrailingTextStyle: TextStyle(fontSize: 16, color: Color(0xFF2C2C54), fontWeight: FontWeight.bold)
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF8C6FAF),
    foregroundColor: const Color(0xFFF5F6FA),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFFE6E0EE),
    shadowColor: const Color(0xFF1E1627),
    iconColor: const Color(0xFF1E1627)
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateColor.resolveWith((states) => const Color(0xFF45335C)),
    trackColor: WidgetStateColor.resolveWith((states) => const Color(0xAA8C6FAF)),
    overlayColor: WidgetStateColor.resolveWith((states) => const Color(0xFF45335C)),
    trackOutlineColor: WidgetStateColor.resolveWith((states) => const Color(0xFF45335C)),
    trackOutlineWidth: WidgetStateProperty.resolveWith((states) => 2)
  ),
  hintColor: const Color(0x66000000)
);
