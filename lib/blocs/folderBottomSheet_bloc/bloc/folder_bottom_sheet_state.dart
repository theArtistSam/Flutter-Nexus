part of 'folder_bottom_sheet_bloc.dart';

sealed class FolderBottomSheetState extends Equatable {
  const FolderBottomSheetState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class FolderBottomSheetInitial extends FolderBottomSheetState {
  int index;
  FolderBottomSheetInitial({this.index = 0});

  FolderBottomSheetInitial copyWith({int? index}) {
    return FolderBottomSheetInitial(index: index ?? this.index);
  }

  @override
  List<Object> get props => [index];
}
