import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'upload_bottom_sheet_event.dart';
part 'upload_bottom_sheet_state.dart';

class UploadBottomSheetBloc
    extends Bloc<UploadBottomSheetEvent, UploadBottomSheetState> {
  UploadBottomSheetBloc() : super(const UploadBottomSheetInitial()) {
    on<Select>(select);
    on<ToggleSelectFile>(toggleSelectFile);
    on<UploadFilesLocal>(uploadFilesLocal);
    on<SelectAiFeature>(selectAiFeature);
    on<RemoveSelectedFiles>(removeSelectedFiles);
  }

  FutureOr<void> select(Select event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Create a new list of files with all boolean values set to false
    final List<Map<String, bool>> updatedFiles = currentState.files.map((file) {
      final key = file.keys.first;
      return {key: false};
    }).toList();

    emit(currentState.copyWith(
      isSelected: !currentState.isSelected,
      files: updatedFiles,
    ));
  }

  FutureOr<void> toggleSelectFile(
      ToggleSelectFile event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    // Create a new list by mapping the current files
    final List<Map<String, bool>> updatedFiles = currentState.files.map((file) {
      if (file.containsKey(event.fileName)) {
        // Toggle the selected status
        return {event.fileName: !file[event.fileName]!};
      }
      return file;
    }).toList();

    emit(currentState.copyWith(files: updatedFiles));
  }

  FutureOr<void> uploadFilesLocal(
      UploadFilesLocal event, Emitter<UploadBottomSheetState> emit) {
    final currentState = state as UploadBottomSheetInitial;

    final List<Map<String, bool>> updatedFiles = List.from(currentState.files);
    updatedFiles.add(event.file);
    emit(currentState.copyWith(files: updatedFiles));
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
    final List<Map<String, bool>> updatedFiles =
        currentState.files.where((file) => file.values.first == false).toList();

    if (updatedFiles.isEmpty) {
      emit(currentState.copyWith(
        files: updatedFiles,
        isSelected: !currentState.isSelected,
      ));
    } else {
      // Emit the updated state with the remaining files
      emit(currentState.copyWith(files: updatedFiles));
    }
  }
}
