import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_text.dart';

// ignore: must_be_immutable
class StyledButton extends StatelessWidget {
  StyledButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.isBordered = false,
      this.isDeleteable = false,
      this.icon});

  String text;
  VoidCallback onTap;
  String? icon;
  bool isBordered;
  bool isDeleteable;

  BorderSide borderSide() {
    if (isBordered) {
      return const BorderSide(
        color: NexusColors.borderColor,
        width: 2,
      );
    } else if (isDeleteable) {
      return const BorderSide(color: NexusColors.warningColor, width: 2);
    }
    return const BorderSide(color: NexusColors.primaryColorLight, width: 2);
  }

  Color color() {
    if (isBordered) {
      return Colors.transparent;
    } else if (isDeleteable) {
      return NexusColors.warningColor;
    }
    return NexusColors.primaryColorLight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: color(),
        shape: SmoothRectangleBorder(
            side: borderSide(),
            borderRadius:
                SmoothBorderRadius(cornerRadius: 13, cornerSmoothing: 0.8)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              SmoothBorderRadius(cornerRadius: 11, cornerSmoothing: 0.8),
          onTap: onTap,
          child: SizedBox(
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
                      text: text,
                      // fontSize: 14,
                      color: isBordered
                          ? NexusColors.textColorDark
                          : NexusColors.textColorLight)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
