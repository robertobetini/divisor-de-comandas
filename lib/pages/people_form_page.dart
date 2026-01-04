import 'package:flutter/material.dart';
import '../constants.dart';
import '../custom_widgets/constrained_text_field.dart';
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
            child: ConstrainedTextField(
              controller,
              "Nome",
              64
              //onChanged: (value) => people?.name = value
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Constants.soothingColor),
            onPressed: () async {
              if (people?.name == controller.text) {
                Navigator.pop(context);
                return;
              }

              if (controller.text.isEmpty) {
                await showErrorDialog(context, Constants.peopleEmptyNameValidationError);
                return;
              }

              if (peopleRepository.findExactMatch(controller.text) != null) {
                await showErrorDialog(context, Constants.peopleNameConflictValidationError);
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

Future showErrorDialog(BuildContext context, String content) async {
  if (!context.mounted) {
    return;
  }

  await showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text("Erro"),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text("OK")
          )
        ],
      );
    }
  );
}
