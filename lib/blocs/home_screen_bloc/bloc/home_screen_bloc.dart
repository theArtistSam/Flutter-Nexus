import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/content_model.dart';
import 'package:nexus/repositories/content_repository.dart';
import 'package:nexus/utils/enums.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<LoadContent>(loadContent);
  }

  FutureOr<void> loadContent(
      LoadContent event, Emitter<HomeScreenState> emit) async {
    // Check if the current state is HomeScreenLoadContent
    final currentState = state as HomeScreenInitial;

    // TODO: FIX THE last_updated to add the below query
    // queryBuilder: (query) => query
    //         .orderBy(
    //           'timestamp',
    //           descending: true,
    //         ) // Replace 'timestamp' with the field indicating when the content was added
    //         .limit(3),
    try {
      Stream<List<ContentModel>> contentList =
          ContentRepository().getAllContents();
      emit(currentState.copyWith(
          contents: contentList, status: ContentStatus.success));

      print('LOADING ... ');
    } catch (e) {
      emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
