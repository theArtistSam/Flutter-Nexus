part of 'support_category_bottom_sheet_bloc.dart';

sealed class SupportCategoryBottomSheetState extends Equatable {
  const SupportCategoryBottomSheetState();

  @override
  List<Object> get props => [];
}

final class SupportCategoryBottomSheetInitial
    extends SupportCategoryBottomSheetState {
  final List<CategoryModel> issues;
  final int selectedIndex;
  const SupportCategoryBottomSheetInitial({
    this.issues = const [],
    this.selectedIndex = 0,
  });

  SupportCategoryBottomSheetInitial copyWith({
    List<CategoryModel>? issues,
    int? selectedIndex,
  }) {
    return SupportCategoryBottomSheetInitial(
      issues: issues ?? this.issues,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [issues, selectedIndex];
}
