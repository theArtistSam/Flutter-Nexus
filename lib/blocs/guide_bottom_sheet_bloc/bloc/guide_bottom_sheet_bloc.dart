import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:nexus/models/guide_model.dart';
import 'package:nexus/repositories/community_repository.dart';

part 'guide_bottom_sheet_event.dart';
part 'guide_bottom_sheet_state.dart';

class GuideBottomSheetBloc
    extends Bloc<GuideBottomSheetEvent, GuideBottomSheetState> {
  Timer? _timer;
  int _currentValue = 0;
  // final GuideModel guide;
  GuideBottomSheetBloc({required GuideModel guide})
      : super(GuideBottomSheetInitial(guide: guide)) {
    on<UpdateSlider>(updateSlider);
    on<StartTimer>(startTimer);
    on<TogglePauseResume>(togglePauseResume);
    on<LikeGuide>(likeGuide);
    on<DislikeGuide>(dislikeGuide);
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentValue >= 15) {
        _stop();
      } else {
        _currentValue++;
        add(UpdateSlider(value: _currentValue.toDouble()));
      }
    });
  }

  FutureOr<void> updateSlider(
      UpdateSlider event, Emitter<GuideBottomSheetState> emit) {
    emit(
      (state as GuideBottomSheetInitial).copyWith(sliderValue: event.value),
    );
  }

  FutureOr<void> startTimer(
      StartTimer event, Emitter<GuideBottomSheetState> emit) async {
    _start();
  }

  FutureOr<void> togglePauseResume(
      TogglePauseResume event, Emitter<GuideBottomSheetState> emit) {
    if (event.value) {
      // Pausing the timer
      _stop();
      emit(
        (state as GuideBottomSheetInitial).copyWith(
          isPaused: true,
          sliderValue: _currentValue.toDouble(),
          elapsedValue: _currentValue.toDouble(),
        ),
      );
    } else {
      // Resuming the timer
      _currentValue = (state as GuideBottomSheetInitial).elapsedValue.toInt();
      _start();
      emit(
        (state as GuideBottomSheetInitial).copyWith(
          isPaused: false,
          sliderValue: _currentValue.toDouble(),
        ),
      );
    }
  }

  FutureOr<void> likeGuide(
      LikeGuide event, Emitter<GuideBottomSheetState> emit) async {
    final currentState = (state as GuideBottomSheetInitial);
    try {
      await CommunityRepository().likeGuide(guideId: event.guideId);
      List<String> likedBy =
          await CommunityRepository().getLikedBy(guideId: event.guideId);
      final guide = currentState.guide!.copyWith(likedBy: likedBy);
      emit(currentState.copyWith(guide: guide));
      print("GUIDE LIKED SUCCESSFULLY");
    } catch (e) {
      print("SOME ERROR OCCURED $e");
    }
  }

  FutureOr<void> dislikeGuide(
      DislikeGuide event, Emitter<GuideBottomSheetState> emit) async {
    final currentState = (state as GuideBottomSheetInitial);
    try {
      await CommunityRepository().dislikeGuide(guideId: event.guideId);
      List<String> likedBy =
          await CommunityRepository().getLikedBy(guideId: event.guideId);
      final guide = currentState.guide!.copyWith(likedBy: likedBy);
      emit(currentState.copyWith(guide: guide));
      print("GUIDE DISLIKED SUCCESSFULLY");
    } catch (e) {
      print("SOME ERROR OCCURED $e");
    }
  }
}
