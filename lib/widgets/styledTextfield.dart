import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/utils/constants.dart';

class StyledTextfield extends StatelessWidget {
  StyledTextfield({super.key, required this.icon, required this.hintText});

  String icon;
  String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
              side: const BorderSide(width: 2, color: NexusColors.borderColor),
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: .8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/$icon.svg',
              color: NexusColors.primaryColorLight,
            ),
            Expanded(
              child: TextField(
                // controller: _textEditingController,
                //autofocus: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  contentPadding: const EdgeInsets.only(left: 10),
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: NexusColors.primaryColorLight,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: NexusColors.primaryColorLight,
                ),
                onChanged: (value) {
                  // Handle text changes
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
