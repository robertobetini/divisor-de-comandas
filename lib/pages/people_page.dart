import 'package:flutter/material.dart';
import '../repositories/people_repository.dart';
import 'people_form_page.dart';
import '../models/people.dart';
import 'utils.dart';

var peopleRepository = PeopleRepository();

MaterialPageRoute createPeopleRoute(BuildContext context) {
  return PeoplePageRoute(builder: (context) => const PeoplePage(title: "Pessoas"));
}

class PeoplePageRoute extends MaterialPageRoute<void> {
  PeoplePageRoute({ required super.builder });
}

class PeoplePage extends StatefulWidget {
  const PeoplePage({ required this.title });

  final String title;

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    var peoples = peopleRepository.getAll();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: peoples.length,
              itemBuilder: (context, index) {
                var people = peoples[index];
                return ListTile(
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: Text(people.name)
                  ),
                  trailing: IconButton(
                    onPressed: () async { 
                      var isRemovalConfirmed = await showDialog(
                        context: context, 
                        builder: deleteItemDialogBuilder
                      );  

                      if (isRemovalConfirmed == true) {
                        setState(() => peopleRepository.remove(people.id));
                      }
                    },
                    icon: Icon(Icons.delete)
                  ),
                  onLongPress: () async {
                    var people = peoples[index];
                    var route = createPeopleFormRoute(context, people: people);
                    var resultado = await Navigator.of(context).push(route);

                    if (resultado != null) {
                      setState(() => peopleRepository.update(resultado as People));
                    }
                  },
                );
              },
            )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var route = createPeopleFormRoute(context);
          var resultado = await Navigator.of(context).push(route);

          if (resultado != null) {
            setState(() => peopleRepository.add(resultado as People));
          }
        },
        child: const Icon(Icons.add)
      ),
    );
  }
}
