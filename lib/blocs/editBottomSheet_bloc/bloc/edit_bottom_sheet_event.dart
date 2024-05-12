part of 'edit_bottom_sheet_bloc.dart';

sealed class EditBottomSheetEvent extends Equatable {
  const EditBottomSheetEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ToggleView extends EditBottomSheetEvent {
  bool isLeftSelected;
  ToggleView({required this.isLeftSelected});
}
