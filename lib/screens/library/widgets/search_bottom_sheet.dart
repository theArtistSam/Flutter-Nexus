import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nexus/blocs/search_bottom_sheet_bloc/bloc/search_bottom_sheet_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/library_repository.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/screens/folder/folder_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key, required this.isFolderSelected});

  final bool isFolderSelected;

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  late SearchBottomSheetBloc searchBottomSheetBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final searchService = LibraryRepository();
    searchBottomSheetBloc = SearchBottomSheetBloc(searchService);

    if (widget.isFolderSelected) {
      searchBottomSheetBloc.add(const SearchFolder(query: ''));
    } else {
      searchBottomSheetBloc.add(const SearchContent(query: ''));
    }

    _searchController.addListener(() {
      final query = _searchController.text;
      if (widget.isFolderSelected) {
        searchBottomSheetBloc.add(SearchFolder(query: query));
      } else {
        searchBottomSheetBloc.add(SearchContent(query: query));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchBottomSheetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    int gridCount() {
      if (width > 185) {
        return (width ~/ 175).toInt();
      }
      return 1;
    }

    return BlocProvider(
      create: (context) => searchBottomSheetBloc,
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
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
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
                  StyledTextfield(
                    icon: 'search',
                    hintText: widget.isFolderSelected
                        ? 'Search folders...'
                        : 'Search contents...',
                    controller: _searchController,
                    onChanged: (query) {
                      if (widget.isFolderSelected) {
                        searchBottomSheetBloc.add(SearchFolder(query: query));
                      } else {
                        searchBottomSheetBloc.add(SearchContent(query: query));
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  BlocBuilder<SearchBottomSheetBloc, SearchBottomSheetState>(
                    builder: (context, state) {
                      if (state is SearchBottomSheetInitial) {
                        if (!widget.isFolderSelected) {
                          final contentStream = state.searchedContents;
                          return StreamBuilder<List<ContentModel>>(
                            stream: contentStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: StyledText(
                                      text: 'Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text('No content available'),
                                );
                              }

                              final contentList = snapshot.data!;

                              return Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: contentList.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 15);
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final content = contentList[index];
                                    return ContentTile(
                                      title: content.title ?? '',
                                      thumbnail: content.thumbnail ?? '',
                                      date: content.dateUpdated ?? '',
                                      icon: content.type ?? '',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) =>
                                                ContentScreen(content: content),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          final folderStream = state.searchedFolders;
                          return StreamBuilder<List<FolderModel>>(
                            stream: folderStream,
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
                                  child: Text('No folder available'),
                                );
                              }

                              final folderList = snapshot.data!;

                              return Expanded(
                                child: MasonryGridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: gridCount(),
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  itemCount: folderList.length,
                                  itemBuilder: (context, index) {
                                    return StyledIconTile(
                                      icon: FolderIcons
                                          .icons[folderList[index].icon ?? 0],
                                      text: folderList[index].title ?? '',
                                      isPrimary: false,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) => FolderScreen(
                                              folder: folderList[index],
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
                      }
                      return const SizedBox(
                        child: Text('Something went wrong'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
