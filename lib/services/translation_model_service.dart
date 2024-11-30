import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TrasnlationModelService {
  Future<String> sendText({
    required String text,
  }) async {
    try {
      const endpoint =
          "https://e372-115-186-169-16.ngrok-free.app/get-translation/";

      final uri = Uri.parse(endpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"text": text});

      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedBody =
            json.decode(utf8.decode(response.bodyBytes)); // Proper decoding
        return decodedBody[
            'text']; // Ensure 'text' is present in the JSON response
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
}
