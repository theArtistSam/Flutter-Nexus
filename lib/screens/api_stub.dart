import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class APIStubScreen extends StatefulWidget {
  const APIStubScreen({super.key});

  @override
  State<APIStubScreen> createState() => _APIStubScreenState();
}

class _APIStubScreenState extends State<APIStubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          // final tempDir = await getTemporaryDirectory();

          // *SEND IMAGE*
          // Make sure to call this in an async context (e.g., an async function)
          // final filePath =
          //     await _copyAssetToFile('assets/images/content.png', tempDir);
          // if (filePath != null) {
          //   print("Sending image");
          //   print(filePath);
          //   final response = await APIStub().sendImage(File(filePath));
          //   print(response);
          // }

          // *SEND AUDIO*
          // Make sure to call this in an async context (e.g., an async function)
          // final audioFilePath =
          //     await _copyAssetToFile('assets/audio/sample-audio.mp3', tempDir);
          // if (audioFilePath != null) {
          //   print("Sending audio");
          //   print(audioFilePath);
          //   final response = await APIStub().sendAudio(File(audioFilePath));
          //   print(response);
          // }

          // Make sure to call this in an async context (e.g., an async function)
          // ByteData _video = await rootBundle.load('assets/video/video.mp4');
          // var path = await getApplicationDocumentsDirectory();
          // var sampleVideo = "${path.path}/sample_video.mp4";
          // File _avFile = await File(sampleVideo).create();
          // await _avFile.writeAsBytes(_video.buffer.asUint8List());
          // var sampleAudio = "${path.path}/sample_audio.mp3";
          // File audioFile = await _avFile.copy(sampleAudio);
        },
        child: const Center(
          child: Text("PRESS ME"),
        ),
      ),
    );
  }
}

Future<String?> _copyAssetToFile(String assetPath, Directory tempDir) async {
  try {
    final byteData = await rootBundle.load(assetPath);
    final file = File('${tempDir.path}/${basename(assetPath)}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  } catch (e) {
    print('Error loading asset: $e');
    return null;
  }
}

class APIStub {
  Future<String> sendAudio(File audioFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.32.35:8000/upload-audio/'));
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        audioFile.path,
        contentType:
            MediaType('audio', 'mp3'), // Adjust based on your audio type
      ),
    );
    var response = await request.send();

    // Handle response status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      return responseData; // This should be the transcribed text
    } else {
      throw Exception(
          'Failed to get response from server: ${response.statusCode} - ${await response.stream.bytesToString()}');
    }
  }

  Future<String> sendImage(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.32.35:8000/upload-image/'));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType:
            MediaType('image', 'png'), // Adjust based on your image type
      ),
    );
    var response = await request.send();

    // Handle response status codes
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      return responseData; // This should be the extracted text or any relevant server response
    } else {
      throw Exception(
          'Failed to get response from server: ${response.statusCode} - ${await response.stream.bytesToString()}');
    }
  }
}
