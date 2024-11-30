import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/support_model.dart';
import 'package:nexus/repositories/support_repository.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc() : super(const SupportInitial()) {
    on<FetchIssues>(fetchIssues);
  }

  FutureOr<void> fetchIssues(FetchIssues event, Emitter<SupportState> emit) {
    final currentState = state as SupportInitial;

    try {
      Stream<List<SupportModel>> issuesList =
          SupportRepository().getAllIssues();

      emit(currentState.copyWith(issues: issuesList));
      print('LOADING ... ');
    } catch (e) {
      print("SHIT FAILED TO LOAD ISSUES...");
      // emit(currentState.copyWith(status: ContentStatus.failure));
    }
  }
}
