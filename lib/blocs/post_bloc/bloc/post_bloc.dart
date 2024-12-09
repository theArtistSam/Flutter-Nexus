import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/models/user_model.dart';
import 'package:nexus/repositories/community_repository.dart';
import 'package:nexus/repositories/local_storage_repository.dart';
import 'package:nexus/repositories/user_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostModel post;
  PostBloc(this.post) : super(PostInitial(post: post)) {
    on<LikePost>(likePost);
    on<DislikePost>(dislikePost);
    on<SavePost>(savePost);
    on<UnsavePost>(unsavePost);
    on<DeletePost>(deletePost);
    on<FetchUserCredientials>(fetchUserCredientials);

    add(FetchUserCredientials());
  }

  FutureOr<void> likePost(LikePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().likePost(
        postId: post.postId!,
      );

      print('LIKED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO LIKE THE POST...");
    }
  }

  FutureOr<void> dislikePost(DislikePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().dislikePost(
        postId: post.postId!,
      );

      print('DISLIKED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO DISLIKE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> savePost(SavePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().savePost(postId: post.postId!);
      print('SAVED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO SAVE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> unsavePost(UnsavePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().unsavePost(
        postId: post.postId!,
      );
      print('UNSAVED THE POST ... ');
    } catch (e) {
      print("SHIT FAILED TO UNSAVE THE POST...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> deletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      await CommunityRepository().deletePost(postId: post.postId!);
      print("POST DELETED!!");
    } catch (e) {
      print("SHIT FAILED TO DELETE THE POST");
    }
  }

  FutureOr<void> fetchUserCredientials(
    FetchUserCredientials event,
    Emitter<PostState> emit,
  ) async {
    final UserModel? user =
        await UserRepository().getUserById(id: post.userId!);

    final String userName;
    final String profilePicture;

    if (user == null) {
      userName = "Some User";
      profilePicture =
          'https://firebasestorage.googleapis.com/v0/b/nexus-ef4c1.appspot.com/o/mock_data%2Fprofile-picture.png?alt=media&token=adb6095a-cbcf-4885-aa77-eb80732eadb1';

      emit(
        (state as PostInitial).copyWith(
          profilePicture: profilePicture,
          userName: userName,
        ),
      );
    } else {
      emit(
        (state as PostInitial).copyWith(
            profilePicture: user.profilePic,
            userName: "${user.firstName} ${user.lastName}"),
      );
    }
  }
}
