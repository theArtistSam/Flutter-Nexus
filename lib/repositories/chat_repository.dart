import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/support_model.dart';
import 'package:nexus/repositories/extractive_model_repository.dart';

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

  Future<void> toggleLike({
    required int index,
    required bool value,
    required String userId,
    required String documentId,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('chat')
          .doc(documentId);

      // Get the document snapshot
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Get the conversation array
        List<dynamic> conversation = docSnapshot['conversation'];

        if (index >= 0 && index < conversation.length) {
          // Update the specific message in the conversation array
          conversation[index]['response_status']['is_liked'] = value;
          conversation[index]['response_status']['is_disliked'] = false;

          // Update the document in Firestore
          await docRef.update({
            'conversation': conversation,
          });

          print('Message updated successfully');
        } else {
          print('Invalid index');
        }
      } else {
        print('Document LIKED does not exist');
      }
    } catch (e) {
      print('Error updating message: $e');
    }
  }

  Future<void> toggleDislike({
    required int index,
    required bool value,
    required String userId,
    required String documentId,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('chat')
          .doc(documentId);

      // Get the document snapshot
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Get the conversation array
        List<dynamic> conversation = docSnapshot['conversation'];

        if (index >= 0 && index < conversation.length) {
          // Update the specific message in the conversation array
          conversation[index]['response_status']['is_disliked'] = value;
          conversation[index]['response_status']['is_liked'] = false;

          // Update the document in Firestore
          await docRef.update({
            'conversation': conversation,
          });

          print('Message DISLIKED updated successfully');
        } else {
          print('Invalid index');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating message: $e');
    }
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

  Future<void> addChatMessage({
    required String userId,
    required String documentId,
    required String text,
    required String messageType,
  }) async {
    try {
      // Define the collection reference
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('chat')
          .doc(documentId);

      Chat message = Chat(
        text: text,
        messageType: messageType,
        datetime: DateTime.now().toString(),
        responseStatus: messageType == 'response'
            ? ResponseStatus(isLiked: false, isDisliked: false)
            : null,
      );

      // new add a new message to conversion field which is an array
      await docRef.update({
        'conversation': FieldValue.arrayUnion([message.toJson()]),
      });

      print("MESSAGE HAS BEEN ADDED");
    } catch (e) {
      print("NOT BEING ABLE TO ADD NEW Message $e");
    }
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
