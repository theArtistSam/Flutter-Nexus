import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/utils/constants.dart';

// ignore: must_be_immutable
class StyledTextfield extends StatelessWidget {
  const StyledTextfield({
    super.key,
    this.icon,
    required this.hintText,
    required this.controller,
    this.maxlines = 1,
    this.isPassword = false,
    this.onChanged,
  });

  final String? icon;
  final String hintText;
  final int maxlines;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          side: BorderSide(width: 2, color: NexusColors.borderColor),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: .8,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            icon != null
                ? SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    // COLOR: FIX
                    color: NexusColors.isDark
                        ? Colors.white
                        : NexusColors.primaryColorLight,
                  )
                : const SizedBox(),
            Expanded(
              child: TextField(
                obscureText: isPassword,
                controller: controller,
                minLines: 1,
                maxLines: maxlines,
                // autofocus: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  contentPadding: icon != null
                      ? const EdgeInsets.only(left: 10, top: 0, bottom: 0)
                      : null,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    // COLOR: FIX
                    color: NexusColors.isDark
                        ? NexusColors.secondaryTextColor
                        : NexusColors.primaryColorLight,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  // COLOR: FIX
                  color: NexusColors.isDark
                      ? Colors.white
                      : NexusColors.primaryColorLight,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
