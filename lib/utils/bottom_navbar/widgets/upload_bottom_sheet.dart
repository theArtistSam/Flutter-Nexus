import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/upload_bottom_sheet_bloc/bloc/upload_bottom_sheet_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/popup_menu.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:uuid/uuid.dart';

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
              child: BlocBuilder<UploadBottomSheetBloc, UploadBottomSheetState>(
                builder: (context, state) {
                  final currentState = state as UploadBottomSheetInitial;
                  final selectionEnabled = currentState.isSelected;
                  final files = currentState.files;
                  final aiFeature = currentState.aiFeature;

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
                                if (files.isNotEmpty) {
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
                                files.isNotEmpty
                                    ? ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: files.length,
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            height: 10,
                                            thickness: 1.5,
                                            color: NexusColors.backgroundColor,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          final String fileName = currentState
                                              .files[index].keys.first;
                                          final isSelected = currentState
                                              .files[index][fileName]!;
                                          return uploadItem(
                                            type: 'image',
                                            fileName: fileName,
                                            selectionEnabled: selectionEnabled,
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
                                        onTap: () {
                                          if (files.length < 5) {
                                            uploadBottomSheetBloc.add(
                                              UploadFilesLocal(
                                                file: {
                                                  'file_${const Uuid().v1().substring(0, 8)}':
                                                      false,
                                                },
                                              ),
                                            );
                                          } else {
                                            StyledSnackbar.show(
                                              context: context,
                                              message:
                                                  'Cannot add more than 5 files',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
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
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: bottomPadding),
                  ]);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget uploadItem({
    required String type,
    required String fileName,
    required bool isSelected,
    required bool selectionEnabled,
  }) {
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
                  'assets/icons/$type.svg',
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
                      uploadBottomSheetBloc
                          .add(ToggleSelectFile(fileName: fileName));
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
