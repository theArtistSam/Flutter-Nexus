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

class SendTextMessage extends SupportChatEvent {
  final String message;
  final String documentId;
  final String senderId;
  const SendTextMessage({
    required this.message,
    required this.documentId,
    required this.senderId,
  });
}

class SendImageMessage extends SupportChatEvent {
  final String documentId;
  final String senderId;
  final XFile file;
  const SendImageMessage({
    required this.documentId,
    required this.senderId,
    required this.file,
  });
}
