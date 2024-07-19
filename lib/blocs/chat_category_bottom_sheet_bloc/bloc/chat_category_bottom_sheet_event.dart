part of 'chat_category_bottom_sheet_bloc.dart';

sealed class ChatCategoryBottomSheetEvent extends Equatable {
  const ChatCategoryBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class FetchModelCategories extends ChatCategoryBottomSheetEvent {}

class SelectModelCategory extends ChatCategoryBottomSheetEvent {
  final int index;
  const SelectModelCategory({required this.index});
}
