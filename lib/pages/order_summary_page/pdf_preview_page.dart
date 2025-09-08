import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

MaterialPageRoute createPdfPreviewRoute(BuildContext context, pw.Document pdf) {
  return PdfPreviewRoute(builder: (context) => PdfPreviewPage(title: "Gerar PDF", pdf: pdf));
}

class PdfPreviewRoute extends MaterialPageRoute<void> {
  PdfPreviewRoute({ required super.builder });
}

class PdfPreviewPage extends StatefulWidget {
  PdfPreviewPage({ required this.title, required this.pdf });

  final String title;
  final pw.Document pdf;

  @override
  State<StatefulWidget> createState() => _PdfPreviewPageState(pdf);
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  _PdfPreviewPageState(this.pdf);

  final pw.Document pdf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gerar PDF da comanda")),
      body: PdfPreview(
        build: (format) async {
          return await pdf.save();
        },
      ),
    );
  }
}