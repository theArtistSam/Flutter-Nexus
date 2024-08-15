part of 'upload_bottom_sheet_bloc.dart';

sealed class UploadBottomSheetEvent extends Equatable {
  const UploadBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class Select extends UploadBottomSheetEvent {}

class ToggleSelectFile extends UploadBottomSheetEvent {
  final String fileName;
  const ToggleSelectFile({required this.fileName});
}

class SelectAiFeature extends UploadBottomSheetEvent {
  final String aiFeature;
  const SelectAiFeature({required this.aiFeature});
}

class UploadFilesLocal extends UploadBottomSheetEvent {
  final Map<String, bool> file;
  const UploadFilesLocal({required this.file});
}

class UploadFilesDrive extends UploadBottomSheetEvent {}

class RemoveSelectedFiles extends UploadBottomSheetEvent {}

class ProceedUpload extends UploadBottomSheetEvent {}
