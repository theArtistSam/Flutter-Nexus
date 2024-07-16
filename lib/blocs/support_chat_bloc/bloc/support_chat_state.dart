part of 'support_chat_bloc.dart';

sealed class SupportChatState extends Equatable {
  const SupportChatState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class SupportChatInitial extends SupportChatState {
  Stream<List<Message>> conversation;

  SupportChatInitial({this.conversation = const Stream.empty()});

  SupportChatInitial copyWith({Stream<List<Message>>? conversation}) {
    return SupportChatInitial(
      conversation: conversation ?? this.conversation,
    );
  }

  @override
  List<Object> get props => [conversation];
}
