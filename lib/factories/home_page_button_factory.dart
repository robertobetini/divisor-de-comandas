import 'package:flutter/material.dart';

class HomePageButtonFactory {
  static ElevatedButton create(BuildContext context, IconData iconData, String text, void Function() handler) {
    return ElevatedButton(
      onPressed: handler,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 36),
          SizedBox(height: 10),
          Text(text, style: TextStyle(fontSize: 15)),
        ],
      )
    );
  }

  static ElevatedButton createWithoutText(BuildContext context, IconData iconData, void Function() handler) {
    return ElevatedButton(
      onPressed: handler,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ Icon(iconData, size: 52) ]
      )
    );
  }
}