import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/search_bottom_sheet_bloc/bloc/search_bottom_sheet_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  late SearchBottomSheetBloc searchBottomSheetBloc;

  @override
  void initState() {
    searchBottomSheetBloc = SearchBottomSheetBloc();
    searchBottomSheetBloc.add(FetchContent());
    super.initState();
  }

  @override
  void dispose() {
    searchBottomSheetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocProvider(
      create: (context) => searchBottomSheetBloc,
      child: Wrap(
        children: [
          Container(
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
                  topRight:
                      SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
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
                    hintText: 'Search content...',
                    controller: TextEditingController(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<SearchBottomSheetBloc, SearchBottomSheetState>(
                    builder: (context, state) {
                      Stream<List<ContentModel>> content =
                          (state as SearchBottomSheetInitial).content;

                      return StreamBuilder<List<ContentModel>>(
                        stream: content,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No content available'));
                          }

                          List<ContentModel> contentList = snapshot.data!;

                          return SizedBox(
                            height: height - 150,
                            child: ListView.separated(
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
