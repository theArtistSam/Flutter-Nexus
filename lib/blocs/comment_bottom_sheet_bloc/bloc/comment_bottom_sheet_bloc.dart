import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/comment_model.dart';
import 'package:nexus/repositories/comment_repository.dart';

part 'comment_bottom_sheet_event.dart';
part 'comment_bottom_sheet_state.dart';

class CommentBottomSheetBloc
    extends Bloc<CommentBottomSheetEvent, CommentBottomSheetState> {
  CommentBottomSheetBloc() : super(CommentBottomSheetInitial()) {
    on<FetchComments>(fetchComments);
    on<LikeComment>(likeComment);
    on<DislikeComment>(dislikeComment);
    on<AddComment>(addComment);
  }

  FutureOr<void> fetchComments(
    FetchComments event,
    Emitter<CommentBottomSheetState> emit,
  ) {
    final currentState = state as CommentBottomSheetInitial;

    try {
      Stream<List<CommentModel>> commentList =
          CommentRepository().getAllComments(documentId: event.postId);
      emit(currentState.copyWith(comments: commentList));

      print('LOADING COMMENTS... ');
    } catch (e) {
      print("SHIT FAILED TO LOAD COMMENTS...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> likeComment(
    LikeComment event,
    Emitter<CommentBottomSheetState> emit,
  ) async {
    final currentState = state as CommentBottomSheetInitial;

    try {
      await CommentRepository().likeComment(
          postId: event.postId,
          userId: event.userId,
          commentId: event.commentId);
      // Simply re-render the screen
      emit(currentState.copyWith(comments: currentState.comments));

      print('LIKED THE COMMENT ... ');
    } catch (e) {
      print("SHIT FAILED TO LIKE THE COMMENT...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> dislikeComment(
    DislikeComment event,
    Emitter<CommentBottomSheetState> emit,
  ) async {
    final currentState = state as CommentBottomSheetInitial;

    try {
      await CommentRepository().dislikeComment(
        postId: event.postId,
        userId: event.userId,
        commentId: event.commentId,
      );
      // Simply re-render the screen
      emit(currentState.copyWith(comments: currentState.comments));

      print('DISLIKED THE COMMENT ... ');
    } catch (e) {
      print("SHIT FAILED TO DISLIKE THE COMMENT...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> addComment(
    AddComment event,
    Emitter<CommentBottomSheetState> emit,
  ) async {
    final currentState = state as CommentBottomSheetInitial;

    try {
      await CommentRepository().addComment(
        postId: event.postId,
        userId: event.userId,
        text: event.text,
      );
      // Simply re-render the screen
      emit(currentState.copyWith(comments: currentState.comments));

      print('ADDED THE COMMENT ... ');
    } catch (e) {
      print("SHIT FAILED TO ADD THE COMMENT...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
