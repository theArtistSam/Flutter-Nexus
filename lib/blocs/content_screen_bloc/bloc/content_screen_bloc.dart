// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/blocs/summarization_config_bloc/bloc/summarization_config_bloc.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/models/model_configs/summarization_config.dart';
import 'package:nexus/models/model_configs/translation_config.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/repositories/folder_repository.dart';
import 'package:nexus/repositories/model_repository.dart';
import 'package:nexus/services/abstractive_model_service.dart';
import 'package:nexus/services/extractive_model_service.dart';
import 'package:nexus/services/translation_model_service.dart';
import 'package:path/path.dart';

part 'content_screen_event.dart';
part 'content_screen_state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState> {
  ContentScreenBloc({required ContentModel content})
      : super(ContentScreenInitial(content: content)) {
    on<ToggleTranslateSummarizeView>(toggleView);
    on<ToggleContainerView>(toggleContainerView);
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
    on<LikeContent>(likeContent);
    on<DislikeContent>(dislikeContent);
    on<UpdateUpVoteStatus>(updateUpVoteStatus);
    on<UpdateDownVoteStatus>(updateDownVoteStatus);
    on<UpdateSummarizationConfig>(updateSummarizationConfig);
    on<GenerateSummary>(generateSummary);
    on<GenerateTranslation>(generateTranslation);

    // Add the start event to fetch all the folders
    add(FetchFolders());
  }

  Future<void> fetchFolders(
    FetchFolders event,
    Emitter<ContentScreenState> emit,
  ) async {
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
    ToggleTranslateSummarizeView event,
    Emitter<ContentScreenState> emit,
  ) {
    final currentState = (state as ContentScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }

  FutureOr<void> toggleContainerView(
    ToggleContainerView event,
    Emitter<ContentScreenState> emit,
  ) {
    final currentState = (state as ContentScreenInitial);
    emit(
      currentState.copyWith(isOriginal: event.isOriginal),
    );
  }

  FutureOr<void> addTag(
    AddTag event,
    Emitter<ContentScreenState> emit,
  ) {
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

  FutureOr<void> removeTag(
    RemoveTag event,
    Emitter<ContentScreenState> emit,
  ) {
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
    DeleteContent event,
    Emitter<ContentScreenState> emit,
  ) async {
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
    AddThumbnail event,
    Emitter<ContentScreenState> emit,
  ) {
    final currentState = (state as ContentScreenInitial);
    emit(currentState.copyWith(
      image: event.file,
    ));
  }

  FutureOr<void> removeThumbnail(
    RemoveThumbnail event,
    Emitter<ContentScreenState> emit,
  ) {
    emit((state as ContentScreenInitial).copyWith());
  }

  FutureOr<void> updateContent(
    UpdateContent event,
    Emitter<ContentScreenState> emit,
  ) async {
    final currentState = state as ContentScreenInitial;
    try {
      await ContentRepository().updateContent(
        content: currentState.content,
        image: currentState.image,
      );

      // Update the state
      add(FetchContent());
    } catch (e) {
      print("Some error occurred $e");
    }
  }

  FutureOr<void> fetchContent(
    FetchContent event,
    Emitter<ContentScreenState> emit,
  ) async {
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

  FutureOr<void> likeContent(
    LikeContent event,
    Emitter<ContentScreenState> emit,
  ) async {
    final currentState = state as ContentScreenInitial;
    final bool isTranslation = currentState.isLeftSelected;
    final ContentModel content = currentState.content;

    try {
      // Determine whether to update translation or summarization
      final updatedContent = isTranslation
          ? content.copyWith(
              translation: content.translation!.copyWith(
                status: Status(isLiked: event.value, isDisliked: false),
              ),
            )
          : content.copyWith(
              summarization: content.summarization!.copyWith(
                status: Status(isLiked: event.value, isDisliked: false),
              ),
            );

      // Emit the updated state
      emit(currentState.copyWith(content: updatedContent));

      // Perform the repository action
      await ContentRepository().toggleLike(
        isTranslation: isTranslation,
        value: event.value,
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        documentId: content.contentId!,
      );
    } catch (e) {
      print("Some error occurred while liking content: $e");
    }
  }

  FutureOr<void> dislikeContent(
    DislikeContent event,
    Emitter<ContentScreenState> emit,
  ) async {
    final currentState = state as ContentScreenInitial;
    final bool isTranslation = currentState.isLeftSelected;
    final ContentModel content = currentState.content;

    try {
      // Determine whether to update translation or summarization
      final updatedContent = isTranslation
          ? content.copyWith(
              translation: content.translation!.copyWith(
                status: Status(isLiked: false, isDisliked: event.value),
              ),
            )
          : content.copyWith(
              summarization: content.summarization!.copyWith(
                status: Status(isLiked: false, isDisliked: event.value),
              ),
            );

      // Emit the updated state
      emit(currentState.copyWith(content: updatedContent));

      // Perform the repository action
      await ContentRepository().toggleDislike(
        isTranslation: isTranslation,
        value: event.value,
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        documentId: content.contentId!,
      );
    } catch (e) {
      print("Some error occurred while disliking content: $e");
    }
  }

  FutureOr<void> updateUpVoteStatus(
    UpdateUpVoteStatus event,
    Emitter<ContentScreenState> emit,
  ) async {
    final currentState = state as ContentScreenInitial;
    final ContentModel content = currentState.content;
    final bool isTranslation = currentState.isLeftSelected;

    try {
      ModelRepository modelRepo;

      if (isTranslation) {
        // Translation model repository
        modelRepo = ModelRepository(documentId: 'zkb0ysUiZpKSFcnoaoQD');
      } else {
        // Summarization model repository
        if (content.summarization!.summarizationConfig!.type! == 'extractive') {
          modelRepo = ModelRepository(documentId: 'FNJAQivoRd7ouJOcQesX');
        } else {
          modelRepo = ModelRepository(documentId: 'FigG5uIMlUEw1IAlSsBr');
        }
      }

      // Update downvote and upvote status
      // Update upvote and downvote status
      if (event.dislikeStatus) {
        await modelRepo
            .incrementUpVote(); // Increment upvote for dislike action
        await modelRepo
            .decrementDownVote(); // Decrement downvote for dislike action
      } else {
        if (event.likeStatus) {
          await modelRepo.incrementUpVote(); // Increment upvote for like action
        } else {
          await modelRepo.decrementUpVote(); // Decrement upvote when no like
        }
      }
    } catch (e) {
      print("Some shit happened $e");
    }
  }

  FutureOr<void> updateDownVoteStatus(
    UpdateDownVoteStatus event,
    Emitter<ContentScreenState> emit,
  ) async {
    final currentState = state as ContentScreenInitial;
    final ContentModel content = currentState.content;
    final bool isTranslation = currentState.isLeftSelected;

    ModelRepository modelRepo;

    try {
      if (isTranslation) {
        // Translation model repository
        modelRepo = ModelRepository(documentId: 'zkb0ysUiZpKSFcnoaoQD');
      } else {
        // Summarization model repository
        if (content.summarization!.summarizationConfig!.type! == 'extractive') {
          modelRepo = ModelRepository(documentId: 'FNJAQivoRd7ouJOcQesX');
        } else {
          modelRepo = ModelRepository(documentId: 'FigG5uIMlUEw1IAlSsBr');
        }
      }

      // Update downvote and upvote status
      if (event.likeStatus) {
        await modelRepo
            .incrementDownVote(); // Increment downvote for like action
        await modelRepo.decrementUpVote(); // Decrement upvote for like action
      } else {
        if (event.dislikeStatus) {
          await modelRepo
              .incrementDownVote(); // Increment downvote for dislike action
        } else {
          await modelRepo
              .decrementDownVote(); // Decrement downvote when neither like nor dislike
        }
      }
    } catch (e) {
      print("Some shit happened $e");
    }
  }

  FutureOr<void> updateSummarizationConfig(
    UpdateSummarizationConfig event,
    Emitter<ContentScreenState> emit,
  ) async {
    final currentState = state as ContentScreenInitial;
    final ContentModel content = currentState.content;
    final SummarizationConfig config = event.config;
    try {
      await ContentRepository().updateSummarizationConfig(
        contentId: content.contentId!,
        summarizationConfig: config,
      );

      emit(
        currentState.copyWith(
          content: content.copyWith(
            summarization:
                content.summarization!.copyWith(summarizationConfig: config),
          ),
        ),
      );
    } catch (e) {
      print('Some error: $e');
    }
  }

  FutureOr<void> generateSummary(
    GenerateSummary event,
    Emitter<ContentScreenState> emit,
  ) async {
    try {
      final currentState = state as ContentScreenInitial;
      final ContentModel content = currentState.content;
      final Summarization? existingSummary = content.summarization;

      // Determine summarization type and length
      final String type =
          existingSummary?.summarizationConfig?.type ?? 'extractive';
      final String length =
          existingSummary?.summarizationConfig?.length ?? 'medium';

      // Choose appropriate service based on type
      final String response = type == 'extractive'
          ? await ExtractiveModelService().sendText(
              text: content.extractedText!,
              length: length,
            )
          : await AbstractiveModelService().sendText(
              text: content.extractedText!,
              length: length,
            );

      // Create the new summarization object
      final Summarization newSummarization = Summarization(
        text: response,
        status: Status(
          isLiked: false,
          isDisliked: false,
        ),
        summarizationConfig: SummarizationConfig(
          type: type,
          length: length,
        ),
      );

      // Update the summary in the repository
      await ContentRepository().generateSummary(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        contentId: content.contentId!,
        summarization: newSummarization,
      );

      // Emit the updated state
      emit(
        currentState.copyWith(
          content: content.copyWith(summarization: newSummarization),
        ),
      );
    } catch (e) {
      print('Error generating summary: $e');
    }
  }

  FutureOr<void> generateTranslation(
    GenerateTranslation event,
    Emitter<ContentScreenState> emit,
  ) async {
    try {
      final currentState = state as ContentScreenInitial;
      final ContentModel content = currentState.content;

      String response = await TrasnlationModelService()
          .sendText(text: content.extractedText!);

      // TODO: Fix the state update translation
      final Translation translation = Translation(
        text: response,
        status: Status(isLiked: false, isDisliked: false),
        translationConfig: TranslationConfig(
          sourceLanguages: ['English'],
          targetLanguages: ['Urdu'],
        ),
      );
      // Now update the summary configuration
      await ContentRepository().generateTraslation(
          userId: 'Bd4umkyLqOLnMpdOLZ0E',
          contentId: content.contentId!,
          translation: translation);

      // update the state
      emit(
        currentState.copyWith(
          content: content.copyWith(translation: translation),
        ),
      );
    } catch (e) {
      print('Some error generating Translation: $e');
    }
  }
}
