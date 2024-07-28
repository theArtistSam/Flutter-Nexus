import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class StyledSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.fromLTRB(
          10,
          10,
          10,
          MediaQuery.of(context).padding.bottom + 10,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: ShapeDecoration(
            color: NexusColors.primaryColor,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 15,
                cornerSmoothing: 0.8,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StyledText(
              text: message,
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        duration: duration,
      ),
    );
  }
}
