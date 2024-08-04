import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/post_bottom_sheet_bloc/bloc/post_bottom_sheet_bloc.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/delete_bottom_sheet.dart';
import 'package:nexus/widgets/popup_menu.dart';
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
    postBottomSheetBloc = PostBottomSheetBloc();
    postBottomSheetBloc.add(FetchPost(post: widget.post));
    controller.text = widget.post?.description ?? '';
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
      child: Wrap(
        children: [
          SingleChildScrollView(
            child: Container(
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
              child: BlocBuilder<PostBottomSheetBloc, PostBottomSheetState>(
                builder: (context, state) {
                  final currentState = (state as PostBottomSheetInitial);
                  final bool isPrivate =
                      currentState.post?.permissions!.isPrivate! ?? false;
                  final bool commentAllowed =
                      currentState.post?.permissions!.commentAllowed! ?? true;
                  final bool likeAllowed =
                      currentState.post?.permissions!.likeAllowed! ?? true;
                  final bool shareAllowed =
                      currentState.post?.permissions!.shareAllowed! ?? true;
                  final List<XFile> newImages = currentState.images;
                  final List<String>? images = currentState.post?.images;
                  final bool showImages = currentState.showImages;
                  final bool isImagesAvailable =
                      images != null && showImages && images.isNotEmpty;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
                          child: Row(
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
                              PopupMenu(
                                onSelected: (value) {
                                  switch (value) {
                                    case 'Comments':
                                      postBottomSheetBloc.add(
                                        AllowComments(
                                          allowComments: !commentAllowed,
                                        ),
                                      );
                                      break;
                                    case 'Likes':
                                      postBottomSheetBloc.add(
                                        AllowLikes(
                                          allowLikes: !likeAllowed,
                                        ),
                                      );
                                      break;
                                    case 'Shares':
                                      postBottomSheetBloc.add(
                                        AllowShares(
                                          allowShares: !shareAllowed,
                                        ),
                                      );
                                      break;
                                    default:
                                  }
                                },
                                items: [
                                  PopupItem(
                                    name: 'Comments',
                                    value: commentAllowed,
                                  ),
                                  PopupItem(
                                    name: 'Likes',
                                    value: likeAllowed,
                                  ),
                                  PopupItem(
                                    name: 'Shares',
                                    value: shareAllowed,
                                  ),
                                ],
                                icon: 'dots-circle',
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                StyledTextfield(
                                  hintText: 'Share your thoughts...',
                                  controller: controller,
                                  maxlines: 5,
                                ),
                                const SizedBox(height: 15),
                                widget.post != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          children: [
                                            StyledText(
                                              text: 'Images',
                                              fontSize: 16,
                                              color: NexusColors.textColor,
                                            ),
                                            const Spacer(),
                                            StyledIconButton(
                                              icon: showImages
                                                  ? 'arrow-circle-up'
                                                  : 'arrow-circle-down',
                                              iconColor: NexusColors.textColor,
                                              backgroundColor:
                                                  NexusColors.backgroundColor,
                                              onTap: () {
                                                postBottomSheetBloc.add(
                                                  ViewImages(
                                                    showImages: !showImages,
                                                  ),
                                                );
                                              },
                                              padding: 0,
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                isImagesAvailable
                                    ? imageSlider(
                                        list: images,
                                        isNew: false,
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 10,
                                ),
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
                                      backgroundColor:
                                          NexusColors.backgroundColor,
                                      iconColor: NexusColors.textColor,
                                      onTap: () async {
                                        // Use image picker to pick the image from gallery
                                        final XFile? image =
                                            await ImageSelector.pickImage();

                                        // Ensure the image is not null before proceeding
                                        if (image == null) {
                                          if (context.mounted) {
                                            print("NOO");
                                            StyledSnackbar.show(
                                              context: context,
                                              message: 'Image not picked',
                                            );
                                          }
                                          return;
                                        }

                                        // Check if the image has already been picked
                                        bool alreadyPicked = newImages.any(
                                            (pickedImage) =>
                                                pickedImage.path == image.path);
                                        bool checkLength = newImages.length +
                                                (images?.length ?? 0) <
                                            5;

                                        if (alreadyPicked) {
                                          if (context.mounted) {
                                            StyledSnackbar.show(
                                              context: context,
                                              message:
                                                  'Already picked that image',
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
                                            PickImage(file: image),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                imageSlider(
                                  list: newImages,
                                  isNew: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Spacer(),
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
                                      } else {
                                        // event to update the post

                                        postBottomSheetBloc.add(
                                          UpdatePost(text: text),
                                        );
                                      }
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
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
          ),
        ],
      ),
    );
  }

  Widget imageSlider({
    required list,
    required bool isNew,
  }) {
    getImage(image) {
      // * isNew refers to XFILE path
      // * !isNew refers to String src
      if (isNew) {
        return Image.file(
          File(image.path),
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
      return Image.network(
        image,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: false,
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
                        cornerRadius: 10,
                        cornerSmoothing: 0.8,
                      ),
                      child: getImage(image)),
                  Center(
                    child: StyledIconButton(
                      iconColor: Colors.white,
                      backgroundColor: Colors.black45,
                      icon: 'trash',
                      onTap: () {
                        if (isNew) {
                          postBottomSheetBloc.add(
                            DeleteNewImage(index: index),
                          );
                        } else {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => DeleteBottomSheet(
                              title: 'Delete Image',
                              message:
                                  'Are you certain you want to delete this image?',
                              onDelete: () {
                                postBottomSheetBloc.add(
                                  DeleteExistingImage(index: index),
                                );
                                // Bottom sheet
                                Navigator.pop(context);
                              },
                            ),
                          );
                        }
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
