part of 'audio_bottom_sheet_bloc.dart';

sealed class AudioBottomSheetEvent extends Equatable {
  const AudioBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class FetchAudioFile extends AudioBottomSheetEvent {}

class PauseAudio extends AudioBottomSheetEvent {}

class PlayAudio extends AudioBottomSheetEvent {}

class UpdateCurrentPosition extends AudioBottomSheetEvent {
  final Duration currentPosition;
  const UpdateCurrentPosition({required this.currentPosition});
}
