import 'package:divisao_contas/db/db_context.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DbContext.initDb();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divisor de comandas',
      theme: darkTheme,
      home: const HomePage(title: 'Divisor de comandas'),
    );
  }
}
