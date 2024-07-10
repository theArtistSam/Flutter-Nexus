part of 'comment_bottom_sheet_bloc.dart';

sealed class CommentBottomSheetState extends Equatable {
  const CommentBottomSheetState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class CommentBottomSheetInitial extends CommentBottomSheetState {
  Stream<List<CommentModel>> comments;

  CommentBottomSheetInitial({this.comments = const Stream.empty()});

  CommentBottomSheetInitial copyWith({Stream<List<CommentModel>>? comments}) {
    return CommentBottomSheetInitial(comments: comments ?? this.comments);
  }

  @override
  List<Object> get props => [comments];
}
