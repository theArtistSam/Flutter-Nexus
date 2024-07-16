import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/issue_model.dart';
import 'package:nexus/repositories/support_repository.dart';

part 'category_bottom_sheet_event.dart';
part 'category_bottom_sheet_state.dart';

class CategoryBottomSheetBloc
    extends Bloc<CategoryBottomSheetEvent, CategoryBottomSheetState> {
  CategoryBottomSheetBloc() : super(const CategoryBottomSheetInitial()) {
    on<FetchCategories>(fetchCategories);
    on<SelectCategory>(selectCategory);
    on<AddIssue>(addIssue);
  }

  FutureOr<void> fetchCategories(
      FetchCategories event, Emitter<CategoryBottomSheetState> emit) {
    final currentState = state as CategoryBottomSheetInitial;

    List<IssueModel> issues = [
      IssueModel(
        icon: 'sparkle',
        type: 'AI Features',
        tagline:
            "Experiencing challenges with translation, transcription, or summarization?",
      ),
      IssueModel(
        icon: 'community-filled',
        type: 'Community',
        tagline:
            "Encountering issues with posts, guides, or data within the community?",
      ),
      IssueModel(
        icon: 'sparkle',
        type: 'Application',
        tagline:
            "Having trouble with folders, content, or general application usage?",
      ),
      IssueModel(
        icon: 'pen',
        type: 'Custom',
        tagline:
            "Dealing with a unique issue? Let us know and we'll figure it out",
      ),
    ];
    emit(currentState.copyWith(issues: issues));
  }

  FutureOr<void> selectCategory(
      SelectCategory event, Emitter<CategoryBottomSheetState> emit) {
    final currentState = state as CategoryBottomSheetInitial;
    emit(currentState.copyWith(selectedIndex: event.index));
  }

  FutureOr<void> addIssue(
      AddIssue event, Emitter<CategoryBottomSheetState> emit) async {
    try {
      await SupportRepository().addIssue(
        userId: event.userId,
        issueCategory: event.issueCategory,
      );

      print('ADDED THE ISSUE ... ');
    } catch (e) {
      print("SHIT FAILED TO ADD THE ISSUE...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
