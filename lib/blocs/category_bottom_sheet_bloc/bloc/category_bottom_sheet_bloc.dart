import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/issue_model.dart';

part 'category_bottom_sheet_event.dart';
part 'category_bottom_sheet_state.dart';

class CategoryBottomSheetBloc
    extends Bloc<CategoryBottomSheetEvent, CategoryBottomSheetState> {
  CategoryBottomSheetBloc() : super(const CategoryBottomSheetInitial()) {
    on<FetchCategories>(fetchCategories);
    on<SelectCategory>(selectCategory);
  }

  FutureOr<void> fetchCategories(
      FetchCategories event, Emitter<CategoryBottomSheetState> emit) {
    final currentState = state as CategoryBottomSheetInitial;

    List<IssueModel> issues = [
      IssueModel(
        icon: 'sparkle',
        type: 'AI Features',
        tagline:
            "Experiencing challenges with translation, transcription, or summarization? We're here to help with all your AI feature needs.",
      ),
      IssueModel(
        icon: 'community-filled',
        type: 'Community',
        tagline:
            "Encountering issues with posts, guides, or data within the community? Let us assist you in resolving community-related problems.",
      ),
      IssueModel(
        icon: 'sparkle',
        type: 'Application',
        tagline:
            "Having trouble with folders, content, or general application usage? Our support team is ready to address your application concerns.",
      ),
      IssueModel(
        icon: 'pen',
        type: 'Custom',
        tagline:
            "Dealing with a unique issue? Describe your specific problem, and we'll make sure to find a tailored solution for you.",
      ),
    ];
    emit(currentState.copyWith(issues: issues));
  }

  FutureOr<void> selectCategory(
      SelectCategory event, Emitter<CategoryBottomSheetState> emit) {
    final currentState = state as CategoryBottomSheetInitial;
    emit(currentState.copyWith(selectedIndex: event.index));
  }
}
