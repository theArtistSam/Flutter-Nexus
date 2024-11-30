import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nexus/services/firebase_init_service.dart';
import 'package:workmanager/workmanager.dart'; // Import Firebase Core

// The top-level function that handles background tasks
@pragma('vm:entry-point')
void backgroundUploadService() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print("WORKING:::");

      // Initalize firebase
      await FirebaseInitService.init();

      // Retrieve parameters passed from the main thread
      String? userId = inputData?['userId'];
      String? contentId = inputData?['contentId'];
      String? filePath = inputData?['filePath'];
      if (userId != null && contentId != null && filePath != null) {
        // Prepare to upload file to Firebase Storage
        String filename = filePath.split('/').last;
        File file = File(filePath);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(userId)
            .child('content')
            .child(contentId)
            .child(filename);

        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore document with the download link
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('content')
            .doc(contentId)
            .update({'link': downloadUrl});

        print("File uploaded in background successfully.");
      }

      return Future.value(true);
    } catch (e) {
      print("Error in background upload task: $e");
      return Future.value(false);
    }
  });
}
