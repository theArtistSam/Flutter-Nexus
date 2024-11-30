import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ExtractiveModelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _getEndpoint() async {
    try {
      // Define the document reference
      final docRef =
          _firestore.collection('models').doc("FNJAQivoRd7ouJOcQesX");

      // Retrieve the document snapshot
      DocumentSnapshot docSnapshot = await docRef.get();

      // Extract the endpoint field from the document snapshot
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        String endpoint = data['endpoint'];
        return endpoint;
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      print('Error getting endpoint: $e');
      return '';
    }
  }

  Future<void> incrementUpVote() async {
    try {
      final docRef =
          _firestore.collection('models').doc("FNJAQivoRd7ouJOcQesX");
      // increment total_up_votes by 1
      // Use FieldValue.increment to increase the total_up_votes by 1
      await docRef.update({
        'total_up_votes': FieldValue.increment(1),
      });
      print("INCREMENTED UPVOTE");
    } catch (e) {
      print("NOT BEING ABLE TO INCREMENT UPVOTE $e");
    }
  }

  Future<void> incrementDownVote() async {
    try {
      final docRef =
          _firestore.collection('models').doc("FNJAQivoRd7ouJOcQesX");
      // increment total_up_votes by 1
      // Use FieldValue.increment to increase the total_up_votes by 1
      await docRef.update({
        'total_down_votes': FieldValue.increment(1),
      });
      print("INCREMENTED DOWNVOTE");
    } catch (e) {
      print("NOT BEING ABLE TO INCREMENT DOWNVOTE $e");
    }
  }

  Future<void> decrementUpVote() async {
    try {
      final docRef =
          _firestore.collection('models').doc("FNJAQivoRd7ouJOcQesX");
      // increment total_up_votes by 1
      // Use FieldValue.increment to increase the total_up_votes by 1
      await docRef.update({
        'total_up_votes': FieldValue.increment(-1),
      });
      print("DECREMENTED UPVOTE");
    } catch (e) {
      print("NOT BEING ABLE TO DECREMENT UPVOTE $e");
    }
  }

  Future<void> decrementDownVote() async {
    try {
      final docRef =
          _firestore.collection('models').doc("FNJAQivoRd7ouJOcQesX");
      // increment total_up_votes by 1
      // Use FieldValue.increment to increase the total_up_votes by 1
      await docRef.update({
        'total_down_votes': FieldValue.increment(-1),
      });
      print("DECREMENTED DOWNVOTE");
    } catch (e) {
      print("NOT BEING ABLE TO DECREMENT DOWNVOTE $e");
    }
  }

  Future<String> sendRequest({
    required String text,
    required String length,
  }) async {
    try {
      final endpoint = await _getEndpoint();

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
}
