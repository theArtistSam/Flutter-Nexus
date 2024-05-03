// ignore: file_names
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/screens/home/widgets/guideTile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';
import 'package:nexus/widgets/styledIconButton.dart';

class HomeScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NexusColors.accentColorLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: NexusColors.accentColorLight,
            leading: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {}, // Handle tap on leading widget
              child: SizedBox(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile-picture.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(text: 'Dunn Oliver', fontSize: 18),
                Row(
                  children: [
                    StyledText(
                      text: 'Premium Account',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: NexusColors.secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/small-arrow-right.svg',
                      color: NexusColors.secondaryTextColor,
                      height: 12,
                    )
                  ],
                ),
              ],
            ),
            actions: [
              StyledIconButton(
                icon: 'notification',
                onTap: () {},
                backgroundColor: Colors.white,
                iconColor: Colors.black,
              ),
              const SizedBox(width: 10),
              StyledIconButton(icon: 'menu', onTap: () {}),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: ShapeDecoration(
          color: NexusColors.backgroundColorLight,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 35,
              cornerSmoothing: 0.8,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CarouselSlider(                
                options: CarouselOptions(height: 170, autoPlay: true, viewportFraction: 1),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GuideTile(
                            image: 'image', title: 'title', onTap: () => {}),
                      );
                    },
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
