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
  final XFile? profileImage;
  final XFile? backgroundImage;

  const ProfileScreenInitial({
    required this.userId,
    this.user,
    this.posts = const Stream.empty(),
    this.profileImage,
    this.backgroundImage,
  });

  ProfileScreenInitial copyWith({
    String? userId,
    UserModel? user,
    Stream<List<PostModel>>? posts,
    XFile? profileImage,
    XFile? backgroundImage,
  }) {
    return ProfileScreenInitial(
      userId: userId ?? this.userId,
      user: user ?? UserModel(),
      posts: posts ?? this.posts,
      profileImage: profileImage,
      backgroundImage: backgroundImage,
    );
  }

  @override
  List<Object> get props => [
        userId,
        user ?? UserModel(),
        posts,
        profileImage ?? '',
        backgroundImage ?? '',
      ];
}
