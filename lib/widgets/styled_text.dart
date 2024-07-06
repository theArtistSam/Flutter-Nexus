import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/utils/constants.dart';

// ignore: must_be_immutable
class StyledText extends StatelessWidget {
  StyledText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.color = NexusColors.textColorDark,
    this.align = TextAlign.left,
  });

  String text;
  double fontSize;
  FontWeight fontWeight;
  Color color;
  TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: fontSize, fontWeight: fontWeight, color: color),
      textAlign: align,
    );
  }
}
