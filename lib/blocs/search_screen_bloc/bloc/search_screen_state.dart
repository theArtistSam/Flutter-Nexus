part of 'search_screen_bloc.dart';

sealed class SearchScreenState extends Equatable {
  const SearchScreenState();

  @override
  List<Object> get props => [];
}

final class SearchScreenInitial extends SearchScreenState {
  final Stream<List<ContentModel>> contents;

  const SearchScreenInitial({this.contents = const Stream.empty()});

  SearchScreenInitial copyWith({Stream<List<ContentModel>>? contents}) {
    return SearchScreenInitial(
      contents: contents ?? this.contents,
    );
  }

  @override
  List<Object> get props => [contents];
}
