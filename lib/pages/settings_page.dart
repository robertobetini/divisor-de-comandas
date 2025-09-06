import 'package:divisao_contas/repositories/settings_repository.dart';
import 'package:divisao_contas/themes.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../db/db_context.dart';
import '../main.dart';

final settingsRepository = SettingsRepository();

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        children: [
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
                  App.setTheme(context, value ? darkTheme : lightPurpleTheme);
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
        ],
      ),
    );
  }
}