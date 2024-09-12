part of 'search_bottom_sheet_bloc.dart';

sealed class SearchBottomSheetState extends Equatable {
  const SearchBottomSheetState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class SearchBottomSheetInitial extends SearchBottomSheetState {
  final Stream<List<ContentModel>> searchedContents;
  final Stream<List<FolderModel>> searchedFolders;
  final LibraryRepository searchService;
  final String searchQuery;

  const SearchBottomSheetInitial({
    this.searchedContents = const Stream.empty(),
    this.searchedFolders = const Stream.empty(),
    required this.searchService,
    this.searchQuery = '',
  });

  SearchBottomSheetInitial copyWith({
    Stream<List<ContentModel>>? searchedContents,
    Stream<List<FolderModel>>? searchedFolders,
    LibraryRepository? searchService,
    String? searchQuery,
  }) {
    return SearchBottomSheetInitial(
      searchedContents: searchedContents ?? this.searchedContents,
      searchService: searchService ?? this.searchService,
      searchQuery: searchQuery ?? this.searchQuery,
      searchedFolders: searchedFolders ?? this.searchedFolders,
    );
  }

  @override
  List<Object> get props =>
      [searchedContents, searchService, searchQuery, searchedFolders];
}
