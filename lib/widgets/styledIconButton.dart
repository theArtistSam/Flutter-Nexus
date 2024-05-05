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
    this.padding = 9,
    required this.icon,
    required this.onTap,
  });

  String icon;
  Color backgroundColor;
  Color iconColor;
  double padding;
  VoidCallback onTap;
  // void Function(int index)? setSelectedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: SvgPicture.asset(
            'assets/icons/$icon.svg',
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
