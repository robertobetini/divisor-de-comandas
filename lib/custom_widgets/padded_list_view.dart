import 'package:flutter/material.dart';

abstract class PaddedTile extends Widget { }

class PaddedListTile extends ListTile implements PaddedTile {
  PaddedListTile({
    super.leading,
    super.title,
    super.subtitle,
    super.trailing,
    super.onTap,
    super.onLongPress,
    super.contentPadding,
    super.minLeadingWidth,
    super.tileColor = Colors.transparent,
    super.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
  });
}

class PaddedExpansionTile extends ExpansionTile implements PaddedTile {
  PaddedExpansionTile({
    super.leading,
    required super.title,
    super.subtitle,
    super.trailing,
    super.children,
    super.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    super.collapsedShape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
  });
}

class PaddedListView extends ListView {
  PaddedListView({ required this.itemCount, required this.itemBuilder, this.ensureListIsReadable = false });

  final int itemCount;
  final PaddedTile? Function(BuildContext, int) itemBuilder;
  final bool ensureListIsReadable;

  @override
  Widget build(BuildContext context) {
    if (ensureListIsReadable) {
      return ListView.builder(
        itemCount: itemCount + 1,
        itemBuilder: (context, index) => index == itemCount 
          ? PaddedListTile(title: SizedBox(height: 60))
          : Padding(padding: EdgeInsetsGeometry.fromLTRB(10, 8, 10, 0), child: itemBuilder(context, index))
      );  
    }

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(padding: EdgeInsetsGeometry.fromLTRB(10, 8, 10, 0), child: itemBuilder(context, index))
    );
  }
}