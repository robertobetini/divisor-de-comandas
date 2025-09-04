import 'package:flutter/material.dart';

enum ButtonType {
  none,
  bottomButtom
}

class EdgeInsetsFactory {
  static EdgeInsets create(ButtonType type) {
    switch(type){
      case ButtonType.bottomButtom:
        return EdgeInsets.fromLTRB(0, 5, 0, 50);
      default:
        return EdgeInsets.all(15);
    }
  }
}
