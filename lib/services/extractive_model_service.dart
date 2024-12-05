import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ExtractiveModelService {
  // * FOR NOW
  // * Extractive Model: "FNJAQivoRd7ouJOcQesX"

  Future<String> sendText({
    required String text,
    required String length,
  }) async {
    try {
      // final endpoint =
      //     await Endpoint(documentId: 'FNJAQivoRd7ouJOcQesX').getEndpoint();

      // https://0b24-111-68-99-41.ngrok-free.app
      const endpoint = "https://a5fc-203-82-62-87.ngrok-free.app/get-response/";

      final uri = Uri.parse(endpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "model_name": "Text_summarization",
        "arguments": {"sentences": length},
        "text": text
      });

      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['text'];
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Error: No internet connection');
    } on TimeoutException {
      throw Exception('Error: Request timed out');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<String> sendAudio({
    required File audioFile,
    required String fileExtension,
  }) async {
    const endpoint = "https://a5fc-203-82-62-87.ngrok-free.app/audio-to-text/";

    var request = http.MultipartRequest('POST', Uri.parse(endpoint));
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        audioFile.path,
        contentType: MediaType(
          'audio',
          fileExtension,
        ), // Adjust based on your audio type
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

  Future<String> sendImage({
    required File imageFile,
    required String fileExtension,
  }) async {
    const endpoint = "https://a5fc-203-82-62-87.ngrok-free.app/image-to-text/";

    var request = http.MultipartRequest(
      // 'POST', Uri.parse('http://192.168.32.35:8000/image-to-text/'));
      'POST',
      Uri.parse(endpoint),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType(
          'image',
          fileExtension,
        ), // Adjust based on your image type
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
