import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/screens/settings/settings_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_text.dart';

// ignore: must_be_immutable
class CommunityScreen extends StatefulWidget {
  CommunityScreen({super.key, required this.controller});

  ScrollController controller;
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: NexusColors.isDark
          ? const Color(0XFF0A0A0A)
          : NexusColors.accentColorLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: NexusColors.isDark
                ? const Color(0XFF0A0A0A)
                : NexusColors.accentColorLight,
            leadingWidth: 30,
            leading: SvgPicture.asset(
              'assets/icons/community-filled.svg',
              color: NexusColors.primaryColor,
            ),
            title: StyledText(
              text: 'Community',
              fontSize: 24,
              color: NexusColors.textColor,
            ),
            actions: [
              StyledIconButton(
                icon: 'menu',
                backgroundColor: NexusColors.primaryColor,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        controller: widget.controller,
        children: [
          Container(
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(
                    cornerRadius: 35,
                    cornerSmoothing: 0.8,
                  ),
                  topRight: SmoothRadius(
                    cornerRadius: 35,
                    cornerSmoothing: 0.8,
                  ),
                  bottomLeft: SmoothRadius(
                    cornerRadius: 0,
                    cornerSmoothing: 0.8,
                  ),
                  bottomRight: SmoothRadius(
                    cornerRadius: 0,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              // !GUIDES
              child: SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return guideTileCommunity(
                      image: 'guide',
                      title: 'Community',
                      isNew: index == 0 ? true : false,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            color: NexusColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/profile-picture.png',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: NexusColors.borderColor,
                          ),
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 15,
                            cornerSmoothing: .8,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            StyledText(
                              text: 'Share your thoughts ...',
                              // COLOR: FIX
                              color: NexusColors.isDark
                                  ? Colors.white54
                                  : NexusColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              'assets/icons/gallery-add.svg',
                              color: NexusColors.isDark
                                  ? Colors.white54
                                  : NexusColors.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 15),
              itemBuilder: (BuildContext context, int index) {
                return post();
              },
            ),
          )
        ],
      ),
    );
  }
}

guideTileCommunity({
  required String image,
  required String title,
  required bool isNew,
}) =>
    Opacity(
      opacity: isNew ? 1 : 0.5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 15, cornerSmoothing: 0.8),
            ),
            child: Image.asset(
              'assets/images/$image.png',
              width: 125,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          // TODO: IF NEW
          isNew
              ? Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    decoration: const ShapeDecoration(
                      color: Colors.white70,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 5,
                            cornerSmoothing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/dot.svg'),
                          const SizedBox(width: 5),
                          StyledText(
                            text: 'New',
                            color: NexusColors.primaryColor,
                            fontSize: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            bottom: 0,
            child: Container(
              width: 125,
              height: 40,
              decoration: const ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0),
                    Color.fromRGBO(0, 0, 0, 0.7),
                  ],
                ),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.only(
                    bottomLeft: SmoothRadius(
                      cornerRadius: 15,
                      cornerSmoothing: 0.8,
                    ),
                    bottomRight: SmoothRadius(
                      cornerRadius: 15,
                      cornerSmoothing: 0.8,
                    ),
                  ),
                ),
              ),
              child: Center(
                child: StyledText(
                  text: title,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );

post() => Container(
      color: NexusColors.backgroundColor,
      child: Container(
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            side: BorderSide(
              width: 1,
              color: NexusColors.backgroundColor,
            ),
            borderRadius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: .8,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/profile-picture.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyledText(
                            text: 'Dunn Oliver',
                            fontSize: 16,
                            color: NexusColors.textColor,
                          ),
                          StyledText(
                            text: 'December 14, 2024',
                            fontSize: 12,
                            color: NexusColors.textColor.withOpacity(.5),
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                      const Spacer(),
                      StyledIconButton(
                        icon: 'dots-circle',
                        backgroundColor: NexusColors.backgroundColor,
                        iconColor: NexusColors.textColor,
                        padding: 0,
                        height: 28,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 10,
                            cornerSmoothing: 0.8,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/content.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          decoration: const ShapeDecoration(
                            color: Colors.white70,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.all(
                                SmoothRadius(
                                  cornerRadius: 5,
                                  cornerSmoothing: 0.8,
                                ),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: StyledText(
                              text: '+5 More',
                              color: NexusColors.primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  StyledText(
                    text:
                        "This app is amazing, i was even able to generate summary from my handwriting. that's pretty much cool tho!",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: NexusColors.textColor,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: ShapeDecoration(
                      color: NexusColors.accentColor,
                      shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 10,
                            cornerSmoothing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 5,
                        bottom: 10,
                        right: 5,
                      ),
                      child: Row(
                        children: [
                          StyledIconButton(
                            icon: 'heart-filled',
                            height: 26,
                            backgroundColor: NexusColors.accentColor,
                            // COLOR: FIX
                            iconColor: NexusColors.isDark
                                ? Colors.white
                                : NexusColors.primaryColor.withOpacity(
                                    1,
                                  ),
                            onTap: () {},
                          ),
                          StyledText(
                            text: '12K',
                            fontSize: 14,
                            color: NexusColors.isDark
                                ? Colors.white
                                : NexusColors.primaryColor.withOpacity(
                                    1,
                                  ),
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 5),
                          StyledIconButton(
                            icon: 'message',
                            height: 26,
                            backgroundColor: NexusColors.accentColor,
                            iconColor: NexusColors.textColor.withOpacity(.5),
                            onTap: () {},
                          ),
                          StyledText(
                            text: '23',
                            fontSize: 14,
                            color: NexusColors.textColor.withOpacity(.5),
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 5),
                          StyledIconButton(
                            icon: 'share',
                            height: 26,
                            backgroundColor: NexusColors.accentColor,
                            iconColor: NexusColors.textColor.withOpacity(
                              .5,
                            ),
                            onTap: () {},
                          ),
                          StyledText(
                            text: '34',
                            fontSize: 14,
                            color: NexusColors.textColor.withOpacity(.5),
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          StyledIconButton(
                            icon: 'save',
                            backgroundColor: NexusColors.accentColor,
                            iconColor: NexusColors.textColor.withOpacity(
                              .5,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: NexusColors.dividerColor,
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      StyledText(
                        text: 'Comments',
                        color: NexusColors.textColor,
                        fontSize: 20,
                      ),
                      const Spacer(),
                      StyledIconButton(
                        icon: 'add-circle',
                        padding: 0,
                        height: 28,
                        onTap: () {},
                        iconColor: NexusColors.textColor,
                        backgroundColor: NexusColors.backgroundColor,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      color: NexusColors.accentColor,
                      shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 10,
                            cornerSmoothing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/profile-picture.png',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              StyledText(
                                text: 'Dunn Oliver',
                                fontSize: 16,
                                color: NexusColors.textColor,
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          StyledText(
                            text:
                                'I love the feel of wood curls flying off the lathe as I begin to shape the log in front of me.',
                            fontSize: 14,
                            color: NexusColors.textColor,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
