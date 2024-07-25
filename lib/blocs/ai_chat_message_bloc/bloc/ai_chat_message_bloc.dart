import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/repositories/chat_repository.dart';
import 'package:nexus/repositories/extractive_model_repository.dart';

part 'ai_chat_message_event.dart';
part 'ai_chat_message_state.dart';

class AiChatMessageBloc extends Bloc<AiChatMessageEvent, AiChatMessageState> {
  AiChatMessageBloc() : super(const AiChatMessageInitial()) {
    on<FetchMessages>(fetchMessages);
    on<ToggleLike>(toggleLike);
    on<ToggleDisike>(toggleDisike);
    on<UpdateUpVoteStatus>(updateUpVoteStatus);
    on<UpdateDownVoteStatus>(updateDownVoteStatus);
    on<AddOriginalMessage>(addOriginalMessage);
    on<AddResponseMessage>(addResponseMessage);
    on<DeleteAIChat>(deleteAIChat);
  }

  FutureOr<void> fetchMessages(
      FetchMessages event, Emitter<AiChatMessageState> emit) {
    final currentState = state as AiChatMessageInitial;

    try {
      Stream<List<Chat>> messageList =
          AIChatRepository().getConversation(documentId: event.documentId);

      emit(currentState.copyWith(conversation: messageList));

      print('LOADING ... ');
    } catch (e) {
      print("SHIT FAILED TO LOAD MESSAGES...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> toggleLike(
      ToggleLike event, Emitter<AiChatMessageState> emit) async {
    try {
      await AIChatRepository().toggleLike(
        index: event.index,
        value: event.value,
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        documentId: event.documentId,
      );
    } catch (e) {
      print("ERROR NOT BEING ABLE TO LIKE");
    }
  }

  FutureOr<void> toggleDisike(
      ToggleDisike event, Emitter<AiChatMessageState> emit) async {
    try {
      await AIChatRepository().toggleDislike(
        index: event.index,
        value: event.value,
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        documentId: event.documentId,
      );
    } catch (e) {
      print("ERROR NOT BEING ABLE TO DISLIKE");
    }
  }

  FutureOr<void> updateUpVoteStatus(
      UpdateUpVoteStatus event, Emitter<AiChatMessageState> emit) async {
    try {
      // * Update the upvote status
      if (event.dislikeStatus) {
        await ExtractiveModelRepository().incrementUpVote();
        await ExtractiveModelRepository().decrementDownVote();
      } else {
        if (event.likeStatus) {
          await ExtractiveModelRepository().incrementUpVote();
        } else {
          await ExtractiveModelRepository().decrementUpVote();
        }
      }
    } catch (e) {
      print("NOT BEING ABLE TO UPDATE UPVOTE STATUS $e");
    }
  }

  FutureOr<void> updateDownVoteStatus(
      UpdateDownVoteStatus event, Emitter<AiChatMessageState> emit) async {
    try {
      // * Update the downvote status
      if (event.likeStatus) {
        await ExtractiveModelRepository().incrementDownVote();
        await ExtractiveModelRepository().decrementUpVote();
      } else {
        if (event.dislikeStatus) {
          await ExtractiveModelRepository().incrementDownVote();
        } else {
          await ExtractiveModelRepository().decrementDownVote();
        }
      }
    } catch (e) {
      print("NOT BEING ABLE TO UPDATE UPVOTE STATUS $e");
    }
  }

  FutureOr<void> addOriginalMessage(
      AddOriginalMessage event, Emitter<AiChatMessageState> emit) async {
    try {
      await AIChatRepository().addChatMessage(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        documentId: event.documentId,
        text: event.text,
        messageType: event.messageType,
      );
    } catch (e) {
      print("SOME ERROR WHILE ADDING CHAT MESSAGE $e");
    }
  }

  FutureOr<void> addResponseMessage(
      AddResponseMessage event, Emitter<AiChatMessageState> emit) async {
    try {
      final String responseMessage = await ExtractiveModelRepository()
          .sendRequest(text: event.text, length: 'medium');

      await AIChatRepository().addChatMessage(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        documentId: event.documentId,
        text: responseMessage.trim(),
        messageType: 'response',
      );
    } catch (e) {
      print("SOME ERROR WHILE ADDING CHAT MESSAGE $e");
    }
  }

  FutureOr<void> deleteAIChat(
      DeleteAIChat event, Emitter<AiChatMessageState> emit) async {
    try {
      await AIChatRepository().deleteAIChat(chatId: event.chatId);
    } catch (e) {
      print("SOME SHITTY ERROR WHILE DELETE $e");
    }
  }
}
