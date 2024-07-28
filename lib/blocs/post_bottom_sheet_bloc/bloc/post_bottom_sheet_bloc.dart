import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/repositories/community_repository.dart';

part 'post_bottom_sheet_event.dart';
part 'post_bottom_sheet_state.dart';

class PostBottomSheetBloc
    extends Bloc<PostBottomSheetEvent, PostBottomSheetState> {
  PostBottomSheetBloc() : super(const PostBottomSheetInitial()) {
    on<FetchPost>(fetchPost);
    on<AllowLikes>(allowLikes);
    on<AllowComments>(allowComments);
    on<AllowShares>(allowShares);
    on<ChangeVisibility>(changeVisibility);
    on<PickImage>(pickImage);
    on<AddPost>(addPost);
    on<UpdatePost>(updatePost);
    on<ViewImages>(viewImages);
    on<DeleteNewImage>(deleteNewImage);
    on<DeleteExistingImage>(deleteExistingImage);
  }

  FutureOr<void> fetchPost(
      FetchPost event, Emitter<PostBottomSheetState> emit) {
    final currentState = (state as PostBottomSheetInitial);
    // if new post
    PostModel post = PostModel(
      permissions: Permissions(
        isPrivate: false,
        commentAllowed: true,
        likeAllowed: true,
        shareAllowed: true,
      ),
    );

    print("WORKING");

    emit(currentState.copyWith(post: event.post ?? post));
  }

  FutureOr<void> allowLikes(
      AllowLikes event, Emitter<PostBottomSheetState> emit) {
    final currentState = (state as PostBottomSheetInitial);
    // Create a copy of the current post with updated visibility
    final updatedPermissions = currentState.post?.permissions?.copyWith(
      likeAllowed: event.allowLikes,
    );

    final updatedPost = currentState.post?.copyWith(
      permissions: updatedPermissions,
    );
    emit(currentState.copyWith(post: updatedPost));
  }

  FutureOr<void> allowComments(
      AllowComments event, Emitter<PostBottomSheetState> emit) {
    final currentState = (state as PostBottomSheetInitial);

    // Create a copy of the current post with updated visibility
    final updatedPermissions = currentState.post?.permissions?.copyWith(
      commentAllowed: event.allowComments,
    );

    final updatedPost = currentState.post?.copyWith(
      permissions: updatedPermissions,
    );
    emit(currentState.copyWith(post: updatedPost));
  }

  FutureOr<void> allowShares(
      AllowShares event, Emitter<PostBottomSheetState> emit) {
    final currentState = (state as PostBottomSheetInitial);
    // Create a copy of the current post with updated visibility
    final updatedPermissions = currentState.post?.permissions?.copyWith(
      shareAllowed: event.allowShares,
    );

    final updatedPost = currentState.post?.copyWith(
      permissions: updatedPermissions,
    );
    emit(currentState.copyWith(post: updatedPost));
  }

  FutureOr<void> changeVisibility(
      ChangeVisibility event, Emitter<PostBottomSheetState> emit) {
    final currentState = state as PostBottomSheetInitial;

    // Create a copy of the current post with updated visibility
    final updatedPermissions = currentState.post?.permissions?.copyWith(
      isPrivate: event.visibility,
    );

    final updatedPost = currentState.post?.copyWith(
      permissions: updatedPermissions,
    );

    emit(currentState.copyWith(post: updatedPost));
  }

  FutureOr<void> pickImage(
      PickImage event, Emitter<PostBottomSheetState> emit) {
    final currentState = state as PostBottomSheetInitial;
    // print(event.file?.path);
    final updatedImages = List<XFile>.from(currentState.images)
      ..add(event.file);
    //  * Post is being used becuse by defauly it would get null
    emit(currentState.copyWith(post: currentState.post, images: updatedImages));
  }

  FutureOr<void> addPost(
      AddPost event, Emitter<PostBottomSheetState> emit) async {
    final currentState = state as PostBottomSheetInitial;
    final PostModel post = PostModel(
      totalLikes: 0,
      totalComments: 0,
      totalShares: 0,
      images: [],
      likedBy: [],
      savedBy: [],
      description: event.text,
      dateCreated: DateTime.now().toString(),
      permissions: currentState.post!.permissions,
    );
    try {
      await CommunityRepository().addPost(
        post: post,
        images: currentState.images,
      );
    } catch (e) {
      print("Some shit has gone wrong while adding post $e");
    }
  }

  FutureOr<void> viewImages(
      ViewImages event, Emitter<PostBottomSheetState> emit) {
    final currentState = state as PostBottomSheetInitial;
    emit(
      currentState.copyWith(
        post: currentState.post,
        showImages: event.showImages,
      ),
    );
  }

  FutureOr<void> updatePost(
      UpdatePost event, Emitter<PostBottomSheetState> emit) async {
    final currentState = state as PostBottomSheetInitial;
    final PostModel post = currentState.post!;
    post.dateCreated = DateTime.now().toString();
    post.description = event.text;
    try {
      await CommunityRepository().updatePost(
        post: post,
        images: currentState.images,
      );
    } catch (e) {
      print("Some shit has gone wrong while updating post $e");
    }
  }

  FutureOr<void> deleteNewImage(
      DeleteNewImage event, Emitter<PostBottomSheetState> emit) {
    final currentState = state as PostBottomSheetInitial;
    final updatedImages = List<XFile>.from(currentState.images);
    updatedImages.removeAt(event.index);
    emit(currentState.copyWith(post: currentState.post, images: updatedImages));
  }

  FutureOr<void> deleteExistingImage(
      DeleteExistingImage event, Emitter<PostBottomSheetState> emit) async {
    final currentState = state as PostBottomSheetInitial;

    // Create a new list with the images, then remove the image at the specified index
    List<String> updatedImages = List<String>.from(currentState.post!.images!);
    String url = updatedImages.removeAt(event.index);

    await CommunityRepository().deleteImage(
      postId: currentState.post!.postId!,
      url: url,
    );

    // Create an updated post model with the new list of images
    PostModel updatedPost = currentState.post!.copyWith(images: updatedImages);

    // Emit the new state with the updated post
    emit(currentState.copyWith(post: updatedPost));
  }
}
