import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/category_model.dart';
import 'package:nexus/repositories/support_repository.dart';

part 'support_category_bottom_sheet_event.dart';
part 'support_category_bottom_sheet_state.dart';

class SupportCategoryBottomSheetBloc extends Bloc<
    SupportCategoryBottomSheetEvent, SupportCategoryBottomSheetState> {
  SupportCategoryBottomSheetBloc()
      : super(const SupportCategoryBottomSheetInitial()) {
    on<FetchIssueCategories>(fetchIssueCategories);
    on<SelectIssueCategory>(selectIssueCategory);
    on<AddIssue>(addIssue);
  }

  FutureOr<void> fetchIssueCategories(FetchIssueCategories event,
      Emitter<SupportCategoryBottomSheetState> emit) {
    final currentState = state as SupportCategoryBottomSheetInitial;

    List<CategoryModel> issues = [
      CategoryModel(
        icon: 'sparkle',
        type: 'AI Features',
        tagline:
            "Experiencing challenges with translation, transcription, or summarization?",
      ),
      CategoryModel(
        icon: 'globe-filled',
        type: 'Community',
        tagline:
            "Encountering issues with posts, guides, or data within the community?",
      ),
      CategoryModel(
        icon: 'sparkle',
        type: 'Application',
        tagline:
            "Having trouble with payment, content, or general application usage?",
      ),
      CategoryModel(
        icon: 'pen',
        type: 'Custom',
        tagline:
            "Dealing with a unique issue? Let us know and we'll figure it out",
      ),
    ];
    emit(currentState.copyWith(issues: issues));
  }

  FutureOr<void> selectIssueCategory(SelectIssueCategory event,
      Emitter<SupportCategoryBottomSheetState> emit) {
    final currentState = state as SupportCategoryBottomSheetInitial;
    emit(currentState.copyWith(selectedIndex: event.index));
  }

  FutureOr<void> addIssue(
      AddIssue event, Emitter<SupportCategoryBottomSheetState> emit) async {
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
