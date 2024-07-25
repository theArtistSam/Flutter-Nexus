import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/repositories/content_repository.dart';

part 'search_bottom_sheet_event.dart';
part 'search_bottom_sheet_state.dart';

class SearchBottomSheetBloc
    extends Bloc<SearchBottomSheetEvent, SearchBottomSheetState> {
  SearchBottomSheetBloc() : super(SearchBottomSheetInitial()) {
    on<FetchContent>(fetchContent);
  }

  FutureOr<void> fetchContent(
      FetchContent event, Emitter<SearchBottomSheetState> emit) {
    final currentState = (state as SearchBottomSheetInitial);
    try {
      final content = ContentRepository().getAllContents();
      emit(currentState.copyWith(content: content));
    } catch (e) {
      print("CANNOT FETCH  CONTENT");
    }
  }
}
