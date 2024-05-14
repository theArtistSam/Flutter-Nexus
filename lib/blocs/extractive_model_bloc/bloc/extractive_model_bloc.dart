import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/extractive_model.dart';
import 'package:nexus/repositories/extractive_model_repository.dart';
import 'package:nexus/utils/enums.dart';

part 'extractive_model_event.dart';
part 'extractive_model_state.dart';

class ExtractiveModelBloc
    extends Bloc<ExtractiveModelEvent, ExtractiveModelState> {
  ExtractiveModelRepository extractiveModelRepository =
      ExtractiveModelRepository();

  ExtractiveModelBloc() : super(const ExtractiveModelInitial()) {
    on<FetchModelResult>(fetchModelResult);
  }

  Future<void> fetchModelResult(
      FetchModelResult event, Emitter<ExtractiveModelState> emit) async {
    final currentState = state
        as ExtractiveModelInitial; // You don't need to cast state as ExtractiveModelInitial, since it's already of type ExtractiveModelState
    try {
      final response =
          await extractiveModelRepository.sendRequest(text: event.text);
      emit(currentState.copyWith(
        status: ModelStatus.success,
        message: response.text,
      ));
    } catch (error) {
      emit(currentState.copyWith(
        status: ModelStatus.failure,
        message: error.toString(),
      ));
    }
  }
}
