import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/models/support_model.dart';

class SupportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<SupportModel>> getAllIssues(
      {Query Function(Query)? queryBuilder}) {
    Query query = _firestore.collection('support');

    // Apply the optional query builder if provided
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SupportModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Message>> getConversation({required String documentId}) {
    // Access the specific document in the 'support' collection using the documentId
    DocumentReference docRef = _firestore.collection('support').doc(documentId);

    // Convert the document snapshot stream into a stream of List<Message>
    return docRef.snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        // Extract the conversation field from the document data
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        SupportModel supportModel = SupportModel.fromJson(data);

        // Return the conversation list if it exists, otherwise return an empty list
        return supportModel.conversation ?? [];
      } else {
        // If the document does not exist, return an empty list
        return [];
      }
    });
  }

  Future<void> addMessage({
    required String message,
    required String documentId,
    required String senderId,
  }) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('support').doc(documentId);

      Message newMessage = Message(
        senderId: senderId,
        timeStamp: DateTime.now().toString(),
        messageType: 'text',
        text: message,
        status: Status(
          isSent: true,
          isSeen: false,
        ),
      );

      await docRef.update({
        'conversation': FieldValue.arrayUnion([newMessage.toJson()]),
      });

      print('Added successfully');
    } catch (e) {
      print('Error getting users: $e');
    }
  }

  Future<bool> checkIssueStatus({required String userId}) async {
    try {
      // Reference the 'support' collection
      final collection = _firestore.collection('support');

      // Query the collection for documents where 'userId' matches and 'issueCategory' is 'Pending'
      final querySnapshot = await collection
          .where('user_id', isEqualTo: userId)
          .where('issue_status', isEqualTo: 'Pending')
          .limit(1)
          .get();

      // Check if any documents match the query
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Some issue occurred: $e');
      return false;
    }
  }

  Future<void> addIssue({
    required String userId,
    required String issueCategory,
  }) async {
    try {
      // hard-code value for now
      final collection = _firestore.collection('support');

      SupportModel issue = SupportModel(
          userId: userId,
          issueOpenedTime: DateTime.now().toString(),
          issueCategory: issueCategory,
          issueStatus: 'Pending',
          conversation: [
            Message(
                senderId: 'bpReSCGFYZY9k1TuuCdW',
                timeStamp: DateTime.now().toString(),
                messageType: 'text',
                text: 'Please describe this issue',
                status: Status(
                  isSent: true,
                  isSeen: false,
                ))
          ]);

      DocumentReference docRef = await collection.add(issue.toJson());
      await docRef.update({'issue_id': docRef.id});

      print('Added successfully');
    } catch (e) {
      print('Error getting users: $e');
    }
  }

  SupportModel supportCollection() {
    List<Message> conversation = [];

    // Generate 20 dummy messages for the conversation
    for (int i = 1; i <= 20; i++) {
      conversation.add(Message(
        senderId: i % 2 != 0 ? 'Bd4umkyLqOLnMpdOLZ0E' : 'bpReSCGFYZY9k1TuuCdW',
        timeStamp: DateTime.now().subtract(Duration(minutes: i * 5)).toString(),
        messageType: i % 3 == 0 ? 'image' : 'text',
        text: i % 3 != 0 ? 'Random messages wesy hi ker rha $i' : null,
        imageLink: i % 3 == 0 ? 'http://dummyimage.com/$i' : null,
        status: Status(isSent: true, isSeen: i % 4 == 0),
      ));
    }

    return SupportModel(
      userId: 'Bd4umkyLqOLnMpdOLZ0E',
      issueId: 'issue_1',
      issueOpenedTime: DateTime.now().subtract(Duration(days: 1)).toString(),
      issueClosedTime: null,
      issueCategory: 'Community',
      issueStatus: 'Closed',
      conversation: conversation,
    );
  }

  Future<void> addIssues() async {
    try {
      // hard-code value for now
      final collection = _firestore.collection('support');

      DocumentReference docRef =
          await collection.add(supportCollection().toJson());
      await docRef.update({'issue_id': docRef.id});

      print('Added successfully');
    } catch (e) {
      print('Error getting users: $e');
    }
  }
}
