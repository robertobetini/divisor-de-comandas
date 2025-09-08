import 'package:flutter/material.dart';
import '../custom_widgets/padded_list_view.dart';
import '../themes.dart';

class PaddedListTileFactory {
  static PaddedListTile create({
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    void Function()? onTap,
    void Function()? onLongPress,
    EdgeInsets? contentPadding,
    double? minLeadingWidth,
    shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)))
  }) {
    return PaddedListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      contentPadding: contentPadding,
      minLeadingWidth: minLeadingWidth,
      shape: shape,
      tileColor: currentTheme.expansionTileTheme.collapsedBackgroundColor
    );
  }  
}
