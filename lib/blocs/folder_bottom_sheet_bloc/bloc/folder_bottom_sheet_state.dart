part of 'folder_bottom_sheet_bloc.dart';

sealed class FolderBottomSheetState extends Equatable {
  const FolderBottomSheetState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class FolderBottomSheetInitial extends FolderBottomSheetState {
  FolderModel folder;
  FolderBottomSheetInitial({
    required this.folder,
  });

  FolderBottomSheetInitial copyWith({int? index, FolderModel? folder}) {
    return FolderBottomSheetInitial(
      folder: folder ?? this.folder,
    );
  }

  @override
  List<Object> get props => [folder];
}
