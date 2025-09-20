import 'package:flutter/material.dart';

late ThemeData currentTheme;

final ThemeData darkGrayTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1A1A1A),
  cardColor: const Color(0xFF1A1A1A),
  splashColor: const Color(0xFF3A3A3A),
  highlightColor: const Color(0x55FFFFFF),
  disabledColor: const Color(0x22FFFFFF),
  hintColor: const Color(0x66FFFFFF),
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
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateColor.resolveWith((states) => Color(0xFFDADADA))
    )
  )
);

final ThemeData lightGrayTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFE6E6E6), // antes #E6E0EE
  cardColor: const Color(0xFFE6E6E6),
  splashColor: const Color(0xFFB5B5B5), // antes #B5A2CC
  highlightColor: const Color(0xFF999999), // antes #9966CC
  disabledColor: const Color(0x99999999), // antes #9966CC com alpha
  hintColor: const Color(0x66000000),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF999999), // antes #9966CC
    secondary: Color(0xFF7A7A7A), // antes #7D55A3
    surface: Color(0xFFECECEC), // antes #ECECF5
    error: Color(0xFFB56592), // ajustado p/ tom de cinza-rosado mais neutro
    onPrimary: Color(0xFFF5F5F5),
    onSecondary: Color(0xFFF5F5F5),
    onSurface: Color(0xFF2C2C2C),
    onError: Color(0xFFF5F5F5),
  ),
  dividerTheme: DividerThemeData(
    color: const Color(0x66999999), // antes #B06FA7 com alpha
    thickness: 2,
    indent: 50,
    endIndent: 20,
    radius: const BorderRadius.all(Radius.circular(12)),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF999999), // antes #8C6FAF
    titleTextStyle: TextStyle(fontSize: 18),
    iconTheme: IconThemeData(color: Color(0xFFF5F5F5)),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF2C2C2C)),
    bodyMedium: TextStyle(color: Color(0xFF606060)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF999999), // antes #8C6FAF
      foregroundColor: const Color(0xFFF5F5F5),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF2C2C2C),
      side: const BorderSide(color: Color(0xFF2C2C2C)),
    ),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    textColor: const Color(0xFF3B3B3B),
    collapsedTextColor: const Color(0xFF3B3B3B),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
    backgroundColor: const Color(0xCCB5B5B5),
    collapsedBackgroundColor: const Color(0xBBCCCCCC),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: Color(0xFF3B3B3B),
    selectedColor: Color(0xFF999999),
    selectedTileColor: Color(0xFF999999),
    iconColor: Color(0xFF454545),
    leadingAndTrailingTextStyle: TextStyle(
      fontSize: 16,
      color: Color(0xFF2C2C2C),
      fontWeight: FontWeight.bold,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF999999),
    foregroundColor: Color(0xFFF5F5F5),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFFE6E6E6),
    shadowColor: Color(0xFF1E1E1E),
    iconColor: Color(0xFF1E1E1E),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateColor.resolveWith((states) => const Color(0xFF454545)),
    trackColor: WidgetStateColor.resolveWith((states) => const Color(0xAA999999)),
    overlayColor: WidgetStateColor.resolveWith((states) => const Color(0xFF454545)),
    trackOutlineColor: WidgetStateColor.resolveWith((states) => const Color(0xFF454545)),
    trackOutlineWidth: WidgetStateProperty.resolveWith((states) => 2),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateColor.resolveWith((states) => Color(0xFFDADADA))
    )
  )
);

