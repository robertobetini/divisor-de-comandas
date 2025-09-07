import 'package:divisao_contas/custom_widgets/padded_list_view.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../factories/header_filters_factory.dart';
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
  var isOrderByAsc = true;
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var peoples = peopleRepository.getAll(name: nameController.text, isOrderByAsc: isOrderByAsc);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        children: [
          HeaderFiltersFactory.create(
            context: context,
            setState: setState,
            textController: nameController,
            hintText: "Nome",
            onSortChanged: () => isOrderByAsc = !isOrderByAsc,
            currentSortValue: isOrderByAsc
          ),
          Expanded(
            child: PaddedListView(
              itemCount: peoples.length,
              itemBuilder: (context, index) {
                var people = peoples[index];
                return PaddedListTile(
                  title: Text(people.name),
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
                    icon: Icon(Icons.delete, color: Constants.dangerColor)
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
            setState(() { 
              peopleRepository.add(resultado as People); 
              nameController.clear();
            });
          }
        },
        child: const Icon(Icons.person_add_alt_1)
      ),
    );
  }
}
