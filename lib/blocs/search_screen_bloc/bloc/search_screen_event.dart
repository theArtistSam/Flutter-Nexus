part of 'search_screen_bloc.dart';

sealed class SearchScreenEvent extends Equatable {
  const SearchScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadContentStream extends SearchScreenEvent {}
