part of 'audio_bottom_sheet_bloc.dart';

sealed class AudioBottomSheetState extends Equatable {
  const AudioBottomSheetState();

  @override
  List<Object> get props => [];
}

final class AudioBottomSheetInitial extends AudioBottomSheetState {
  final bool isPlaying;
  final Duration currentPosition;
  const AudioBottomSheetInitial({
    this.isPlaying = false,
    this.currentPosition = Duration.zero,
  });

  AudioBottomSheetInitial copyWith({
    bool? isPlaying,
    Duration? currentPosition,
    Duration? totalDuration,
    String? url,
  }) {
    return AudioBottomSheetInitial(
      isPlaying: isPlaying ?? this.isPlaying,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }

  @override
  List<Object> get props => [isPlaying, currentPosition];
}
