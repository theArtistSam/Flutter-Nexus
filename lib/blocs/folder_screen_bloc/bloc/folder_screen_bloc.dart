import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/repositories/folder_repository.dart';
import 'package:nexus/utils/enums.dart';

part 'folder_screen_event.dart';
part 'folder_screen_state.dart';

class FolderScreenBloc extends Bloc<FolderScreenEvent, FolderScreenState> {
  FolderScreenBloc() : super(FolderScreenInitial()) {
    on<LoadContent>(loadContent);
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
}
