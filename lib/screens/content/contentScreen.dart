import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/contentTile.dart';
import 'package:nexus/widgets/styledButton.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledTabs.dart';
import 'package:nexus/widgets/styledText.dart';
import 'package:nexus/widgets/styledTextfield.dart';

class ContentScreen extends StatefulWidget {
  ContentScreen(
      {super.key,
      required this.image,
      required this.title,
      this.folder,
      this.summary,
      this.translation});

  String image;
  String title;
  String? summary;
  String? translation;
  String? folder;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  String dropdownValue = "School Work";

  List<String> dropDownItems = ["ABC", "DEF", "GHI", "JKL"];

  @override
  Widget build(BuildContext context) {
    final appbarHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: NexusColors.accentColorLight,
      body: SizedBox(
        // height: 410,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/${widget.image}.png',
              fit: BoxFit.cover,
              width: double.infinity,
              // height: double.infinity,
              height: 410,
            ),
            Positioned(
                child: Container(
              height: 410,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.3), // Start color (0% black)
                    Colors.black.withOpacity(0.5), // End color (90% black)
                  ],
                ),
                // borderRadius: BorderRadius.circular(15),
              ),
            )),
            // Appbar
            SizedBox(
              height: 410,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: appbarHeight,
                    ),
                    Row(
                      children: [
                        StyledIconButton(
                          icon: 'back-arrow',
                          onTap: () => Navigator.pop(context),
                          backgroundColor: Colors.black26,
                          padding: 15,
                        ),
                        const Spacer(),
                        StyledIconButton(
                          icon: 'pencil-filled',
                          onTap: () => {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) =>
                                    contentEditBottomSheet() // Add actual content
                                )
                          },
                          padding: 11.5,
                          backgroundColor: Colors.black26,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        StyledIconButton(
                          icon: 'setting-filled',
                          onTap: () => {},
                          backgroundColor: Colors.black26,
                        )
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/play.svg',
                        height: 45,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    StyledText(
                      text: widget.title,
                      color: NexusColors.textColorLight,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: (screenHeight - 410 + 40) / screenHeight,
                minChildSize: (screenHeight - 410 + 40) / screenHeight,
                maxChildSize: .9,
                builder: (context, controller) => Container(
                      decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.only(
                                  topLeft: SmoothRadius(
                                      cornerRadius: 25, cornerSmoothing: .8),
                                  topRight: SmoothRadius(
                                      cornerRadius: 25, cornerSmoothing: .8)))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          controller: controller,
                          children: [
                            Center(
                              child: Container(
                                width: 60,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: NexusColors.borderColor),
                              ),
                            ),
                            const SizedBox(height: 15),
                            StyledTabs(
                                leftTabText: 'Translate',
                                rightTabText: 'Summarize',
                                isLeftSelected: false),
                            const Divider(
                              height: 30,
                              color: NexusColors.dividerColor,
                            ),
                            Column(
                              children: [
                                // StyledText(
                                //     fontSize: 18,
                                //     text:
                                //         "What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear, she didn't dare ask."),
                                Container(
                                  decoration: ShapeDecoration(
                                      color: NexusColors.accentColorLight,
                                      shape: SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius(
                                              cornerRadius: 15,
                                              cornerSmoothing: 0.8))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: StyledText(
                                      fontSize: 18,
                                      text: widget.summary ?? '',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    StyledIconButton(
                                      icon: 'rotate-left',
                                      onTap: () {},
                                      backgroundColor:
                                          NexusColors.accentColorLight,
                                      iconColor: NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledIconButton(
                                      icon: 'arrow-down',
                                      onTap: () {},
                                      backgroundColor:
                                          NexusColors.accentColorLight,
                                      iconColor: NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledIconButton(
                                      icon: 'share',
                                      onTap: () {},
                                      backgroundColor:
                                          NexusColors.accentColorLight,
                                      iconColor: NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledIconButton(
                                      icon: 'pencil',
                                      onTap: () {},
                                      backgroundColor:
                                          NexusColors.accentColorLight,
                                      iconColor: NexusColors.primaryColorLight,
                                    ),
                                    const Spacer(),
                                    StyledIconButton(
                                      icon: 'like-filled',
                                      onTap: () {},
                                      backgroundColor:
                                          NexusColors.accentColorLight,
                                      iconColor: NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledIconButton(
                                      icon: 'dislike',
                                      onTap: () {},
                                      backgroundColor:
                                          NexusColors.accentColorLight,
                                      iconColor: NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  contentEditBottomSheet() => SingleChildScrollView(
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
                        topLeft: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 0.8),
                        topRight: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 0.8)),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: NexusColors.borderColor),
                        ),
                        const SizedBox(height: 15),
                        StyledTabs(
                            leftTabText: 'Details',
                            rightTabText: 'Tags',
                            isLeftSelected: false),
                        const Divider(
                          color: NexusColors.dividerColor,
                          height: 30,
                        ),
                        Stack(
                          children: [
                            ClipRRect(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 15, cornerSmoothing: 0.8),
                                child: Image.asset('assets/images/content.png',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover)),
                            Positioned.fill(
                                child: Container(
                              // height: 410,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(
                                        .1), // Start color (0% black)
                                    Colors.black.withOpacity(
                                        0.5), // End color (90% black)
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/pencil-filled.svg',
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledText(
                                      text: 'Change Thumbnail',
                                      fontWeight: FontWeight.w500,
                                      color: NexusColors.textColorLight,
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/video.svg',
                                color: NexusColors.primaryColorLight),
                            const SizedBox(
                              width: 5,
                            ),
                            StyledText(text: 'Video Title', fontSize: 18),
                          ],
                        ),
                        const SizedBox(height: 10),
                        StyledTextfield(
                          icon: null,
                          hintText: 'Add video title...',
                          controller: TextEditingController(),
                          maxlines: 5,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/folder-filled.svg',
                                color: NexusColors.primaryColorLight),
                            const SizedBox(
                              width: 5,
                            ),
                            StyledText(text: 'Select Folder', fontSize: 18),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: ShapeDecoration(
                              // color: Colors.amber,
                              shape: SmoothRectangleBorder(
                                  side: const BorderSide(
                                      width: 2, color: NexusColors.borderColor),
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 15, cornerSmoothing: 0.8))),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 15, cornerSmoothing: 0.8),
                                icon: SvgPicture.asset(
                                  'assets/icons/small-arrow-down.svg',
                                  color: NexusColors.primaryColorLight,
                                ),
                                // value: dropdownValue,
                                items: <String>['A', 'B', 'C', 'D']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: StyledText(
                                      text: value,
                                      color: NexusColors.primaryColorLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 50,
                          color: NexusColors.dividerColor,
                        ),
                        StyledButton(
                            text: 'Delete Video',
                            onTap: () {},
                            isDeleteable: true),
                        const SizedBox(
                          height: 15,
                        ),
                        StyledButton(text: 'Confirm Changes', onTap: () {}),
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      );
}
