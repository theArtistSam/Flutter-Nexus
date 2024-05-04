import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';

// ignore: must_be_immutable
class StyledButton extends StatelessWidget {
  StyledButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.isBordered = false,
      this.icon});

  String text;
  VoidCallback onTap;
  String? icon;
  bool isBordered;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: isBordered ? Colors.transparent : NexusColors.primaryColorLight,
        shape: SmoothRectangleBorder(
            side: isBordered
                ? const BorderSide(color: NexusColors.borderColor, width: 2)
                : const BorderSide(color: NexusColors.primaryColorLight, width: 2),
            borderRadius:
                SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    height: 24,
                    color: isBordered
                        ? NexusColors.primaryColorLight
                        : NexusColors.textColorLight,
                  )
                : const SizedBox(),
            SizedBox(width: icon != null ? 10 : 0),
            StyledText(
                text: 'Upload via Drive',
                fontSize: 14,
                color: isBordered
                    ? NexusColors.textColorDark
                    : NexusColors.textColorLight)
          ],
        ),
      ),
    );
  }
}
