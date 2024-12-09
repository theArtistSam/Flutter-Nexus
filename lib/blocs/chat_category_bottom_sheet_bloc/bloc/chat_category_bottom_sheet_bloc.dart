import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/category_model.dart';
import 'package:nexus/repositories/chat_repository.dart';

part 'chat_category_bottom_sheet_event.dart';
part 'chat_category_bottom_sheet_state.dart';

class ChatCategoryBottomSheetBloc
    extends Bloc<ChatCategoryBottomSheetEvent, ChatCategoryBottomSheetState> {
  ChatCategoryBottomSheetBloc() : super(ChatCategoryBottomSheetInitial()) {
    on<FetchModelCategories>(fetchModelCategories);
    on<SelectModelCategory>(selectModelCategory);
    on<AddAIChat>(addAIChat);
  }

  FutureOr<void> fetchModelCategories(
    FetchModelCategories event,
    Emitter<ChatCategoryBottomSheetState> emit,
  ) {
    final currentState = state as ChatCategoryBottomSheetInitial;

    List<CategoryModel> models = [
      CategoryModel(
        icon: 'sparkle',
        type: 'AI Summarizer ',
        tagline:
            "Effortlessly summarize text with AI for concise and accurate results.",
      ),
      CategoryModel(
        icon: 'sparkle',
        type: 'AI Translator',
        tagline:
            "Seamlessly translate text into multiple languages with AI precision.",
      ),
    ];
    emit(currentState.copyWith(models: models));
  }

  FutureOr<void> selectModelCategory(
    SelectModelCategory event,
    Emitter<ChatCategoryBottomSheetState> emit,
  ) {
    final currentState = state as ChatCategoryBottomSheetInitial;
    emit(currentState.copyWith(selectedIndex: event.index));
  }

  FutureOr<void> addAIChat(
    AddAIChat event,
    Emitter<ChatCategoryBottomSheetState> emit,
  ) async {
    try {
      AIChatRepository().addAIChat(chatType: event.chatType);
      print("HELL YEAH..  ADDED!!");
    } catch (e) {
      print("CANNOT ADD NEW CHAT!");
    }
  }
}
