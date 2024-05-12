import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_bottom_sheet_event.dart';
part 'edit_bottom_sheet_state.dart';

class EditBottomSheetBloc
    extends Bloc<EditBottomSheetEvent, EditBottomSheetState> {
  EditBottomSheetBloc() : super(EditBottomSheetInitial()) {
    on<ToggleView>(toggleView);
  }

  FutureOr<void> toggleView(
      ToggleView event, Emitter<EditBottomSheetState> emit) {
    final currentState = (state as EditBottomSheetInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }
}
