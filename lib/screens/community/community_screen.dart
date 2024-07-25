import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/community_bloc/bloc/community_bloc.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/widgets/bottom_sheets/comment_bottom_sheet.dart';
import 'package:nexus/screens/settings/settings_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/delete_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/image_slider_bottom_sheet.dart';
import 'package:nexus/widgets/popup_menu.dart';
import 'package:nexus/widgets/post_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

// ignore: must_be_immutable
class CommunityScreen extends StatefulWidget {
  CommunityScreen({super.key, required this.controller});

  ScrollController controller;
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late CommunityBloc communityBloc;

  @override
  void initState() {
    communityBloc = CommunityBloc();
    communityBloc.add(FetchPosts());
    super.initState();
  }

  @override
  void dispose() {
    communityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => communityBloc,
      child: Scaffold(
        backgroundColor: NexusColors.isDark
            ? const Color(0XFF0A0A0A)
            : NexusColors.accentColorLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              // COLOR: FIX
              backgroundColor: NexusColors.isDark
                  ? const Color(0XFF0A0A0A)
                  : NexusColors.accentColorLight,
              leadingWidth: 30,
              leading: SvgPicture.asset(
                'assets/icons/globe-filled.svg',
                // COLOR: FIX
                color: NexusColors.isDark
                    ? Colors.white
                    : NexusColors.primaryColor,
              ),
              title: StyledText(
                text: 'Community',
                fontSize: 24,
                color: NexusColors.textColor,
              ),
              actions: [
                StyledIconButton(
                  isBordered: true,
                  backgroundColor: NexusColors.isDark
                      ? const Color(0XFF0A0A0A)
                      : NexusColors.accentColor,
                  // COLOR: FIX
                  iconColor: NexusColors.isDark
                      ? Colors.white
                      : NexusColors.primaryColor,
                  // padding: 6,
                  height: 20,
                  icon: 'configure',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: widget.controller,
          child: Column(
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
                  // * GUIDES
                  child: ClipRRect(
                    borderRadius: const SmoothBorderRadius.all(
                      SmoothRadius(
                        // * Check this baad ma
                        cornerRadius: 10,
                        cornerSmoothing: 0.8,
                      ),
                    ),
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
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => createPostBottomSheet(
                                height: height,
                              ),
                            );
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: SmoothRectangleBorder(
                                side: BorderSide(
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
                                        ? Colors.white
                                        : NexusColors.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    'assets/icons/gallery-add.svg',
                                    color: NexusColors.isDark
                                        ? Colors.white
                                        : NexusColors.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              BlocBuilder<CommunityBloc, CommunityState>(
                builder: (context, state) {
                  Stream<List<PostModel>> posts =
                      (state as CommunityInitial).posts;

                  return StreamBuilder<List<PostModel>>(
                    stream: posts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No content available'),
                        );
                      }
                      List<PostModel> postList = snapshot.data!;

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: postList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 15),
                        itemBuilder: (BuildContext context, int index) {
                          PostModel postModel = postList[index];
                          return PostTile(
                            post: postModel,
                            userId: 'Bd4umkyLqOLnMpdOLZ0E',
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
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

  createPostBottomSheet({required double height}) => Wrap(
        children: [
          Container(
            height: height - 40,
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        color: NexusColors.borderColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/profile-picture.png',
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      StyledText(
                        text: 'Dunn Oliver',
                        fontSize: 16,
                        color: NexusColors.textColor,
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 10,
                            cornerSmoothing: .8,
                          ),
                          onTap: () {},
                          child: Ink(
                            decoration: ShapeDecoration(
                              color: NexusColors.accentColor,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 10,
                                  cornerSmoothing: .8,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/earth.svg',
                                    // COLOR: FIX
                                    color: NexusColors.isDark
                                        ? Colors.white
                                        : NexusColors.primaryColorLight,
                                  ),
                                  const SizedBox(width: 5),
                                  StyledText(
                                    text: "Public",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    // COLOR: FIX
                                    color: NexusColors.isDark
                                        ? Colors.white
                                        : NexusColors.primaryColorLight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      StyledIconButton(
                        icon: 'dots-circle',
                        padding: 0,
                        backgroundColor: NexusColors.backgroundColor,
                        iconColor: NexusColors.textColor,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  StyledTextfield(
                    hintText: 'Share your thoughts...',
                    controller: TextEditingController(),
                    maxlines: 5,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      StyledText(
                        text: 'Images',
                        color: NexusColors.textColor,
                      ),
                      const Spacer(),
                      StyledIconButton(
                        icon: 'add-circle',
                        padding: 0,
                        backgroundColor: NexusColors.backgroundColor,
                        iconColor: NexusColors.textColor,
                        onTap: () {},
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      viewportFraction: 1,
                    ),
                    items: [1, 2, 3, 4, 5].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: ClipSmoothRect(
                              radius: SmoothBorderRadius(
                                cornerRadius: 10,
                                cornerSmoothing: 0.8,
                              ),
                              child: Image.asset(
                                'assets/images/content.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  StyledButton(text: "Post now", onTap: () {}),
                  // ! Replace with bottom padding
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
}
