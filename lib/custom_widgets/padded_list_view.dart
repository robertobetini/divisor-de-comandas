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
    super.iconColor = const Color(0xEE594176),
    super.tileColor = const Color(0xBBCEC1DD),
    super.textColor = const Color(0xFF3B2B4F),
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
    super.iconColor = const Color(0xEE594176),
    super.collapsedIconColor = const Color(0xEE594176),
    super.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    super.collapsedShape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
  });
}

class PaddedListView extends ListView {
  PaddedListView({ required this.itemCount, required this.itemBuilder });

  final int itemCount;
  final PaddedTile? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(padding: EdgeInsetsGeometry.fromLTRB(10, 8, 10, 0), child: itemBuilder(context, index))
    );
  }
}