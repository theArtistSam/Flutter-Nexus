// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';

// ignore: must_be_immutable
class StyledIconButton extends StatelessWidget {
  const StyledIconButton({
    super.key,
    this.backgroundColor = NexusColors.primaryColorLight,
    this.iconColor = Colors.white,
    this.borderColor,
    this.isBordered = false,
    this.padding = 9,
    this.height = 24,
    required this.icon,
    required this.onTap,
  });

  final String icon;
  final Color backgroundColor;
  final Color? borderColor;
  final Color iconColor;
  final bool isBordered;
  final double padding;
  final double height;
  final VoidCallback onTap;

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
                    color: borderColor ?? NexusColors.borderColor,
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
