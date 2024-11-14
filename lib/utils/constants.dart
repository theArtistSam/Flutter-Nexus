import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NexusColors {
  static bool isDark = true;

  static const primaryColorLight = Color(0XFF2A4E8F);
  static const backgroundColorLight = Color(0XFFFFFFFF);
  static const accentColorLight = Color(0XFFF4F6F9);
  static const textColorLight = Colors.white;
  static const secondaryTextColorLight = Colors.white54;
  static const borderColorLight = Color(0XFFCBD5E4);

  static const confirmColor = Color(0XFF2B9F03);
  static const warningColor = Color(0XFFff0f0f);
  static const dividerColor = Color(0xFFEBEEF4);

  // Issue Colors
  static const resolvedColor = Color(0xFF2B9F03);
  static const closedColor = Color(0xFFff0f0f);
  static const pendingColor = Color(0xFFF29339);

  static const primaryColorDark = Color(0XFF27457D);
  static const backgroundColorDark = Color(0XFF13151b);
  static const borderColorDark = accentColorDark;
  static const accentColorDark = Color(0XFF2c2d32);
  static const textColorDark = Colors.black;
  static const secondaryTextColorDark = Colors.black45;

  // Main colors to be used with in the app
  static Color get borderColor => isDark ? borderColorDark : borderColorLight;
  static Color get primaryColor =>
      isDark ? primaryColorDark : primaryColorLight;
  static Color get backgroundColor =>
      isDark ? backgroundColorDark : backgroundColorLight;
  static Color get accentColor => isDark ? accentColorDark : accentColorLight;
  static Color get textColor => isDark ? textColorLight : textColorDark;
  static Color get secondaryTextColor =>
      isDark ? secondaryTextColorLight : secondaryTextColorDark;
}

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

  static String formattedSearchDate(String inputDate) {
    // Define the input format
    final DateFormat inputFormat = DateFormat('MMMM d, yyyy');
    // Define the output format
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    // Parse the input date
    DateTime dateTime = inputFormat.parse(inputDate);

    // Format the date into the desired output format
    return outputFormat.format(dateTime);
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

  // Function to extract date components from a full date string
  static bool dateMatches(String date, String query) {
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    try {
      final parsedDate = dateFormat.parse(date);
      final year = parsedDate.year.toString();
      final month = DateFormat("MMMM").format(parsedDate).toLowerCase();
      final day = parsedDate.day.toString();

      return year.contains(query) ||
          month.contains(query) ||
          day.contains(query);
    } catch (e) {
      return false; // If parsing fails, don't match
    }
  }

  static String getChatTime({required String datetime}) {
    DateTime messageTime = DateTime.parse(datetime); // Parse string to DateTime
    DateTime now = DateTime.now();
    Duration difference = now.difference(messageTime);

    if (difference.inDays == 0) {
      // If the difference is less than a day
      return 'Today';
    } else if (difference.inDays == 1) {
      // If the difference is exactly one day
      return 'Yesterday';
    } else if (difference.inDays <= 7) {
      // If the difference is within the last week
      return DateFormat('EEEE')
          .format(messageTime); // Returns the day of the week
    } else {
      // If the difference is more than a week
      return DateFormat('MMMM d, yyyy')
          .format(messageTime); // Returns the formatted date
    }
  }

  static bool isDifferentDay({index, messageList, message}) {
    String currentMessageTime = DateTimeConversion.getChatTime(
      datetime: message.timeStamp,
    );
    String nextMessageTime = DateTimeConversion.getChatTime(
      datetime: messageList[index - 1].timeStamp,
    );
    return currentMessageTime != nextMessageTime;
  }
}

class ImageSelector {
  static Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    return pickedFile;
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
