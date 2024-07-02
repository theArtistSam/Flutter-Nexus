import 'dart:io';

import 'package:flutter/material.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/services.dart';
import 'package:nexus/models/extractive_model.dart';
import 'package:nexus/repositories/extractive_model_repository.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  String? extractedText;
  String? outputText;
  Future<void> _extractWordText() async {
    try {
      final bytes = await rootBundle.load("assets/files/sample-doc.docx");
      final text =
          docxToText(bytes.buffer.asUint8List()); // Use buffer.asUint8List()

      ExtractiveModel output = await ExtractiveModelRepository()
          .sendRequest(text: text, sentences: 'short');
      outputText = output.text;
      setState(() {
        extractedText = text;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/files/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> _extractPdfText() async {
    try {
      //Load an existing PDF document.
      PdfDocument document =
          PdfDocument(inputBytes: await _readDocumentData('sample-pdf.pdf'));

      //Create a new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.

      String text = extractor
          .extractText()
          .replaceAll(RegExp(r'\s*-\s*\n\s*'), '')
          .replaceAll(RegExp(r'\s*\n\s*'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      ExtractiveModel output = await ExtractiveModelRepository()
          .sendRequest(text: text, sentences: 'medium');
      outputText = output.text;

      setState(() {
        extractedText = text;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // _extractWordText();
    _extractPdfText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          extractedText != null
              ? Text("EXTRACTED: ${extractedText!}")
              : const Text('Extracting text...'),
          const SizedBox(
            height: 20,
          ),
          outputText != null
              ? Text("OUTPUT: ${outputText!}")
              : const Text('Generating output '),
        ],
      ),
    );
  }
}
