import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class DatetimeTile extends StatelessWidget {
  const DatetimeTile({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Container(
          decoration: ShapeDecoration(
            color: NexusColors.accentColor,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 7,
                cornerSmoothing: 0.8,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            child: StyledText(
              text: DateTimeConversion.getChatTime(datetime: time),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: NexusColors.secondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
