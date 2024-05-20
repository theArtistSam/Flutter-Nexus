part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class HomeScreenInitial extends HomeScreenState {
  List<ContentModel> contents;
  ContentStatus status;

  HomeScreenInitial(
      {this.contents = const <ContentModel>[],
      this.status = ContentStatus.loading});

  HomeScreenInitial copyWith(
      {List<ContentModel>? contents, ContentStatus? status}) {
    return HomeScreenInitial(
        contents: contents ?? this.contents, status: status ?? this.status);
  }

  @override
  List<Object> get props => [contents, status];
}

// ignore: must_be_immutable
// final class HomeScreenLoadContent extends HomeScreenState {
// }
