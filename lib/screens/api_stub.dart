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
import 'package:permission_handler/permission_handler.dart';

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

          // final audioFile =
          await _extractAudioFromVideo('assets/video/sample.mp4');
          // print("Sending audio");
          // final response = await APIStub().sendAudio(audioFile!);
          // print(response);
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

Future<File?> _extractAudioFromVideo(String videoAssetPath) async {
  try {
    ByteData videoData = await rootBundle.load(videoAssetPath);

    // Get application documents directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Save the video to a file
    String videoFilePath = "${appDocDir.path}/sample.mp4";
    File videoFile = File(videoFilePath);
    await videoFile.create();
    await videoFile.writeAsBytes(videoData.buffer.asUint8List());

    print("Video file created at $videoFilePath");

    // Define the path for the audio file
    String audioFilePath = "${appDocDir.path}/just_audio.mp3";
    // print(await videoFile.length());

    // Execute the FFmpeg command to extract audio
    final command = '-i $videoFilePath -vn -ac copy $audioFilePath';
    print(command);
    FFmpegKit.executeAsync(command).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        print("FFmpeg command successful");

        // Verify the audio file existence after FFmpeg command completion
        if (await File(audioFilePath).exists()) {
          print("Audio file created at $audioFilePath");
          return File(audioFilePath);
        } else {
          throw Exception("Audio file was not created");
        }
      } else if (ReturnCode.isCancel(returnCode)) {
        print("FFmpeg command canceled");
        throw Exception("FFmpeg command was canceled");
      } else {
        final errorMessage = await session.getFailStackTrace();
        final state = await session.getState();

        // Console output generated for this execution
        // final output = await session.getOutput();
        // print(output);
        print("FFmpeg command failed (state: $state, error: $errorMessage)");
        throw Exception("FFmpeg command failed: $errorMessage");
      }
    });
  } catch (e) {
    print("Exception: $e");
    throw Exception("Failed to extract audio: $e");
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
