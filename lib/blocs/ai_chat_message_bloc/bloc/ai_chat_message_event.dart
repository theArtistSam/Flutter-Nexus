part of 'ai_chat_message_bloc.dart';

sealed class AiChatMessageEvent extends Equatable {
  const AiChatMessageEvent();

  @override
  List<Object> get props => [];
}

class FetchMessages extends AiChatMessageEvent {
  final String documentId;
  const FetchMessages({required this.documentId});
}
