import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexus/blocs/ai_chat_bloc/bloc/ai_chat_bloc.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/screens/chat/ai_chat_message_screen.dart';
import 'package:nexus/screens/chat/widgets/chat_category_bottom_sheet.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/styled_widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key, required this.controller});

  final ScrollController controller;
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  late AiChatBloc aiChatBloc;

  @override
  void initState() {
    aiChatBloc = AiChatBloc();
    aiChatBloc.add(FetchChats());
    super.initState();
  }

  @override
  void dispose() {
    aiChatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => aiChatBloc,
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
                'assets/icons/message-filled-2.svg',
                // COLOR: FIX
                color: NexusColors.isDark
                    ? Colors.white
                    : NexusColors.primaryColor,
              ),
              title: StyledText(
                text: 'AI Chat',
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
                  icon: 'plus',
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const ChatCategoryBottomSheet(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: widget.controller,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height - (kToolbarHeight + 5) - 53,
            ),
            child: DecoratedBox(
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
                child: BlocBuilder<AiChatBloc, AiChatState>(
                  builder: (context, state) {
                    Stream<List<ChatModel>> issues =
                        (state as AiChatInitial).messages;

                    return StreamBuilder<List<ChatModel>>(
                      stream: issues,
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
                            child: Text('No chats yet'),
                          );
                        }
                        List<ChatModel> messageList = snapshot.data!;

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messageList.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (BuildContext context, int index) {
                            ChatModel messageModel = messageList[index];
                            print(messageList.length);
                            return chatTile(
                              message: messageModel,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => AIChatMessageScreen(
                                      chat: messageModel,
                                    ),
                                  ),
                                );
                              },
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
        ),
      ),
    );
  }

  chatTile({required ChatModel message, required VoidCallback onTap}) {
    String lastMessageTime = DateTimeConversion.getTime(
      datetime: message.conversation!.last.datetime!,
    );

    String lastMessage = message.conversation!.last.text!;

    if (lastMessage.split('').length > 10 &&
        message.conversation!.last.messageType == 'response') {
      lastMessage = '${lastMessage.split(' ').take(10).join(' ')}...';
    }
    // * use this for selection rendering profile picture and
    // * user name for the tile
    bool isOriginal = message.conversation!.last.messageType! == 'original';

    bool isUrdu = message.chatType == 'Translation' && !isOriginal;

    return GestureDetector(
      onTap: onTap,
      child: Column(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
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
                            text: isOriginal ? 'Dunn Oliver' : 'AI Chat',
                            fontSize: 16,
                            color: NexusColors.textColor,
                          ),
                          const Spacer(),
                          StyledText(
                            text: lastMessageTime,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: NexusColors.textColor.withOpacity(.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      StyledText(
                        isUrdu: isUrdu,
                        text: lastMessage,
                        fontSize: 14,
                        color: NexusColors.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: NexusColors.backgroundColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: StyledText(
                    text: "● ${message.chatType!}",
                    fontSize: 12,
                    // COLOR: FIX
                    color: NexusColors.isDark
                        ? NexusColors.textColor
                        : NexusColors.primaryColorLight,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
