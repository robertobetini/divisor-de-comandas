import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' as  material;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../models/order.dart';
import '../themes.dart';

var dateFormatter = DateFormat("dd/MM/yyyy - HH:mm");

PdfColor mapColor(material.Color? color) {
  if (color == null) {
    return PdfColors.black;
  }

  return PdfColor(color.r, color.g, color.b, color.a);
} 

class OrderPdfFactory {
  OrderPdfFactory(material.ThemeData theme);

  final headerTextStyle = TextStyle(color: mapColor(currentTheme.textTheme.bodyMedium?.color));
  final peopleNameTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mapColor(currentTheme.textTheme.bodyMedium?.color));
  final listLeadingAndTrailTextStyle = TextStyle(fontWeight: FontWeight.bold, color: mapColor(currentTheme.listTileTheme.textColor));
  final listTitleTextStyle = TextStyle(color: mapColor(currentTheme.listTileTheme.textColor));
  final listSubtitleTextStyle = TextStyle(fontSize: 11, color: mapColor(currentTheme.listTileTheme.textColor));
  final totalTextStyle = TextStyle(fontWeight: FontWeight.bold, color: mapColor(currentTheme.listTileTheme.textColor));
  final conciliationWarningTextStyle = TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: mapColor(currentTheme.listTileTheme.textColor));

  Document create(Order order) {
    var pageTheme = PageTheme(
      buildBackground: (context) {
        return FullPage(
          ignoreMargins: true,
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            color: mapColor(currentTheme.scaffoldBackgroundColor)
          ),
        );
      },
    );
    
    var summaryItems = _createSummaryItems(order);

    final pdf = Document();
    pdf.addPage(
      Page(
        pageTheme: pageTheme,
        build: (context) => Center(
          child: Column(
            children: [
              Text(dateFormatter.format(order.createdAt), style: headerTextStyle),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(order.description ?? "", style: headerTextStyle)
              ),
              _getDivider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: summaryItems
              ),
              _getConciliationWarning(order)
            ]
          )
        ),
      ),
    );

    for (var payer in order.getPayers()) {
      var payerDetailedItems = _createPayerDetailedItems(payer, order);

      pdf.addPage(
        Page(
          pageTheme: pageTheme,
          build: (context) => Center(
            child: Column(
              children: [
                Text(dateFormatter.format(order.createdAt), style: headerTextStyle),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(payer.people.name, style: peopleNameTextStyle)
                ),
                _getDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: payerDetailedItems
                )
              ]
            )
          ),
        ),
      );
    }

    return pdf;
  }

  Divider _getDivider() => Divider(
      color: mapColor(currentTheme.dividerTheme.color),
      thickness: 2,
      indent: 30,
      endIndent: 30,
      borderStyle: BorderStyle(phase: 1)
    );

  List<Widget> _createSummaryItems(Order order) {
    final orderItems = order.getItems();

    List<Widget> summary = orderItems
      .map<Widget>((item) {
        var totalItemPrice = Decimal.fromInt(item.quantity) * item.product.price;

        return ListTile(
          leading: Text("${item.quantity}x", style: listLeadingAndTrailTextStyle),
          title: _createItemTitle(item),
          subtitle: Text("\$${item.product.price.toStringAsFixed(2)} / un.", style: listSubtitleTextStyle),
          trailing: Text("\$${totalItemPrice.toStringAsFixed(2)}", style: listLeadingAndTrailTextStyle)
        );
      })
      .toList();

    if (order.hasServiceCharge) {
      summary.add(
        ListTile(
          leading: Text("1x", style: listLeadingAndTrailTextStyle),
          title: Text("Taxa de serviço (10%)", style: listTitleTextStyle),
          trailing: Text("\$${order.getServiceCharge().toStringAsFixed(2)}", style: listLeadingAndTrailTextStyle)
        )
      );
    }

    summary.add(_getDivider());
    summary.add(
      ListTile(
        leading: Text("", style: listLeadingAndTrailTextStyle),
        title: Text("Total", style: totalTextStyle),
        trailing: Text("\$${order.total().toStringAsFixed(2)}", style: listLeadingAndTrailTextStyle)
      )
    );

    return summary;
  }

  List<Widget> _createPayerDetailedItems(Payer payer, Order order) {
    var items = payer.sharings
      .map<Widget>((sharing) {
        var totalPayerSharingPrice = sharing.getSharingSubtotal();

        return ListTile(
          leading: Text("${sharing.quantity}x", style: listLeadingAndTrailTextStyle),
          title: _createItemTitle(sharing.orderItem),
          subtitle: Text("\$${sharing.orderItem.product.price.toStringAsFixed(2)} / un.", style: listSubtitleTextStyle),
          trailing: Text("\$${totalPayerSharingPrice.toStringAsFixed(2)}", style: listLeadingAndTrailTextStyle)
      );
      })
      .toList();

    if (order.hasServiceCharge) {
      items.add(
        ListTile(
          leading: Text("1x", style: listLeadingAndTrailTextStyle),
          title: Text("Taxa de serviço (10%)", style: listTitleTextStyle),
          trailing: Text("\$${payer.getServiceCharge().toStringAsFixed(2)}", style: listLeadingAndTrailTextStyle)
        )
      );
    }

    items.add(_getDivider());
    items.add(
      ListTile(
        leading: Text("", style: listLeadingAndTrailTextStyle),
        title: Text("Total", style: totalTextStyle),
        trailing: Text("\$${payer.getTotal(order.hasServiceCharge).toStringAsFixed(2)}", style: listLeadingAndTrailTextStyle)
      )
    );

    return items;
  }

  Widget _getConciliationWarning(Order order) => order.isConciliated() 
    ? Text("") 
    : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon(IconData(Icons)),
        SizedBox(width: 8),
        Text("Existem itens não atribuídos na comanda", style: conciliationWarningTextStyle)
      ],
    );

  Row _createItemTitle(OrderItem item, { bool showConciliationStatus = false }) { 
    var children = [
      // resolveSharingTypeButton(item.isIndividual),
      // spaceBetweenTextAndIcon,
      Text(item.product.name, style: listTitleTextStyle)
    ];

    // if (showConciliationStatus && !item.isConciliated()) {
    //   children.insert(1, warningIcon);
    // }

    return Row(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: children
    );
  }
}

class ListTile extends Container {
  ListTile({ this.leading, this.title, this.subtitle, this.trailing });
 
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  
  @override
  EdgeInsetsGeometry? get padding => EdgeInsets.symmetric(vertical: 8);

  @override
  Widget? get child => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 40,
        child: leading ?? Text("")
      ),
      SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title ?? Text(""),
            subtitle ?? Text("")
          ]
        )
      ),
      SizedBox(width: 8),
      trailing ?? Text("")
    ]
  );
}