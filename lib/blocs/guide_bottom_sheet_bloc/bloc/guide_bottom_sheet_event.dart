part of 'guide_bottom_sheet_bloc.dart';

sealed class GuideBottomSheetEvent extends Equatable {
  const GuideBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class StartTimer extends GuideBottomSheetEvent {
  final double endTime;
  const StartTimer({this.endTime = 15});
}

class TogglePauseResume extends GuideBottomSheetEvent {
  final bool value;
  const TogglePauseResume({required this.value});
}

class UpdateSlider extends GuideBottomSheetEvent {
  final double value;
  const UpdateSlider({required this.value});
}

class LikeGuide extends GuideBottomSheetEvent {
  final String guideId;
  const LikeGuide({required this.guideId});
}

class DislikeGuide extends GuideBottomSheetEvent {
  final String guideId;
  const DislikeGuide({required this.guideId});
}
