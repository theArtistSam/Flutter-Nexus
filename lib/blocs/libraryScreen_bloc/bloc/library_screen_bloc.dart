import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'library_screen_event.dart';
part 'library_screen_state.dart';

class LibraryScreenBloc extends Bloc<LibraryScreenEvent, LibraryScreenState> {
  LibraryScreenBloc() : super(LibraryScreenInitial()) {
    on<ToggleView>(toggleView);
  }

  FutureOr<void> toggleView(
      ToggleView event, Emitter<LibraryScreenState> emit) {
    final currentState = (state as LibraryScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }
}
