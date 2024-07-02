import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/home_screen_bloc/bloc/home_screen_bloc.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/screens/folder/folder_screen.dart';
import 'package:nexus/screens/home/home_screen.dart';
import 'package:nexus/screens/library/library_screen.dart';
import 'package:nexus/screens/ai_stub.dart';
import 'package:nexus/screens/database_stub.dart';
import 'package:nexus/utils/bottom_navbar.dart';
import 'package:nexus/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Create an env file to hide that
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyA-Kcgm4RmMydrKt-VzRsNCyWx9ZJYnHD8',
    appId: '1:217320925090:android:bf4c7c37d5c0df98cc34fb',
    messagingSenderId: '217320925090',
    projectId: 'nexus-ef4c1',
    storageBucket: 'nexus-ef4c1.appspot.com',
  ));
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
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor:
              Colors.transparent // Set the desired background color
          ),
    );

    services.SystemChrome.setEnabledSystemUIMode(
        services.SystemUiMode.edgeToEdge,
        overlays: [services.SystemUiOverlay.top]);
    return const MaterialApp(
      title: 'Coffee Application',
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}
