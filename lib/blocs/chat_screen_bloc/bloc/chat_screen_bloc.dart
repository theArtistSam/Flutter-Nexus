import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';

part 'chat_screen_event.dart';
part 'chat_screen_state.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  ChatScreenBloc() : super(const ChatScreenInitial()) {
    on<ToggleView>(toggleView);
    on<NewChatSummary>(newChat);
  }

  FutureOr<void> toggleView(ToggleView event, Emitter<ChatScreenState> emit) {
    final currentState = (state as ChatScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }

  FutureOr<void> newChat(NewChatSummary event, Emitter<ChatScreenState> emit) {
    final currentState = (state as ChatScreenInitial);
    final List<ChatModel> updatedSummaries = List.from(currentState.summaries)
      ..add(event.chat);
    emit(currentState.copyWith(summaries: updatedSummaries));
  }
}
