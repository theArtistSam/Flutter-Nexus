// ignore: file_names
// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens/home/widgets/contentTile.dart';
import 'package:nexus/screens/home/widgets/guideTile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';

class HomeScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    List<TabItem> items = [
      TabItem(
        icon: SizedBox(
          height: 24,
          width: 24,
        ),
        title: 'Home',
      ),
      // TabItem(
      //   icon: Icons.search_sharp,
      //   title: 'Shop',
      // ),
      // TabItem(
      //   icon: Icons.favorite_border,
      //   title: 'Wishlist',
      // ),
      // TabItem(
      //   icon: Icons.shopping_cart_outlined,
      //   title: 'Cart',
      // ),
      // TabItem(
      //   icon: Icons.account_box,
      //   title: 'profile',
      // ),
    ];
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: NexusColors.accentColorLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: NexusColors.accentColorLight,
            centerTitle: true,
            leading: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {}, // Handle tap on leading widget
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile-picture.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(text: 'Dunn Oliver', fontSize: 20),
                Row(
                  children: [
                    StyledText(
                      text: 'Premium Account',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: NexusColors.secondaryTextColorDark,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/small-arrow-right.svg',
                      color: NexusColors.secondaryTextColorDark,
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
      body: SingleChildScrollView(
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      height: 170, autoPlay: true, viewportFraction: 1),
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
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    quickAccessTile(
                        icon: 'translate-filled',
                        text: 'Translate',
                        onTap: () => {}),
                    const SizedBox(width: 10),
                    quickAccessTile(
                        icon: 'book-filled',
                        text: 'Summarize',
                        onTap: () => {}),
                  ],
                ),
                const SizedBox(height: 15),
                StyledText(text: 'Recent Content', fontSize: 20),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5, // Number of items
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                        height: 15); // Separator between items
                  },
                  itemBuilder: (BuildContext context, int index) {
                    // Build each item
                    return ContentTile(
                        title: 'Learn how to make vids on YouTube from home',
                        image: 'content',
                        date: 'December 10, 2024',
                        icon: 'video',
                        onTap: () => {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }

  Widget quickAccessTile({String? icon, String? text, VoidCallback? onTap}) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: ShapeDecoration(
              color: NexusColors.primaryColorLight,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    height: 37,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  StyledText(
                    text: text ?? '',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
