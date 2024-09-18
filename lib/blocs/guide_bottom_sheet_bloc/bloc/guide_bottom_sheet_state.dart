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
  final GuideModel guide;
  final double duration;

  const GuideBottomSheetInitial({
    this.sliderValue = 0,
    this.isPaused = false,
    this.elapsedValue = 0,
    required this.guide,
    this.duration = 0,
  });

  GuideBottomSheetInitial copyWith({
    double? sliderValue,
    bool? isPaused,
    double? elapsedValue,
    GuideModel? guide,
    double? duration,
  }) {
    return GuideBottomSheetInitial(
      sliderValue: sliderValue ?? this.sliderValue,
      elapsedValue: elapsedValue ?? this.elapsedValue,
      isPaused: isPaused ?? this.isPaused,
      guide: guide ?? this.guide,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object> get props => [sliderValue, isPaused, guide, duration];
}
