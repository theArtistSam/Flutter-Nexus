import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:nexus/models/extractive_model.dart';

class ExtractiveModelRepository {
  Future<ExtractiveModel> sendRequest({required String text}) async {
    try {
      final uri = Uri.parse('http://192.168.32.35:8000/get-response/');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "model_name": "Text_summarization",
        "arguments": {"sentences": "medium"},
        "text": text
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print(body.toString());
        return ExtractiveModel.fromJson(body);
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
