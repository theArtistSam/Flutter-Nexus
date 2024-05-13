part of 'content_screen_bloc.dart';

sealed class ContentScreenEvent extends Equatable {
  const ContentScreenEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ToggleView extends ContentScreenEvent {
  bool isLeftSelected;
  ToggleView({required this.isLeftSelected});
}

// ignore: must_be_immutable
class ToggleContainerView extends ContentScreenEvent {
  bool isOriginal;
  ToggleContainerView({required this.isOriginal});
}

// ignore: must_be_immutable
class ToggleLikeDislike extends ContentScreenEvent {
  bool isLiked;
  ToggleLikeDislike({required this.isLiked});
}
