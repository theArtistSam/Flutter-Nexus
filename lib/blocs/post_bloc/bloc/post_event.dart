part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LikePost extends PostEvent {}

class DislikePost extends PostEvent {}

class SavePost extends PostEvent {}

class UnsavePost extends PostEvent {}

class DeletePost extends PostEvent {}

class FetchUserCredientials extends PostEvent {}
