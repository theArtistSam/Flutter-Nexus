// ignore: file_names
// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens/home/widgets/contentSheetTile.dart';
import 'package:nexus/screens/home/widgets/contentTile.dart';
import 'package:nexus/screens/home/widgets/guideTile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';
import 'package:nexus/widgets/styledButton.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:nexus/widgets/styledTabs.dart';

class HomeScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool isTranslateSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                  topRight:
                      SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8)),
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
      bottomNavigationBar: BottomBarCreative(
        items: navbarItems(index: selectedIndex),
        backgroundColor: Colors.white,
        color: Colors.black,
        colorSelected: NexusColors.primaryColorLight,
        titleStyle:
            GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        indexSelected: selectedIndex,
        onTap: (int index) => setState(() {
          selectedIndex = index;
          if (selectedIndex == 2) {
            showModalBottomSheet(              
                isScrollControlled: false,
                context: context,
                builder: (context) => contentBottomSheet() // Add actual content
                );
            selectedIndex = 0;
          }
        }),
      ),
    );
  }

  Widget contentBottomSheet() => Wrap(
        children: [
          Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
                    topRight:
                        SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(children: [
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: NexusColors.borderColor),
                ),
                const SizedBox(height: 15),
                const StyledTabs(),
                const Divider(color: NexusColors.dividerColor, height: 30),
                Row(
                  children: [
                    ContentSheetTile(
                        icon: 'video', text: 'Video', onTap: () => {}),
                    const Spacer(),
                    ContentSheetTile(
                        icon: 'audio', text: 'Audio', onTap: () => {}),
                    const Spacer(),
                    ContentSheetTile(
                        icon: 'image', text: 'Image', onTap: () => {}),
                    const Spacer(),
                    ContentSheetTile(
                        icon: 'document', text: 'Document', onTap: () => {}),
                  ],
                ),
                const SizedBox(height: 20),
                StyledButton(
                  text: 'Upload via Drive',
                  onTap: () => {},
                  icon: 'google-drive',
                  isBordered: true,
                ),
                const SizedBox(height: 20),
                StyledButton(
                  text: 'Live chat with AI',
                  onTap: () => {},
                  icon: 'message-filled',
                ),
                const SizedBox(height: 20),
              ]),
            ),
          )
        ],
      );

  navbarItems({int? index}) => [
        TabItem(
            icon: SvgPicture.asset(
              index == 0
                  ? 'assets/icons/home-filled.svg'
                  : 'assets/icons/home.svg',
              color: index == 0 ? NexusColors.primaryColorLight : Colors.black,
              height: 24,
            ),
            title: 'Home'),
        TabItem(
            icon: SvgPicture.asset(
              index == 1
                  ? 'assets/icons/library-filled.svg'
                  : 'assets/icons/library.svg',
              color: index == 1 ? NexusColors.primaryColorLight : Colors.black,
              height: 24,
            ),
            title: 'Library'),
        TabItem(
            icon: SvgPicture.asset(
              'assets/icons/sparkle.svg',
              height: 24,
            ),
            title: 'AI'),
        TabItem(
            icon: SvgPicture.asset(
              index == 3
                  ? 'assets/icons/community-filled.svg'
                  : 'assets/icons/community.svg',
              color: index == 3 ? NexusColors.primaryColorLight : Colors.black,
              height: 24,
            ),
            title: 'Forum'),
        TabItem(
            icon: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: 
                      Border.all(
                          color: index == 4 ? NexusColors.primaryColorLight : Colors.white, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile-picture.png',
                  fit: BoxFit.cover,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            title: 'Profile')
      ];

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
