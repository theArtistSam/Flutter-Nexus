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

  const UploadBottomSheetInitial({
    this.isSelected = false,
    this.aiFeature = 'Summarization',
    this.pickedFiles = const [],
  });

  UploadBottomSheetInitial copyWith({
    bool? isSelected,
    String? aiFeature,
    List<Map<File, bool>>? pickedFiles,
  }) {
    return UploadBottomSheetInitial(
      isSelected: isSelected ?? this.isSelected,
      aiFeature: aiFeature ?? this.aiFeature,
      pickedFiles: pickedFiles ?? this.pickedFiles,
    );
  }

  @override
  List<Object> get props => [isSelected, aiFeature, pickedFiles];
}
