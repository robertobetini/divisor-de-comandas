import 'package:divisao_contas/pages/settings_page.dart';
import 'package:flutter/material.dart';
import '../factories/home_page_button_factory.dart';
import 'people_page.dart';
import 'order_page.dart';

const double gridPaddingX = 60;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final buttons = [
      HomePageButtonFactory.createWithoutText(context, Icons.receipt_long_outlined,
        () {
          var route = createOrderRoute(context);
          Navigator.of(context).push(route);
        }
      ),
      HomePageButtonFactory.createWithoutText(context, Icons.group_outlined,
        () {
          var route = createPeopleRoute(context);
          Navigator.of(context).push(route);
        }
      ),
      HomePageButtonFactory.createWithoutText(context, Icons.settings,
        () async {
          var route = createSettingsRoute(context);
          Navigator.of(context).push(route);
        }
      )
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(gridPaddingX, 40, gridPaddingX, 40),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            final isLeftSidedTile = index % 2 == 0;
            
            return Padding(
              padding: isLeftSidedTile
                ? EdgeInsets.fromLTRB(0, 15, 15, 15) 
                : EdgeInsets.fromLTRB(15, 15, 0, 15),
              child: GridTile(child: buttons[index])
            );
          }
        ),
    );
  }
}
