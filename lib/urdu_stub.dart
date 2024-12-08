import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> createSimpleUrduPdf() async {
  // TODO: fix urdu font!
  // final ByteData urduFontData =
  //     await rootBundle.load('assets/fonts/NotoNastaliqUrdu-Regular.ttf');
  // final PdfTrueTypeFont urduFont =
  //     PdfTrueTypeFont(File('Arial.ttf').readAsBytesSync(), 14);

  final PdfDocument document = PdfDocument();
  final PdfPage page = document.pages.add();

  final PdfStringFormat urduStringFormat = PdfStringFormat(
    textDirection: PdfTextDirection.rightToLeft, // RTL support
    alignment: PdfTextAlignment.right, // Align text to the right
  );

  page.graphics.drawString(
    'یہ ایک اردو متن کا نمونہ ہے۔',
    PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 100),
    format: urduStringFormat,
  );

  final List<int> bytes = await document.save();
  document.dispose();

  final Directory tempDir = await getTemporaryDirectory();
  final File file = File('${tempDir.path}/urdu_sample.pdf');
  await file.writeAsBytes(bytes);

  await OpenFile.open(file.path);

  print('PDF saved to: ${file.path}');
}
