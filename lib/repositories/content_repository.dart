import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/model_configs/summarization_config.dart';
import 'package:nexus/models/model_configs/translation_config.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:workmanager/workmanager.dart';

class ContentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Now the function also takes a query as a parameter
  Stream<List<ContentModel>> getAllContents({
    Query Function(Query)? queryBuilder,
  }) {
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
      // Firestore reference to the content document
      final docRef = _firestore
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E') // Use actual userId
          .collection('content')
          .doc(contentId);

      // Delete the Firestore document
      await docRef.delete();
      print("Document deleted from Firestore.");

      // Reference to the Firebase Storage folder
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child('Bd4umkyLqOLnMpdOLZ0E') // Use actual userId
          .child('content')
          .child(contentId);

      // List all files in the folder (contentId)
      final ListResult result = await storageRef.listAll();

      // Loop through each file and delete it
      for (var fileRef in result.items) {
        try {
          await fileRef.delete();
          print("File ${fileRef.fullPath} deleted from Firebase Storage.");
        } catch (e) {
          print("Error deleting file ${fileRef.fullPath}: $e");
        }
      }

      // Optionally: You can try to delete the folder itself if it's empty
      try {
        await storageRef.delete(); // This will only work if the folder is empty
        print("Folder deleted successfully.");
      } catch (e) {
        print("Folder could not be deleted or doesn't exist: $e");
      }

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

  Future<void> uploadContentList({
    required String userId,
    required List<ContentModel> contentList,
    required List<File> files,
  }) async {
    try {
      print("+++>${contentList.length}");

      for (var content in contentList) {
        // Upload metadata to Firestore
        final docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('content')
            .add(content.toJson());

        // Get the generated document ID
        String contentId = docRef.id;

        // Update the content ID
        content.contentId = contentId;
        await docRef.update({'content_id': contentId});

        // TODO: Implement the following using background service
        // Match the file to the content title (if needed)
        File? matchedFile = files.firstWhere(
          (file) => file.path.split('/').last == content.title,
          orElse: () => throw Exception("No matching file found"),
        );

        // Schedule background upload task
        Workmanager().registerOneOffTask(
          'upload_task_$contentId', // Unique task identifier
          'backgroundUploadTask', // Background task name
          inputData: {
            'userId': userId,
            'contentId': contentId,
            'filePath': matchedFile.path,
          },
        );
      }

      print('Content uploaded. Files will be uploaded in the background.');
    } catch (e) {
      print("Error during content upload: $e");
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

  Future<void> toggleLike({
    required bool isTranslation,
    required bool value,
    required String userId,
    required String documentId,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('content')
          .doc(documentId);

      // Check if the document exists
      final DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception("Document not found");
      }

      // Determine the path for the specific section (translation or summarization)
      final String path =
          isTranslation ? 'translation.status' : 'summarization.status';

      // Prepare the update data
      final Map<String, dynamic> updateData = {
        '$path.is_liked': value, // Update isLiked
        '$path.is_disliked': false, // Update isDisliked
      };

      // Update only the status fields without affecting other properties
      await docRef.update(updateData);
      print('Document $documentId updated successfully.');
    } catch (e) {
      print('Error updating message: $e');
    }
  }

  Future<void> toggleDislike({
    required bool isTranslation,
    required bool value,
    required String userId,
    required String documentId,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('content')
          .doc(documentId);

      // Check if the document exists
      final DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception("Document not found");
      }

      // Determine the path for the specific section (translation or summarization)
      final String path =
          isTranslation ? 'translation.status' : 'summarization.status';

      // Prepare the update data
      final Map<String, dynamic> updateData = {
        '$path.is_liked': false, // Update isLiked
        '$path.is_disliked': value, // Update isDisliked
      };

      // Update only the status fields without affecting other properties
      await docRef.update(updateData);
      print('Document $documentId updated successfully.');
    } catch (e) {
      print('Error updating message: $e');
    }
  }

  Future<void> updateSummarizationConfig({
    required String contentId,
    required SummarizationConfig summarizationConfig,
  }) async {
    try {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E') // Consider making the user ID dynamic
          .collection('content')
          .doc(contentId);

      // then go to ['summarization']['summarization_config'] to update
      await docRef.update({
        'summarization.summarization_config': summarizationConfig.toJson(),
      });

      print('Summarization Config updated successfully');
    } catch (e) {
      print('Failed to update Summarization Config: $e');
    }
  }

  Future<void> updateTranslationConfig({
    required String contentId,
    required TranslationConfig translationConfig,
  }) async {
    try {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc('Bd4umkyLqOLnMpdOLZ0E') // Consider making the user ID dynamic
          .collection('chat')
          .doc(contentId);

      await docRef.update({
        'summarization.translation_config': translationConfig.toJson(),
      });

      print('Translation Config updated successfully');
    } catch (e) {
      print('Failed to update Summarization Config: $e');
    }
  }

  Future<void> generateSummary({
    required String userId,
    required String contentId,
    required Summarization summarization,
  }) async {
    try {
      // Reference to the specific content document in Firestore
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('content')
          .doc(contentId);

      // Update Firestore with summarization config and text
      await docRef.update({'summarization': summarization.toJson()});

      print("Summary generated and updated successfully.");
    } catch (e) {
      print("Failed to generate summary: $e");
    }
  }

  Future<void> generateTraslation({
    required String userId,
    required String contentId,
    required Translation translation,
  }) async {
    try {
      // Reference to the specific content document in Firestore
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('content')
          .doc(contentId);

      // Update Firestore with summarization config and text
      await docRef.update({'translation': translation.toJson()});

      print("Translation generated and updated successfully.");
    } catch (e) {
      print("Failed to generate translation: $e");
    }
  }
}
