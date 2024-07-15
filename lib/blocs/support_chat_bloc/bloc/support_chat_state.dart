part of 'support_chat_bloc.dart';

sealed class SupportChatState extends Equatable {
  const SupportChatState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class SupportChatInitial extends SupportChatState {
  Stream<List<Message>> conversation;

  SupportChatInitial({
    Stream<List<Message>>? conversation,
  }) : conversation =
            (conversation ?? const Stream.empty()).asBroadcastStream();

  SupportChatInitial copyWith({
    Stream<List<Message>>? conversation,
  }) {
    return SupportChatInitial(
      conversation: conversation ?? this.conversation,
    );
  }

  @override
  List<Object> get props => [conversation];
}
