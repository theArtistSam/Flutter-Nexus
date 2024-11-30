import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/repositories/chat_repository.dart';
import 'package:nexus/repositories/extractive_model_repository.dart';
import 'package:nexus/services/abstractive_model_service.dart';
import 'package:nexus/services/extractive_model_service.dart';
import 'package:nexus/services/translation_model_service.dart';

part 'ai_chat_message_event.dart';
part 'ai_chat_message_state.dart';

class AiChatMessageBloc extends Bloc<AiChatMessageEvent, AiChatMessageState> {
  final ChatModel chat;
  AiChatMessageBloc({required this.chat})
      : super(AiChatMessageInitial(
          summarizationConfig: chat.summarizationConfig,
          translationConfig: chat.translationConfig,
        )) {
    on<FetchMessages>(fetchMessages);
    on<ToggleLike>(toggleLike);
    on<ToggleDisike>(toggleDisike);
    on<UpdateUpVoteStatus>(updateUpVoteStatus);
    on<UpdateDownVoteStatus>(updateDownVoteStatus);
    on<AddOriginalMessage>(addOriginalMessage);
    on<AddResponseMessage>(addResponseMessage);
    on<DeleteAIChat>(deleteAIChat);
    on<UpdateSummarizationConfig>(updateSummarizationConfig);
    on<UpdateTranslationConfig>(updateTranslationConfig);

    add(FetchMessages(documentId: chat.chatId!));
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

  // * Check this later
  FutureOr<void> addResponseMessage(
    AddResponseMessage event,
    Emitter<AiChatMessageState> emit,
  ) async {
    try {
      final currentState = state as AiChatMessageInitial;

      String responseMessage;
      // check the type of messsage
      if (chat.chatType == 'Translation') {
        //  TODO: Use this for the future functionality
        // final TranslationConfig config = currentState.translationConfig!;
        // final List<String> sourceLanguages = config.sourceLanguages!;
        // final List<String> targetLanguages = config.targetLanguages!;

        responseMessage =
            await TrasnlationModelService().sendText(text: event.text);
        print(responseMessage);
// // * Change this to Extractive Model Service
        await AIChatRepository().addChatMessage(
          userId: 'Bd4umkyLqOLnMpdOLZ0E',
          documentId: event.documentId,
          text: responseMessage.trim(),
          messageType: 'response',
        );

        // TODO: Send request to the translation model
      } else {
        final SummarizationConfig config = currentState.summarizationConfig!;
        final String modelType = config.type!;
        final String length = config.length!;

        if (modelType == 'extractive') {
          responseMessage = await ExtractiveModelService()
              .sendText(text: event.text, length: length);

// * Change this to Extractive Model Service
          await AIChatRepository().addChatMessage(
            userId: 'Bd4umkyLqOLnMpdOLZ0E',
            documentId: event.documentId,
            text: responseMessage.trim(),
            messageType: 'response',
          );
        } else {
          responseMessage = await AbstractiveModelService()
              .sendText(text: event.text, length: length);

          // * Change this to Abstractive Model Service
          await AIChatRepository().addChatMessage(
            userId: 'Bd4umkyLqOLnMpdOLZ0E',
            documentId: event.documentId,
            text: responseMessage.trim(),
            messageType: 'response',
          );
        }
      }
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

  FutureOr<void> updateSummarizationConfig(
      UpdateSummarizationConfig event, Emitter<AiChatMessageState> emit) {
    final currentState = state as AiChatMessageInitial;
    emit(currentState.copyWith(summarizationConfig: event.summarizationConfig));
  }

  FutureOr<void> updateTranslationConfig(
    UpdateTranslationConfig event,
    Emitter<AiChatMessageState> emit,
  ) {
    final currentState = state as AiChatMessageInitial;
    emit(currentState.copyWith(translationConfig: event.translationConfig));
  }
}
