part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {
  final PostModel post;
  final String userName;
  final String profilePicture;

  const PostInitial({
    required this.post,
    this.userName = '',
    this.profilePicture = '',
  });

  PostInitial copyWith({
    PostModel? post,
    String? userName,
    String? profilePicture,
  }) {
    return PostInitial(
      post: post ?? this.post,
      profilePicture: profilePicture ?? this.profilePicture,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object> get props => [post, userName, profilePicture];
}
