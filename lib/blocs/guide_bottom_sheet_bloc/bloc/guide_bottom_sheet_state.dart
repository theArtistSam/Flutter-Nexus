part of 'guide_bottom_sheet_bloc.dart';

sealed class GuideBottomSheetState extends Equatable {
  const GuideBottomSheetState();

  @override
  List<Object> get props => [];
}

final class GuideBottomSheetInitial extends GuideBottomSheetState {
  final double sliderValue;
  final double elapsedValue;
  final bool isPaused;
  final double duration;
  final bool isLiked;
  const GuideBottomSheetInitial({
    this.sliderValue = 0,
    this.isPaused = false,
    this.elapsedValue = 0,
    this.duration = 0,
    required this.isLiked,
  });

  GuideBottomSheetInitial copyWith({
    double? sliderValue,
    bool? isPaused,
    double? elapsedValue,
    bool? isLiked,
    double? duration,
  }) {
    return GuideBottomSheetInitial(
      sliderValue: sliderValue ?? this.sliderValue,
      elapsedValue: elapsedValue ?? this.elapsedValue,
      isPaused: isPaused ?? this.isPaused,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object> get props => [sliderValue, isPaused, duration, isLiked];
}
