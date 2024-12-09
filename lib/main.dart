import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter/material.dart';
import 'package:nexus/screens/onboarding/onboarding_screen.dart';
import 'package:nexus/services/background_upload_service.dart';
import 'package:nexus/services/firebase_init_service.dart';
import 'package:nexus/services/local_storage_service.dart';
import 'package:nexus/utils/bottom_navbar/bottom_navbar.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initalize firebase
  await FirebaseInitService.init();

  // Initialize Local Storage Service

  await LocalStorageService.init();

  // Initialize Workmanager
  Workmanager().initialize(
    // The top-level function that handles background tasks
    backgroundUploadService,
    isInDebugMode: true, // Set this to false in production
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    services.SystemChrome.setSystemUIOverlayStyle(
      const services.SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    services.SystemChrome.setEnabledSystemUIMode(
      services.SystemUiMode.edgeToEdge,
      overlays: [services.SystemUiOverlay.top],
    );

    return MaterialApp(
      title: 'NEXUS',
      debugShowCheckedModeBanner: false,
      home: _AuthStateWrapper(),
    );
  }
}

class _AuthStateWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking authentication state
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // If the user is signed in, show the bottom navigation bar
          return const BottomNavBar(); // Replace with your bottom nav bar screen
        } else {
          // If the user is not signed in, show the onboarding screen
          return const OnboardingScreen(); // Replace with your onboarding screen
        }
      },
    );
  }
}
