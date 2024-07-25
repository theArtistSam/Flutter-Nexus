import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/utils/constants.dart';

// ignore: must_be_immutable
class StyledText extends StatelessWidget {
  const StyledText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.color,
    this.align = TextAlign.left,
    this.isUrdu = false,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign align;
  final bool isUrdu;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: isUrdu
          ? GoogleFonts.notoNastaliqUrdu(
              color: color ?? NexusColors.textColor,
              height: 2.1,
              fontSize: fontSize,
              fontWeight: fontWeight,
            )
          : GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color ?? NexusColors.textColor,
            ),
      textAlign: isUrdu ? TextAlign.right : align,
    );
  }
}
