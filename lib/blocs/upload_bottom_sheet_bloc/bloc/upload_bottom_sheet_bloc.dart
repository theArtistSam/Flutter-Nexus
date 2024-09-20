import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path;

part 'upload_bottom_sheet_event.dart';
part 'upload_bottom_sheet_state.dart';

class UploadBottomSheetBloc
    extends Bloc<UploadBottomSheetEvent, UploadBottomSheetState> {
  UploadBottomSheetBloc() : super(const UploadBottomSheetInitial()) {
    on<Select>(select);
    on<ToggleSelectFile>(toggleSelectFile);
    on<SelectAiFeature>(selectAiFeature);
    on<RemoveSelectedFiles>(removeSelectedFiles);
    on<PickFile>(pickFile);
  }

  FutureOr<void> select(Select event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Create a new list of files with all boolean values set to false
    final List<Map<File, bool>> updatedFiles =
        currentState.pickedFiles.map((file) {
      final key = file.keys.first;
      return {key: false};
    }).toList();

    emit(currentState.copyWith(
      isSelected: !currentState.isSelected,
      pickedFiles: updatedFiles,
    ));
  }

  FutureOr<void> toggleSelectFile(
      ToggleSelectFile event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Create a new list by mapping the current files
    final updatedFiles = currentState.pickedFiles.map((fileMap) {
      // Check if the fileMap contains the file with the name from the event
      if (fileMap.containsKey(event.file)) {
        final file = fileMap.keys.first; // Get the file
        final isSelected = fileMap[file]!; // Get the current selection status

        // Toggle the selection status
        return {file: !isSelected};
      }
      return fileMap;
    }).toList();

    emit(currentState.copyWith(pickedFiles: updatedFiles));
  }

  FutureOr<void> selectAiFeature(
      SelectAiFeature event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;
    emit(currentState.copyWith(aiFeature: event.aiFeature));
  }

  FutureOr<void> removeSelectedFiles(
      RemoveSelectedFiles event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Filter out files where the boolean value is true
    final List<Map<File, bool>> updatedFiles = currentState.pickedFiles
        .where((fileMap) => fileMap.values.first == false)
        .toList();

    // Emit the updated state with the remaining files
    emit(currentState.copyWith(
      pickedFiles: updatedFiles,
      isSelected: updatedFiles.isNotEmpty,
    ));
  }

  FutureOr<void> pickFile(
    PickFile event,
    Emitter<UploadBottomSheetState> emit,
  ) {
    final currentState = state;
    if (currentState is UploadBottomSheetInitial) {
      // Create a mutable copy of the pickedFiles list
      final updatedFiles = List<Map<File, bool>>.from(currentState.pickedFiles);

      // Add the new file to the mutable list
      updatedFiles.add({event.file: false});

      // Emit the updated state with the modified files list
      emit(currentState.copyWith(
        pickedFiles: updatedFiles, // Ensure this is the mutable updated list
      ));
    }
  }
}
