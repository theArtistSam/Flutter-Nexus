import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/repositories/chat_repository.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc() : super(AiChatInitial()) {
    on<FetchChats>(fetchChats);
  }

  FutureOr<void> fetchChats(FetchChats event, Emitter<AiChatState> emit) async {
    final currentState = state as AiChatInitial;

    try {
      Stream<List<ChatModel>> messageList =
          AIChatRepository().getAllChats(userId: 'Bd4umkyLqOLnMpdOLZ0E');

      // print(await messageList.length);
      emit(currentState.copyWith(messages: messageList));

      print('LOADING ... ');
    } catch (e) {
      print("SHIT FAILED TO LOAD MESSAGES...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
