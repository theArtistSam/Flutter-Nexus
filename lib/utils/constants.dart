import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NexusColors {
  static bool isDark = false;

  static const primaryColorLight = Color(0XFF2A4E8F);
  static const backgroundColorLight = Color(0XFFFFFFFF);
  static const accentColorLight = Color(0XFFF4F6F9);
  static const textColorLight = Colors.white;
  static const secondaryTextColorLight = Colors.white54;

  static const borderColor = Color(0XFFCBD5E4);
  static const confirmColor = Color(0XFF2B9F03);
  static const warningColor = Color(0XFFB50202);
  static const dividerColor = Color(0xFFEBEEF4);

  // Issue Colors
  static const resolvedColor = Color(0xFF2B9F03);
  static const closedColor = Color(0xFFB50202);
  static const pendingColor = Color(0xFFF29339);

  // static const primaryColorDark = Color(0XFFFFFFFF);
  // static const primaryColorDark = Color(0XFF1D385C);
  static const primaryColorDark = Color(0XFF27457D);
  static const backgroundColorDark = Color(0XFF13151b);
  static const accentColorDark = Color(0XFF2c2d32);
  // static const accentColorDark = Color(0XFF151C29);
  static const textColorDark = Colors.black;
  static const secondaryTextColorDark = Colors.black45;

  // Main colors to be used with in the app
  static Color get primaryColor =>
      isDark ? primaryColorDark : primaryColorLight;
  static Color get backgroundColor =>
      isDark ? backgroundColorDark : backgroundColorLight;
  static Color get accentColor => isDark ? accentColorDark : accentColorLight;
  static Color get textColor => isDark ? textColorLight : textColorDark;
  static Color get secondaryTextColor =>
      isDark ? secondaryTextColorLight : secondaryTextColorDark;
}

// class NexusThemes {
//   static final lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: NexusColors.primaryColorLight,
//     // accentColor: NexusColors.accentColorLight,
//     scaffoldBackgroundColor: NexusColors.backgroundColorLight,
//     cardColor: NexusColors
//         .backgroundColorLight, // You can use backgroundColorLight as cardColor
//     canvasColor: NexusColors
//         .backgroundColorLight, // You can use backgroundColorLight as canvasColor
//     dividerColor:
//         NexusColors.borderColor, // You can use borderColor as dividerColor
//     focusColor: NexusColors
//         .primaryColorLight, // You can use primaryColorLight as focusColor
//     splashColor: NexusColors.primaryColorLight
//         .withOpacity(0.3), // You can adjust the opacity as needed
//     // Add other colors as needed
//   );

//   static final darkTheme = ThemeData(
//     primaryColor: NexusColors.primaryColorDark,
//     brightness: Brightness.dark,
//     // accentColor: NexusColors.accentColorDark,
//     scaffoldBackgroundColor: NexusColors.backgroundColorDark,
//     cardColor: NexusColors
//         .backgroundColorDark, // You can use backgroundColorDark as cardColor
//     canvasColor: NexusColors
//         .backgroundColorDark, // You can use backgroundColorDark as canvasColor
//     dividerColor:
//         NexusColors.borderColor, // You can use borderColor as dividerColor
//     focusColor: NexusColors
//         .primaryColorDark, // You can use primaryColorDark as focusColor
//     splashColor: NexusColors.primaryColorDark
//         .withOpacity(0.3), // You can adjust the opacity as needed
//     // Add other colors as needed
//   );
// }

class DateTimeConversion {
  static String formattedDate({required String datetime}) {
    DateTime dateTime = DateTime.parse(datetime);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
    return formattedDate;
  }

  static String formattedTime({required String datetime}) {
    DateTime dateTime = DateTime.parse(datetime);
    String formattedTime = DateFormat('hh:mm a')
        .format(dateTime)
        .toUpperCase(); // Ensuring AM/PM is in uppercase
    return formattedTime;
  }

  static String getTime({required String datetime}) {
    DateTime messageTime = DateTime.parse(datetime); // Parse string to DateTime

    DateTime now = DateTime.now();
    Duration difference = now.difference(messageTime);

    String lastMessageTime;
    if (difference.inHours < 24) {
      lastMessageTime = DateTimeConversion.formattedTime(datetime: datetime);
    } else {
      lastMessageTime = DateTimeConversion.formattedDate(datetime: datetime);
    }
    return lastMessageTime;
  }
}

class FolderIcons {
  static const List icons = [
    'folder-minus',
    'double-folder',
    'heart-folder',
    'favorite-chart',
    'notification-status',
    'brush-square',
    'gallery',
    'audio-square',
    'video-square',
    'calendar',
    'code',
    'key-square',
  ];
}
