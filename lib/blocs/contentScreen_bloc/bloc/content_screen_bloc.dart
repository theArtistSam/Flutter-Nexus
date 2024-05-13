import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'content_screen_event.dart';
part 'content_screen_state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState> {
  ContentScreenBloc() : super(ContentScreenInitial()) {
    on<ToggleView>(toggleView);
    on<ToggleContainerView>(toggleContainerView);
    on<ToggleLikeDislike>(toggleLikeDislike);
  }

  FutureOr<void> toggleView(
      ToggleView event, Emitter<ContentScreenState> emit) {
    final currentState = (state as ContentScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }

  FutureOr<void> toggleContainerView(
      ToggleContainerView event, Emitter<ContentScreenState> emit) {
    final currentState = (state as ContentScreenInitial);
    emit(
      currentState.copyWith(isOriginal: event.isOriginal),
    );
  }

  FutureOr<void> toggleLikeDislike(
      ToggleLikeDislike event, Emitter<ContentScreenState> emit) {
    final currentState = (state as ContentScreenInitial);
    emit(currentState.copyWith(isLiked: event.isLiked));
  }
}
