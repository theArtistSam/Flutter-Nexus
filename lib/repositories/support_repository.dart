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
