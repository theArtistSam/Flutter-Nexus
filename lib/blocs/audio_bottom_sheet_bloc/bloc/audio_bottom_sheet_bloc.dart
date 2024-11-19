import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_bottom_sheet_event.dart';
part 'audio_bottom_sheet_state.dart';

class AudioBottomSheetBloc
    extends Bloc<AudioBottomSheetEvent, AudioBottomSheetState> {
  AudioBottomSheetBloc() : super(const AudioBottomSheetInitial()) {
    on<UpdateCurrentPosition>(updateCurrentPosition);
    on<PauseAudio>(pauseAudio);
    on<PlayAudio>(playAudio);
  }

  FutureOr<void> updateCurrentPosition(
      UpdateCurrentPosition event, Emitter<AudioBottomSheetState> emit) {
    final currentState = state as AudioBottomSheetInitial;
    emit(currentState.copyWith(
      isPlaying: true,
      currentPosition: event.currentPosition,
    ));
  }

  FutureOr<void> pauseAudio(
      PauseAudio event, Emitter<AudioBottomSheetState> emit) {
    final currentState = state as AudioBottomSheetInitial;
    emit(currentState.copyWith(
        currentPosition: currentState.currentPosition, isPlaying: false));
  }

  FutureOr<void> playAudio(
      PlayAudio event, Emitter<AudioBottomSheetState> emit) {
    final currentState = state as AudioBottomSheetInitial;
    emit(currentState.copyWith(
        currentPosition: currentState.currentPosition, isPlaying: true));
  }
}
