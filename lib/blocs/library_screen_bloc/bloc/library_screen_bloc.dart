import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/utils/enums.dart';
// import 'package:flutter/material.dart';

part 'library_screen_event.dart';
part 'library_screen_state.dart';

class LibraryScreenBloc extends Bloc<LibraryScreenEvent, LibraryScreenState> {
  LibraryScreenBloc() : super(LibraryScreenInitial()) {
    on<ToggleView>(toggleView);
    on<LoadContent>(loadContent);
  }

  FutureOr<void> toggleView(
      ToggleView event, Emitter<LibraryScreenState> emit) {
    final currentState = (state as LibraryScreenInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }

  FutureOr<void> loadContent(
      LoadContent event, Emitter<LibraryScreenState> emit) async {
    final currentState = (state as LibraryScreenInitial);
    try {
      List<ContentModel> contentList =
          await ContentRepository().getAllContents();
      emit(currentState.copyWith(
          contents: contentList, status: ContentStatus.success));
    } catch (e) {
      emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
