import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/screens/folder/folderScreen.dart';
import 'package:nexus/screens/home/widgets/contentTile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledIconTile.dart';
import 'package:nexus/widgets/styledTabs.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool isFolderSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final statusBarHeight = MediaQuery.of(context).padding.top;

    // Grid view count for products
    int gridCount() {
      if (screenWidth > 185) {
        return (screenWidth ~/ 175).toInt();
      }
      return 1;
    }

    void changeState() {
      setState(() {
        isFolderSelected = !isFolderSelected;
      });
    }

    return Scaffold(
        backgroundColor: NexusColors.accentColorLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: NexusColors.accentColorLight,
              leadingWidth: 30,
              leading: SvgPicture.asset(
                'assets/icons/library-filled.svg',
                color: NexusColors.primaryColorLight,
              ),
              title: StyledText(text: 'Library', fontSize: 24),
              actions: [
                StyledIconButton(icon: 'search', onTap: () {}),
              ],
            ),
          ),
        ),
        body: Container(
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
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                StyledTabs(
                    leftTabText: 'Folders',
                    rightTabText: 'Content',
                    isLeftSelected: isFolderSelected,
                    changeState: changeState),
                const Divider(
                  color: NexusColors.dividerColor,
                  height: 30,
                ),
                isFolderSelected
                    ? Expanded(
                        child: MasonryGridView.count(
                            padding: const EdgeInsets.all(0),
                            crossAxisCount: gridCount(),
                            crossAxisSpacing: 15, //
                            mainAxisSpacing: 15,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return StyledIconTile(
                                    icon: 'add-folder-filled',
                                    text: 'Create Folder',
                                    onTap: () => {});
                              }
                              return StyledIconTile(
                                  icon: 'folder-minus',
                                  text: 'School Work',
                                  isPrimary: false,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => FolderScreen(
                                                folderName: 'School Work')));
                                  });
                            }),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: 5, // Number of items
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                                height: 15); // Separator between items
                          },
                          itemBuilder: (BuildContext context, int index) {
                            // Build each item
                            return ContentTile(
                                title:
                                    'Learn how to make vids on YouTube from home',
                                image: 'content',
                                date: 'December 10, 2024',
                                icon: 'video',
                                onTap: () => {});
                          },
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
