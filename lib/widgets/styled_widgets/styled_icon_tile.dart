import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

// ignore: must_be_immutable
class StyledIconTile extends StatelessWidget {
  StyledIconTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isPrimary = true,
    this.secondaryText,
  });
  final String icon;
  final String text;
  final String? secondaryText;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Ink(
          decoration: ShapeDecoration(
            color:
                isPrimary ? NexusColors.primaryColor : NexusColors.accentColor,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 15,
                cornerSmoothing: 0.8,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/$icon.svg',
                  height: 35,
                  color: isPrimary ? Colors.white : NexusColors.textColor,
                ),
                const SizedBox(height: 10),
                secondaryText != null
                    ? StyledText(
                        text: secondaryText!,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: NexusColors.secondaryTextColorLight,
                      )
                    : const SizedBox(),
                StyledText(
                  text: text,
                  color: isPrimary
                      ? NexusColors.textColorLight
                      : NexusColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
