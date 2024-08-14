import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/content_model.dart';

class ContentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Now the function also takes a query as a parameter
  Stream<List<ContentModel>> getAllContents(
      {Query Function(Query)? queryBuilder}) {
    Query query = _firestore
        .collection('users')
        .doc('Bd4umkyLqOLnMpdOLZ0E')
        .collection('content');

    // Apply the optional query builder if provided
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ContentModel.fromJson(data);
      }).toList();
    });
  }

  Future<String> deleteContent({required String contentId}) async {
    try {
      await _firestore
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E')
          .collection('content')
          .doc(contentId)
          .delete();
      return 'Success';
    } catch (e) {
      return 'Failed to delete content: ${e.toString()}';
    }
  }

  Future<void> updateContent({
    required ContentModel content,
    required XFile? image,
  }) async {
    try {
      String? downloadURL;

      if (image != null) {
        // Reference to the storage location
        final ref = FirebaseStorage.instance
            .ref()
            .child('users')
            .child('Bd4umkyLqOLnMpdOLZ0E') // Replace with user ID
            .child('content')
            .child(content.contentId!)
            .child('image.jpg');

        // Upload the file to Firebase Storage
        await ref.putFile(File(image.path));

        // Get the download URL of the uploaded image
        downloadURL = await ref.getDownloadURL();
      }

      // Update the content's thumbnail if a new image was uploaded
      if (downloadURL != null) {
        content = content.copyWith(thumbnail: downloadURL);
      }

      // Set the dateUpdated attribute to the current date and time
      content = content.copyWith(dateUpdated: DateTime.now().toString());

      // Update the Firestore document with the content data
      await FirebaseFirestore.instance
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E') // Replace with user ID
          .collection('content')
          .doc(content.contentId)
          .update(content.toJson());
    } catch (e) {
      print("SOME ERROR: $e");
    }
  }

  Future<ContentModel> getContentById({
    required String userId,
    required String contentId,
  }) async {
    try {
      // Define the document reference
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('content')
          .doc(contentId);

      // Fetch the document snapshot
      final docSnapshot = await docRef.get();

      // Check if the document exists
      final contentData = docSnapshot.data();
      return ContentModel.fromJson(contentData!..['content_id'] = contentId);
    } catch (e) {
      throw ('Error fetching folder: $e');
    }
  }

  Future<void> addContents() async {
    List<ContentModel> contents = [
      ContentModel(
        contentId: 'content1',
        extractedText: 'Text 1',
        dateUpdated: '2024-05-01',
        translation: Translation(
            text: 'Translated Text 1',
            status: Status(isLiked: true, isDisliked: false)),
        summarization: Translation(
            text: 'Summarized Text 1',
            status: Status(isLiked: true, isDisliked: false)),
        type: 'Type 1',
        title: 'Title 1',
        folderId: 'tvfhU74PpaFHfWg5Qxi0',
        thumbnail:
            'https://images.unsplash.com/photo-1657981879763-d39602db3838?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        link: 'http://link1.com',
        tags: ['tag1', 'tag2'],
      ),
      ContentModel(
        contentId: 'content2',
        extractedText: 'Text 2',
        dateUpdated: '2024-05-02',
        translation: Translation(
            text: 'Translated Text 2',
            status: Status(isLiked: false, isDisliked: true)),
        summarization: Translation(
            text: 'Summarized Text 2',
            status: Status(isLiked: false, isDisliked: true)),
        type: 'Type 2',
        title: 'Title 2',
        folderId: 'folder2',
        thumbnail:
            'https://images.unsplash.com/photo-1657981879763-d39602db3838?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        link: 'http://link2.com',
        tags: ['tag3', 'tag4'],
      ),
      ContentModel(
        contentId: 'content3',
        extractedText: 'Text 3',
        dateUpdated: '2024-05-03',
        translation: Translation(
            text: 'Translated Text 3',
            status: Status(isLiked: true, isDisliked: false)),
        summarization: Translation(
            text: 'Summarized Text 3',
            status: Status(isLiked: true, isDisliked: false)),
        type: 'Type 3',
        title: 'Title 3',
        folderId: 'tvfhU74PpaFHfWg5Qxi0',
        thumbnail:
            'https://images.unsplash.com/photo-1657981879763-d39602db3838?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        link: 'http://link3.com',
        tags: ['tag5', 'tag6'],
      ),
      ContentModel(
        contentId: 'content4',
        extractedText: 'Text 4',
        dateUpdated: '2024-05-04',
        translation: Translation(
            text: 'Translated Text 4',
            status: Status(isLiked: false, isDisliked: true)),
        summarization: Translation(
            text: 'Summarized Text 4',
            status: Status(isLiked: false, isDisliked: true)),
        type: 'Type 4',
        title: 'Title 4',
        folderId: 'tvfhU74PpaFHfWg5Qxi0',
        thumbnail:
            'https://images.unsplash.com/photo-1657981879763-d39602db3838?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        link: 'http://link4.com',
        tags: ['tag7', 'tag8'],
      ),
      ContentModel(
        contentId: 'content5',
        extractedText: 'Text 5',
        dateUpdated: '2024-05-05',
        translation: Translation(
            text: 'Translated Text 5',
            status: Status(isLiked: true, isDisliked: false)),
        summarization: Translation(
            text: 'Summarized Text 5',
            status: Status(isLiked: true, isDisliked: false)),
        type: 'Type 5',
        title: 'Title 5',
        folderId: 'tvfhU74PpaFHfWg5Qxi0',
        thumbnail:
            'https://images.unsplash.com/photo-1657981879763-d39602db3838?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        link: 'http://link5.com',
        tags: ['tag9', 'tag10'],
      ),
    ];
    try {
      // hard-code value for now
      final collection = _firestore
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E')
          .collection('content');

      for (var content in contents) {
        DocumentReference docRef = await collection.add(content.toJson());
        await docRef.update({'content_id': docRef.id});
      }

      print('Added successfully');
    } catch (e) {
      print('Error getting users: $e');
    }
  }
}
