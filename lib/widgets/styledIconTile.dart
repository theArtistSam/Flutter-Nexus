import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledText.dart';

// ignore: must_be_immutable
class StyledIconTile extends StatelessWidget {
  StyledIconTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.onTap,
      this.isPrimary = true});
  String icon;
  String text;
  VoidCallback onTap;
  bool isPrimary;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: isPrimary
              ? NexusColors.primaryColorLight
              : NexusColors.accentColorLight,
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
                color: isPrimary ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 10),
              StyledText(
                text: text,
                color: isPrimary
                    ? NexusColors.textColorLight
                    : NexusColors.textColorDark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
        ),
      ),
    );
  }
}
