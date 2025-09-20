import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../factories/debug_mock_data_factory.dart';
import '../repositories/order_repository.dart';
import '../repositories/settings_repository.dart';
import '../themes.dart';
import '../constants.dart';
import '../db/db_context.dart';
import '../main.dart';
import 'pix_configuration_page.dart';

final settingsRepository = SettingsRepository();
final orderRepository = OrderRepository();

MaterialPageRoute createSettingsRoute(BuildContext context) {
  return SettingsPageRoute(builder: (context) => const SettingsPage(title: "Configurações"));
}

class SettingsPageRoute extends MaterialPageRoute<void> {
  SettingsPageRoute({ required super.builder });
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({ required this.title });

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var isDarkModeOn = settingsRepository.getPreference<bool>(Constants.settingsIsDarkModeOnParam) ?? false;

    var items = [
      ListTile(
        leading: Icon(Icons.contrast),
        title: const Text("Tema escuro"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isDarkModeOn ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
            Switch(
              value: isDarkModeOn,
              onChanged: (value) {
                setState(() {
                  settingsRepository.setPreference(Constants.settingsIsDarkModeOnParam, value);
                  App.setTheme(context, value ? darkGrayTheme : lightPurpleTheme);
                });
              }
            )
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.delete_forever),
        title: const Text("Apagar histórico"),
        onTap: () async {
          var result = await showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: Text("Apagar histórico"),
                content: Text("Deseja apagar todo o histórico de comandas e pessoas?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancelar")
                  ),
                  TextButton(
                    onPressed: () async {
                      await DbContext.resetDb();

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.of(context).pop(true);
                    },
                    child: Text("OK")
                  )
                ]
              );
            }
          );

          if (result == true && context.mounted) {
            showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  title: const Text("Apagar histórico"),
                  content: Text("Todo o histórico de comandas e pessoas foi apagado"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("OK")
                    )
                  ],
                );
              }
            );
          }
        },
      ),
      ListTile(
        leading: Icon(Icons.account_balance_wallet),
        title: const Text("Configurar chave PIX (WIP)"),
        onTap: () {
          var route = createPixConfigurationRoute(context);
          Navigator.push(context, route);
        }
      ),
      ListTile(
        leading: Icon(Icons.info_outline),
        title: const Text("Sobre"),
        onTap: () => showAboutDialog(
          context: context,
          applicationName: "Divisor de comandas",
          applicationVersion: "0.1.0",
          applicationLegalese: '© 2025 Roberto Betini Junior',
          children: [
            const SizedBox(height: 16),
            const Text('Projeto pessoal para gerenciar comandas virtuais.'),
            const Text('Sem fins lucrativos.')
          ],
        )
      )
    ];

    if (kDebugMode) {
      items.add(
        ListTile(
          leading: Icon(Icons.bug_report),
          title: Text("Gerar mocks para teste"),
          onTap: () async {
            var mockedOrders = DebugMockDataFactory.createManyOrders(20, maxItems: 20, maxPayers: 5);
            for (var order in mockedOrders) {
              orderRepository.add(order);
            }

            var os = orderRepository.getAll();
            print(os.length);

            await showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  title: Text("Info"),
                  content: Text("Dados de mock gerados com sucesso"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: Text("OK")
                    )
                  ],
                );
              },
            );
          }
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        children: items,
      ),
    );
  }
}