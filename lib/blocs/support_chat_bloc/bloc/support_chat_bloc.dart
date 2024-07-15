import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/support_model.dart';
import 'package:nexus/repositories/support_repository.dart';

part 'support_chat_event.dart';
part 'support_chat_state.dart';

class SupportChatBloc extends Bloc<SupportChatEvent, SupportChatState> {
  SupportChatBloc() : super(SupportChatInitial()) {
    on<FetchMessages>(fetchMessages);
    on<SendMessage>(sendMessage);
  }

  FutureOr<void> fetchMessages(
    FetchMessages event,
    Emitter<SupportChatState> emit,
  ) {
    final currentState = state as SupportChatInitial;

    try {
      Stream<List<Message>> messageList = SupportRepository()
          .getConversation(documentId: event.documentId)
          .asBroadcastStream();
      emit(currentState.copyWith(conversation: messageList));

      print('LOADING ... ');
    } catch (e) {
      print("SHIT FAILED TO LOAD MESSAGES...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> sendMessage(
      SendMessage event, Emitter<SupportChatState> emit) async {
    final currentState = state as SupportChatInitial;

    try {
      await SupportRepository().addMessage(
        documentId: event.documentId,
        message: event.message,
        senderId: event.senderId,
      );

      // Simply re-render the screen
      emit(currentState.copyWith(conversation: currentState.conversation));

      print('SENT THE MESSAGE ... ');
    } catch (e) {
      print("SHIT FAILED TO SEND THE MESSAGE...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
