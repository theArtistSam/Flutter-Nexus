import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/folder_repository.dart';

part 'folder_bottom_sheet_event.dart';
part 'folder_bottom_sheet_state.dart';

class FolderBottomSheetBloc
    extends Bloc<FolderBottomSheetEvent, FolderBottomSheetState> {
  FolderBottomSheetBloc({required FolderModel? folder})
      : super(
          FolderBottomSheetInitial(folder: folder ?? FolderModel(icon: 0)),
        ) {
    on<SelectFolderIcon>(selectFolderIcon);
    on<UpdateFolder>(updateFolder);
    on<CreateFolder>(createFolder);
    on<DeleteFolder>(deleteFolder);
  }

  FutureOr<void> selectFolderIcon(
    SelectFolderIcon event,
    Emitter<FolderBottomSheetState> emit,
  ) {
    final currentState = (state as FolderBottomSheetInitial);
    emit(
      currentState.copyWith(
        folder: currentState.folder.copyWith(icon: event.index),
      ),
    );
  }

  FutureOr<void> updateFolder(
    UpdateFolder event,
    Emitter<FolderBottomSheetState> emit,
  ) async {
    final currentState = (state as FolderBottomSheetInitial);
    try {
      final FolderModel folder = currentState.folder.copyWith(
        title: event.title,
        dateUpdated: DateTime.now().toString(),
      );
      await FolderRepository().updateFolder(
        folder: folder,
      );

      // Added Folder
    } catch (e) {
      print('Some error occured');
    }
  }

  FutureOr<void> createFolder(
    CreateFolder event,
    Emitter<FolderBottomSheetState> emit,
  ) async {
    final currentState = (state as FolderBottomSheetInitial);
    try {
      final FolderModel folder = currentState.folder.copyWith(
        title: event.title,
        dateUpdated: DateTime.now().toString(),
        contents: [],
      );
      await FolderRepository().addFolder(
        folder: folder,
      );
      print("ADDED FOLDER");
      // Added Folder
    } catch (e) {
      print('Some error occured');
    }
  }

  FutureOr<void> deleteFolder(
    DeleteFolder event,
    Emitter<FolderBottomSheetState> emit,
  ) async {
    try {
      await FolderRepository().deleteFolder(
        folderId: event.folderId,
      );
    } catch (e) {
      print("Some error occured $e");
    }
  }
}
