import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/models/folder_model.dart';
import 'package:nexus/repositories/library_repository.dart';

part 'search_bottom_sheet_event.dart';
part 'search_bottom_sheet_state.dart';

class SearchBottomSheetBloc
    extends Bloc<SearchBottomSheetEvent, SearchBottomSheetState> {
  final LibraryRepository _searchService;

  // Constructor with dependency injection for FirebaseSearchService
  SearchBottomSheetBloc(this._searchService)
      : super(SearchBottomSheetInitial(searchService: _searchService)) {
    on<SearchContent>(searchContent);
    on<SearchFolder>(searchFolder);
  }

  FutureOr<void> searchContent(
      SearchContent event, Emitter<SearchBottomSheetState> emit) async {
    final currentState = state as SearchBottomSheetInitial;
    try {
      // Perform the search using the FirebaseSearchService
      final searchedContentsStream = _searchService.searchContent(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        searchQuery: event.query,
      );

      // Emit the state with the updated search results
      emit(currentState.copyWith(
        searchedContents: searchedContentsStream,
        searchQuery: event.query,
      ));
    } catch (e) {
      print("Error during search: $e");
    }
  }

  FutureOr<void> searchFolder(event, Emitter<SearchBottomSheetState> emit) {
    final currentState = state as SearchBottomSheetInitial;
    try {
      // Perform the search using the FirebaseSearchService
      final searchedFoldersStream = _searchService.searchFolder(
        userId: 'Bd4umkyLqOLnMpdOLZ0E',
        searchQuery: event.query,
      );

      // Emit the state with the updated search results
      emit(currentState.copyWith(
        searchedFolders: searchedFoldersStream,
        searchQuery: event.query,
      ));
    } catch (e) {
      print("Error during search: $e");
    }
  }
}
