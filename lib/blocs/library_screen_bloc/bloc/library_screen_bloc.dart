import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/repositories/folder_repository.dart';
import 'package:nexus/repositories/library_repository.dart';
import 'package:nexus/screens/library/library_screen.dart';
import 'package:nexus/utils/enums.dart';
// import 'package:flutter/material.dart';

part 'library_screen_event.dart';
part 'library_screen_state.dart';

class LibraryScreenBloc extends Bloc<LibraryScreenEvent, LibraryScreenState> {
  LibraryScreenBloc() : super(const LibraryScreenInitial()) {
    on<ToggleView>(toggleView);
    on<LoadContent>(loadContent);
  }

  FutureOr<void> toggleView(
      ToggleView event, Emitter<LibraryScreenState> emit) {
    final currentState = (state as LibraryScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }

  FutureOr<void> loadContent(
      LoadContent event, Emitter<LibraryScreenState> emit) {
    final currentState = (state as LibraryScreenInitial);
    try {
      Stream<List<ContentModel>> contentList =
          ContentRepository().getAllContents();

      Stream<List<FolderModel>> folderList = FolderRepository().getAllFolders();

      emit(currentState.copyWith(
        contents: contentList,
        status: LibraryStatus.success,
        folders: folderList,
      ));
    } catch (e) {
      emit(currentState.copyWith(status: LibraryStatus.failure));
    }
  }
}
