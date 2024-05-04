import 'dart:ffi';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';

// ignore: must_be_immutable
class ContentTile extends StatelessWidget {
  ContentTile(
      {super.key,
      required this.title,
      required this.image,
      required this.date,
      required this.icon,
      required this.onTap});

  String title;
  String date;
  String icon;
  String image;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
}
