part of 'category_bottom_sheet_bloc.dart';

sealed class CategoryBottomSheetState extends Equatable {
  const CategoryBottomSheetState();

  @override
  List<Object> get props => [];
}

final class CategoryBottomSheetInitial extends CategoryBottomSheetState {
  final List<IssueModel> issues;
  final int selectedIndex;
  const CategoryBottomSheetInitial(
      {this.issues = const [], this.selectedIndex = 0});

  CategoryBottomSheetInitial copyWith({
    List<IssueModel>? issues,
    int? selectedIndex,
  }) {
    return CategoryBottomSheetInitial(
        issues: issues ?? this.issues,
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props => [issues, selectedIndex];
}
