part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class HomeScreenInitial extends HomeScreenState {
  final Stream<List<ContentModel>> contents;
  final Stream<List<GuideModel>> guides;
  final String profilePicture;
  final String userName;

  ContentStatus status;

  HomeScreenInitial({
    this.contents = const Stream.empty(),
    this.guides = const Stream.empty(),
    this.status = ContentStatus.loading,
    this.profilePicture = '',
    this.userName = '',
  });

  HomeScreenInitial copyWith({
    Stream<List<ContentModel>>? contents,
    ContentStatus? status,
    Stream<List<GuideModel>>? guides,
    String? profilePicture,
    String? userName,
  }) {
    return HomeScreenInitial(
      contents: contents ?? this.contents,
      status: status ?? this.status,
      guides: guides ?? this.guides,
      profilePicture: profilePicture ?? this.profilePicture,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object> get props =>
      [contents, status, guides, profilePicture, userName, userName];
}

// ignore: must_be_immutable
// final class HomeScreenLoadContent extends HomeScreenState {
// }
