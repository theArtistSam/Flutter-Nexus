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

class ToggleLike extends AiChatMessageEvent {
  final bool value;
  final int index;
  final String documentId;
  const ToggleLike({
    required this.value,
    required this.index,
    required this.documentId,
  });
}

class ToggleDisike extends AiChatMessageEvent {
  final bool value;
  final int index;
  final String documentId;
  const ToggleDisike({
    required this.value,
    required this.index,
    required this.documentId,
  });
}

class UpdateUpVoteStatus extends AiChatMessageEvent {
  final bool likeStatus;
  final bool dislikeStatus;
  const UpdateUpVoteStatus({
    required this.likeStatus,
    required this.dislikeStatus,
  });
}

class UpdateDownVoteStatus extends AiChatMessageEvent {
  final bool likeStatus;
  final bool dislikeStatus;
  const UpdateDownVoteStatus({
    required this.likeStatus,
    required this.dislikeStatus,
  });
}

class AddOriginalMessage extends AiChatMessageEvent {
  final String text;
  final String messageType;
  final String documentId;
  const AddOriginalMessage({
    required this.text,
    required this.messageType,
    required this.documentId,
  });
}

class AddResponseMessage extends AiChatMessageEvent {
  final String text;
  final String documentId;
  const AddResponseMessage({
    required this.text,
    required this.documentId,
  });
}

class DeleteAIChat extends AiChatMessageEvent {
  final String chatId;
  const DeleteAIChat({required this.chatId});
}
