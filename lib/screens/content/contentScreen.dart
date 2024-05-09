import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/screens/content/widgets/contentConfigureTabs.dart';
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
  bool isOriginalDisplayed = false;
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
                          onTap: () => {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) =>
                                    contentConfigureBottomSheet() // Add actual content
                                )
                          },
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

                    // contentTyle: isAudio
                    // Container(
                    //   decoration: ShapeDecoration(
                    //       color: Colors.black26,
                    //       shape: SmoothRectangleBorder(
                    //           borderRadius: SmoothBorderRadius(
                    //               cornerRadius: 15, cornerSmoothing: .8))),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(2),
                    //     child: Slider(
                    //       thumbColor: Colors.white,
                    //       activeColor: Colors.white,
                    //       inactiveColor: Colors.white54,
                    //       min: 0,
                    //       max: 100,
                    //       value: 50,
                    //       onChanged: (value) {
                    //         // setState(() {
                    //         //   _value = value;
                    //         // });
                    //       },
                    //     ),
                    //   ),
                    // ),

                    // contentType: isImage
                    // contentIconButton('View complete image', 'maximize', () {}),

                    // contentType: isDocument
                    // contentIconButton(
                    //     'View complete document', 'sticky-note', () {}),

                    const SizedBox(
                      height: 10,
                    ),
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
                maxChildSize: .95,
                builder: (context, controller) =>
                    contentBottomSheet(controller))
          ],
        ),
      ),
    );
  }

  contentIconButton(title, icon, onTap) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: SmoothBorderRadius(cornerRadius: 15),
          onTap: onTap,
          child: Ink(
              decoration: ShapeDecoration(
                  color: Colors.black26,
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 15, cornerSmoothing: .8))),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    StyledText(
                      text: title,
                      color: NexusColors.textColorLight,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      'assets/icons/$icon.svg',
                      color: Colors.white,
                    )
                  ],
                ),
              )),
        ),
      );

  contentTile({isOpen, openTitle, closeTitle, text, onTap}) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: .8),
          onTap: onTap,
          child: Ink(
            decoration: ShapeDecoration(
                color: NexusColors.accentColorLight,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 0.8))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StyledText(
                        fontSize: 14,
                        text: isOpen ? openTitle : closeTitle,
                        color: NexusColors.primaryColorLight,
                      ),
                      const Spacer(),
                      !isOpen
                          ? SvgPicture.asset(
                              'assets/icons/small-arrow-down.svg',
                              color: NexusColors.primaryColorLight,
                            )
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(height: isOpen ? 10 : 0),
                  isOpen
                      ? StyledText(
                          fontSize: 18,
                          text: text,
                          fontWeight: FontWeight.w500,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      );

  contentBottomSheet(controller) => Container(
        decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 25, cornerSmoothing: .8),
                    topRight:
                        SmoothRadius(cornerRadius: 25, cornerSmoothing: .8)))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(0, 105, 0, 0),
                controller: controller,
                children: [
                  Column(
                    children: [
                      // StyledText(
                      //     fontSize: 18,
                      //     text:
                      //         "What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear, she didn't dare ask."),
                      //  Content Tile here
                      contentTile(
                          onTap: () {
                            setState(() {
                              isOriginalDisplayed = true;
                            });
                          },
                          isOpen: isOriginalDisplayed ? true : false,
                          openTitle: 'Original',
                          closeTitle: 'View original text',
                          text: 'This is the original text'),
                      const SizedBox(
                        height: 10,
                      ),
                      contentTile(
                          onTap: () {
                            setState(() {
                              isOriginalDisplayed = false;
                            });
                          },
                          isOpen: isOriginalDisplayed ? false : true,
                          openTitle: 'Summary',
                          closeTitle: 'View summary',
                          text: widget.summary! + widget.summary!),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          StyledIconButton(
                            icon: 'rotate-left',
                            onTap: () {},
                            backgroundColor: NexusColors.accentColorLight,
                            iconColor: NexusColors.primaryColorLight,
                          ),
                          const SizedBox(width: 5),
                          StyledIconButton(
                            icon: 'arrow-down',
                            onTap: () {},
                            backgroundColor: NexusColors.accentColorLight,
                            iconColor: NexusColors.primaryColorLight,
                          ),
                          const SizedBox(width: 5),
                          StyledIconButton(
                            icon: 'share',
                            onTap: () {},
                            backgroundColor: NexusColors.accentColorLight,
                            iconColor: NexusColors.primaryColorLight,
                          ),
                          const SizedBox(width: 5),
                          StyledIconButton(
                            icon: 'pencil',
                            onTap: () {},
                            backgroundColor: NexusColors.accentColorLight,
                            iconColor: NexusColors.primaryColorLight,
                          ),
                          const Spacer(),
                          StyledIconButton(
                            icon: 'like-filled',
                            onTap: () {},
                            backgroundColor: NexusColors.accentColorLight,
                            iconColor: NexusColors.primaryColorLight,
                          ),
                          const SizedBox(width: 5),
                          StyledIconButton(
                            icon: 'dislike',
                            onTap: () {},
                            backgroundColor: NexusColors.accentColorLight,
                            iconColor: NexusColors.primaryColorLight,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  )
                ],
              ),
              // been put at the end to act as a sticky header
              Container(
                height: 105,
                color: Colors.white,
                child: Column(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );

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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        StyledText(text: 'Video Title', fontSize: 18),
                        const SizedBox(height: 10),
                        StyledTextfield(
                          icon: null,
                          hintText: 'Add video title...',
                          controller: TextEditingController(),
                          maxlines: 5,
                        ),
                        const SizedBox(height: 20),
                        StyledText(text: 'Select Folder', fontSize: 18),
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

  contentConfigureBottomSheet() => Wrap(
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 15, cornerSmoothing: .8),
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SvgPicture.asset(
                            'assets/icons/small-arrow-down.svg',
                            color: Colors.black,
                          ),
                        ),
                        // value: dropdownValue,
                        hint: StyledText(text: 'Summarization Length'),
                        items: <String>['Standard Length', 'Custom Length']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: StyledText(
                              text: value,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // setState(() {
                          //   dropdownValue = newValue!;
                          // });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ContentConfigureTabs(
                      tabsText: const ['Small', 'Medium', 'Large'],
                      index: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StyledText(text: 'Summarization Style'),
                    const SizedBox(
                      height: 10,
                    ),
                    ContentConfigureTabs(
                        tabsText: const ['Creative', 'Balanaced', 'Precise'],
                        index: 1),
                    const Divider(
                      height: 50,
                      color: NexusColors.dividerColor,
                    ),
                    StyledButton(text: 'Confirm changes', onTap: () {}),
                    const SizedBox(height: 20),
                  ]),
            ),
          )
        ],
      );
}
