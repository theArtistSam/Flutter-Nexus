import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/contentTile.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledTabs.dart';
import 'package:nexus/widgets/styledText.dart';

class ContentScreen extends StatelessWidget {
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

  content() {
    if (summary == null && translation == null) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: NexusColors.accentColorLight,
      body: SizedBox(
        // height: 410,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/$image.png',
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StyledIconButton(
                          icon: 'back-arrow',
                          onTap: () => Navigator.pop(context),
                          backgroundColor: Colors.black38,
                          padding: 15,
                        ),
                        const Spacer(),
                        StyledIconButton(
                          icon: 'pencil-filled',
                          onTap: () => {},
                          padding: 11.5,
                          backgroundColor: Colors.black38,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        StyledIconButton(
                          icon: 'setting-filled',
                          onTap: () => {},
                          backgroundColor: Colors.black38,
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
                      text: title,
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
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          controller: controller,
                          children: [
                            StyledTabs(
                                leftTabText: 'Translate',
                                rightTabText: 'Summarize',
                                isLeftSelected: false),
                            const Divider(
                              height: 30,
                            ),
                            Column(
                              children: [
                                // StyledText(
                                //     fontSize: 18,
                                //     text:
                                //         "What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear. What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear, she didn't dare ask."),
                                StyledText(
                                  fontSize: 18,
                                  text: summary ?? '',
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
      // bottomSheet: DraggableScrollableSheet(
      //     initialChildSize: 0.45,
      //     minChildSize: 0.37,
      //     maxChildSize: .5,
      //     builder: (context, controller) => Container(
      //           child: ListView(
      //             controller: controller,
      //           ),
      //         )),
    );
  }
}
