import 'package:divisao_contas/db/db_context.dart';
import 'package:flutter/material.dart';
import 'people_page.dart';
import 'order_page.dart';

const double buttonWidth = 152;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  var route = createOrderRoute(context);
                  Navigator.of(context).push(route);
                },
                child: const Text("Comandas")
              ),
            ),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  var route = createPeopleRoute(context);
                  Navigator.of(context).push(route);
                },
                child: const Text("Pessoas")
              )
            ),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () async {
                  await DbContext.resetDb();

                  if (!context.mounted) {
                    return;
                  }

                  await showDialog(
                    context: context, 
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Apagar histórico"),
                        content: Text("Todo o histórico de comandas e pessoas foi apagado"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK")
                          )
                        ],
                      );
                    }
                  );
                },
                child: const Text("Apagar histórico")
              )
            )
          ],
        ),
      ),
    );
  }
}
