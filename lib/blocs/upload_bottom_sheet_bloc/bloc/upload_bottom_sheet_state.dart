part of 'upload_bottom_sheet_bloc.dart';

sealed class UploadBottomSheetState extends Equatable {
  const UploadBottomSheetState();

  @override
  List<Object> get props => [];
}

final class UploadBottomSheetInitial extends UploadBottomSheetState {
  final bool isSelected;
  final String aiFeature;
  final List<Map<String, bool>> files;

  const UploadBottomSheetInitial({
    this.isSelected = false,
    this.aiFeature = 'Summarization',
    this.files = const [],
  });

  UploadBottomSheetInitial copyWith({
    bool? isSelected,
    String? aiFeature,
    List<Map<String, bool>>? files,
  }) {
    return UploadBottomSheetInitial(
      isSelected: isSelected ?? this.isSelected,
      aiFeature: aiFeature ?? this.aiFeature,
      files: files ?? this.files,
    );
  }

  @override
  List<Object> get props => [isSelected, aiFeature, files];
}
