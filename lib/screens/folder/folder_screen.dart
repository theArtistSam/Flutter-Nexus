import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/folder_screen_bloc/bloc/folder_screen_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/screens/content/content_screen.dart';
import 'package:nexus/widgets/bottom_sheets/folder_bottom_sheet.dart';
import 'package:nexus/widgets/content_tile.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';

// ignore: must_be_immutable
class FolderScreen extends StatefulWidget {
  FolderScreen({super.key, required this.folder});

  FolderModel folder;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  late FolderScreenBloc folderScreenBloc;
  @override
  void initState() {
    folderScreenBloc = FolderScreenBloc(folder: widget.folder);
    folderScreenBloc.add(LoadContent(folderID: widget.folder.folderId ?? ''));
    super.initState();
  }

  @override
  void dispose() {
    folderScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => folderScreenBloc,
      child: Scaffold(
        backgroundColor: NexusColors.isDark
            ? const Color(0XFF0A0A0A)
            : NexusColors.accentColorLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<FolderScreenBloc, FolderScreenState>(
              builder: (context, state) {
                final folder = (state as FolderScreenInitial).folder;
                return AppBar(
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
                    text: folder.title!,
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
                      // padding: 6,
                      height: 20,
                      icon: 'configure',
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => FolderBottomSheet(
                            folder: folder,
                            updateState: () {
                              folderScreenBloc.add(
                                FetchFolder(folderId: folder.folderId!),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height - kToolbarHeight + 5 - 63,
            ),
            child: Container(
              decoration: ShapeDecoration(
                color: NexusColors.backgroundColor,
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.only(
                    topLeft: SmoothRadius(
                      cornerRadius: 35,
                      cornerSmoothing: 0.8,
                    ),
                    topRight: SmoothRadius(
                      cornerRadius: 35,
                      cornerSmoothing: 0.8,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(children: [
                  BlocBuilder<FolderScreenBloc, FolderScreenState>(
                    builder: (context, state) {
                      Stream<List<ContentModel>> contents =
                          (state as FolderScreenInitial).folderContents;

                      return StreamBuilder<List<ContentModel>>(
                        stream: contents,
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
                            return Center(
                              child: StyledText(
                                text: 'No content available',
                                fontWeight: FontWeight.w500,
                                color: NexusColors.secondaryTextColor,
                              ),
                            );
                          }

                          List<ContentModel> contentList = snapshot.data!;

                          // ! use Expanded if want to use the following
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                date: DateTimeConversion.formattedDate(
                                  datetime: content.dateUpdated!,
                                ),
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
                          );
                        },
                      );
                    },
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
