import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_screen_event.dart';
part 'chat_screen_state.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  ChatScreenBloc() : super(ChatScreenInitial()) {
    on<ToggleView>(toggleView);
  }

  FutureOr<void> toggleView(ToggleView event, Emitter<ChatScreenState> emit) {
    final currentState = (state as ChatScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }
}
