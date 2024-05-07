import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledText.dart';

class FilterTile extends StatelessWidget {
  FilterTile(
      {super.key,
      this.isTapped = false,
      required this.filter,
      required this.onTap});

  bool isTapped;
  String filter;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
            color:
                isTapped ? NexusColors.primaryColorLight : Colors.transparent,
            shape: SmoothRectangleBorder(
                side: BorderSide(
                    width: 1.5,
                    color: !isTapped
                        ? NexusColors.borderColor
                        : NexusColors.primaryColorLight),
                borderRadius: SmoothBorderRadius(
                    cornerRadius: 12, cornerSmoothing: 0.8))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StyledText(
              text: filter,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: !isTapped
                  ? NexusColors.primaryColorLight
                  : NexusColors.accentColorLight),
        ),
      ),
    );
  }
}
