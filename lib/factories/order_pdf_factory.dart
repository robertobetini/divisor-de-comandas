import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pix_flutter/pix_flutter.dart';
import '../constants.dart';
import '../models/order.dart';
import '../repositories/settings_repository.dart';
import '../themes.dart';

var dateFormatter = DateFormat("dd/MM/yyyy - HH:mm");
final settingsRepository = SettingsRepository();

PdfColor mapColor(material.Color? color) {
  if (color == null) {
    return PdfColors.black;
  }

  return PdfColor(color.r, color.g, color.b, color.a);
} 

class OrderPdfFactory {
  OrderPdfFactory(material.ThemeData theme);

  final headerTextStyle = TextStyle(color: mapColor(currentTheme.textTheme.bodyMedium?.color));
  final pageTitleTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mapColor(currentTheme.textTheme.bodyMedium?.color));
  final listLeadingAndTrailTextStyle = TextStyle(fontWeight: FontWeight.bold, color: mapColor(currentTheme.listTileTheme.textColor));
  final listTitleTextStyle = TextStyle(color: mapColor(currentTheme.listTileTheme.textColor));
  final listSubtitleTextStyle = TextStyle(fontSize: 11, color: mapColor(currentTheme.listTileTheme.textColor));
  final totalTextStyle = TextStyle(fontWeight: FontWeight.bold, color: mapColor(currentTheme.listTileTheme.textColor));
  final conciliationWarningTextStyle = TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: mapColor(currentTheme.listTileTheme.textColor));

  Future<Document> create(Order order) async {
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

    var header = Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(dateFormatter.format(order.createdAt), style: headerTextStyle),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Comanda Virtual #${order.id}", style: pageTitleTextStyle)
          )
        ]
      )
    );

    pdf.addPage(
      MultiPage(
        header: (context) => header,
        pageTheme: pageTheme,
        build: (context) => [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(order.description ?? "", style: headerTextStyle)
                ),
                _getConciliationWarning(order),
              ]
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: summaryItems
          )
        ],
      ),
    );

    for (var payer in order.getPayers()) {
      var header = Center(
        child: Column(
          children: [
            Text(dateFormatter.format(order.createdAt), style: headerTextStyle),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(payer.people.name, style: pageTitleTextStyle)
            )
          ]
        )
      );

      var payerDetailedItems = await _createPayerDetailedItems(payer, order);

      pdf.addPage(
        MultiPage(
          header: (context) => header,
          pageTheme: pageTheme,
          build: (context) => [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: payerDetailedItems
            )
          ],
        ),
      );
    }

    return pdf;
  }

  Divider _getDivider() => Divider(
      color: mapColor(currentTheme.dividerTheme.color),
      thickness: currentTheme.dividerTheme.thickness,
      indent: currentTheme.dividerTheme.indent,
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

  Future<List<Widget>> _createPayerDetailedItems(Payer payer, Order order) async {
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

    var payerTotal = payer.getTotal(order.hasServiceCharge);

    items.add(_getDivider());
    items.add(
      ListTile(
        leading: Text("", style: listLeadingAndTrailTextStyle),
        title: Text("Total", style: totalTextStyle),
        trailing: Text("\$${payerTotal.toStringAsFixed(2)}", style: listLeadingAndTrailTextStyle)
      )
    );

    items.add(SizedBox(height: 40));    
    
    var includePixOnPdf = settingsRepository.getPreference<bool>(Constants.settingsIncludePixOnPdfParam) ?? false;

    if (payerTotal > Decimal.zero) {
      if (includePixOnPdf) {
        var pixReceiverName = settingsRepository.getPreference<String>(Constants.settingsCurrentNameParam);
        var pixReceiverKey = settingsRepository.getPreference<String>(Constants.settingsCurrentPixKeyParam);

        var pix = PixFlutter(
          payload: Payload(
            pixKey: pixReceiverKey,
            merchantName: pixReceiverName,
            merchantCity: "BR",
            amount: payerTotal.toStringAsFixed(2),
            txid: "***"
          )
        );

        print(pix.getQRCode());

        var barcode = BarcodeWidget(
          color: mapColor(currentTheme.listTileTheme.textColor),
          barcode: Barcode.qrCode(),
          data: pix.getQRCode(),
          width: 100,
          height: 100
        );

        var pixItem = Center(
          child: Column(
            children: [
              barcode,
              SizedBox(height: 20),
              Text("Atenção!", style: listSubtitleTextStyle),
              Text("Sempre confirme o destinatário e o valor da transação antes de efetuá-la.", style: listSubtitleTextStyle)
            ]
          )
        );

        items.add(pixItem);
      }
    } else {
      items.add(
        Center(
          child: Text("Nada a pagar! :D", style: listSubtitleTextStyle)
        )
      );
    }

    return items;
  }

  Widget _getConciliationWarning(Order order) => order.isConciliated() 
    ? Text("") 
    : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Existem itens não atribuídos na comanda", style: conciliationWarningTextStyle)
      ],
    );

  Row _createItemTitle(OrderItem item) { 
    var children = [
      Text(item.product.name, style: listTitleTextStyle)
    ];

    return Row(
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
