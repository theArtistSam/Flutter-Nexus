import 'dart:io';
import 'dart:math';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/content_screen_bloc/bloc/content_screen_bloc.dart';
import 'package:nexus/blocs/edit_bottom_sheet_bloc/bloc/edit_bottom_sheet_bloc.dart';
import 'package:nexus/blocs/home_screen_bloc/bloc/home_screen_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/screens/home/home_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_tabs.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

// ignore: must_be_immutable
class EditBottomSheet extends StatefulWidget {
  EditBottomSheet({super.key, required this.content, required this.folders});

  ContentModel content;
  List<FolderModel> folders;
  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  late EditBottomSheetBloc editBottomSheetBloc;
  late TextEditingController titleController;
  late TextEditingController tagController;

  @override
  void initState() {
    editBottomSheetBloc = EditBottomSheetBloc();

    // Load all the folders at the initial event
    // editBottomSheetBloc.add(InitialEvent());

    titleController = TextEditingController();
    titleController.text = widget.content.title ?? '';

    tagController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    editBottomSheetBloc.close();
    super.dispose();
  }

  void changeView(bool isLeftSelected) {
    editBottomSheetBloc.add(ToggleView(isLeftSelected: isLeftSelected));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocProvider(
      create: (context) => editBottomSheetBloc,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Container(
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
                    horizontal: 20,
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
                      const SizedBox(height: 15),
                      StyledTabs(
                        leftTabText: 'Details',
                        rightTabText: 'Tags',
                        changeState: changeView,
                        // isLeftSelected: false
                      ),
                      const SizedBox(height: 15),
                      // const Divider(
                      //   color: NexusColors.dividerColor,
                      //   height: 30,
                      // ),
                      BlocBuilder<EditBottomSheetBloc, EditBottomSheetState>(
                        builder: (context, state) {
                          if (state is EditBottomSheetInitial) {
                            return state.isLeftSelected
                                ? editBottomSheetContent(
                                    content: state.content ?? widget.content,
                                    bottomPadding: bottomPadding,
                                    folders: widget.folders,
                                  )
                                : tagsBottomSheetContent(
                                    content: state.content ?? widget.content,
                                    onTap: () {},
                                    bottomPadding: bottomPadding,
                                  );
                          } else {
                            return const SizedBox();
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  tagTile({tagTitle, onTap}) => Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: .8),
            onTap: onTap,
            child: Ink(
              decoration: ShapeDecoration(
                color: NexusColors.accentColor,
                shape: SmoothRectangleBorder(
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: .8),
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
                      text: tagTitle ?? '',
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

  tagsBottomSheetContent({
    onTap,
    required double bottomPadding,
    required ContentModel content,
  }) =>
      Column(
        children: [
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Already Exists'),
                      ),
                    );
                  } else if (newTag.isNotEmpty) {
                    editBottomSheetBloc.add(
                      AddTag(tag: newTag, contentId: widget.content.contentId!),
                    );
                    tagController.clear();
                  }
                },
                backgroundColor: tagController.text.isEmpty
                    ? NexusColors.primaryColorLight.withOpacity(.5)
                    : NexusColors.primaryColorLight,
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 503 + bottomPadding,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(children: [
                for (var tag in content.tags!)
                  tagTile(
                      tagTitle: tag,
                      onTap: () {
                        editBottomSheetBloc.add(
                            RemoveTag(tag: tag, contentId: content.contentId!));
                      })
              ]),
            ),
          ),
        ],
      );

  editBottomSheetContent({
    required double bottomPadding,
    required ContentModel content,
    required List<FolderModel> folders,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 0.8),
                child: Image.network(content.thumbnail ?? '',
                    height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned.fill(
                  child: GestureDetector(
                onTap: () async {
                  // Use image picker to pick the image from gallery
                  final XFile? image = await ImageSelector.pickImage();

                  if (image != null) {
                    // Trigger the ChangeThumbnail operation with the picked image file and content ID
                    editBottomSheetBloc.add(
                      ChangeThumbnail(
                        file: File(image.path),
                        contentId: content.contentId!,
                      ),
                    );
                  } else {
                    // User canceled the image picker
                    // Handle accordingly or show a message
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(.1), // Start color (0% black)
                        Colors.black.withOpacity(0.5), // End color (90% black)
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
                        const SizedBox(width: 10),
                        const StyledText(
                          text: 'Change Thumbnail',
                          fontWeight: FontWeight.w500,
                          color: NexusColors.textColorLight,
                        )
                      ],
                    ),
                  ),
                ),
              )),
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
            icon: null,
            hintText: 'Add video title...',
            controller: titleController,
            maxlines: 5,
          ),
          const SizedBox(height: 20),
          StyledText(
            text: 'Select Folder',
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
                  icon: SvgPicture.asset(
                    'assets/icons/small-arrow-down.svg',
                    color: NexusColors.primaryColorLight,
                  ),
                  // value: content.title,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: StyledText(
                        text: 'None',
                        color: NexusColors.primaryColorLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ...folders.map((FolderModel folder) {
                      return DropdownMenuItem<String>(
                        value: folder.title,
                        child: StyledText(
                          text: folder.title ?? '>>>',
                          color: NexusColors.primaryColorLight,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      content.title = newValue;
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

          // TODO: FIX STYLED BUTTON
          StyledButton(
            text: 'Delete content',
            onTap: () async {
              editBottomSheetBloc.add(
                DeleteContent(contentId: content.contentId!),
              );
              // Reload content on HomeScreen
              // context.read<HomeScreenBloc>().add(LoadContent());

              // Pop from EditBottomSheet
              Navigator.of(context).pop();
              // Pop from Content Screen
              Navigator.of(context).pop();

              // Show an error message or handle the failure case
              await Future.delayed(const Duration(seconds: 1));
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Content deleted!'),
                ),
              );
            },
            isDeleteable: true,
          ),
          const SizedBox(
            height: 15,
          ),
          StyledButton(text: 'Confirm Changes', onTap: () {}),
          SizedBox(
            height: bottomPadding,
          ),
        ],
      );
}
