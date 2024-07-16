import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/repositories/community_repository.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc() : super(const CommunityInitial()) {
    on<FetchPosts>(fetchPosts);
    on<LikePost>(likePost);
    on<DislikePost>(dislikePost);
    on<SavePost>(savePost);
    on<UnsavePost>(unsavePost);
  }

  FutureOr<void> fetchPosts(FetchPosts event, Emitter<CommunityState> emit) {
    final currentState = state as CommunityInitial;

    try {
      Stream<List<PostModel>> postList = CommunityRepository().getAllPosts();
      emit(currentState.copyWith(posts: postList));

      print('LOADING ... ');
    } catch (e) {
      print("SHIT FAILED TO LOAD POSTS...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> likePost(LikePost event, Emitter<CommunityState> emit) async {
    try {
      await CommunityRepository()
          .likePost(postId: event.postId, userId: event.userId);

      print('LIKED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO LIKE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> dislikePost(
      DislikePost event, Emitter<CommunityState> emit) async {
    try {
      await CommunityRepository()
          .dislikePost(postId: event.postId, userId: event.userId);

      print('DISLIKED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO DISLIKE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> savePost(SavePost event, Emitter<CommunityState> emit) async {
    try {
      await CommunityRepository()
          .savePost(postId: event.postId, userId: event.userId);
      print('SAVED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO SAVE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> unsavePost(
      UnsavePost event, Emitter<CommunityState> emit) async {
    try {
      await CommunityRepository()
          .unsavePost(postId: event.postId, userId: event.userId);
      print('UNSAVED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO UNSAVE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
