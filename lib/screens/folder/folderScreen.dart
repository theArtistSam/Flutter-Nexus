import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens/home/widgets/contentTile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';
import 'package:nexus/widgets/styledButton.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledTextfield.dart';

// ignore: must_be_immutable
class FolderScreen extends StatefulWidget {
  FolderScreen({super.key, required this.folderName});

  String folderName;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  int selectedIndex = 0;

  void setSelectedIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int gridCount() {
      if (screenWidth > 70) {
        return (screenWidth ~/ 65).toInt();
      }
      return 1;
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
              leading: Transform.scale(
                scale: 1,
                child: StyledIconButton(
                    icon: 'back-arrow',
                    backgroundColor: NexusColors.accentColorLight,
                    iconColor: NexusColors.primaryColorLight,
                    onTap: () => Navigator.pop(context)),
              ),
              title: StyledText(text: widget.folderName, fontSize: 24),
              actions: [
                StyledIconButton(
                    icon: 'menu',
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => folderBottomSheet(gridCount),
                      );
                    }),
              ],
            ),
          ),
        ),
        body: Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                    topRight:
                        SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8)),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(children: [
                  StyledTextfield(
                      icon: 'search',
                      hintText: 'Search ${widget.folderName}...'),
                  const Divider(
                    color: NexusColors.dividerColor,
                    height: 30,
                  ),
                  Expanded(
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
                ]))));
  }

  Widget folderBottomSheet(gridCount) {
    const List icons = [
      'folder-minus',
      'double-folder',
      'heart-folder',
      'favorite-chart',
      'notification-status',
      'brush-square',
      'gallery',
      'audio-square',
      'video-square',
      'calendar',
      'code',
      'key-square',
    ];

    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(children: [
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: NexusColors.borderColor),
                  ),
                  const SizedBox(height: 15),
                  StyledTextfield(
                      icon: 'folder-minus', hintText: 'New Folder name'),
                  const SizedBox(height: 15),
                  MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      crossAxisCount: gridCount(),
                      crossAxisSpacing: 15, //
                      mainAxisSpacing: 15,
                      itemCount: icons.length,
                      itemBuilder: (context, index) {
                        return StyledIconButton(
                            icon: icons[index],
                            iconColor: index == selectedIndex
                                ? Colors.white
                                : NexusColors.primaryColorLight,
                            backgroundColor: index == selectedIndex
                                ? NexusColors.primaryColorLight
                                : NexusColors.accentColorLight,
                            onTap: () => setSelectedIndex(index));
                      }),
                  const Divider(
                    color: NexusColors.dividerColor,
                    height: 30,
                  ),
                  StyledButton(
                      text: 'Delete Folder',
                      isDeleteable: true,
                      onTap: () => {}),
                  const SizedBox(height: 20),
                  StyledButton(text: 'Confirm Changes', onTap: () => {}),
                  const SizedBox(height: 20),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
