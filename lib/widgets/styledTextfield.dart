import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/utils/constants.dart';

class StyledTextfield extends StatelessWidget {
  StyledTextfield(
      {super.key,
      required this.icon,
      required this.hintText,
      required this.controller});

  String? icon;
  String hintText;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
              side: const BorderSide(width: 2, color: NexusColors.borderColor),
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: .8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            icon != null
                ? SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    color: NexusColors.primaryColorLight,
                  )
                : const SizedBox(),
            Expanded(
              child: TextField(
                controller: controller,
                // autofocus: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  contentPadding: icon != null
                      ? const EdgeInsets.only(left: 10, top: 0, bottom: 0)
                      : null,
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
