import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:nexus/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfGenerator {
  static Future<String> generateContentPdf({
    required Map<String, dynamic> contentModel,
    required bool isTranslation,
  }) async {
    // Load fonts
    final ByteData boldFontData =
        await rootBundle.load('assets/fonts/Poppins-SemiBold.ttf');
    final PdfTrueTypeFont boldFont =
        PdfTrueTypeFont(boldFontData.buffer.asUint8List(), 14);

    final ByteData regularFontData =
        await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final PdfTrueTypeFont regularFont =
        PdfTrueTypeFont(regularFontData.buffer.asUint8List(), 12);

    // Create PDF document
    final PdfDocument document = PdfDocument();
    PdfPage currentPage = document.pages.add();
    double currentY = 0;

    void checkPageBounds(double contentHeight) {
      if (currentY + contentHeight > currentPage.getClientSize().height) {
        currentPage = document.pages.add();
        currentY = 0;
      }
    }

    // Add content info
    const double headingHeight = 20;
    checkPageBounds(headingHeight);
    currentPage.graphics.drawString(
      'Content Info',
      boldFont,
      bounds: Rect.fromLTWH(
          0, currentY, currentPage.getClientSize().width, headingHeight),
    );
    currentY += headingHeight + 5;

    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);

    grid.rows.add().cells[0].value = 'Content Title:';
    grid.rows[grid.rows.count - 1].cells[1].value =
        contentModel['title'] ?? 'N/A';

    grid.rows.add().cells[0].value = 'Tags:';
    grid.rows[grid.rows.count - 1].cells[1].value =
        (contentModel['tags'] as List).join(', ');

    grid.rows.add().cells[0].value = 'Date Updated:';
    grid.rows[grid.rows.count - 1].cells[1].value =
        DateTimeConversion.formattedDate(
            datetime: contentModel['date_updated']);

    grid.rows.add().cells[0].value = 'Type:';
    grid.rows[grid.rows.count - 1].cells[1].value =
        contentModel['type'] ?? 'N/A';

    grid.style = PdfGridStyle(
      font: regularFont,
      cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5),
    );

    final PdfLayoutResult gridResult = grid.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, currentPage.getClientSize().width, 0),
    )!;
    currentY = gridResult.bounds.bottom + 20;

    // Add extracted text
    checkPageBounds(headingHeight);
    currentPage.graphics.drawString(
      'Extracted Text',
      boldFont,
      bounds: Rect.fromLTWH(
          0, currentY, currentPage.getClientSize().width, headingHeight),
    );
    currentY += headingHeight + 5;

    final PdfTextElement extractedTextElement = PdfTextElement(
      text: contentModel['extracted_text'] ?? 'N/A',
      font: regularFont,
    );

    final PdfLayoutResult extractedTextResult = extractedTextElement.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
          0, currentY, currentPage.getClientSize().width, double.infinity),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    )!;
    currentPage = extractedTextResult.page;
    currentY = extractedTextResult.bounds.bottom + 20;

    // Add translation or summarization
    final String additionalHeading =
        isTranslation ? 'Translation' : 'Summarization';
    final String additionalText = isTranslation
        ? contentModel['translation']['text'] ?? 'N/A'
        : contentModel['summarization']['text'] ?? 'N/A';

    checkPageBounds(headingHeight);
    currentPage.graphics.drawString(
      additionalHeading,
      boldFont,
      bounds: Rect.fromLTWH(
          0, currentY, currentPage.getClientSize().width, headingHeight),
    );
    currentY += headingHeight + 5;

    final PdfTextElement additionalTextElement = PdfTextElement(
      text: additionalText,
      font: regularFont,
    );

    final PdfLayoutResult additionalTextResult = additionalTextElement.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
          0, currentY, currentPage.getClientSize().width, double.infinity),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    )!;
    currentPage = additionalTextResult.page;
    currentY = additionalTextResult.bounds.bottom + 20;

    // Save PDF document
    final List<int> bytes = await document.save();
    document.dispose();

    // Save the file in the temp directory
    final Directory tempDir = await getTemporaryDirectory();
    final String path = '${tempDir.path}/${contentModel['title']}.pdf';
    final File file = File(path);
    await file.writeAsBytes(bytes);

    print('PDF saved to temp directory: $path');
    return path;
  }
}
