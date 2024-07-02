import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/repositories/content_repository.dart';

part 'search_screen_event.dart';
part 'search_screen_state.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  SearchScreenBloc() : super(const SearchScreenInitial()) {
    on<LoadContentStream>(fetchContentStream);
  }

  FutureOr<void> fetchContentStream(
      LoadContentStream event, Emitter<SearchScreenState> emit) async {
    final currentState = state as SearchScreenInitial;
    try {
      Stream<List<ContentModel>> contentList =
          ContentRepository().getAllContents();
      emit(currentState.copyWith(contents: contentList));

      print('LOADING ... ');
    } catch (e) {
      print("Some Shitty Error");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
