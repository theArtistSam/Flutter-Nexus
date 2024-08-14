import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/repositories/folder_repository.dart';

part 'content_screen_event.dart';
part 'content_screen_state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState> {
  ContentScreenBloc({required ContentModel content})
      : super(ContentScreenInitial(content: content)) {
    on<ToggleTranslateSummarizeView>(toggleView);
    on<ToggleContainerView>(toggleContainerView);
    on<ToggleLikeDislike>(toggleLikeDislike);
    on<AddTag>(addTag);
    on<RemoveTag>(removeTag);
    on<DeleteContent>(deleteContent);
    on<RevertChanges>(revertChanges);
    on<FetchFolders>(fetchFolders);
    on<ChangeFolder>(changeFolder);
    on<AddThumbnail>(addThumbnail);
    on<RemoveThumbnail>(removeThumbnail);
    on<UpdateContent>(updateContent);
    on<FetchContent>(fetchContent);

    // Add the start event to fetch all the folders
    add(FetchFolders());
  }

  Future<void> fetchFolders(
      FetchFolders event, Emitter<ContentScreenState> emit) async {
    final currentState = (state as ContentScreenInitial);

    try {
      // Fetch folders as a stream
      Stream<List<FolderModel>> folderStream =
          FolderRepository().getAllFolders();

      // Listen to the stream and get the list of folders
      await for (List<FolderModel> folders in folderStream) {
        // Emit the new state with the updated folders
        emit(currentState.copyWith(folders: folders));
      }
    } catch (e) {
      print("Something went wrong $e");
    }
  }

  FutureOr<void> toggleView(
      ToggleTranslateSummarizeView event, Emitter<ContentScreenState> emit) {
    final currentState = (state as ContentScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }

  FutureOr<void> toggleContainerView(
      ToggleContainerView event, Emitter<ContentScreenState> emit) {
    final currentState = (state as ContentScreenInitial);
    emit(
      currentState.copyWith(isOriginal: event.isOriginal),
    );
  }

  FutureOr<void> toggleLikeDislike(
      ToggleLikeDislike event, Emitter<ContentScreenState> emit) {
    final currentState = (state as ContentScreenInitial);
    emit(currentState.copyWith(isLiked: event.isLiked));
  }

  FutureOr<void> addTag(AddTag event, Emitter<ContentScreenState> emit) {
    final currentState = state as ContentScreenInitial;

    // Create a new list with the added tag
    final List<String> updatedTags = List.from(currentState.content.tags ?? []);
    updatedTags.add(event.tag);

    // Emit the new state with the updated tags
    emit(
      currentState.copyWith(
        content: currentState.content.copyWith(
          tags: updatedTags,
        ),
        image: currentState.image,
      ),
    );
  }

  FutureOr<void> removeTag(RemoveTag event, Emitter<ContentScreenState> emit) {
    final currentState = state as ContentScreenInitial;

    // Create a new list with the tag removed at the specified index
    final List<String> updatedTags = List.from(currentState.content.tags ?? []);

    updatedTags.remove(event.tag);

    // Emit the new state with the updated tags
    emit(
      currentState.copyWith(
        content: currentState.content.copyWith(
          tags: updatedTags,
        ),
        image: currentState.image,
      ),
    );
  }

  FutureOr<void> deleteContent(
      DeleteContent event, Emitter<ContentScreenState> emit) async {
    final currentState = state as ContentScreenInitial;
    try {
      await ContentRepository()
          .deleteContent(contentId: currentState.content.contentId!);
    } catch (e) {
      print("Some error occured $e");
    }
  }

  FutureOr<void> revertChanges(
    RevertChanges event,
    Emitter<ContentScreenState> emit,
  ) {
    emit((state as ContentScreenInitial).copyWith(content: event.content));
  }

  FutureOr<void> changeFolder(
    ChangeFolder event,
    Emitter<ContentScreenState> emit,
  ) {
    final currentState = (state as ContentScreenInitial);
    emit(
      currentState.copyWith(
        content: currentState.content.copyWith(
          folderId: event.folderId,
        ),
        image: currentState.image,
      ),
    );
  }

  FutureOr<void> addThumbnail(
      AddThumbnail event, Emitter<ContentScreenState> emit) {
    final currentState = (state as ContentScreenInitial);
    emit(currentState.copyWith(
      image: event.file,
    ));
  }

  FutureOr<void> removeThumbnail(
      RemoveThumbnail event, Emitter<ContentScreenState> emit) {
    emit((state as ContentScreenInitial).copyWith());
  }

  FutureOr<void> updateContent(
      UpdateContent event, Emitter<ContentScreenState> emit) async {
    final currentState = state as ContentScreenInitial;
    try {
      await ContentRepository().updateContent(
          content: currentState.content, image: currentState.image);

      // Update the state
      add(FetchContent());
    } catch (e) {
      print("Some error occurred $e");
    }
  }

  FutureOr<void> fetchContent(
      FetchContent event, Emitter<ContentScreenState> emit) async {
    final currentState = state as ContentScreenInitial;
    try {
      final ContentModel content = await ContentRepository().getContentById(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        contentId: currentState.content.contentId!,
      );
      emit(currentState.copyWith(content: content));
    } catch (e) {
      print("Error fetching folder $e");
    }
  }
}
