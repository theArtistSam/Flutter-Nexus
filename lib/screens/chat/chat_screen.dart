import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/blocs/chat_screen_bloc/bloc/chat_screen_bloc.dart';
import 'package:nexus/blocs/extractive_model_bloc/bloc/extractive_model_bloc.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/extractive_model.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/utils/enums.dart';
import 'package:nexus/widgets/content_configure_bottomsheet.dart';
import 'package:nexus/widgets/styled_text.dart';
import 'package:nexus/widgets/styled_icon_button.dart';
import 'package:nexus/widgets/styled_tabs.dart';
import 'package:nexus/widgets/styled_textfield.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  late ChatScreenBloc chatScreenBloc;
  late ExtractiveModelBloc extractiveModelBloc;
  @override
  void initState() {
    chatScreenBloc = ChatScreenBloc();
    extractiveModelBloc = ExtractiveModelBloc();

    //  FOR NOW JUST KEEP SUMMARIZATION
    chatScreenBloc.add(ToggleView(isLeftSelected: false));
    super.initState();
  }

  @override
  void dispose() {
    chatScreenBloc.close();
    extractiveModelBloc.close();
    controller.dispose();
    super.dispose();
  }

  void toggleView(bool isLeftSelected) {
    chatScreenBloc.add(ToggleView(isLeftSelected: isLeftSelected));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatScreenBloc>.value(value: chatScreenBloc),
        BlocProvider<ExtractiveModelBloc>.value(value: extractiveModelBloc),
      ],
      child: Scaffold(
          backgroundColor: NexusColors.accentColorLight,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 5),
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
                title: StyledText(text: 'Chat with AI', fontSize: 24),
                actions: [
                  StyledIconButton(
                    icon: 'menu',
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) =>
                              const ContentConfigureBottomSheet() // Add actual content
                          );
                    },
                  ),
                ],
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
              child: Column(
                children: [
                  StyledTabs(
                    leftTabText: 'Translate',
                    rightTabText: 'Summarize',
                    changeState: toggleView,
                    // isLeftSelected: false,
                  ),
                  const SizedBox(height: 15),
                  const Divider(
                    height: 1,
                    color: NexusColors.dividerColor,
                  ),
                  BlocListener<ExtractiveModelBloc, ExtractiveModelState>(
                    listener: (context, state) {
                      if (state is ExtractiveModelInitial &&
                          state.status == ModelStatus.success) {
                        chatScreenBloc.add(
                          NewChatSummary(
                            chat: ChatModel(
                                user: 'ai',
                                message: state.message,
                                type: 'summarization'),
                          ),
                        );
                      }
                      // ADD AN ELSE IN CASE OF ERROR
                      // REMOVE PREVIOUS ADDED ITEM
                    },
                    child: BlocBuilder<ChatScreenBloc, ChatScreenState>(
                      builder: (context, state) {
                        if (state is ChatScreenInitial) {
                          bool isLeftSelected = state.isLeftSelected;
                          List<ChatModel> chatList = isLeftSelected
                              ? state.translations
                              : state.summaries;
                          return coversation(
                              isTranslation: isLeftSelected, chatList: chatList
                              // userChat:
                              //     "What were they eating? It didn't taste like anything she had ever eaten before and although she was famished, she didn't dare ask. She knew the answer would be one she didn't want to hear.",
                              // aiChat: isLeftSelected
                              //     ? "وہ کیا کھا رہے تھے؟ اس کا ذائقہ ایسا نہیں تھا جو اس نے پہلے کبھی کھایا ہو اور اگرچہ وہ بھوکی تھی، اس نے پوچھنے کی ہمت نہیں کی۔ وہ جانتی تھی کہ جواب وہی ہوگا جو وہ سننا نہیں چاہتی تھی۔"
                              //     : "What were they eating? It didn't taste like anything she had ever eaten before and although she was famished");
                              );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(
                    // 190
                    height: 106,
                  )
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: StyledTextfield(
                      icon: null,
                      maxlines: 5,
                      // FOR NOW LET"S KEEP IT SUMMARIZE
                      hintText: 'Write text to summarize',
                      controller: controller,
                    ),
                  ),
                  const SizedBox(width: 10),
                  StyledIconButton(
                    icon: 'arrow-up',
                    backgroundColor: NexusColors.primaryColorLight,
                    onTap: () => {
                      if (controller.text.isNotEmpty)
                        {
                          extractiveModelBloc.add(
                            FetchModelResult(text: controller.text),
                          ),
                          chatScreenBloc.add(
                            NewChatSummary(
                              chat: ChatModel(
                                user: 'user',
                                message: controller.text,
                                type: 'summarization',
                              ),
                            ),
                          ),
                          controller.clear()
                        }
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }

  userChat({required chat}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                color: NexusColors.accentColorLight,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 0.8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: StyledText(
                  text: chat,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );

  aiChat({required chat, isTranslation = true}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                color: NexusColors.primaryColorLight,
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 15, cornerSmoothing: 0.8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: isTranslation
                    ? Text(
                        chat,
                        style: GoogleFonts.notoNastaliqUrdu(
                          color: NexusColors.textColorLight,
                          height: 2,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      )
                    : StyledText(
                        text: chat,
                        fontWeight: FontWeight.w500,
                        color: NexusColors.textColorLight,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ClipOval(
            child: Image.asset(
              'assets/images/profile-picture.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );

  coversation(
          {required bool isTranslation, required List<ChatModel> chatList}) =>
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 15),
          reverse: true,
          itemCount: chatList.length, // Number of items
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 15); // Separator between items
          },
          itemBuilder: (BuildContext context, int index) {
            final recent = chatList.length - index - 1;
            if (chatList[recent].user == 'user') {
              return userChat(chat: chatList[recent].message);
            }
            return aiChat(
              isTranslation: isTranslation,
              chat: chatList[recent].message,
            );
          },
        ),
      );
}
