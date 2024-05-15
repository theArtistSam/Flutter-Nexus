part of 'chat_screen_bloc.dart';

sealed class ChatScreenState extends Equatable {
  const ChatScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ChatScreenInitial extends ChatScreenState {
  final bool isLeftSelected;
  final List<ChatModel> summaries;
  final List<ChatModel> translations;

  const ChatScreenInitial(
      {this.isLeftSelected = true,
      this.summaries = const <ChatModel>[],
      this.translations = const <ChatModel>[]});

  ChatScreenInitial copyWith(
      {bool? isLeftSelected,
      List<ChatModel>? summaries,
      List<ChatModel>? translations}) {
    return ChatScreenInitial(
      isLeftSelected: isLeftSelected ?? this.isLeftSelected,
      summaries: summaries ?? this.summaries,
      translations: translations ?? this.translations,
    );
  }

  @override
  List<Object> get props => [isLeftSelected, summaries, translations];
}
