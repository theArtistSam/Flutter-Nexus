part of 'search_bottom_sheet_bloc.dart';

sealed class SearchBottomSheetEvent extends Equatable {
  const SearchBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class FetchContent extends SearchBottomSheetEvent {}
