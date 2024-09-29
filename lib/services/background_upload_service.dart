import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart'; // Import Firebase Core

// The top-level function that handles background tasks
@pragma('vm:entry-point')
void backgroundUploadService() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize Firebase in the background isolate
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY']!,
          appId: dotenv.env['FIREBASE_APP_ID']!,
          messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
          storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
        ),
      );

      // Retrieve parameters passed from the main thread
      String? userId = inputData?['userId'];
      String? contentId = inputData?['contentId'];
      String? filePath = inputData?['filePath'];

      if (userId != null && contentId != null && filePath != null) {
        // Prepare to upload file to Firebase Storage
        File file = File(filePath);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(userId)
            .child('content')
            .child(contentId);

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
