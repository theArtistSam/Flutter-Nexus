import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/category_model.dart';

part 'chat_category_bottom_sheet_event.dart';
part 'chat_category_bottom_sheet_state.dart';

class ChatCategoryBottomSheetBloc
    extends Bloc<ChatCategoryBottomSheetEvent, ChatCategoryBottomSheetState> {
  ChatCategoryBottomSheetBloc() : super(ChatCategoryBottomSheetInitial()) {
    on<FetchModelCategories>(fetchModelCategories);
    on<SelectModelCategory>(selectModelCategory);
  }

  FutureOr<void> fetchModelCategories(
      FetchModelCategories event, Emitter<ChatCategoryBottomSheetState> emit) {
    final currentState = state as ChatCategoryBottomSheetInitial;

    List<CategoryModel> models = [
      CategoryModel(
        icon: 'sparkle',
        type: 'AI Summarizer ',
        tagline:
            "Discover AI Summarizer for precise text summarization. Choose your preferred length and style for a custom summary.",
      ),
      CategoryModel(
        icon: 'sparkle',
        type: 'AI Translator',
        tagline:
            "Discover AI Translator to effortlessly translate text across a wide variety of languages.",
      ),
    ];
    emit(currentState.copyWith(models: models));
  }

  FutureOr<void> selectModelCategory(
      SelectModelCategory event, Emitter<ChatCategoryBottomSheetState> emit) {
    final currentState = state as ChatCategoryBottomSheetInitial;
    emit(currentState.copyWith(selectedIndex: event.index));
  }
}
