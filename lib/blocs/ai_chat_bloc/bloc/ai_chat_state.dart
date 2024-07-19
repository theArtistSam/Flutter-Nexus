// ignore_for_file: must_be_immutable

part of 'ai_chat_bloc.dart';

sealed class AiChatState extends Equatable {
  const AiChatState();

  @override
  List<Object> get props => [];
}

final class AiChatInitial extends AiChatState {
  Stream<List<ChatModel>> messages;

  AiChatInitial({this.messages = const Stream.empty()});

  AiChatInitial copyWith({Stream<List<ChatModel>>? messages}) {
    return AiChatInitial(messages: messages ?? this.messages);
  }

  @override
  List<Object> get props => [messages];
}
