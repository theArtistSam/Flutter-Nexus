import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/post_bottom_sheet_bloc/bloc/post_bottom_sheet_bloc.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class PostBottomSheet extends StatefulWidget {
  const PostBottomSheet({super.key, this.post});

  final PostModel? post;
  @override
  State<PostBottomSheet> createState() => _PostBottomSheetState();
}

class _PostBottomSheetState extends State<PostBottomSheet> {
  late PostBottomSheetBloc postBottomSheetBloc;
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    postBottomSheetBloc = PostBottomSheetBloc(post: widget.post);
    super.initState();
  }

  @override
  void dispose() {
    postBottomSheetBloc.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => postBottomSheetBloc,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Container(
                height: height - 50,
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
                child: BlocBuilder<PostBottomSheetBloc, PostBottomSheetState>(
                  builder: (context, state) {
                    final currentState = (state as PostBottomSheetInitial);
                    final PostModel post = currentState.post!;

                    // Post useful properties
                    final bool isPrivate = post.permissions!.isPrivate!;
                    final bool commentAllowed =
                        post.permissions!.commentAllowed!;
                    final bool likeAllowed = post.permissions!.likeAllowed!;
                    final bool shareAllowed = post.permissions!.shareAllowed!;

                    final List<dynamic> images = currentState.images;

                    // *Set the description
                    controller.text = post.description!;

                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 60,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
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
                                  onTap: () {
                                    postBottomSheetBloc.add(
                                      ChangeVisibility(
                                        visibility: !isPrivate,
                                      ),
                                    );
                                  },
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
                                            'assets/icons/${isPrivate ? 'lock' : 'earth'}.svg',
                                            // COLOR: FIX
                                            color: NexusColors.isDark
                                                ? Colors.white
                                                : NexusColors.primaryColorLight,
                                          ),
                                          const SizedBox(width: 5),
                                          StyledText(
                                            text: isPrivate
                                                ? "Private"
                                                : "Public",
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
                            ],
                          ),
                          const SizedBox(height: 15),
                          StyledTextfield(
                            hintText: 'Share your thoughts...',
                            controller: controller,
                            maxlines: 5,
                            onChanged: (val) => {post.description = val},
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              StyledText(
                                text: 'Add Images',
                                color: NexusColors.textColor,
                              ),
                              const Spacer(),
                              StyledIconButton(
                                icon: 'add-circle',
                                padding: 0,
                                backgroundColor: NexusColors.backgroundColor,
                                iconColor: NexusColors.textColor,
                                onTap: () async {
                                  // Use image picker to pick the image from gallery
                                  final XFile? image =
                                      await ImageSelector.pickImage();

                                  // Ensure the image is not null before proceeding
                                  if (image == null) {
                                    if (context.mounted) {
                                      StyledSnackbar.show(
                                        context: context,
                                        message: 'Image not picked',
                                      );
                                    }
                                    return;
                                  }

                                  // Check if the image has already been picked
                                  bool alreadyPicked =
                                      images.any((pickedImage) {
                                    if (pickedImage is XFile) {
                                      return pickedImage.path == image.path;
                                    }
                                    return false; // Handle other types accordingly
                                  });

                                  bool checkLength = images.length < 5;

                                  if (alreadyPicked) {
                                    if (context.mounted) {
                                      StyledSnackbar.show(
                                        context: context,
                                        message: 'Image already picked',
                                      );
                                    }
                                  } else if (!checkLength) {
                                    if (context.mounted) {
                                      StyledSnackbar.show(
                                        context: context,
                                        message:
                                            'Cannot pick more than 5 images',
                                      );
                                    }
                                  } else {
                                    postBottomSheetBloc.add(
                                      AddImage(file: image),
                                    );
                                    StyledSnackbar.show(
                                      context: context,
                                      message: "Image Added",
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          images.isEmpty
                              ? Container(
                                  height: 200,
                                  decoration: ShapeDecoration(
                                    color: NexusColors.accentColor,
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 15,
                                        cornerSmoothing: .8,
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: StyledText(
                                      text: 'No image',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : imageSlider(
                                  list: images,
                                ),
                          const SizedBox(
                            height: 15,
                          ),
                          StyledText(
                            text: 'Permissions',
                            color: NexusColors.textColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          allowTile(
                            isAllowed: likeAllowed,
                            text: 'Allow Likes',
                            onTap: () {
                              postBottomSheetBloc.add(
                                AllowLikes(
                                  allowLikes: !likeAllowed,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          allowTile(
                            isAllowed: shareAllowed,
                            text: 'Allow Shares',
                            onTap: () {
                              postBottomSheetBloc.add(
                                AllowShares(
                                  allowShares: !shareAllowed,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          allowTile(
                            isAllowed: commentAllowed,
                            text: 'Allow Comments',
                            onTap: () {
                              postBottomSheetBloc.add(
                                AllowComments(
                                  allowComments: !commentAllowed,
                                ),
                              );
                            },
                          ),
                          const Spacer(),
                          Divider(
                            height: 20,
                            color: NexusColors.borderColor,
                          ),
                          StyledButton(
                            text: widget.post == null
                                ? "Post now"
                                : "Update Post",
                            onTap: () {
                              String text = controller.text.trim();
                              if (text.isNotEmpty) {
                                if (widget.post == null) {
                                  // event to add a new post
                                  postBottomSheetBloc.add(
                                    AddPost(text: text),
                                  );

                                  //  TODO: use bloc listner and enum
                                  //  to wait for the post to be added
                                  //  then use pop out of the screen
                                  StyledSnackbar.show(
                                    context: context,
                                    message: "Post added",
                                  );
                                } else {
                                  // event to update the post

                                  postBottomSheetBloc.add(
                                    UpdatePost(text: text),
                                  );
                                  StyledSnackbar.show(
                                    context: context,
                                    message: "Post updated",
                                  );
                                }
                              }
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget allowTile({
    required bool isAllowed,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: NexusColors.accentColor,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: .8,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 8, 8, 8),
        child: Row(
          children: [
            StyledText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            StyledIconButton(
              icon: isAllowed ? 'tick-circle' : 'empty-circle',
              onTap: onTap,
              backgroundColor: NexusColors.accentColor,
              iconColor: isAllowed
                  ? NexusColors.textColor
                  : NexusColors.secondaryTextColor,
            )
          ],
        ),
      ),
    );
  }

  Widget getImage({required dynamic image}) {
    if (image is XFile) {
      // It's an XFile, so use File widget
      return Image.file(
        File(image.path),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      width: double.infinity,
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: CircularProgressIndicator(
          value: progress.progress,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget imageSlider({
    required List<dynamic> list,
  }) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        viewportFraction: 1,
        enableInfiniteScroll: false,
      ),
      items: List.generate(list.length, (index) {
        final image = list[index];
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              child: Stack(
                children: [
                  ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 15,
                      cornerSmoothing: 0.8,
                    ),
                    child: getImage(image: image),
                  ),
                  Center(
                    child: StyledIconButton(
                      iconColor: Colors.white,
                      backgroundColor: Colors.black45,
                      icon: 'trash',
                      onTap: () {
                        postBottomSheetBloc.add(
                          RemoveImage(index: index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
