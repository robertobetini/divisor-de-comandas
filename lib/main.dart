import 'package:divisao_contas/db/db_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants.dart';
import 'pages/home_page.dart';
import 'themes.dart';
import 'repositories/settings_repository.dart';

late SettingsRepository settingsRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbContext.initDb();

  settingsRepository = SettingsRepository();
  var isDarkModeOn = settingsRepository.getPreference<bool>(Constants.settingsIsDarkModeOnParam) ?? false;
  currentTheme = isDarkModeOn ? darkTheme : lightPurpleTheme;
  
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();

  static void setTheme(BuildContext context, ThemeData themeData) {
    var state = context.findAncestorStateOfType<_AppState>();
    if (state == null) {
      throw Exception("_AppState não encontrado!");
    }

    state.setState(() {
      currentTheme = themeData;
    });
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp(
      title: "Divisor de comandas",
      theme: currentTheme,
      // darkTheme: darkGreenTheme,
      home: const HomePage(title: "Divisor de comandas"),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
    );
  }
}
