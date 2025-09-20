import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../factories/order_pdf_factory.dart';
import '../../models/order.dart';
import '../../themes.dart';

MaterialPageRoute createPdfPreviewRoute(BuildContext context, Order order) {
  return PdfPreviewRoute(builder: (context) => PdfPreviewPage(title: "Gerar PDF", order: order));
}

class PdfPreviewRoute extends MaterialPageRoute<void> {
  PdfPreviewRoute({ required super.builder });
}

class PdfPreviewPage extends StatefulWidget {
  PdfPreviewPage({ required this.title, required this.order });

  final String title;
  final Order order;

  @override
  State<StatefulWidget> createState() => _PdfPreviewPageState(order);
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  _PdfPreviewPageState(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gerar PDF da comanda")),
      body: PdfPreview(
        build: (format) async {
          var orderPdfFactory = OrderPdfFactory(currentTheme);
          var pdf = await orderPdfFactory.create(order);
          
          return await pdf.save();
        },
      ),
    );
  }
}
