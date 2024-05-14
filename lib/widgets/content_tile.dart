// ignore_for_file: deprecated_member_use, file_names

import 'dart:ffi';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_text.dart';

// ignore: must_be_immutable
class ContentTile extends StatelessWidget {
  ContentTile(
      {super.key,
      required this.title,
      required this.image,
      required this.date,
      required this.icon,
      required this.onTap,
      this.isSmall = false});

  String title;
  String date;
  String icon;
  String image;
  VoidCallback onTap;
  bool isSmall;

  @override
  Widget build(BuildContext context) {
    return isSmall ? contentTileSmall() : contentTileLarge();
  }

  Widget contentTileSmall() => GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 100,
        decoration: ShapeDecoration(
            color: NexusColors.accentColorLight,
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                    cornerRadius: 15, cornerSmoothing: 0.8))),
        child: Row(
          children: [
            Stack(children: [
              // Give this container available height
              ClipSmoothRect(
                radius: const SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 15, cornerSmoothing: 0.8),
                  bottomLeft:
                      SmoothRadius(cornerRadius: 15, cornerSmoothing: 0.8),
                ),
                child: Image.asset(
                  'assets/images/$image.png',
                  fit: BoxFit.cover,
                  width: 100,
                  // height: double.infinity,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0), // Start color (0% black)
                        Colors.black.withOpacity(0.5), // End color (90% black)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/$icon.svg',
                      color: Colors.white60,
                      height: 35,
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledText(
                      text: title,
                      fontSize: 16,
                      color: NexusColors.textColorDark,
                    ),
                    // const Spacer(),
                    StyledText(
                      text: date,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: NexusColors.secondaryTextColorDark,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ));

  Widget contentTileLarge() => GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            SizedBox(
              height: 210,
              child: ClipSmoothRect(
                radius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
                child: Image.asset(
                  'assets/images/$image.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0), // Start color (0% black)
                      Colors.black.withOpacity(0.5), // End color (90% black)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    StyledText(
                      text: title,
                      fontSize: 18,
                      color: NexusColors.textColorLight,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        StyledText(
                          text: date,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: NexusColors.secondaryTextColorLight,
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          'assets/icons/$icon.svg',
                          color: NexusColors.secondaryTextColorLight,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
