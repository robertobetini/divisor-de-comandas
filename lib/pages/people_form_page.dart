import 'package:flutter/material.dart';
import '../models/people.dart';
import '../repositories/people_repository.dart';

var peopleRepository = PeopleRepository();

MaterialPageRoute createPeopleFormRoute(BuildContext context, { People? people }) {
  return PeopleFormPageRoute(builder: (context) => PeopleFormPage(title: "Pessoas", people: people,) );
}

class PeopleFormPageRoute extends MaterialPageRoute<void> {
  PeopleFormPageRoute({required super.builder});
}

class PeopleFormPage extends StatefulWidget {
  const PeopleFormPage({ required this.title, this.people });

  final String title;
  final People? people;

  @override
  State<PeopleFormPage> createState() => _PeopleFormPageState(people);
}

class _PeopleFormPageState extends State<PeopleFormPage> {
  _PeopleFormPageState(this.people);

  People? people;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: people?.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(people == null ? "Nova pessoa" : "Editar pessoa")
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Nome")
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (people?.name == controller.text) {
                Navigator.pop(context);
                return;
              }

              if (peopleRepository.findExactMatch(controller.text) != null) {
                if (!context.mounted) {
                  return;
                }

                await showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Erro"),
                      content: const Text("Nome de pessoa já utilizado"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(), 
                          child: const Text("OK")
                        )
                      ],
                    );
                  }
                );
                
                return;
              }

              people ??= People(controller.text);
              people?.name = controller.text;

              Navigator.pop(context, people);
            },
            child: const Text("Salvar")
          )
        ]
      ),
    );
  }
}
