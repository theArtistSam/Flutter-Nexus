import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/folder_repository.dart';

part 'content_screen_event.dart';
part 'content_screen_state.dart';

class ContentScreenBloc extends Bloc<ContentScreenEvent, ContentScreenState> {
  ContentScreenBloc() : super(ContentScreenInitial()) {
    on<ToggleTranslateSummarizeView>(toggleView);
    on<ToggleContainerView>(toggleContainerView);
    on<ToggleLikeDislike>(toggleLikeDislike);
    // on<ContentScreenInitialEvent>(contentScreenInitialEvent);
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

  // FutureOr<void> contentScreenInitialEvent(
  //     ContentScreenInitialEvent event, Emitter<ContentScreenState> emit) async {
  //   final currentState = (state as ContentScreenInitial);
  //   try {
  //     List<FolderModel> folders = await FolderRepository().getAllFolders();
  //     emit(currentState.copyWith(
  //         content: currentState.content, folders: folders));
  //     print('Loading Folders...');
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
