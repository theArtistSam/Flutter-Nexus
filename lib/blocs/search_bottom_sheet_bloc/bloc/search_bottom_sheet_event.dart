part of 'search_bottom_sheet_bloc.dart';

sealed class SearchBottomSheetEvent extends Equatable {
  const SearchBottomSheetEvent();

  @override
  List<Object> get props => [];
}

class FetchContent extends SearchBottomSheetEvent {}

class SearchContent extends SearchBottomSheetEvent {
  final String query;
  const SearchContent({required this.query});
}

class SearchFolder extends SearchBottomSheetEvent {
  final String query;
  const SearchFolder({required this.query});
}
