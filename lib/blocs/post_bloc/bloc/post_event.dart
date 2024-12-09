part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LikePost extends PostEvent {
  final String postId;

  const LikePost({required this.postId});
}

class DislikePost extends PostEvent {
  final String postId;

  const DislikePost({
    required this.postId,
  });
}

class SavePost extends PostEvent {
  final String postId;

  const SavePost({
    required this.postId,
  });
}

class UnsavePost extends PostEvent {
  final String postId;

  const UnsavePost({
    required this.postId,
  });
}

class DeletePost extends PostEvent {
  final String postId;
  const DeletePost({required this.postId});
}
