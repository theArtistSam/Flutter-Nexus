import 'package:flutter/services.dart' as services;
import 'package:flutter/material.dart';
import 'package:nexus/services/background_upload_service.dart';
import 'package:nexus/services/firebase_init_service.dart';
import 'package:nexus/utils/bottom_navbar/bottom_navbar.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initalize firebase
  await FirebaseInitService.init();

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
