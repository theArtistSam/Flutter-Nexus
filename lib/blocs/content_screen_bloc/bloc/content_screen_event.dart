part of 'content_screen_bloc.dart';

sealed class ContentScreenEvent extends Equatable {
  const ContentScreenEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ToggleTranslateSummarizeView extends ContentScreenEvent {
  bool isLeftSelected;
  ToggleTranslateSummarizeView({required this.isLeftSelected});
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

// ignore: must_be_immutable
class ContentScreenInitialEvent extends ContentScreenEvent {
  ContentModel content;
  ContentScreenInitialEvent({required this.content});
}
