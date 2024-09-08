import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nexus/screens/cached_image_stub.dart';
import 'package:nexus/screens/home/home_screen.dart';
import 'package:nexus/screens/video_stub.dart';
import 'package:nexus/utils/bottom_navbar/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!,
      appId: dotenv.env['FIREBASE_APP_ID']!,
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    services.SystemChrome.setSystemUIOverlayStyle(
      const services.SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor:
            Colors.transparent, // Set the desired background color
      ),
    );

    services.SystemChrome.setEnabledSystemUIMode(
      services.SystemUiMode.edgeToEdge,
      overlays: [services.SystemUiOverlay.top],
    );
    return const MaterialApp(
      title: 'NEXUS',
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}
