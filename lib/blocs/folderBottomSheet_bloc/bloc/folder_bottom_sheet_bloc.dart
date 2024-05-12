import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'folder_bottom_sheet_event.dart';
part 'folder_bottom_sheet_state.dart';

class FolderBottomSheetBloc
    extends Bloc<FolderBottomSheetEvent, FolderBottomSheetState> {
  FolderBottomSheetBloc() : super(FolderBottomSheetInitial()) {
    on<SelectFolderIcon>(selectFolderIcon);
  }

  FutureOr<void> selectFolderIcon(
      SelectFolderIcon event, Emitter<FolderBottomSheetState> emit) {
    final currentState = (state as FolderBottomSheetInitial);
    emit(currentState.copyWith(index: event.index));
  }
}
