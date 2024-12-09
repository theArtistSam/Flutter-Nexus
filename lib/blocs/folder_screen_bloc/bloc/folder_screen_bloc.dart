import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/folder_repository.dart';
import 'package:nexus/utils/enums.dart';

part 'folder_screen_event.dart';
part 'folder_screen_state.dart';

class FolderScreenBloc extends Bloc<FolderScreenEvent, FolderScreenState> {
  FolderScreenBloc({required FolderModel folder})
      : super(FolderScreenInitial(folder: folder)) {
    on<LoadContent>(loadContent);
    on<FetchFolder>(fetchFolder);
  }

  FutureOr<void> loadContent(
      LoadContent event, Emitter<FolderScreenState> emit) async {
    // Check if the current state is HomeScreenLoadContent
    final currentState = state as FolderScreenInitial;

    try {
      Stream<List<ContentModel>> folderContents =
          FolderRepository().getAllFolderContents(folderID: event.folderID);

      emit(currentState.copyWith(
          folderContents: folderContents, status: ContentStatus.success));

      print('LOADING FOLDER CONTENTS ... ');
    } catch (e) {
      emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }

  FutureOr<void> fetchFolder(
    FetchFolder event,
    Emitter<FolderScreenState> emit,
  ) async {
    final currentState = state as FolderScreenInitial;
    try {
      final FolderModel folder = await FolderRepository().getFolderById(
        folderId: event.folderId,
      );
      emit(currentState.copyWith(folder: folder));
    } catch (e) {
      print("Error fetching folder $e");
    }
  }
}
