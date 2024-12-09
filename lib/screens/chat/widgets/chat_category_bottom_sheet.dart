import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/blocs/chat_category_bottom_sheet_bloc/bloc/chat_category_bottom_sheet_bloc.dart';
import 'package:nexus/utils/constants.dart';
import 'package:nexus/widgets/category_tile.dart';
import 'package:nexus/widgets/styled_widgets/styled_button.dart';
import 'package:nexus/widgets/styled_widgets/styled_text.dart';

class ChatCategoryBottomSheet extends StatefulWidget {
  const ChatCategoryBottomSheet({super.key});

  @override
  State<ChatCategoryBottomSheet> createState() =>
      _ChatCategoryBottomSheetState();
}

class _ChatCategoryBottomSheetState extends State<ChatCategoryBottomSheet> {
  late ChatCategoryBottomSheetBloc chatCategoryBottomSheetBloc;

  @override
  void initState() {
    chatCategoryBottomSheetBloc = ChatCategoryBottomSheetBloc();
    chatCategoryBottomSheetBloc.add(FetchModelCategories());

    super.initState();
  }

  @override
  void dispose() {
    chatCategoryBottomSheetBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => chatCategoryBottomSheetBloc,
      child: Wrap(
        children: [
          Container(
            // height: height - 40,
            decoration: ShapeDecoration(
              color: NexusColors.backgroundColor,
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 0.8,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                    text: 'Chat Type',
                    color: NexusColors.textColor,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 600,
                    child: BlocBuilder<ChatCategoryBottomSheetBloc,
                        ChatCategoryBottomSheetState>(
                      builder: (context, state) {
                        final currentState =
                            (state as ChatCategoryBottomSheetInitial);
                        final models = currentState.models;
                        return ListView.separated(
                          itemCount: models.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (BuildContext context, int index) {
                            final model = models[index];
                            return CategoryTile(
                              title: model.type!,
                              tagline: model.tagline!,
                              icon: model.icon!,
                              isSelected: currentState.selectedIndex == index,
                              onTap: () {
                                chatCategoryBottomSheetBloc.add(
                                  SelectModelCategory(index: index),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StyledButton(
                    text: 'Proceed',
                    onTap: () async {
                      final state = (chatCategoryBottomSheetBloc.state
                          as ChatCategoryBottomSheetInitial);
                      final int index = state.selectedIndex;

                      Map<int, String> chatType = {
                        0: "Summarization",
                        1: "Translation",
                      };
                      chatCategoryBottomSheetBloc.add(
                        AddAIChat(chatType: chatType[index]!),
                      );
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
