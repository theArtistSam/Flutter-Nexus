part of 'edit_bottom_sheet_bloc.dart';

sealed class EditBottomSheetState extends Equatable {
  const EditBottomSheetState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class EditBottomSheetInitial extends EditBottomSheetState {
  bool isLeftSelected;
  final ContentModel? content;
  List<FolderModel> folders;
  TagsStatus status;

  EditBottomSheetInitial(
      {this.isLeftSelected = true,
      this.content,
      this.folders = const <FolderModel>[],
      this.status = TagsStatus.loading});

  EditBottomSheetInitial copyWith(
      {bool? isLeftSelected,
      ContentModel? content,
      List<FolderModel>? folders,
      TagsStatus? status}) {
    return EditBottomSheetInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected,
        content: content ?? this.content,
        folders: folders ?? this.folders,
        status: status ?? this.status);
  }

  @override
  List<Object> get props =>
      [isLeftSelected, content ?? ContentModel(), folders, status];
}
