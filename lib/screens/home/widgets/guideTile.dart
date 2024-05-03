import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/styledText.dart';

// ignore: must_be_immutable
class GuideTile extends StatelessWidget {
  GuideTile({super.key, required this.image, required this.title, required this.onTap});

  String image;
  String title;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SizedBox(
            height: 170,
            child: ClipSmoothRect(
              radius: SmoothBorderRadius(
                cornerRadius: 15,
                cornerSmoothing: 0.8,
              ),
              child: Image.asset(
                'assets/images/guide.png',
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
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    text: 'Guide',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 220,
                    child: StyledText(
                      text: 'Learn to Translate',
                      fontSize: 24,
                      color: Colors.white,
                    ),
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
