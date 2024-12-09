import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/post_bloc/bloc/post_bloc.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/comment_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/delete_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/image_slider_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/post_bottom_sheet.dart';
import 'package:nexus/widgets/popup_menu.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class PostTile extends StatefulWidget {
  PostTile({
    super.key,
    required this.post,
    required this.userId,
  });

  final PostModel post;
  final String userId;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late PostBloc postBloc;

  @override
  void initState() {
    postBloc = PostBloc(widget.post);
    super.initState();
  }

  @override
  void dispose() {
    postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isLiked = widget.post.likedBy!.contains(widget.userId);
    final isSaved = widget.post.savedBy!.contains(widget.userId);
    final isSelfPost = widget.post.userId! == widget.userId;

    return BlocProvider(
      create: (context) => postBloc,
      child: Container(
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
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    isSelfPost ? 10 : 15,
                    isSelfPost ? 7 : 20,
                    isSelfPost ? 5 : 15,
                  ),
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      final currentState = state as PostInitial;
                      final String userName = currentState.userName;
                      final String profilePicture = currentState.profilePicture;
                      print(userName);
                      print(profilePicture);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                              imageUrl: profilePicture,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(width: 10),
                          StyledText(
                            text: userName,
                            fontSize: 16,
                            color: NexusColors.textColor,
                          ),
                          const Spacer(),
                          StyledText(
                            text: DateTimeConversion.formattedDate(
                              datetime: widget.post.dateCreated!,
                            ),
                            fontSize: 12,
                            color: NexusColors.textColor.withOpacity(.5),
                            fontWeight: FontWeight.w500,
                          ),
                          isSelfPost
                              ? PopupMenu(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'Edit':
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) => PostBottomSheet(
                                            post: widget.post,
                                          ),
                                        );
                                        break;
                                      case 'Delete':
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) =>
                                              DeleteBottomSheet(
                                            title: 'Delete Post',
                                            message:
                                                'Are you certain you want to delete this post?',
                                            onDelete: () {
                                              postBloc.add(
                                                DeletePost(),
                                              );
                                              // Bottom sheet
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                        break;
                                      default:
                                    }
                                  },
                                  items: const [
                                    PopupItem(name: "Edit"),
                                    PopupItem(name: 'Delete')
                                  ],
                                  icon: "dots-circle",
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => ImageSliderBottomSheet(
                                  images: widget.post.images!,
                                ),
                              );
                            },
                            child: widget.post.images!.isNotEmpty
                                ? ClipSmoothRect(
                                    radius: SmoothBorderRadius(
                                      cornerRadius: 15,
                                      cornerSmoothing: .8,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.post.images?[0] ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                SizedBox(
                                          height: 100,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          widget.post.images!.length > 1
                              ? Positioned(
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
                                        text:
                                            '+${widget.post.images!.length - 1} More',
                                        color: NexusColors.primaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                      const SizedBox(height: 10),
                      StyledText(
                        text: widget.post.description ?? '',
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
                                cornerRadius: 15,
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
                                icon: isLiked ? 'heart-filled' : 'heart',
                                height: 26,
                                backgroundColor: NexusColors.accentColor,
                                // COLOR: FIX
                                iconColor: _postIconColor(isActive: isLiked),
                                onTap: () {
                                  // * USE HARDCORE USER ID FOR NOW!!
                                  if (isLiked) {
                                    postBloc.add(
                                      DislikePost(),
                                    );
                                  } else {
                                    postBloc.add(
                                      LikePost(),
                                    );
                                  }
                                },
                              ),
                              StyledText(
                                text: widget.post.permissions!.likeAllowed!
                                    ? '${widget.post.totalLikes}'
                                    : 'Like',
                                fontSize: 14,
                                color: _postIconColor(isActive: isLiked),
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(width: 5),
                              StyledIconButton(
                                icon: 'message',
                                height: 26,
                                backgroundColor: NexusColors.accentColor,
                                iconColor:
                                    NexusColors.textColor.withOpacity(.5),
                                onTap: () {
                                  if (widget
                                      .post.permissions!.commentAllowed!) {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                              child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: CommentBottomSheet(
                                          postId: widget.post.postId!,
                                          height: height,
                                          context: context,
                                        ),
                                      )),
                                    );
                                  } else {
                                    StyledSnackbar.show(
                                      context: context,
                                      message: "Comments disabled",
                                    );
                                  }
                                },
                              ),
                              StyledText(
                                text: widget.post.permissions!.commentAllowed!
                                    ? '${widget.post.totalComments}'
                                    : 'Comment',
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
                                text: widget.post.permissions!.shareAllowed!
                                    ? '${widget.post.totalShares}'
                                    : 'Share',
                                fontSize: 14,
                                color: NexusColors.textColor.withOpacity(.5),
                                fontWeight: FontWeight.w500,
                              ),
                              const Spacer(),
                              StyledIconButton(
                                icon: isSaved ? 'save-filled' : 'save',
                                backgroundColor: NexusColors.accentColor,
                                iconColor: _postIconColor(isActive: isSaved),
                                onTap: () {
                                  // ! USE HARDCORE USER ID FOR NOW!!
                                  if (isSaved) {
                                    postBloc.add(
                                      UnsavePost(),
                                    );
                                  } else {
                                    postBloc.add(
                                      SavePost(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  // COLOR: FIX
  Color _postIconColor({bool isActive = false}) {
    if (NexusColors.isDark && isActive) {
      return Colors.white;
    }
    return isActive ? NexusColors.primaryColor : NexusColors.secondaryTextColor;
  }
}
