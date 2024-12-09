import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/model_configs/summarization_config.dart';
import 'package:nexus/models/model_configs/translation_config.dart';
import 'package:nexus/repositories/chat_repository.dart';
import 'package:nexus/repositories/model_repository.dart';
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
    FetchMessages event,
    Emitter<AiChatMessageState> emit,
  ) {
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
    ToggleLike event,
    Emitter<AiChatMessageState> emit,
  ) async {
    try {
      await AIChatRepository().toggleLike(
        index: event.index,
        value: event.value,
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
        documentId: event.documentId,
      );
    } catch (e) {
      print("ERROR NOT BEING ABLE TO DISLIKE");
    }
  }

  FutureOr<void> updateUpVoteStatus(
    UpdateUpVoteStatus event,
    Emitter<AiChatMessageState> emit,
  ) async {
    try {
      final currentState = state as AiChatMessageInitial;
      final Stream<List<Chat>> chatStream = currentState.conversation;

      // Convert the stream into a list to access individual chat messages
      final List<Chat> chatList = await chatStream.first;

      // Ensure the index is within bounds
      if (event.index < 0 || event.index >= chatList.length) {
        throw Exception("Invalid index: ${event.index}");
      }

      // Get the single chat message response ID
      final String? responseId = chatList[event.index].responseMessageId;

      if (responseId == null || responseId.isEmpty) {
        throw Exception(
            "Response ID is null or empty for index: ${event.index}");
      }

      final ModelRepository modelRepo = ModelRepository(documentId: responseId);

      // Update upvote and downvote status
      if (event.dislikeStatus) {
        await modelRepo
            .incrementUpVote(); // Increment upvote for dislike action
        await modelRepo
            .decrementDownVote(); // Decrement downvote for dislike action
      } else if (event.likeStatus) {
        await modelRepo.incrementUpVote(); // Increment upvote for like action
      } else {
        await modelRepo.decrementUpVote(); // Decrement upvote when no like
      }

      print("UPVOTE STATUS UPDATED SUCCESSFULLY");
    } catch (e) {
      print("NOT ABLE TO UPDATE UPVOTE STATUS: $e");
    }
  }

  FutureOr<void> updateDownVoteStatus(
    UpdateDownVoteStatus event,
    Emitter<AiChatMessageState> emit,
  ) async {
    try {
      final currentState = state as AiChatMessageInitial;
      final Stream<List<Chat>> chatStream = currentState.conversation;

      // Convert the stream into a list to access individual chat messages
      final List<Chat> chatList = await chatStream.first;

      // Ensure the index is within bounds
      if (event.index < 0 || event.index >= chatList.length) {
        throw Exception("Invalid index: ${event.index}");
      }

      // Get the single chat message response ID
      final String? responseId = chatList[event.index].responseMessageId;

      if (responseId == null || responseId.isEmpty) {
        throw Exception(
            "Response ID is null or empty for index: ${event.index}");
      }

      ModelRepository modelRepo = ModelRepository(documentId: responseId);

      // Update downvote and upvote status
      if (event.likeStatus) {
        await modelRepo
            .incrementDownVote(); // Increment downvote for like action
        await modelRepo.decrementUpVote(); // Decrement upvote for like action
      } else if (event.dislikeStatus) {
        await modelRepo
            .incrementDownVote(); // Increment downvote for dislike action
      } else {
        await modelRepo
            .decrementDownVote(); // Decrement downvote when neither like nor dislike
      }

      print("DOWNVOTE STATUS UPDATED SUCCESSFULLY");
    } catch (e) {
      print("NOT ABLE TO UPDATE DOWNVOTE STATUS: $e");
    }
  }

  FutureOr<void> addOriginalMessage(
    AddOriginalMessage event,
    Emitter<AiChatMessageState> emit,
  ) async {
    try {
      await AIChatRepository().addChatMessage(
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
            documentId: event.documentId,
            text: responseMessage.trim(),
            messageType: 'response',
            reponseMessageId: 'zkb0ysUiZpKSFcnoaoQD' // translation model id
            );
      } else {
        final SummarizationConfig config = currentState.summarizationConfig!;
        final String modelType = config.type!;
        final String length = config.length!;

        if (modelType == 'extractive') {
          responseMessage = await ExtractiveModelService()
              .sendText(text: event.text, length: length);

          await AIChatRepository().addChatMessage(
            documentId: event.documentId,
            text: responseMessage.trim(),
            messageType: 'response',
            reponseMessageId: 'FNJAQivoRd7ouJOcQesX',
          );
        } else {
          responseMessage = await AbstractiveModelService()
              .sendText(text: event.text, length: length);

          // * Change this to Abstractive Model Service
          await AIChatRepository().addChatMessage(
            documentId: event.documentId,
            text: responseMessage.trim(),
            messageType: 'response',
            reponseMessageId: 'FigG5uIMlUEw1IAlSsBr',
          );
        }
      }
    } catch (e) {
      print("SOME ERROR WHILE ADDING CHAT MESSAGE $e");
    }
  }

  FutureOr<void> deleteAIChat(
    DeleteAIChat event,
    Emitter<AiChatMessageState> emit,
  ) async {
    try {
      await AIChatRepository().deleteAIChat(chatId: event.chatId);
    } catch (e) {
      print("SOME SHITTY ERROR WHILE DELETE $e");
    }
  }

  FutureOr<void> updateSummarizationConfig(
    UpdateSummarizationConfig event,
    Emitter<AiChatMessageState> emit,
  ) async {
    final currentState = state as AiChatMessageInitial;

    try {
      await AIChatRepository().updateSummarizationConfig(
        chatId: chat.chatId!,
        summarizationConfig: event.summarizationConfig,
      );
    } catch (e) {
      print("Some error occurred $e");
    }
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
