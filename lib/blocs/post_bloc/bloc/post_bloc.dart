import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/repositories/community_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<LikePost>(likePost);
    on<DislikePost>(dislikePost);
    on<SavePost>(savePost);
    on<UnsavePost>(unsavePost);
    on<DeletePost>(deletePost);
  }

  FutureOr<void> likePost(LikePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().likePost(
        postId: event.postId,
      );

      print('LIKED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO LIKE THE POST...");
    }
  }

  FutureOr<void> dislikePost(DislikePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().dislikePost(
        postId: event.postId,
      );

      print('DISLIKED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO DISLIKE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> savePost(SavePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().savePost(
        postId: event.postId,
      );
      print('SAVED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO SAVE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> unsavePost(UnsavePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().unsavePost(
        postId: event.postId,
      );
      print('UNSAVED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO UNSAVE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> deletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().deletePost(postId: event.postId);
      print("POST DELETED!!");
    } catch (e) {
      print("SHIT FAILED TO DELETE THE POST");
    }
  }
}
