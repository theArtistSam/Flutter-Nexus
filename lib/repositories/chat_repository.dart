import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/support_model.dart';

class AIChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getAllChats({
    Query Function(Query)? queryBuilder,
    required String userId,
  }) {
    Query query = _firestore.collection('users').doc(userId).collection('chat');

    // Apply the optional query builder if provided
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ChatModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Chat>> getConversation({required String documentId}) {
    // Access the specific document in the 'support' collection using the documentId
    DocumentReference docRef = _firestore
        .collection('users')
        .doc('Bd4umkyLqOLnMpdOLZ0E')
        .collection('chat')
        .doc(documentId);

    // Convert the document snapshot stream into a stream of List<Message>
    return docRef.snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        // Extract the conversation field from the document data
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        ChatModel chatModel = ChatModel.fromJson(data);

        // Return the conversation list if it exists, otherwise return an empty list
        return chatModel.conversation ?? [];
      } else {
        // If the document does not exist, return an empty list
        return [];
      }
    });
  }

  Future<void> addChatWithMessages() async {
    try {
      // Define the collection reference
      final collection = _firestore
          .collection('users')
          .doc("Bd4umkyLqOLnMpdOLZ0E")
          .collection('chat');

      // Create a list of 20 conversations
      List<Chat> conversations = List.generate(20, (index) {
        return Chat(
          text: index % 2 == 0
              ? 'Yeh Translation hai bhai! $index'
              : 'یہ ترجمہ ہے بھائی',
          messageType: index % 2 == 0 ? 'original' : 'response',
          datetime: DateTime.now().toString(),
          responseStatus: ResponseStatus(
            isLiked: Random().nextBool(),
            isDisliked: Random().nextBool(),
          ),
        );
      });

      // Create the ChatModel instance
      ChatModel chat = ChatModel(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        conversation: conversations,
        chatType: 'Translation', // or 'Translation'
        summarizationConfig: SummarizationConfig(
          length: 'Medium',
          // sentences: 3,
          // style: 'balanced',
        ),
        // translationConfig: TranslationConfig(
        //   sourceLanguage: 'en',
        //   targetLanguage: 'ur',
        // ),
      );

      // Add the chat to Firestore
      DocumentReference docRef = await collection.add(chat.toJson());
      await docRef.update({'chat_id': docRef.id});

      print('Added successfully');
    } catch (e) {
      print('Error adding chat: $e');
    }
  }
}
