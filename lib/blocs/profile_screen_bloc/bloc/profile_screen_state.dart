part of 'profile_screen_bloc.dart';

sealed class ProfileScreenState extends Equatable {
  const ProfileScreenState();

  @override
  List<Object> get props => [];
}

final class ProfileScreenInitial extends ProfileScreenState {
  final String userId;
  final UserModel? user;
  final Stream<List<PostModel>> posts;

  const ProfileScreenInitial({
    required this.userId,
    this.user,
    this.posts = const Stream.empty(),
  });

  ProfileScreenInitial copyWith({
    String? userId,
    UserModel? user,
    Stream<List<PostModel>>? posts,
  }) {
    return ProfileScreenInitial(
      userId: userId ?? this.userId,
      user: user ?? UserModel(),
      posts: posts ?? this.posts,
    );
  }

  @override
  List<Object> get props => [userId, user ?? UserModel(), posts];
}
