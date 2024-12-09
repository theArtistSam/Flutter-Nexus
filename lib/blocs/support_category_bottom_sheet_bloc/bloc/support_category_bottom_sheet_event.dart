part of 'support_category_bottom_sheet_bloc.dart';

sealed class SupportCategoryBottomSheetEvent extends Equatable {
  const SupportCategoryBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class FetchIssueCategories extends SupportCategoryBottomSheetEvent {}

class SelectIssueCategory extends SupportCategoryBottomSheetEvent {
  final int index;
  const SelectIssueCategory({required this.index});
}

class AddIssue extends SupportCategoryBottomSheetEvent {
  final String issueCategory;
  const AddIssue({required this.issueCategory});
}