final ThemeData lightPurpleTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFE6E0EE),
  cardColor: const Color(0xFFE6E0EE),
  splashColor: const Color(0xFFB5A2CC),
  highlightColor: const Color(0xFF9966CC),
  disabledColor: const Color(0x999966CC),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF9966CC),
    secondary: Color(0xFF7D55A3),
    surface: Color(0xFFECECF5),
    error: Color(0xFFD46FAF),
    onPrimary: Color(0xFFF5F6FA),
    onSecondary: Color(0xFFF5F6FA),
    onSurface: Color(0xFF2C2C54),
    onError: Color(0xFFF5F6FA),
  ),
  dividerTheme: DividerThemeData(
    color: const Color(0x66B06FA7),
    thickness: 2,
    indent: 50,
    endIndent: 20,
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

ThemeData applyColorTo(ThemeData theme, Color color) {
  var colorScheme = theme.brightness == Brightness.light 
    ? ColorScheme.light(
      primary: Color.lerp(theme.colorScheme.primary, color, 0.1) ?? Color(0xFFFFFFFF),
      secondary: Color.lerp(theme.colorScheme.secondary, color, 0.1) ?? Color(0xFFFFFFFF),
      surface: Color.lerp(theme.colorScheme.surface, color, 0.1)?? Color(0xFFFFFFFF),
      error: Color.lerp(theme.colorScheme.error, color, 0.1)?? Color(0xFFFFFFFF),
      onPrimary: Color.lerp(theme.colorScheme.onPrimary, color, 0.1)?? Color(0xFFFFFFFF),
      onSecondary: Color.lerp(theme.colorScheme.onSecondary, color, 0.1)?? Color(0xFFFFFFFF),
      onSurface: Color.lerp(theme.colorScheme.onSurface, color, 0.1)?? Color(0xFFFFFFFF),
      onError: Color.lerp(theme.colorScheme.onError, color, 0.1)?? Color(0xFFFFFFFF),
    )
    : ColorScheme.dark(
      primary: Color.lerp(theme.colorScheme.primary, color, 0.1) ?? Color(0xFF000000),
      secondary: Color.lerp(theme.colorScheme.secondary, color, 0.1) ?? Color(0xFF000000),
      surface: Color.lerp(theme.colorScheme.surface, color, 0.1)?? Color(0xFF000000),
      error: Color.lerp(theme.colorScheme.error, color, 0.1)?? Color(0xFF000000),
      onPrimary: Color.lerp(theme.colorScheme.onPrimary, color, 0.1)?? Color(0xFF000000),
      onSecondary: Color.lerp(theme.colorScheme.onSecondary, color, 0.1)?? Color(0xFF000000),
      onSurface: Color.lerp(theme.colorScheme.onSurface, color, 0.1)?? Color(0xFF000000),
      onError: Color.lerp(theme.colorScheme.onError, color, 0.1)?? Color(0xFF000000),
    );

  return ThemeData(
    brightness: theme.brightness,
    scaffoldBackgroundColor: Color.lerp(theme.scaffoldBackgroundColor, color, 0.15),
    cardColor: Color.lerp(theme.cardColor, color, 0.15),
    splashColor: Color.lerp(theme.splashColor, color, 0.5),
    highlightColor: Color.lerp(theme.highlightColor, color, 0.5),
    disabledColor: Color.lerp(theme.disabledColor, color, 0.5),
    colorScheme: colorScheme,
    dividerTheme: DividerThemeData(
      color: Color.lerp(theme.dividerTheme.color, color, 0.5),
      thickness: 2,
      indent: 50,
      endIndent: 20,
      radius: BorderRadius.all(Radius.circular(12))
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color.lerp(theme.appBarTheme.backgroundColor, color, 0.6),
      titleTextStyle: TextStyle(fontSize: 18),
      iconTheme: IconThemeData(color: Color.lerp(theme.appBarTheme.iconTheme?.color , color, 0.2)),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Color.lerp(theme.textTheme.bodyLarge?.color , color, 0.1)),
      bodyMedium: TextStyle(color: Color.lerp(theme.textTheme.bodyMedium?.color , color, 0.1)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.lerp(theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}), color, 0.6),
        foregroundColor: Color.lerp(theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}), color, 0.1),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color.lerp(theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}), color, 0.5),
        side: BorderSide(color: Color.lerp(theme.outlinedButtonTheme.style?.side?.resolve({})?.color, color, 0.5) ?? Color(0xFFFFFFFF)),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      textColor: Color.lerp(theme.expansionTileTheme.textColor, color, 0.05),
      collapsedTextColor: Color.lerp(theme.expansionTileTheme.collapsedTextColor, color, 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      backgroundColor: Color.lerp(theme.expansionTileTheme.backgroundColor, color, 0.4),
      collapsedBackgroundColor: Color.lerp(theme.expansionTileTheme.collapsedBackgroundColor, color, 0.3)
    ),
    listTileTheme: ListTileThemeData(
      textColor: Color.lerp(theme.listTileTheme.textColor, color, 0.2),
      selectedColor: Color.lerp(theme.listTileTheme.selectedColor, color, 0.5),
      selectedTileColor: Color.lerp(theme.listTileTheme.selectedTileColor, color, 0.2),
      iconColor: Color.lerp(theme.listTileTheme.iconColor, color, 0.2),
      leadingAndTrailingTextStyle: TextStyle(
        fontSize: 16,
        color: Color.lerp(theme.listTileTheme.leadingAndTrailingTextStyle?.color , color, 0.2),
        fontWeight: FontWeight.bold
      )
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.lerp(theme.floatingActionButtonTheme.backgroundColor , color, 0.6),
      foregroundColor: Color.lerp(theme.floatingActionButtonTheme.foregroundColor , color, 0.2),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Color.lerp(theme.dialogTheme.backgroundColor, color, 0.1),
      shadowColor: Color.lerp(theme.dialogTheme.shadowColor, color, 0.1),
      iconColor: Color.lerp(theme.dialogTheme.iconColor, color, 0.1)
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateColor.resolveWith((states) => Color.lerp(theme.switchTheme.thumbColor?.resolve(states), color, 0.5) ?? Color(0xFFFFFFFF)),
      trackColor: WidgetStateColor.resolveWith((states) => Color.lerp(theme.switchTheme.trackColor?.resolve(states), color, 0.5) ?? Color(0xFFFFFFFF)),
      overlayColor: WidgetStateColor.resolveWith((states) => Color.lerp(theme.switchTheme.trackOutlineColor?.resolve(states), color, 0.5) ?? Color(0xFFFFFFFF)),
      trackOutlineColor: WidgetStateColor.resolveWith((states) => Color.lerp(theme.switchTheme.trackOutlineColor?.resolve(states), color, 0.5) ?? Color(0xFFFFFFFF)),
      trackOutlineWidth: WidgetStateProperty.resolveWith((states) => 2)
    ),
    hintColor: Color.lerp(theme.hintColor, color, 0.2)
  );
}