import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens/chat/chatScreen.dart';
import 'package:nexus/screens/home/homeScreen.dart';
import 'package:nexus/screens/home/widgets/contentUploadTile.dart';
import 'package:nexus/screens/library/libraryScreen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledText.dart';
import 'package:nexus/widgets/styledButton.dart';
import 'package:nexus/widgets/styledTabs.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  bool isTranslateSelected = false;

  final List _pages = [
    const HomeScreen(),
    const LibraryScreen(),
    Center(child: StyledText(text: 'Forum')),
    Center(child: StyledText(text: 'Profile'))
  ];

  _changeTab(int index) {
    setState(() {
      final temp = _selectedIndex;
      _selectedIndex = index;
      if (index == 2) {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => contentBottomSheet(),
        );
        _selectedIndex = temp;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomBarCreative(
        items: navbarItems(index: _selectedIndex),
        backgroundColor: Colors.white,
        color: Colors.black,
        colorSelected: NexusColors.primaryColorLight,
        titleStyle:
            GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
        indexSelected: _selectedIndex,
        onTap: (int index) => _changeTab(index),
      ),
    );
  }

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
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Container(
                padding: const EdgeInsets.all(1.0), // Adjust padding as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: index == 4
                      ? Border.all(
                          color: NexusColors.primaryColorLight,
                          width: 2,
                        )
                      : null,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile-picture.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: 'Profile')
      ];

  Widget uploadingTile(
          {required String image,
          required String text,
          required VoidCallback onTap}) =>
      Row(
        children: [
          Stack(
            children: [
              SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 12,
                      cornerSmoothing: 0.8,
                    ),
                    child: Image.asset(
                      'assets/images/$image.png',
                      fit: BoxFit.cover,
                    ),
                  )),
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
                      'assets/icons/spinner.svg',
                      color: Colors.white,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          StyledText(
            text: text,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: SvgPicture.asset(
              'assets/icons/trash-filled.svg',
              color: NexusColors.primaryColorLight,
            ),
          )
        ],
      );

  Widget uploadBottomSheet() => Wrap(
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
                ListView.separated(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3, // Number of items
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                        height: 15); // Separator between items
                  },
                  itemBuilder: (BuildContext context, int index) {
                    // Build each item
                    return uploadingTile(
                        text: '1 Video Uploading',
                        onTap: () => {},
                        image: 'content');
                  },
                ),
                const Divider(
                  color: NexusColors.dividerColor,
                  height: 30,
                ),
                Row(
                  children: [
                    ContentUploadTile(
                        icon: 'video', text: 'Video', onTap: () => {}),
                    const Spacer(),
                    ContentUploadTile(
                        icon: 'audio', text: 'Audio', onTap: () => {}),
                    const Spacer(),
                    ContentUploadTile(
                        icon: 'image', text: 'Image', onTap: () => {}),
                    const Spacer(),
                    ContentUploadTile(
                        icon: 'document', text: 'Document', onTap: () => {}),
                  ],
                ),
                const SizedBox(height: 20),
                StyledButton(
                  text: 'Summarize All',
                  onTap: () => {},
                ),
                const SizedBox(height: 20),
              ]),
            ),
          )
        ],
      );

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
                StyledTabs(
                    leftTabText: 'Translate',
                    rightTabText: 'Summarize',
                    isLeftSelected: isTranslateSelected),
                const Divider(color: NexusColors.dividerColor, height: 30),
                Row(
                  children: [
                    ContentUploadTile(
                        icon: 'video',
                        text: 'Video',
                        onTap: () {
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) =>
                                  uploadBottomSheet() // Add actual content
                              );
                        }),
                    const Spacer(),
                    ContentUploadTile(
                        icon: 'audio', text: 'Audio', onTap: () => {}),
                    const Spacer(),
                    ContentUploadTile(
                        icon: 'image', text: 'Image', onTap: () => {}),
                    const Spacer(),
                    ContentUploadTile(
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
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => ChatScreen()));
                  },
                  icon: 'message-filled',
                ),
                const SizedBox(height: 20),
              ]),
            ),
          )
        ],
      );
}
