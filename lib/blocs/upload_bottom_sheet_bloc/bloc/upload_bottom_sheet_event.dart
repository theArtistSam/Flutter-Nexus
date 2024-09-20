part of 'upload_bottom_sheet_bloc.dart';

sealed class UploadBottomSheetEvent extends Equatable {
  const UploadBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class Select extends UploadBottomSheetEvent {}

class ToggleSelectFile extends UploadBottomSheetEvent {
  final File file;
  const ToggleSelectFile({required this.file});
}

class SelectAiFeature extends UploadBottomSheetEvent {
  final String aiFeature;
  const SelectAiFeature({required this.aiFeature});
}

class PickFile extends UploadBottomSheetEvent {
  final File file;
  const PickFile({required this.file});
}

class UploadFilesLocal extends UploadBottomSheetEvent {
  final Map<String, bool> file;
  const UploadFilesLocal({required this.file});
}

class UploadFilesDrive extends UploadBottomSheetEvent {}

class RemoveSelectedFiles extends UploadBottomSheetEvent {}

class ProceedUpload extends UploadBottomSheetEvent {}
