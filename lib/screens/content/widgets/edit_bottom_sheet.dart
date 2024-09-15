import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/content_screen_bloc/bloc/content_screen_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/delete_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/image_slider_bottom_sheet.dart';
import 'package:nexus/widgets/popup_menu.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

// ignore: must_be_immutable
class EditBottomSheet extends StatefulWidget {
  const EditBottomSheet({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;
  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  late TextEditingController titleController;
  late TextEditingController tagController;

  @override
  void initState() {
    // Title controller
    titleController = TextEditingController();
    final String? title =
        (context.read<ContentScreenBloc>().state as ContentScreenInitial)
            .content
            .title;
    titleController.text = title ?? '';

    // Tag controller
    tagController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        children: [
          Container(
            height: height - 50,
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 0.8,
                  ),
                  topRight: SmoothRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 7),
                    child: Row(
                      children: [
                        StyledText(
                          text: 'Edit Details',
                          color: NexusColors.textColor,
                          fontSize: 20,
                        ),
                        const Spacer(),
                        PopupMenu(
                          onSelected: (value) async {
                            switch (value) {
                              case 'Delete content':
                                showModalBottomSheet(
                                  context: context,
                                  builder: (builder) {
                                    return DeleteBottomSheet(
                                      title: 'Delete Content',
                                      message:
                                          "Are you certain that you want to delete this content?",
                                      onDelete: () {
                                        context
                                            .read<ContentScreenBloc>()
                                            .add(DeleteContent());

                                        // Close the delete bottom sheet
                                        Navigator.of(context).pop();

                                        // Close the edit bottom sheet
                                        Navigator.of(context).pop();

                                        // Exit the content screen
                                        Navigator.of(context).pop();

                                        StyledSnackbar.show(
                                          context: context,
                                          message: "Content deleted",
                                        );
                                      },
                                    );
                                  },
                                );

                                break;
                              case 'Edit thumbnail':
                                // Use image picker to pick the image from gallery
                                final XFile? image =
                                    await ImageSelector.pickImage();

                                if (image != null) {
                                  if (context.mounted) {
                                    context.read<ContentScreenBloc>().add(
                                          AddThumbnail(file: image),
                                        );
                                  }
                                } else {
                                  if (context.mounted) {
                                    StyledSnackbar.show(
                                      context: context,
                                      message: "Image not selected",
                                    );
                                  }
                                }
                                break;
                              default:
                            }
                          },
                          items: const [
                            PopupItem(name: 'Edit thumbnail'),
                            PopupItem(name: 'Delete content'),
                          ],
                          icon: 'dots-circle',
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          BlocBuilder<ContentScreenBloc, ContentScreenState>(
                            builder: (context, state) {
                              final ContentModel content =
                                  (state as ContentScreenInitial).content;
                              final List<FolderModel> folders = state.folders;
                              final XFile? image = state.image;
                              return Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1.5,
                                  ),
                                  child: editDetailsBottomSheet(
                                    content: content,
                                    bottomPadding: bottomPadding,
                                    folders: folders,
                                    image: image,
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            // COLOR: FIX
                            color: NexusColors.isDark
                                ? NexusColors.accentColor
                                : NexusColors.dividerColor,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          StyledButton(
                            text: 'Confirm Changes',
                            onTap: widget.onConfirm,
                          ),
                          SizedBox(
                            height: bottomPadding,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  editDetailsBottomSheet({
    required double bottomPadding,
    required ContentModel content,
    required List<FolderModel> folders,
    XFile? image,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
                child: image != null
                    ? Image.file(
                        File(image.path),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: content.thumbnail ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
                          child: CircularProgressIndicator(
                            value: progress.progress,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
              image != null
                  ? StyledIconButton(
                      icon: 'trash',
                      onTap: () {
                        context.read<ContentScreenBloc>().add(
                              RemoveThumbnail(),
                            );
                      },
                      backgroundColor: Colors.black45,
                    )
                  : StyledIconButton(
                      icon: 'maximize',
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (builder) => ImageSliderBottomSheet(
                            images: [content.thumbnail!],
                          ),
                        );
                      },
                      backgroundColor: Colors.black45,
                    )
            ],
          ),
          const SizedBox(height: 20),
          StyledText(
            text: 'Content Title',
            fontSize: 18,
            color: NexusColors.textColor,
          ),
          const SizedBox(height: 10),
          StyledTextfield(
            hintText: 'Add video title...',
            controller: titleController,
            maxlines: 5,
            onChanged: (value) {
              content.title = value;
            },
          ),
          const SizedBox(height: 20),
          StyledText(
            text: 'Folder Selected',
            fontSize: 18,
            color: NexusColors.textColor,
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: ShapeDecoration(
              // color: Colors.amber,
              shape: SmoothRectangleBorder(
                side: BorderSide(width: 2, color: NexusColors.borderColor),
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.8,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 15,
                    cornerSmoothing: 0.8,
                  ),
                  dropdownColor: NexusColors.accentColor,
                  icon: SvgPicture.asset(
                    'assets/icons/small-arrow-down.svg',
                    color: NexusColors.isDark
                        ? Colors.white
                        : NexusColors.primaryColor,
                  ),
                  value: content.folderId ?? 'None',
                  items: [
                    DropdownMenuItem<String>(
                      value: 'None',
                      child: StyledText(
                        text: 'None',
                        // COLOR: FIX
                        color: NexusColors.isDark
                            ? Colors.white
                            : NexusColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ...folders.map((FolderModel folder) {
                      return DropdownMenuItem<String>(
                        value: folder.folderId,
                        child: StyledText(
                          text: folder.title!,
                          fontWeight: FontWeight.w500,
                          color: NexusColors.isDark
                              ? Colors.white
                              : NexusColors.primaryColor,
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? id) {
                    context.read<ContentScreenBloc>().add(
                          ChangeFolder(folderId: id),
                        );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          StyledText(
            text: 'Content Tags ',
            fontSize: 18,
            color: NexusColors.textColor,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: StyledTextfield(
                  icon: 'hashtag-square',
                  hintText: 'Add a tag',
                  controller: tagController,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              StyledIconButton(
                icon: 'arrow-up',
                onTap: () {
                  String newTag = tagController.text.trim();
                  if (content.tags != null && content.tags!.contains(newTag)) {
                    StyledSnackbar.show(
                        context: context, message: "Tag already exists");
                  } else if (newTag.isNotEmpty) {
                    context.read<ContentScreenBloc>().add(AddTag(tag: newTag));
                    tagController.clear();
                  }
                },
                backgroundColor: tagController.text.isEmpty
                    ? NexusColors.primaryColorLight.withOpacity(.5)
                    : NexusColors.primaryColorLight,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              for (var tag in content.tags!)
                tagTile(
                  tagTitle: tag,
                  onTap: () {
                    context.read<ContentScreenBloc>().add(RemoveTag(tag: tag));
                  },
                )
            ],
          ),
        ],
      );

  tagTile({required String tagTitle, required VoidCallback onTap}) => Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: .8,
            ),
            onTap: onTap,
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
                padding: const EdgeInsets.all(5),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/cancel.svg',
                      // COLOR: FIX
                      color: NexusColors.isDark
                          ? Colors.white
                          : NexusColors.primaryColorLight,
                    ),
                    StyledText(
                      text: tagTitle,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      // COLOR: FIX
                      color: NexusColors.isDark
                          ? Colors.white
                          : NexusColors.primaryColorLight,
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
