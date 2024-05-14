import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/screens/folder/widgets/folder_bottom_sheet.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_text.dart';
import 'package:nexus/widgets/styled_button.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_textfield.dart';

// ignore: must_be_immutable
class FolderScreen extends StatefulWidget {
  FolderScreen({super.key, required this.folderName});

  String folderName;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => const FolderBottomSheet(),
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
                topLeft: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                topRight: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(children: [
            // StyledTextfield(
            //     icon: 'search',
            //     hintText: 'Search ${widget.folderName}...'),
            // const Divider(
            //   color: NexusColors.dividerColor,
            //   height: 30,
            // ),
            Expanded(
              child: ListView.separated(
                itemCount: 5, // Number of items
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 15); // Separator between items
                },
                itemBuilder: (BuildContext context, int index) {
                  // Build each item
                  return ContentTile(
                      title: 'Learn how to make vids on YouTube from home',
                      image: 'content',
                      date: 'December 10, 2024',
                      icon: 'video',
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => ContentScreen(
                                  image: 'content',
                                  title:
                                      'Learn how to make vids on YouTube from home',
                                  summary:
                                      "What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear, she didn't dare ask.",
                                ),
                              ),
                            ),
                          });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
