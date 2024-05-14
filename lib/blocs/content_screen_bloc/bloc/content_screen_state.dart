part of 'content_screen_bloc.dart';

sealed class ContentScreenState extends Equatable {
  const ContentScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class ContentScreenInitial extends ContentScreenState {
  bool isLeftSelected;
  bool isOriginal;
  bool isLiked;
  ContentScreenInitial(
      {this.isLeftSelected = true,
      this.isOriginal = false,
      this.isLiked = false});

  ContentScreenInitial copyWith(
      {bool? isLeftSelected, bool? isOriginal, bool? isLiked}) {
    return ContentScreenInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected,
        isOriginal: isOriginal ?? this.isOriginal,
        isLiked: isLiked ?? this.isLiked);
  }

  @override
  List<Object> get props => [isLeftSelected, isOriginal, isLiked];
}
