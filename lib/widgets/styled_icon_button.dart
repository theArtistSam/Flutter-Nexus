// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';

// ignore: must_be_immutable
class StyledIconButton extends StatelessWidget {
  StyledIconButton({
    super.key,
    this.backgroundColor = NexusColors.primaryColorLight,
    this.iconColor = Colors.white,
    this.borderColor = NexusColors.borderColor,
    this.isBordered = false,
    this.padding = 9,
    this.height = 24,
    required this.icon,
    required this.onTap,
  });

  String icon;
  Color backgroundColor;
  Color borderColor;
  Color iconColor;
  bool isBordered;
  double padding;
  double height;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            border: isBordered
                ? Border.all(
                    color: borderColor,
                    width: 2,
                  )
                : null,
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: SvgPicture.asset(
              'assets/icons/$icon.svg',
              color: iconColor,
              height: height,
            ),
          ),
        ),
      ),
    );
  }
}
