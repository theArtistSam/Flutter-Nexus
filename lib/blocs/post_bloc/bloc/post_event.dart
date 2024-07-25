part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LikePost extends PostEvent {
  final String postId;
  final String userId;
  const LikePost({required this.postId, required this.userId});
}

class DislikePost extends PostEvent {
  final String postId;
  final String userId;
  const DislikePost({required this.postId, required this.userId});
}

class SavePost extends PostEvent {
  final String postId;
  final String userId;
  const SavePost({required this.postId, required this.userId});
}

class UnsavePost extends PostEvent {
  final String postId;
  final String userId;
  const UnsavePost({required this.postId, required this.userId});
}

class DeletePost extends PostEvent {
  final String postId;
  const DeletePost({required this.postId});
}
