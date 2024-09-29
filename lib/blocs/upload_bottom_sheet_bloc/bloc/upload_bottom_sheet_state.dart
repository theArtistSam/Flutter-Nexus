part of 'upload_bottom_sheet_bloc.dart';

sealed class UploadBottomSheetState extends Equatable {
  const UploadBottomSheetState();

  @override
  List<Object> get props => [];
}

final class UploadBottomSheetInitial extends UploadBottomSheetState {
  final bool isSelected;
  final String aiFeature;
  final List<Map<File, bool>> pickedFiles;
  final List<ContentModel> content;
  final int count;
  final ReturnResponseStatus status;

  // file, isPicked, extracted_data,

  const UploadBottomSheetInitial({
    this.isSelected = false,
    this.aiFeature = 'Summarization',
    this.pickedFiles = const [],
    this.count = 0,
    this.status = ReturnResponseStatus.initial,
    this.content = const [],
  });

  UploadBottomSheetInitial copyWith({
    bool? isSelected,
    String? aiFeature,
    List<Map<File, bool>>? pickedFiles,
    int? count,
    ReturnResponseStatus? status,
    List<ContentModel>? content,
  }) {
    return UploadBottomSheetInitial(
      isSelected: isSelected ?? this.isSelected,
      aiFeature: aiFeature ?? this.aiFeature,
      pickedFiles: pickedFiles ?? this.pickedFiles,
      count: count ?? this.count,
      status: status ?? this.status,
      content: content ?? this.content,
    );
  }

  @override
  List<Object> get props => [
        isSelected,
        aiFeature,
        pickedFiles,
        count,
        status,
        content,
      ];
}
