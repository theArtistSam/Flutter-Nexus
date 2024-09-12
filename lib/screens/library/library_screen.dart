import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/library_screen_bloc/bloc/library_screen_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/screens/folder/folder_screen.dart';
import 'package:nexus/screens/library/widgets/search_bottom_sheet.dart';
import 'package:nexus/utils/enums.dart';
import 'package:nexus/widgets/bottom_sheets/folder_bottom_sheet.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_tabs.dart';

// ignore: must_be_immutable
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, required this.controller});
  final ScrollController controller;
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late LibraryScreenBloc libraryScreenBloc;

  @override
  void initState() {
    libraryScreenBloc = LibraryScreenBloc();
    libraryScreenBloc.add(LoadContent());
    super.initState();
  }

  @override
  void dispose() {
    libraryScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final statusBarHeight = MediaQuery.of(context).padding.top;

    // Grid view count for products
    int gridCount() {
      if (screenWidth > 185) {
        return (screenWidth ~/ 175).toInt();
      }
      return 1;
    }

    void toggleView(bool isLeftSelected) {
      libraryScreenBloc.add(ToggleView(isLeftSelected: isLeftSelected));
    }

    return BlocProvider(
      create: (context) => libraryScreenBloc,
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
              backgroundColor: NexusColors.isDark
                  ? const Color(0XFF0A0A0A)
                  : NexusColors.accentColorLight,
              leadingWidth: 30,
              leading: SvgPicture.asset(
                'assets/icons/library-filled.svg',
                // COLOR: FIX
                color: NexusColors.isDark
                    ? Colors.white
                    : NexusColors.primaryColor,
              ),
              title: StyledText(
                text: 'Library',
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
                  padding: 6,
                  icon: 'search',
                  onTap: () {
                    bool isLeftSelected =
                        (libraryScreenBloc.state as LibraryScreenInitial)
                            .isLeftSelected;
                    // * Use modal bottom sheet
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SearchBottomSheet(
                        isFolderSelected: isLeftSelected,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        body: Container(
          decoration: ShapeDecoration(
            color: NexusColors.backgroundColor,
            shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                topRight: SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                StyledTabs(
                  leftTabText: 'Folders',
                  rightTabText: 'Content',
                  changeState: toggleView,
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<LibraryScreenBloc, LibraryScreenState>(
                  builder: (context, state) {
                    if (state is LibraryScreenInitial) {
                      bool isLeftSelected = state.isLeftSelected;
                      Stream<List<ContentModel>> contentList = state.contents;
                      Stream<List<FolderModel>> folderList = state.folders;
                      LibraryStatus status = state.status;

                      if (status == LibraryStatus.success) {
                        if (isLeftSelected) {
                          return StreamBuilder<List<FolderModel>>(
                            stream: folderList,
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
                                  child: Text('No content available'),
                                );
                              }

                              List<FolderModel> folderList = snapshot.data!;

                              return Expanded(
                                child: MasonryGridView.count(
                                  controller: widget.controller,
                                  // padding: const EdgeInsets.only(top: 15),
                                  crossAxisCount: gridCount(),
                                  crossAxisSpacing: 15, //
                                  mainAxisSpacing: 15,
                                  itemCount: folderList.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return StyledIconTile(
                                        icon: 'add-folder-filled',
                                        text: 'Create Folder',
                                        onTap: () => {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                const FolderBottomSheet(),
                                          )
                                        },
                                      );
                                    }
                                    return StyledIconTile(
                                      icon: FolderIcons.icons[
                                          folderList[index - 1].icon ?? 0],
                                      text: folderList[index - 1].title ?? '',
                                      isPrimary: false,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) => FolderScreen(
                                              folder: folderList[index - 1],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                        return StreamBuilder<List<ContentModel>>(
                          stream: contentList,
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
                                child: Text('No content available'),
                              );
                            }

                            List<ContentModel> contentList = snapshot.data!;

                            return Expanded(
                              child: ListView.separated(
                                // shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                controller: widget.controller,
                                itemCount: contentList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 15);
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  ContentModel content = contentList[index];
                                  return ContentTile(
                                    title: content.title ?? '',
                                    thumbnail: content.thumbnail ?? '',
                                    date: content.dateUpdated!,
                                    icon: content.type ?? '',
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) =>
                                              ContentScreen(content: content),
                                        ),
                                      )
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else if (status == LibraryStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                    return const SizedBox(
                      child: Text('Something went wrong'),
                    );
                  },
                ),
                // const SizedBox(
                //   height: 25,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
