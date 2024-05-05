import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:nexus/screens/home/widgets/contentTile.dart';
import 'package:nexus/screens/search/widgets/filterTile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/styledText.dart';
import 'package:nexus/widgets/styledIconButton.dart';
import 'package:nexus/widgets/styledTextfield.dart';

class SearchScreenn extends StatefulWidget {
  const SearchScreenn({super.key});

  @override
  State<SearchScreenn> createState() => _SearchScreennState();
}

class _SearchScreennState extends State<SearchScreenn> {
  int selectedIndex = 0;
  final List filters = [
    'Video',
    'Audio',
    'Translation',
    'Summarization',
    'YouTube',
    'Bruh'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NexusColors.accentColorLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: NexusColors.accentColorLight,
              leadingWidth: 30,
              leading: Transform.scale(
                scale: 1,
                child: StyledIconButton(
                    icon: 'back-arrow',
                    backgroundColor: NexusColors.accentColorLight,
                    iconColor: NexusColors.primaryColorLight,
                    onTap: () => Navigator.pop(context)),
              ),
              title: StyledText(text: 'Search', fontSize: 24),
              // actions: [
              //   StyledIconButton(icon: 'menu', onTap: () {}),
              // ],
            ),
          ),
        ),
        body: Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft:
                        SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8),
                    topRight:
                        SmoothRadius(cornerRadius: 35, cornerSmoothing: 0.8)),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(children: [
                  StyledTextfield(
                      icon: 'search', hintText: 'Search content...'),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(1),
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length, // Number of items
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                            width: 7); // Separator between items
                      },
                      itemBuilder: (BuildContext context, int index) {
                        // Build each item
                        return FilterTile(
                          filter: filters[index],
                          isTapped: selectedIndex == index,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(
                    color: NexusColors.dividerColor,
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 5, // Number of items
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                            height: 15); // Separator between items
                      },
                      itemBuilder: (BuildContext context, int index) {
                        // Build each item
                        return ContentTile(
                            title:
                                'Learn how to make vids on YouTube from home',
                            image: 'content',
                            date: 'December 10, 2024',
                            icon: 'video',
                            onTap: () => {});
                      },
                    ),
                  ),
                ]))));
  }
}
