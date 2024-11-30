import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/post_model.dart';
import 'package:nexus/repositories/community_repository.dart';

part 'post_bottom_sheet_event.dart';
part 'post_bottom_sheet_state.dart';

class PostBottomSheetBloc
    extends Bloc<PostBottomSheetEvent, PostBottomSheetState> {
  PostBottomSheetBloc({required PostModel? post})
      : super(
          PostBottomSheetInitial(
            post: post ??
                PostModel(
                  totalComments: 0,
                  totalLikes: 0,
                  totalShares: 0,
                  description: '',
                  likedBy: [],
                  savedBy: [],
                  images: [],
                  dateCreated: DateTime.now().toString(),
                  permissions: Permissions(
                    isPrivate: false,
                    commentAllowed: true,
                    likeAllowed: true,
                    shareAllowed: true,
                  ),
                ),
          ),
        ) {
    on<SetExistingImages>(setExistingImages);
    on<AllowLikes>(allowLikes);
    on<AllowComments>(allowComments);
    on<AllowShares>(allowShares);
    on<ChangeVisibility>(changeVisibility);
    on<AddImage>(addImage);
    on<AddPost>(addPost);
    on<UpdatePost>(updatePost);
    // on<ViewImages>(viewImages);
    on<RemoveImage>(removeImage);

    // * Add old post images to the dynamic list images
    if (post != null) {
      add(SetExistingImages(images: post.images!));
    }
  }
  FutureOr<void> setExistingImages(
    SetExistingImages event,
    Emitter<PostBottomSheetState> emit,
  ) {
    final currentState = (state as PostBottomSheetInitial);

    // Combine the current images with the new images from the event
    final updatedImages = List<dynamic>.from(currentState.images)
      ..addAll(event.images);

    // Emit the new state with the updated list of images
    emit(currentState.copyWith(post: currentState.post, images: updatedImages));
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

  FutureOr<void> addImage(AddImage event, Emitter<PostBottomSheetState> emit) {
    final currentState = state as PostBottomSheetInitial;
    final updatedImages = List<dynamic>.from(currentState.images)
      ..add(event.file);
    //  * Post is being used becuse by default it would get null
    emit(currentState.copyWith(post: currentState.post, images: updatedImages));
  }

  FutureOr<void> addPost(
      AddPost event, Emitter<PostBottomSheetState> emit) async {
    final currentState = state as PostBottomSheetInitial;

    final PostModel post = currentState.post!.copyWith(
      description: event.text,
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

  FutureOr<void> updatePost(
      UpdatePost event, Emitter<PostBottomSheetState> emit) async {
    final currentState = state as PostBottomSheetInitial;
    final PostModel post = currentState.post!.copyWith(
      dateCreated: DateTime.now().toString(),
      description: event.text,
    );
    try {
      await CommunityRepository().updatePost(
        post: post,
        images: currentState.images,
      );
    } catch (e) {
      print("Some shit has gone wrong while updating post $e");
    }
  }

  FutureOr<void> removeImage(
    RemoveImage event,
    Emitter<PostBottomSheetState> emit,
  ) {
    final currentState = state as PostBottomSheetInitial;
    final updatedImages = List<dynamic>.from(currentState.images);
    updatedImages.removeAt(event.index);
    emit(currentState.copyWith(post: currentState.post, images: updatedImages));
  }
}
