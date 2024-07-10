part of 'community_bloc.dart';

sealed class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends CommunityEvent {}

class LikePost extends CommunityEvent {
  final String postId;
  final String userId;
  const LikePost({required this.postId, required this.userId});
}

class DislikePost extends CommunityEvent {
  final String postId;
  final String userId;
  const DislikePost({required this.postId, required this.userId});
}

class SavePost extends CommunityEvent {
  final String postId;
  final String userId;
  const SavePost({required this.postId, required this.userId});
}

class UnsavePost extends CommunityEvent {
  final String postId;
  final String userId;
  const UnsavePost({required this.postId, required this.userId});
}
