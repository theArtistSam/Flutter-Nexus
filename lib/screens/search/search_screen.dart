import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/content_screen_bloc/bloc/content_screen_bloc.dart';
import 'package:nexus/blocs/search_screen_bloc/bloc/search_screen_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/screens/search/widgets/filterTile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_text.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_textfield.dart';

class SearchScreenn extends StatefulWidget {
  const SearchScreenn({super.key});

  @override
  State<SearchScreenn> createState() => _SearchScreennState();
}

class _SearchScreennState extends State<SearchScreenn> {
  int selectedIndex = 0;
  late SearchScreenBloc searchScreenBloc;
  final List filters = [
    'Video',
    'Audio',
    'Translation',
    'Summarization',
    'YouTube',
    'Bruh'
  ];

  @override
  void initState() {
    searchScreenBloc = SearchScreenBloc();
    searchScreenBloc.add(LoadContentStream());
    super.initState();
  }

  @override
  void dispose() {
    searchScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchScreenBloc,
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
              leading: Transform.scale(
                scale: 1,
                child: StyledIconButton(
                  icon: 'back-arrow',
                  backgroundColor: NexusColors.isDark
                      ? const Color(0XFF0A0A0A)
                      : NexusColors.accentColorLight,
                  // COLOR: FIX
                  iconColor: NexusColors.isDark
                      ? Colors.white
                      : NexusColors.primaryColorLight,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              title: StyledText(
                text: 'Search',
                fontSize: 24,
                color: NexusColors.textColor,
              ),
              // actions: [
              //   StyledIconButton(icon: 'menu', onTap: () {}),
              // ],
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
                StyledTextfield(
                  icon: 'search',
                  hintText: 'Search content...',
                  controller: TextEditingController(),
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                // SizedBox(
                //   height: 44,
                //   child: ListView.separated(
                //     padding: const EdgeInsets.all(1),
                //     scrollDirection: Axis.horizontal,
                //     itemCount: filters.length, // Number of items
                //     separatorBuilder: (BuildContext context, int index) {
                //       return const SizedBox(
                //           width: 7); // Separator between items
                //     },
                //     itemBuilder: (BuildContext context, int index) {
                //       // Build each item
                //       return FilterTile(
                //         filter: filters[index],
                //         isTapped: selectedIndex == index,
                //         onTap: () {
                //           setState(() {
                //             selectedIndex = index;
                //           });
                //         },
                //       );
                //     },
                //   ),
                // ),
                // const Divider(
                //   color: NexusColors.dividerColor,
                //   height: 30,
                // ),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<SearchScreenBloc, SearchScreenState>(
                  builder: (context, state) {
                    Stream<List<ContentModel>> contents =
                        (state as SearchScreenInitial).contents;

                    return StreamBuilder<List<ContentModel>>(
                      stream: contents,
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

                        return Expanded(
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
                                onTap: () => {
                                  // Define your onTap action here
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
