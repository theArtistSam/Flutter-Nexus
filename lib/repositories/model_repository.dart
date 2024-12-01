import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ModelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String documentId;

  ModelRepository({required this.documentId});

  Future<String> _getEndpoint() async {
    try {
      // Define the document reference
      final docRef = _firestore.collection('models').doc(documentId);

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
      final docRef = _firestore.collection('models').doc(documentId);
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
      final docRef = _firestore.collection('models').doc(documentId);
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
      final docRef = _firestore.collection('models').doc(documentId);
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
      final docRef = _firestore.collection('models').doc(documentId);
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
}
