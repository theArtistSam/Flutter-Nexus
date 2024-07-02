import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/extractive_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/repositories/folder_repository.dart';
import 'package:nexus/utils/enums.dart';

part 'edit_bottom_sheet_event.dart';
part 'edit_bottom_sheet_state.dart';

class EditBottomSheetBloc
    extends Bloc<EditBottomSheetEvent, EditBottomSheetState> {
  EditBottomSheetBloc() : super(EditBottomSheetInitial()) {
    // on<InitialEvent>(initialEvent);
    on<ToggleView>(toggleView);
    on<AddTag>(addTag);
    on<RemoveTag>(removeTag);
    on<DeleteContent>(deleteContent);
    on<ChangeThumbnail>(changeThumbnail);
  }

  // FutureOr<void> initialEvent(
  //     InitialEvent event, Emitter<EditBottomSheetState> emit) async {
  //   final currentState = (state as EditBottomSheetInitial);
  //   try {
  //     List<FolderModel> folders = await FolderRepository().getAllFolders();
  //     emit(currentState.copyWith(folders: folders));
  //     print('Loading Folders');
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  FutureOr<void> toggleView(
      ToggleView event, Emitter<EditBottomSheetState> emit) {
    final currentState = (state as EditBottomSheetInitial);
    emit(currentState.copyWith(isLeftSelected: event.isLeftSelected));
  }

  FutureOr<void> addTag(
      AddTag event, Emitter<EditBottomSheetState> emit) async {
    final currentState = (state as EditBottomSheetInitial);
    try {
      ContentModel content = await ContentRepository()
          .addTag(tag: event.tag, contentId: event.contentId);
      emit(currentState.copyWith(content: content));
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> removeTag(
      RemoveTag event, Emitter<EditBottomSheetState> emit) async {
    final currentState = (state as EditBottomSheetInitial);
    try {
      ContentModel content = await ContentRepository()
          .removeTag(tag: event.tag, contentId: event.contentId);
      emit(currentState.copyWith(content: content));
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> deleteContent(
      DeleteContent event, Emitter<EditBottomSheetState> emit) async {
    try {
      await ContentRepository().deleteContent(contentId: event.contentId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> changeThumbnail(
      ChangeThumbnail event, Emitter<EditBottomSheetState> emit) async {
    final currentState = (state as EditBottomSheetInitial);
    try {
      ContentModel content = await ContentRepository()
          .changeThumbnail(file: event.file, contentId: event.contentId);
      emit(currentState.copyWith(content: content));
    } catch (e) {
      print(e.toString());
    }
  }
}
