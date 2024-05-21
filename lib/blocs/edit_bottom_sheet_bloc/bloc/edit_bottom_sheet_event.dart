// ignore_for_file: must_be_immutable

part of 'edit_bottom_sheet_bloc.dart';

sealed class EditBottomSheetEvent extends Equatable {
  const EditBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends EditBottomSheetEvent {}

class ToggleView extends EditBottomSheetEvent {
  bool isLeftSelected;
  ToggleView({required this.isLeftSelected});
}

class AddTag extends EditBottomSheetEvent {
  String contentId;
  String tag;
  AddTag({
    required this.tag,
    required this.contentId,
  });
}

class RemoveTag extends EditBottomSheetEvent {
  String contentId;
  String tag;
  RemoveTag({
    required this.tag,
    required this.contentId,
  });
}

class DeleteContent extends EditBottomSheetEvent {
  String contentId;
  DeleteContent({required this.contentId});
}

class ChangeThumbnail extends EditBottomSheetEvent {
  File file;
  String contentId;
  ChangeThumbnail({required this.file, required this.contentId});
}
