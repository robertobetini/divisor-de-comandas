import 'package:flutter/material.dart';
import '../constants.dart';

class HeaderFiltersFactory {
  static Widget create({
      required BuildContext context, 
      required void Function(void Function()) setState, 
      TextEditingController? textController, 
      String? hintText,
      void Function()? onCleared, 
      Future Function()? onDateChanged,
      void Function()? onSortChanged,
      bool? currentSortValue
    }
  ) {
    var children = <Widget>[];

    if (textController != null) {
      var textField = Expanded(
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            hint: Text(hintText ?? "", style: TextStyle(color: Constants.textHintColor, fontSize: 16)),
            hintFadeDuration: Duration(milliseconds: 200),
            prefixIcon: Icon(Icons.search),
            prefixIconConstraints: BoxConstraints(maxWidth: 32),
            isDense: true
          ),
          onChanged: (value) => setState(() {}),
        )
      );

      children.add(textField);
    }

    var clearButton = IconButton(
      onPressed: () {
        setState(() {
          textController?.clear();
          if (onCleared != null) {
            onCleared();
          }
        });
      }, 
      icon: Icon(Icons.clear_all)
    );
    children.add(clearButton);

    if (onDateChanged != null) {
      var datePicketButton = IconButton(
        onPressed: () async {
          await onDateChanged();
          setState(() {});
        },  
        icon: Icon(Icons.date_range)
      );

      children.add(datePicketButton);
    }

    if (onSortChanged != null) {
      var sortButton = IconButton(
        onPressed: () async => setState(onSortChanged), 
        icon: Stack(
          alignment: AlignmentGeometry.bottomRight,
          children: [
            Icon(Icons.sort),
            currentSortValue == true ? Icon(Icons.arrow_upward, size: 16) : Icon(Icons.arrow_downward, size: 16)
          ],
        )
      );

      children.add(sortButton);
    }

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Container(
        color: Constants.containerdefaultColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: children,
        )
      )
    );
  }
}