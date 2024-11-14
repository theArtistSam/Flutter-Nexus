import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseInitService {
  static Future<void> init() async {
    try {
      // Load the .env file
      await dotenv.load(fileName: ".env");

      // Initialize Firebase only if it's not already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: dotenv.env['FIREBASE_API_KEY']!,
            appId: dotenv.env['FIREBASE_APP_ID']!,
            messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
            projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
            storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
          ),
        );
        print("Firebase initialized successfully.");
      } else {
        print("Firebase is already initialized.");
      }
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }
}
