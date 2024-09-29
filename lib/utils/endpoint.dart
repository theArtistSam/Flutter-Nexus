import 'package:cloud_firestore/cloud_firestore.dart';

class Endpoint {
  String documentId;
  Endpoint({required this.documentId});

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // * Get endpoint
  // * same method can be used for all three models
  Future<String> getEndpoint() async {
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
}
