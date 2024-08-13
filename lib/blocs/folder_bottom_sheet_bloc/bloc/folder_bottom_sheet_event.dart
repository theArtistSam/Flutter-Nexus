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

class UpdateFolder extends FolderBottomSheetEvent {
  final String title;
  const UpdateFolder({required this.title});
}

class CreateFolder extends FolderBottomSheetEvent {
  final String title;
  const CreateFolder({required this.title});
}

class DeleteFolder extends FolderBottomSheetEvent {
  final String folderId;
  const DeleteFolder({required this.folderId});
}
