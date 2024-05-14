part of 'edit_bottom_sheet_bloc.dart';

sealed class EditBottomSheetState extends Equatable {
  const EditBottomSheetState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class EditBottomSheetInitial extends EditBottomSheetState {
  bool isLeftSelected;
  EditBottomSheetInitial({this.isLeftSelected = true});

  EditBottomSheetInitial copyWith({bool? isLeftSelected}) {
    return EditBottomSheetInitial(
        isLeftSelected: isLeftSelected ?? this.isLeftSelected);
  }

  @override
  List<Object> get props => [isLeftSelected];
}
