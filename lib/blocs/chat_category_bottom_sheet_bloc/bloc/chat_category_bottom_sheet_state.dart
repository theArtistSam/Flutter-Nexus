part of 'chat_category_bottom_sheet_bloc.dart';

sealed class ChatCategoryBottomSheetState extends Equatable {
  const ChatCategoryBottomSheetState();

  @override
  List<Object> get props => [];
}

final class ChatCategoryBottomSheetInitial
    extends ChatCategoryBottomSheetState {
  final List<CategoryModel> models;
  final int selectedIndex;
  const ChatCategoryBottomSheetInitial({
    this.models = const [],
    this.selectedIndex = 0,
  });

  ChatCategoryBottomSheetInitial copyWith({
    List<CategoryModel>? models,
    int? selectedIndex,
  }) {
    return ChatCategoryBottomSheetInitial(
      models: models ?? this.models,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [models, selectedIndex];
}
