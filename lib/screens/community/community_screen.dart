import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/community_bloc/bloc/community_bloc.dart';
import 'package:nexus/models/guide_model.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/repositories/local_storage_repository.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/guide_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/post_bottom_sheet.dart';
import 'package:nexus/widgets/post_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

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
    communityBloc.add(FetchGuides());
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
                  onTap: () {
                    // Show snackbar
                    StyledSnackbar.show(context: context, message: 'MESSAGE');
                  },
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
                      child: BlocBuilder<CommunityBloc, CommunityState>(
                        builder: (context, state) {
                          Stream<List<GuideModel>> guides =
                              (state as CommunityInitial).guides;

                          return StreamBuilder<List<GuideModel>>(
                            stream: guides,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text('No guide available'),
                                );
                              }
                              List<GuideModel> guideList = snapshot.data!;

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: guideList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(width: 10),
                                itemBuilder: (BuildContext context, int index) {
                                  GuideModel guide = guideList[index];
                                  return guideTileCommunity(
                                    image: guide.thumbnail!,
                                    title: guide.title!,
                                    isNew: guide.viewedBy!
                                        .contains('Bd4umkyLqOLnMpdOLZ0E'),
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => GuideBottomSheet(
                                          key: UniqueKey(),
                                          guide: guide,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                              builder: (context) => const PostBottomSheet(),
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
              const SizedBox(height: 10),
              BlocBuilder<CommunityBloc, CommunityState>(
                builder: (context, state) {
                  final currentState = state as CommunityInitial;
                  Stream<List<PostModel>> posts = currentState.posts;

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
                            const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          PostModel postModel = postList[index];
                          final userId = LocalStorageRepository().getUserId()!;

                          // TODO: Find a better way to fix the post id null
                          return postModel.postId == null
                              ? SizedBox()
                              : PostTile(
                                  post: postModel,
                                  userId: userId,
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
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: isNew ? 1 : 0.5,
          child: Stack(
            children: [
              ClipSmoothRect(
                radius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  width: 125,
                  height: 150,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  // width: double.maxFinite,
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
        ),
      );
}
