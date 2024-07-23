import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/ai_chat_message_bloc/bloc/ai_chat_message_bloc.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/repositories/extractive_model_repository.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/content_configure_bottom_sheet.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_text.dart';
import 'package:nexus/widgets/styled_textfield.dart';

class AIChatMessageScreen extends StatefulWidget {
  const AIChatMessageScreen({super.key, required this.chat});

  final ChatModel chat;
  @override
  State<AIChatMessageScreen> createState() => _AIChatMessageScreenState();
}

class _AIChatMessageScreenState extends State<AIChatMessageScreen> {
  late TextEditingController _textEditingController;
  late ScrollController _scrollController;
  late AiChatMessageBloc aiChatMessageBloc;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    aiChatMessageBloc = AiChatMessageBloc();
    aiChatMessageBloc.add(FetchMessages(documentId: widget.chat.chatId!));
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    aiChatMessageBloc.close();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocProvider(
      create: (context) => aiChatMessageBloc,
      child: Scaffold(
        // COLOR: FIX
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
              automaticallyImplyLeading: false,
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
              title: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/profile-picture.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        text: 'AI Model',
                        fontSize: 16,
                        color: NexusColors.textColor,
                      ),
                      const Row(
                        children: [
                          StyledText(
                            text: 'Available',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: NexusColors.confirmColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
                      builder: (context) => const ContentConfigureBottomSheet(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
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
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 85,
                right: 20,
                left: 20,
              ),
              child: BlocBuilder<AiChatMessageBloc, AiChatMessageState>(
                builder: (context, state) {
                  Stream<List<Chat>> conversation =
                      (state as AiChatMessageInitial).conversation;

                  return StreamBuilder<List<Chat>>(
                    stream: conversation,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No messages yet'),
                        );
                      }
                      List<Chat> messageList = snapshot.data!;

                      // Scroll to bottom after messages are loaded
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: messageList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 15),
                        itemBuilder: (BuildContext context, int index) {
                          Chat message = messageList[index];

                          if (message.messageType! == 'response') {
                            return modelChat(
                              message: message,
                              index: index,
                            );
                          }
                          return userChat(
                            message: message,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: NexusColors.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 0), // x, y values
                blurRadius: 25,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10 + bottomPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: StyledTextfield(
                    maxlines: 3,
                    // FOR NOW LET"S KEEP IT SUMMARIZE
                    hintText: widget.chat.chatType == 'Summarization'
                        ? 'Enter text summarize...'
                        : 'Enter text to translate...',
                    controller: _textEditingController,
                  ),
                ),
                const SizedBox(width: 10),
                StyledIconButton(
                  icon: 'arrow-up',
                  backgroundColor: _textEditingController.text.isEmpty
                      ? NexusColors.primaryColor.withOpacity(0.5)
                      : NexusColors.primaryColor,
                  onTap: () async {
                    if (_textEditingController.text.isNotEmpty) {
                      String message = _textEditingController.text.trim();
                      // Add the original messsage
                      aiChatMessageBloc.add(AddOriginalMessage(
                        text: message,
                        messageType: 'original',
                        documentId: widget.chat.chatId!,
                      ));

                      // Add response message
                      aiChatMessageBloc.add(AddResponseMessage(
                        text: message,
                        documentId: widget.chat.chatId!,
                      ));

                      _textEditingController.text = '';
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  modelChat({
    required Chat message,
    required int index,
  }) {
    final bool isLiked = message.responseStatus!.isLiked!;
    final bool isDisliked = message.responseStatus!.isDisliked!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 20),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile-picture.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  decoration: ShapeDecoration(
                    color: NexusColors.primaryColor,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 15,
                        cornerSmoothing: 0.8,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 22),
                    child: StyledText(
                      text: message.text!,
                      fontSize: 14,
                      color: NexusColors.textColorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 0,
                child: Row(
                  children: [
                    StyledIconButton(
                      icon: message.responseStatus!.isLiked!
                          ? 'like-filled'
                          : 'like',
                      isBordered: true,
                      height: 20,
                      borderColor: NexusColors.backgroundColor,
                      padding: 7,
                      onTap: () {
                        if (isLiked) {
                          aiChatMessageBloc.add(
                            ToggleLike(
                              value: false,
                              index: index,
                              documentId: widget.chat.chatId!,
                            ),
                          );

                          // * Update upvote status
                          aiChatMessageBloc.add(
                            UpdateUpVoteStatus(
                              likeStatus: false,
                              dislikeStatus: isDisliked,
                            ),
                          );
                        } else {
                          aiChatMessageBloc.add(
                            ToggleLike(
                              value: true,
                              index: index,
                              documentId: widget.chat.chatId!,
                            ),
                          );

                          // * Update upvote status
                          aiChatMessageBloc.add(
                            UpdateUpVoteStatus(
                              likeStatus: true,
                              dislikeStatus: isDisliked,
                            ),
                          );
                        }
                      },
                    ),
                    StyledIconButton(
                      icon: message.responseStatus!.isDisliked!
                          ? 'dislike-filled'
                          : 'dislike',
                      height: 20,
                      padding: 7,
                      isBordered: true,
                      borderColor: NexusColors.backgroundColor,
                      onTap: () {
                        if (isDisliked) {
                          aiChatMessageBloc.add(
                            ToggleDisike(
                              value: false,
                              index: index,
                              documentId: widget.chat.chatId!,
                            ),
                          );
                          // * Update downvote status
                          aiChatMessageBloc.add(
                            UpdateDownVoteStatus(
                              likeStatus: isLiked,
                              dislikeStatus: false,
                            ),
                          );
                        } else {
                          aiChatMessageBloc.add(
                            ToggleDisike(
                              value: true,
                              index: index,
                              documentId: widget.chat.chatId!,
                            ),
                          );
                          // * Update downvote status
                          aiChatMessageBloc.add(
                            UpdateDownVoteStatus(
                              likeStatus: isLiked,
                              dislikeStatus: true,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  userChat({
    required Chat message,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
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
                  child: StyledText(
                    text: message.text!,
                    fontSize: 14,
                    color: NexusColors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile-picture.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
