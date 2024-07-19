import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/repositories/chat_repository.dart';

part 'ai_chat_message_event.dart';
part 'ai_chat_message_state.dart';

class AiChatMessageBloc extends Bloc<AiChatMessageEvent, AiChatMessageState> {
  AiChatMessageBloc() : super(const AiChatMessageInitial()) {
    on<FetchMessages>(fetchMessages);
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
}
