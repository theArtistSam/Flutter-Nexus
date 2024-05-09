import 'package:flutter/services.dart' as services;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus/screens/content/contentScreen.dart';
import 'package:nexus/screens/folder/folderScreen.dart';
import 'package:nexus/screens/home/homeScreen.dart';
import 'package:nexus/screens/library/libraryScreen.dart';
import 'package:nexus/utils/bottomNavbar.dart';
import 'package:nexus/utils/constants.dart';

void main() {
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
      // theme: ThemeData(
      //     appBarTheme:
      //         const AppBarTheme(color: NexusColors.backgroundColorLight)),
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}
