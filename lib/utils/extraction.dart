import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:docx_to_text/docx_to_text.dart';

class Extraction {
  
  static Future<String> extractWordText({required File docxFile}) async {
    try {
      // * Load the file from the file system (passed as an argument)
      final bytes = await docxFile.readAsBytes();

      // Extract text from the DOCX file
      final text = docxToText(
        bytes,
      );

      return text;
    } catch (error) {
      print("Error extracting text from DOCX file: $error");
      return '';
    }
  }

  static Future<String> extractPdfText({required File pdfFile}) async {
    try {
      // * Read the bytes from the PDF file
      final bytes = await pdfFile.readAsBytes();

      // * Create PdfDocument from file bytes
      PdfDocument document = PdfDocument(inputBytes: bytes);

      // * Create a new instance of the PdfTextExtractor
      PdfTextExtractor extractor = PdfTextExtractor(document);

      // * Extract all the text from the document
      String text = extractor
          .extractText()
          .replaceAll(RegExp(r'\s*-\s*\n\s*'), '') // Clean the text
          .replaceAll(RegExp(r'\s*\n\s*'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      return text;
    } catch (e) {
      print("Error extracting text from PDF file: $e");
      return '';
    }
  }

  // * So far no extension is being used, be let's see if it works 
  static Future<File?> extractAudioFromVideo({required File videoFile}) async {
    try {
      // Ensure the video file exists
      if (!await videoFile.exists()) {
        throw Exception("Video file does not exist");
      }

      // Get application documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Define the video path (use the provided video file's path)
      String videoFilePath = videoFile.path;

      // Define the audio file path in the temporary directory
      String audioFilePath = "${appDocDir.path}/extracted_audio.aac";

      // Execute the FFmpeg command to extract audio based on file extension
      final command = '-y -i $videoFilePath -vn -acodec aac $audioFilePath';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      final errorMessage = await session.getFailStackTrace();

      if (ReturnCode.isSuccess(returnCode)) {
        final audioFile = File(audioFilePath);

        // Add delay to ensure file update
        await Future.delayed(const Duration(seconds: 1));

        final fileExists = await audioFile.exists();
        final fileLength = fileExists ? await audioFile.length() : 0;

        if (fileExists && fileLength > 0) {
          return audioFile;
        } else {
          throw Exception(
              "Audio file was created but has zero length or does not exist");
        }
      } else if (ReturnCode.isCancel(returnCode)) {
        throw Exception("FFmpeg command was canceled");
      } else {
        throw Exception("FFmpeg command failed: $errorMessage");
      }
    } catch (e) {
      throw Exception("Failed to extract audio: $e");
    }
  }
}
