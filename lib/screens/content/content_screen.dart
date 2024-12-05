import 'package:cached_network_image/cached_network_image.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/blocs/content_screen_bloc/bloc/content_screen_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/model_configs/translation_config.dart';
import 'package:nexus/screens/content/widgets/edit_bottom_sheet.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/bottom_sheets/audio_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/image_slider_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/summarization_config/summarization_config_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/translation_config_bottom_sheet.dart';
import 'package:nexus/widgets/bottom_sheets/video_bottom_sheet.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_snackbar.dart';
import 'package:nexus/widgets/styled_widgets/styled_tabs.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

// ignore: must_be_immutable
class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key, required this.content});

  final ContentModel content;
  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late ContentScreenBloc contentScreenBloc;

  @override
  void initState() {
    contentScreenBloc = ContentScreenBloc(content: widget.content);
    super.initState();
  }

  @override
  void dispose() {
    contentScreenBloc.close();
    super.dispose();
  }

  void toggleView(bool isLeftSelected) {
    contentScreenBloc
        .add(ToggleTranslateSummarizeView(isLeftSelected: isLeftSelected));
  }

  @override
  Widget build(BuildContext context) {
    final appbarHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => contentScreenBloc,
      child: Scaffold(
        backgroundColor: NexusColors.accentColor,
        body: SizedBox(
          child: Stack(
            children: [
              BlocBuilder<ContentScreenBloc, ContentScreenState>(
                builder: (context, state) {
                  final currentState = state as ContentScreenInitial;
                  return CachedNetworkImage(
                    imageUrl: currentState.content.thumbnail!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 410,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
              ),

              Container(
                height: 410,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.3), // Start color (0% black)
                      Colors.black.withOpacity(0.5), // End color (90% black)
                    ],
                  ),
                  // borderRadius: BorderRadius.circular(15),
                ),
              ),
              // Appbar
              SizedBox(
                height: 410,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: appbarHeight,
                      ),
                      Row(
                        children: [
                          StyledIconButton(
                            icon: 'back-arrow',
                            onTap: () => Navigator.pop(context),
                            backgroundColor: Colors.black26,
                            padding: 15,
                          ),
                          const Spacer(),
                          StyledIconButton(
                            icon: 'pencil-filled',
                            height: 20,
                            onTap: () {
                              bool isConfirmed = false;
                              final state = (contentScreenBloc.state
                                  as ContentScreenInitial);
                              final ContentModel content = state.content;

                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return BlocProvider.value(
                                      value: contentScreenBloc,
                                      child: EditBottomSheet(
                                        onConfirm: () {
                                          isConfirmed = true;
                                          // Add an event to update content
                                          contentScreenBloc.add(
                                            UpdateContent(),
                                          );
                                          StyledSnackbar.show(
                                            context: context,
                                            message: "Content updated",
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  } // Add actual content
                                  ).whenComplete(
                                () {
                                  if (!isConfirmed) {
                                    contentScreenBloc.add(
                                      RevertChanges(content: content),
                                    );
                                  }
                                },
                              );
                            },
                            padding: 11.5,
                            backgroundColor: Colors.black26,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          StyledIconButton(
                            icon: 'setting-filled',
                            onTap: () {
                              final state = contentScreenBloc.state
                                  as ContentScreenInitial;
                              final ContentModel content = state.content;
                              final bool isTranslation = state.isLeftSelected;

                              if (isTranslation) {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      // TODO: Future Update!
                                      TranslationConfigBottomSheet(
                                    chatId: content.contentId!,
                                    translationConfig: TranslationConfig(
                                      sourceLanguages: ['English'],
                                      targetLanguages: ['Urdu'],
                                    ),
                                  ),
                                );
                              } else {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      SummarizationConfigBottomSheet(
                                    onConfirm: (
                                        {required summarizationConfig}) {
                                      contentScreenBloc.add(
                                        UpdateSummarizationConfig(
                                          config: summarizationConfig,
                                        ),
                                      );

                                      StyledSnackbar.show(
                                          context: context,
                                          message: "Content Updated!");
                                    },
                                    docId: content.contentId!,
                                    summarizationConfig: content
                                        .summarization!.summarizationConfig!,
                                  ),
                                );
                              }
                            },
                            backgroundColor: Colors.black26,
                          )
                        ],
                      ),
                      const Spacer(),
                      contentIconButton(
                        title: _buttonText(type: widget.content.type!),
                        icon: widget.content.type!,
                        onTap: () async {
                          final String? link = widget.content.link;
                          final String type = widget.content.type!;

                          if (link == null) {
                            StyledSnackbar.show(
                                context: context,
                                message:
                                    '${type[0].toUpperCase() + type.substring(1)} file is still uploading');
                          } else {
                            if (type == 'document') {
                              // * use url launcher to download the file
                              // "https://firebasestorage.googleapis.com/v0/b/nexus-ef4c1.appspot.com/o/users%2FBd4umkyLqOLnMpdOLZ0E%2Fcontent%2Fc3QGMiK0Hhka3iLmXso7%2Fsample-doc.docx?alt=media&token=c29ac290-893b-458d-8a76-14f478559543"

                              //  the attribute is coming as a link

                              // TODO: Develop a document previewer for opening docs
                              StyledSnackbar.show(
                                context: context,
                                message: 'Impelmenting document viewer!!',
                              );
                            } else {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return _contentPlayerBottomSheet(
                                    type: type,
                                    link: link,
                                  );
                                }, // Add actual content
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<ContentScreenBloc, ContentScreenState>(
                        builder: (context, state) {
                          final currentState = state as ContentScreenInitial;
                          return StyledText(
                            text: currentState.content.title ?? '',
                            color: NexusColors.textColorLight,
                            fontSize: 18,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),

              DraggableScrollableSheet(
                initialChildSize: (screenHeight - 410 + 40) / screenHeight,
                minChildSize: (screenHeight - 410 + 40) / screenHeight,
                maxChildSize: .95,
                builder: (context, controller) =>
                    contentBottomSheet(controller),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentPlayerBottomSheet({
    required String type,
    required String link,
  }) {
    switch (type) {
      case 'audio':
        return AudioBottomSheet(url: link);
      case 'video':
        return VideoBottomSheet(
          url: link,
        );
      case 'document':
        return SizedBox();
      default:
        return ImageSliderBottomSheet(images: [link]);
    }
  }

  String _buttonText({required String type}) {
    switch (type) {
      case 'audio':
        return 'Listen complete audio';
      case 'video':
        return 'Watch complete video';
      case 'document':
        return 'View complete document';
      case 'image':
        return 'View complete image';
      default:
        return '';
    }
  }

  contentIconButton({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: SmoothBorderRadius(cornerRadius: 15),
          onTap: onTap,
          child: Ink(
            decoration: ShapeDecoration(
              color: Colors.black45,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: .8,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  StyledText(
                    text: title,
                    color: NexusColors.textColorLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  contentTile({
    isOpen,
    openTitle,
    closeTitle,
    text,
    onTap,
    isTranslation = false,
  }) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 15,
            cornerSmoothing: .8,
          ),
          onTap: onTap,
          child: Ink(
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
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: isTranslation
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StyledText(
                        fontSize: 14,
                        text: isOpen ? openTitle : closeTitle,
                        // COLOR: FIX
                        color: NexusColors.isDark
                            ? Colors.white54
                            : NexusColors.primaryColorLight,
                      ),
                      const Spacer(),
                      !isOpen
                          ? SvgPicture.asset(
                              'assets/icons/small-arrow-down.svg',
                              // COLOR: FIX
                              color: NexusColors.isDark
                                  ? Colors.white54
                                  : NexusColors.primaryColorLight,
                            )
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(height: isOpen ? 10 : 0),
                  isOpen
                      ? isTranslation
                          ? Text(
                              text,
                              style: GoogleFonts.notoNastaliqUrdu(
                                // COLOR: FIX
                                color: NexusColors.isDark
                                    ? Colors.white
                                    : NexusColors.textColor,
                                height: 2.1,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            )
                          : StyledText(
                              fontSize: 16,
                              text: text,
                              fontWeight: FontWeight.w500,
                              // COLOR: FIX
                              color: NexusColors.isDark
                                  ? Colors.white
                                  : NexusColors.textColor,
                            )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget contentBottomSheet(controller) {
    bool _isOptionsAvailable({
      required ContentScreenInitial state,
    }) {
      if (state.isLeftSelected) {
        return state.content.translation != null && state.isLeftSelected;
      }
      return state.content.summarization != null && !state.isLeftSelected;
    }

    String _getLikeIcon(ContentScreenInitial state) {
      final status = state.isLeftSelected
          ? state.content.translation?.status
          : state.content.summarization?.status;

      return status?.isLiked == true ? 'like-filled' : 'like';
    }

    String _getDislikeIcon(ContentScreenInitial state) {
      final status = state.isLeftSelected
          ? state.content.translation?.status
          : state.content.summarization?.status;

      return status?.isDisliked == true ? 'dislike-filled' : 'dislike';
    }

    void _updateUpvoteStatus(bool isLiked, bool isDisliked) {
      contentScreenBloc.add(
        UpdateUpVoteStatus(
          likeStatus: isLiked,
          dislikeStatus: isDisliked,
        ),
      );
    }

    void _updateDownvoteStatus(bool isLiked, bool isDisliked) {
      contentScreenBloc.add(
        UpdateDownVoteStatus(
          likeStatus: isLiked,
          dislikeStatus: isDisliked, // Toggle the dislike status
        ),
      );
    }

    return Container(
      decoration: ShapeDecoration(
        color: NexusColors.backgroundColor,
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.only(
            topLeft: SmoothRadius(cornerRadius: 25, cornerSmoothing: .8),
            topRight: SmoothRadius(cornerRadius: 25, cornerSmoothing: .8),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Stack(
          children: [
            ListView(
              key: UniqueKey(),
              padding: const EdgeInsets.only(top: 95),
              controller: controller,
              children: [
                BlocBuilder<ContentScreenBloc, ContentScreenState>(
                  builder: (context, state) {
                    if (state is ContentScreenInitial) {
                      bool isLeftSelected = state.isLeftSelected;
                      return Column(
                        children: [
                          contentTile(
                            onTap: () {
                              contentScreenBloc.add(
                                ToggleContainerView(isOriginal: true),
                              );
                            },
                            isOpen: state.isOriginal ? true : false,
                            openTitle: 'Original',
                            closeTitle: 'View original text',
                            text: widget.content.extractedText,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // This one can help with both translation and summarization
                          contentTile(
                              onTap: () {
                                contentScreenBloc.add(
                                    ToggleContainerView(isOriginal: false));
                              },
                              isTranslation: isLeftSelected,
                              isOpen: state.isOriginal ? false : true,
                              openTitle:
                                  isLeftSelected ? 'Translation' : 'Summary',
                              closeTitle: isLeftSelected
                                  ? 'View Translation'
                                  : 'View summary',
                              text: isLeftSelected
                                  ? widget.content.translation?.text ??
                                      'کوئی ترجمہ دستیاب نہیں ہے۔'
                                  : widget.content.summarization?.text ??
                                      'No Summary available'),

                          const SizedBox(height: 10),
                          _isOptionsAvailable(state: state)
                              ? Row(
                                  children: [
                                    StyledIconButton(
                                      icon: 'rotate-left',
                                      onTap: () {},
                                      backgroundColor: NexusColors.accentColor,
                                      iconColor: NexusColors.isDark
                                          ? Colors.white
                                          : NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledIconButton(
                                      icon: 'arrow-down',
                                      onTap: () {},
                                      backgroundColor: NexusColors.accentColor,
                                      iconColor: NexusColors.isDark
                                          ? Colors.white
                                          : NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledIconButton(
                                      icon: 'share',
                                      onTap: () {},
                                      backgroundColor: NexusColors.accentColor,
                                      iconColor: NexusColors.isDark
                                          ? Colors.white
                                          : NexusColors.primaryColorLight,
                                    ),
                                    const SizedBox(width: 5),
                                    StyledIconButton(
                                      icon: 'pencil',
                                      onTap: () {},
                                      height: 20,
                                      backgroundColor: NexusColors.accentColor,
                                      iconColor: NexusColors.isDark
                                          ? Colors.white
                                          : NexusColors.primaryColorLight,
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        StyledIconButton(
                                          icon: _getLikeIcon(state),
                                          onTap: () {
                                            final bool isTranslation =
                                                state.isLeftSelected;
                                            final Status status = isTranslation
                                                ? state.content.translation!
                                                    .status!
                                                : state.content.summarization!
                                                    .status!;

                                            final bool isDisliked =
                                                status.isDisliked ?? false;
                                            final bool isLiked =
                                                status.isLiked ?? false;

                                            // Toggle the like status
                                            final bool newLikeStatus = !isLiked;

                                            // Trigger content like update
                                            contentScreenBloc.add(
                                              LikeContent(value: newLikeStatus),
                                            );

                                            // Update the upvote status
                                            _updateUpvoteStatus(
                                              newLikeStatus,
                                              isDisliked,
                                            );
                                          },
                                          backgroundColor:
                                              NexusColors.accentColor,
                                          iconColor: NexusColors.isDark
                                              ? Colors.white
                                              : NexusColors.primaryColorLight,
                                        ),
                                        const SizedBox(width: 5),
                                        StyledIconButton(
                                          icon: _getDislikeIcon(state),
                                          onTap: () {
                                            final bool isTranslation =
                                                state.isLeftSelected;
                                            final Status status = isTranslation
                                                ? state.content.translation!
                                                    .status!
                                                : state.content.summarization!
                                                    .status!;

                                            final bool isDisliked =
                                                status.isDisliked ?? false;
                                            final bool isLiked =
                                                status.isLiked ?? false;

                                            // Toggle the dislike status
                                            final bool newDislikeStatus =
                                                !isDisliked;

                                            // Trigger content dislike update
                                            contentScreenBloc.add(
                                              DislikeContent(
                                                value: newDislikeStatus,
                                              ),
                                            );

                                            // Update the downvote status
                                            _updateDownvoteStatus(
                                              isLiked,
                                              newDislikeStatus,
                                            );
                                          },
                                          backgroundColor:
                                              NexusColors.accentColor,
                                          // COLOR: FIX
                                          iconColor: NexusColors.isDark
                                              ? Colors.white
                                              : NexusColors.primaryColorLight,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      print("Generate that thing!");
                                    },
                                    child: Ink(
                                      width: double.infinity,
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
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Center(
                                          child: StyledText(
                                            text: 'Generate',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            // color: NexusColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 30),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
            // been put at the end to act as a sticky header
            Container(
              height: 95,
              color: NexusColors.backgroundColor,
              child: Column(
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
                  StyledTabs(
                    leftTabText: 'Translate',
                    rightTabText: 'Summarize',
                    changeState: toggleView,
                    // isLeftSelected: false
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // )
                  // const Divider(
                  //   height: 30,
                  //   color: NexusColors.dividerColor,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
