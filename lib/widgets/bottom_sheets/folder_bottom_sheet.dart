import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nexus/blocs/folder_bottom_sheet_bloc/bloc/folder_bottom_sheet_bloc.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/delete_bottom_sheet.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class FolderBottomSheet extends StatefulWidget {
  const FolderBottomSheet({
    super.key,
    this.folder,
    this.updateState,
  });

  final FolderModel? folder;
  final VoidCallback? updateState;

  @override
  State<FolderBottomSheet> createState() => _FolderBottomSheetState();
}

class _FolderBottomSheetState extends State<FolderBottomSheet> {
  late FolderBottomSheetBloc folderBottomSheetBloc;
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    if (widget.folder != null) {
      controller.text = widget.folder!.title!;
    }
    folderBottomSheetBloc = FolderBottomSheetBloc(folder: widget.folder);
    super.initState();
  }

  @override
  void dispose() {
    folderBottomSheetBloc.close();
    super.dispose();
  }

  void setSelectedIndex(index) {
    folderBottomSheetBloc.add(SelectFolderIcon(index: index));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    int gridCount() {
      if (screenWidth > 70) {
        return (screenWidth ~/ 65).toInt();
      }
      return 1;
    }

    return BlocProvider(
      create: (context) => folderBottomSheetBloc,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Column(children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: NexusColors.borderColor),
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<FolderBottomSheetBloc, FolderBottomSheetState>(
                      builder: (context, state) {
                        if (state is FolderBottomSheetInitial) {
                          final FolderModel folder = (state).folder;
                          return Column(
                            children: [
                              StyledTextfield(
                                icon: FolderIcons.icons[folder.icon ?? 0],
                                hintText: 'New folder name',
                                controller: controller,
                              ),
                              const SizedBox(height: 15),
                              MasonryGridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                crossAxisCount: gridCount(),
                                crossAxisSpacing: 15, //
                                mainAxisSpacing: 15,
                                itemCount: FolderIcons.icons.length,
                                itemBuilder: (context, index) {
                                  return StyledIconButton(
                                    icon: FolderIcons.icons[index],
                                    iconColor: _getIconColor(
                                        isSelected: index == folder.icon),
                                    // COLOR: FIX
                                    backgroundColor: index == folder.icon
                                        ? NexusColors.primaryColor
                                        : NexusColors.accentColor,
                                    onTap: () => setSelectedIndex(index),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    // COLOR: FIX
                    Divider(
                      color: NexusColors.isDark
                          ? NexusColors.accentColor
                          : NexusColors.dividerColor,
                      height: 30,
                    ),
                    widget.folder != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: StyledButton(
                              text: 'Delete Folder',
                              isDeleteable: true,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => DeleteBottomSheet(
                                    title: "Delete Folder",
                                    message:
                                        'Are you certain you want to delete this folder?',
                                    onDelete: () {
                                      folderBottomSheetBloc.add(DeleteFolder(
                                        folderId: widget.folder!.folderId!,
                                      ));

                                      // Show Snackbar
                                      StyledSnackbar.show(
                                        message: "Folder Deleted",
                                        context: context,
                                      );

                                      // Close Folder bottom sheet
                                      Navigator.pop(context);

                                      // Close Delete bottom sheet
                                      Navigator.pop(context);

                                      // Back out of the screen
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                    StyledButton(
                      text: widget.folder != null
                          ? 'Confirm Changes'
                          : "Create Folder",
                      onTap: () {
                        if (widget.folder != null) {
                          folderBottomSheetBloc.add(UpdateFolder(
                            title: controller.text,
                          ));
                          widget.updateState?.call();

                          // Show snack bar
                          StyledSnackbar.show(
                            message: "Folder Updated",
                            context: context,
                          );

                          // Close bottom sheet
                          Navigator.pop(context);
                        } else {
                          if (controller.text.isNotEmpty) {
                            folderBottomSheetBloc.add(CreateFolder(
                              title: controller.text,
                            ));

                            // Show snack bar
                            StyledSnackbar.show(
                              message: "Folder Created",
                              context: context,
                            );

                            // Close bottom sheet
                            Navigator.pop(context);
                          } else {
                            // Show snack bar
                            StyledSnackbar.show(
                              message: "Cannot add empty title",
                              context: context,
                            );

                            // Close bottom sheet
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                    SizedBox(height: bottomPadding),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // COLOR: FIX
  _getIconColor({required bool isSelected}) {
    if (isSelected) {
      return Colors.white;
    }
    return NexusColors.isDark ? Colors.white : NexusColors.primaryColorLight;
  }
}
