import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

// ignore: must_be_immutable
class ContentUploadTile extends StatelessWidget {
  ContentUploadTile(
      {super.key, required this.icon, required this.text, required this.onTap});

  String icon;
  String text;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                side: BorderSide(color: NexusColors.borderColor, width: 2),
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SvgPicture.asset(
                'assets/icons/$icon.svg',
                width: 37,
                height: 37,
                color: NexusColors.primaryColorLight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        StyledText(
          text: text,
          fontSize: 14,
        )
      ],
    );
  }
}
