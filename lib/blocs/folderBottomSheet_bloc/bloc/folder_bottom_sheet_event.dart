part of 'folder_bottom_sheet_bloc.dart';

sealed class FolderBottomSheetEvent extends Equatable {
  const FolderBottomSheetEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class SelectFolderIcon extends FolderBottomSheetEvent {
  int index;
  SelectFolderIcon({required this.index});
}
