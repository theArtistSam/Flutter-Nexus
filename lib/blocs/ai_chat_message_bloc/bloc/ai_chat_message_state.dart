part of 'ai_chat_message_bloc.dart';

sealed class AiChatMessageState extends Equatable {
  const AiChatMessageState();

  @override
  List<Object> get props => [];
}

final class AiChatMessageInitial extends AiChatMessageState {
  final Stream<List<Chat>> conversation;

  const AiChatMessageInitial({this.conversation = const Stream.empty()});

  AiChatMessageInitial copyWith({Stream<List<Chat>>? conversation}) {
    return AiChatMessageInitial(
        conversation: conversation ?? this.conversation);
  }

  @override
  List<Object> get props => [conversation];
}
