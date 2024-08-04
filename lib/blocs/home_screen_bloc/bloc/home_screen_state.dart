part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class HomeScreenInitial extends HomeScreenState {
  Stream<List<ContentModel>> contents;
  Stream<List<GuideModel>> guides;
  ContentStatus status;

  HomeScreenInitial({
    this.contents = const Stream.empty(),
    this.guides = const Stream.empty(),
    this.status = ContentStatus.loading,
  });

  HomeScreenInitial copyWith({
    Stream<List<ContentModel>>? contents,
    ContentStatus? status,
    Stream<List<GuideModel>>? guides,
  }) {
    return HomeScreenInitial(
      contents: contents ?? this.contents,
      status: status ?? this.status,
      guides: guides ?? this.guides,
    );
  }

  @override
  List<Object> get props => [contents, status, guides];
}

// ignore: must_be_immutable
// final class HomeScreenLoadContent extends HomeScreenState {
// }
