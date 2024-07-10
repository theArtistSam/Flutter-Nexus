part of 'comment_bottom_sheet_bloc.dart';

sealed class CommentBottomSheetEvent extends Equatable {
  const CommentBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends CommentBottomSheetEvent {
  final String postId;
  const FetchComments({required this.postId});
}

class LikeComment extends CommentBottomSheetEvent {
  final String postId;
  final String userId;
  final String commentId;
  const LikeComment({
    required this.postId,
    required this.userId,
    required this.commentId,
  });
}

class DislikeComment extends CommentBottomSheetEvent {
  final String postId;
  final String userId;
  final String commentId;
  const DislikeComment({
    required this.postId,
    required this.userId,
    required this.commentId,
  });
}

class AddComment extends CommentBottomSheetEvent {
  final String postId;
  final String userId;
  final String text;
  const AddComment({
    required this.postId,
    required this.userId,
    required this.text,
  });
}
