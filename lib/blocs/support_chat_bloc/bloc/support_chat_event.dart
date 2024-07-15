part of 'support_chat_bloc.dart';

sealed class SupportChatEvent extends Equatable {
  const SupportChatEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class FetchMessages extends SupportChatEvent {
  final String documentId;
  const FetchMessages({required this.documentId});
}

class SendMessage extends SupportChatEvent {
  final String message;
  final String documentId;
  final String senderId;
  const SendMessage({
    required this.message,
    required this.documentId,
    required this.senderId,
  });
}
