import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/comment_bottom_sheet_bloc/bloc/comment_bottom_sheet_bloc.dart';
import 'package:nexus/models/comment_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';
import 'package:nexus/widgets/styled_widgets/styled_textfield.dart';

class CommentBottomSheet extends StatefulWidget {
  const CommentBottomSheet({
    super.key,
    required this.height,
    required this.context,
    required this.postId,
  });

  final double height;
  final BuildContext context;
  final String postId;

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late CommentBottomSheetBloc commentBottomSheetBloc;
  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    commentBottomSheetBloc = CommentBottomSheetBloc();
    commentBottomSheetBloc.add(FetchComments(postId: widget.postId));
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    commentBottomSheetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => commentBottomSheetBloc,
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
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 15,
                bottom: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        color: NexusColors.borderColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StyledText(
                    text: 'Comments',
                    color: NexusColors.textColor,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: height -
                        210 -
                        MediaQuery.of(widget.context).viewInsets.bottom,
                    child: BlocBuilder<CommentBottomSheetBloc,
                        CommentBottomSheetState>(
                      builder: (context, state) {
                        Stream<List<CommentModel>> comments =
                            (state as CommentBottomSheetInitial).comments;

                        return StreamBuilder<List<CommentModel>>(
                          stream: comments,
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
                                child: StyledText(text: 'No comments'),
                              );
                            }
                            List<CommentModel> commentList = snapshot.data!;

                            return ListView.separated(
                              padding: const EdgeInsets.all(0),
                              itemCount: commentList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 10),
                              itemBuilder: (BuildContext context, int index) {
                                final comment = commentList[index];
                                return commentTile(comment: comment);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: StyledTextfield(
                            hintText: 'Add a comment...',
                            controller: textEditingController,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        StyledIconButton(
                          icon: 'arrow-up',
                          backgroundColor: textEditingController.text.isNotEmpty
                              ? NexusColors.primaryColor
                              : NexusColors.primaryColor.withOpacity(.5),
                          onTap: () {
                            final String text =
                                textEditingController.text.trim();
                            if (text.isNotEmpty) {
                              commentBottomSheetBloc.add(
                                AddComment(
                                  postId: widget.postId,
                                  userId: 'Bd4umkyLqOLnMpdOLZ0E',
                                  text: text,
                                ),
                              );
                              textEditingController.text = '';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  commentTile({required CommentModel comment}) {
    final bool isLiked = comment.likedBy!.contains('Bd4umkyLqOLnMpdOLZ0E');
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                color: NexusColors.accentColor,
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 15,
                      cornerSmoothing: 0.8,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 30,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/profile-picture.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        StyledText(
                          text: 'Dunn Oliver',
                          fontSize: 16,
                          color: NexusColors.textColor,
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    StyledText(
                      text: comment.text ?? '',
                      fontSize: 14,
                      color: NexusColors.textColor,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        Positioned(
          left: 10,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: NexusColors.accentColor,
              border: Border.all(
                color: NexusColors.backgroundColor,
                width: 2,
              ),
              borderRadius: const SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: 100,
                  cornerSmoothing: .8,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                right: 15,
                top: 1,
                bottom: 1,
              ),
              child: Row(
                children: [
                  StyledIconButton(
                    icon: isLiked ? 'like-filled' : 'like',
                    height: 20,
                    // COLOR: FIX
                    iconColor: NexusColors.isDark
                        ? Colors.white
                        : NexusColors.primaryColor,
                    backgroundColor: NexusColors.accentColor,
                    onTap: () {
                      if (isLiked) {
                        commentBottomSheetBloc.add(DislikeComment(
                          postId: widget.postId,
                          userId: 'Bd4umkyLqOLnMpdOLZ0E',
                          commentId: comment.commentId!,
                        ));
                      } else {
                        commentBottomSheetBloc.add(LikeComment(
                          postId: widget.postId,
                          userId: 'Bd4umkyLqOLnMpdOLZ0E',
                          commentId: comment.commentId!,
                        ));
                      }
                    },
                  ),
                  StyledText(
                    text: '${comment.totalLikes}',
                    fontSize: 14,
                    // COLOR: FIX

                    color: NexusColors.isDark
                        ? Colors.white
                        : NexusColors.primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
