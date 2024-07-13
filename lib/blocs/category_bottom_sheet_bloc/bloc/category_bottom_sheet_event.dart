part of 'category_bottom_sheet_bloc.dart';

sealed class CategoryBottomSheetEvent extends Equatable {
  const CategoryBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class FetchCategories extends CategoryBottomSheetEvent {}

class SelectCategory extends CategoryBottomSheetEvent {
  final int index;
  const SelectCategory({required this.index});
}
