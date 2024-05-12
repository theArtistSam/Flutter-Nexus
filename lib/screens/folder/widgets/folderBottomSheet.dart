import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nexus/blocs/folderBottomSheet_bloc/bloc/folder_bottom_sheet_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styledButton.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledTextfield.dart';

class FolderBottomSheet extends StatefulWidget {
  const FolderBottomSheet({super.key});

  @override
  State<FolderBottomSheet> createState() => _FolderBottomSheetState();
}

class _FolderBottomSheetState extends State<FolderBottomSheet> {
  late FolderBottomSheetBloc folderBottomSheetBloc;
  @override
  void initState() {
    folderBottomSheetBloc = FolderBottomSheetBloc();
    super.initState();
  }

  @override
  void dispose() {
    folderBottomSheetBloc.close();
    super.dispose();
  }

  final List icons = [
    'folder-minus',
    'double-folder',
    'heart-folder',
    'favorite-chart',
    'notification-status',
    'brush-square',
    'gallery',
    'audio-square',
    'video-square',
    'calendar',
    'code',
    'key-square',
  ];

  void setSelectedIndex(index) {
    folderBottomSheetBloc.add(SelectFolderIcon(index: index));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                        topLeft: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 0.8),
                        topRight: SmoothRadius(
                            cornerRadius: 20, cornerSmoothing: 0.8)),
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
                    StyledTextfield(
                      icon: 'folder-minus',
                      hintText: 'New Folder name',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<FolderBottomSheetBloc, FolderBottomSheetState>(
                      builder: (context, state) {
                        if (state is FolderBottomSheetInitial) {
                          return MasonryGridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              crossAxisCount: gridCount(),
                              crossAxisSpacing: 15, //
                              mainAxisSpacing: 15,
                              itemCount: icons.length,
                              itemBuilder: (context, index) {
                                return StyledIconButton(
                                    icon: icons[index],
                                    iconColor: index == state.index
                                        ? Colors.white
                                        : NexusColors.primaryColorLight,
                                    backgroundColor: index == state.index
                                        ? NexusColors.primaryColorLight
                                        : NexusColors.accentColorLight,
                                    onTap: () => setSelectedIndex(index));
                              });
                        }
                        return const SizedBox();
                      },
                    ),
                    const Divider(
                      color: NexusColors.dividerColor,
                      height: 30,
                    ),
                    StyledButton(
                        text: 'Delete Folder',
                        isDeleteable: true,
                        onTap: () => {}),
                    const SizedBox(height: 20),
                    StyledButton(text: 'Confirm Changes', onTap: () => {}),
                    const SizedBox(height: 20),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
