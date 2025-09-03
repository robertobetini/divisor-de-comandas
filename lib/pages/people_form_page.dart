import 'package:flutter/material.dart';
import '../models/people.dart';

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            onPressed: () {
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
