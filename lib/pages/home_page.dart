import 'package:flutter/material.dart';
import 'people_page.dart';
import 'order_page.dart';

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                var route = createOrderRoute(context);
                Navigator.of(context).push(route);
              },
              child: const Text("Comandas")
            ),
            ElevatedButton(
              onPressed: () {
                var route = createPeopleRoute(context);
                Navigator.of(context).push(route);
              },
              child: const Text("Pessoas")
            ),
          ],
        ),
      ),
    );
  }
}
