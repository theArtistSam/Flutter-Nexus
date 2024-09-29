import 'dart:io';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/content_screen_bloc/bloc/content_screen_bloc.dart';
import 'package:nexus/blocs/upload_bottom_sheet_bloc/bloc/upload_bottom_sheet_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/enums.dart';
import 'package:nexus/widgets/popup_menu.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:path/path.dart' as path;

class UploadBottomSheet extends StatefulWidget {
  const UploadBottomSheet({super.key});

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  late UploadBottomSheetBloc uploadBottomSheetBloc;
  @override
  void initState() {
    uploadBottomSheetBloc = UploadBottomSheetBloc();
    super.initState();
  }

  @override
  void dispose() {
    uploadBottomSheetBloc.close();
    super.dispose();
  }

  // Function to pick a single file and return it
  Future<File?> _pickFile() async {
    // Pick a single file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'm4a',
        'aac',
        'mkv',
        'mp4',
        'docx',
        'doc',
        'pdf',
        'jpeg',
        'png'
      ],
    );

    // If a file was picked, return it as a File object
    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!); // Return the picked file
    }

    return null; // Return null if no file was picked
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocProvider(
      create: (context) => uploadBottomSheetBloc,
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
                vertical: 15,
              ),
              child:
                  BlocConsumer<UploadBottomSheetBloc, UploadBottomSheetState>(
                listener: (context, state) {
                  if (state is UploadBottomSheetInitial &&
                      state.status == ReturnResponseStatus.success) {
                    Navigator.pop(context); // Close the modal on success
                    StyledSnackbar.show(
                      context: context,
                      message: 'Background Upload Generated!',
                    );
                  }
                },
                builder: (context, state) {
                  final currentState = state as UploadBottomSheetInitial;
                  final selectionEnabled = currentState.isSelected;
                  final aiFeature = currentState.aiFeature;
                  final pickedFiles = currentState.pickedFiles;
                  final status = currentState.status;
                  final filesLength = pickedFiles.length;
                  final count = currentState.count;

                  print(">>>>${filesLength}");
                  print("<<<<${currentState.content.length}");

                  if (status == ReturnResponseStatus.initial) {
                    return Column(children: [
                      Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: NexusColors.borderColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: Row(
                          children: [
                            const StyledText(
                              text: "Files Selected",
                              fontSize: 20,
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
                                  if (pickedFiles.isNotEmpty) {
                                    uploadBottomSheetBloc.add(Select());
                                  }
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
                                    padding: !selectionEnabled
                                        ? const EdgeInsets.all(9)
                                        : const EdgeInsets.fromLTRB(
                                            2,
                                            2,
                                            11,
                                            2,
                                          ),
                                    child: Row(
                                      children: [
                                        selectionEnabled
                                            ? SvgPicture.asset(
                                                'assets/icons/cancel.svg',
                                                // COLOR: FIX
                                                color: NexusColors.isDark
                                                    ? Colors.white
                                                    : NexusColors
                                                        .primaryColorLight,
                                              )
                                            : const SizedBox(),
                                        // const SizedBox(width: 5),
                                        StyledText(
                                          text: "Select",
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
                                  case 'Delete Selected':
                                    uploadBottomSheetBloc.add(
                                      RemoveSelectedFiles(),
                                    );

                                    break;
                                  default:
                                }
                              },
                              items: [
                                if (selectionEnabled)
                                  const PopupItem(name: "Delete Selected"),
                                const PopupItem(name: "Upload Google Drive")
                              ],
                              icon: 'dots-circle',
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: ShapeDecoration(
                                color: NexusColors.accentColor,
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 15,
                                    cornerSmoothing: .8,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  pickedFiles.isNotEmpty
                                      ? ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: pickedFiles.length,
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              height: 10,
                                              thickness: 1.5,
                                              color:
                                                  NexusColors.backgroundColor,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            final isSelected =
                                                pickedFiles[index].values.first;
                                            return _uploadItem(
                                              file:
                                                  pickedFiles[index].keys.first,
                                              selectionEnabled:
                                                  selectionEnabled,
                                              isSelected: isSelected,
                                            );
                                          },
                                        )
                                      : const SizedBox(),
                                  Divider(
                                    height: 0,
                                    thickness: 1.5,
                                    color: NexusColors.backgroundColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: NexusColors.backgroundColor,
                                        shape: SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius(
                                            cornerRadius: 10,
                                            cornerSmoothing: 0.8,
                                          ),
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: SmoothBorderRadius(
                                            cornerRadius: 10,
                                            cornerSmoothing: 0.8,
                                          ),
                                          onTap: () async {
                                            if (pickedFiles.length < 5) {
                                              final File? file =
                                                  await _pickFile();

                                              if (file != null) {
                                                String fileName =
                                                    path.basename(file.path);

                                                // TODO: FOR NOW Based on the same name

                                                final bool isPicked =
                                                    pickedFiles.any(
                                                        (pickedFile) =>
                                                            path.basename(
                                                                pickedFile
                                                                    .keys
                                                                    .first
                                                                    .path) ==
                                                            fileName);

                                                // Check if the file is already picked
                                                if (isPicked) {
                                                  StyledSnackbar.show(
                                                    context: context,
                                                    message:
                                                        'File already picked!',
                                                  );
                                                } else {
                                                  // Add the file to the bloc
                                                  uploadBottomSheetBloc.add(
                                                    PickFile(file: file),
                                                  );
                                                }
                                              } else {
                                                StyledSnackbar.show(
                                                  context: context,
                                                  message: 'File not picked!',
                                                );
                                              }
                                            } else {
                                              StyledSnackbar.show(
                                                context: context,
                                                message:
                                                    'Cannot pick more than 5 files!',
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/plus.svg',
                                                  height: 24,
                                                  color: NexusColors.textColor,
                                                ),
                                                const SizedBox(width: 5),
                                                StyledText(
                                                  text: "Select File",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: NexusColors.textColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const StyledText(
                              text: "AI Feature",
                              fontSize: 20,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: ShapeDecoration(
                                shape: SmoothRectangleBorder(
                                  side: BorderSide(
                                    width: 2,
                                    color: NexusColors.borderColor,
                                  ),
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 15,
                                    cornerSmoothing: 0.8,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
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
                                    value: aiFeature,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'Translation',
                                        child: StyledText(
                                          text: 'Translation',
                                          // COLOR: FIX
                                          color: NexusColors.isDark
                                              ? Colors.white
                                              : NexusColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Summarization',
                                        child: StyledText(
                                          text: 'Summarization',
                                          // COLOR: FIX
                                          color: NexusColors.isDark
                                              ? Colors.white
                                              : NexusColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                    onChanged: (String? value) {
                                      uploadBottomSheetBloc.add(
                                        SelectAiFeature(aiFeature: value!),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            StyledButton(
                              text: 'Upload Files',
                              onTap: () {
                                uploadBottomSheetBloc.add(GetResponse());
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: bottomPadding),
                    ]);
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: NexusColors.borderColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const CircularProgressIndicator(),
                        StyledText(
                          text: '$count/$filesLength Files Processing',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: bottomPadding),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  String _getExtensionIcon({required String extension}) {
    switch (extension.toLowerCase()) {
      case '.png':
      case '.jpeg':
      case '.jpg': // Consider adding .jpg as well
        return 'image'; // Return image icon or identifier
      case '.mp3':
      case '.aac':
      case '.m4a':
        return 'audio'; // Return audio icon or identifier
      case '.mkv':
      case '.mp4':
        return 'video'; // Return video icon or identifier
      case '.doc':
      case '.docx':
      case '.pdf':
        return 'document'; // Return document icon or identifier
      default:
        return 'unknown'; // Return default icon for unsupported types
    }
  }

  Widget _uploadItem({
    required File file,
    required bool isSelected,
    required bool selectionEnabled,
  }) {
    final String filePath = file.path;
    String fileName = path.basename(filePath);
    final String fileExtension = path.extension(filePath);
    if (fileName.length > 25) {
      fileName = "${fileName.substring(0, 22)}...";
    }
    return Container(
      decoration: ShapeDecoration(
        color: NexusColors.accentColor,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: 0.8,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: ShapeDecoration(
                color: NexusColors.backgroundColor,
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 10,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/${_getExtensionIcon(extension: fileExtension)}.svg',
                  // COLOR: FIX
                  color: NexusColors.isDark
                      ? Colors.white
                      : NexusColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            StyledText(
              text: fileName,
              fontSize: 14,
            ),
            const Spacer(),
            selectionEnabled
                ? StyledIconButton(
                    icon: isSelected ? 'tick-square-filled' : 'tick-square',
                    onTap: () {
                      uploadBottomSheetBloc.add(ToggleSelectFile(file: file));
                    },
                    iconColor: isSelected
                        ? NexusColors.textColor
                        : NexusColors.textColor.withOpacity(.5),
                    backgroundColor: NexusColors.accentColor,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
