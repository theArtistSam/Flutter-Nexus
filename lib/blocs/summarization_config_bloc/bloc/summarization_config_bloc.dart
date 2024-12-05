import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/model_configs/summarization_config.dart';
import 'package:nexus/repositories/chat_repository.dart';

part 'summarization_config_event.dart';
part 'summarization_config_state.dart';

class SummarizationConfigBloc
    extends Bloc<SummarizationConfigEvent, SummarizationConfigState> {
  final SummarizationConfig summarizationConfig;
  final String chatId;
  SummarizationConfigBloc({
    required this.summarizationConfig,
    required this.chatId,
  }) : super(SummarizationConfigInitial(
          summarizationConfig: summarizationConfig,
        )) {
    on<ChangeSummarizationLength>(changeSummarizationLength);
    on<ChangeSummarizationStyle>(changeSummarizationStyle);

    // initialize with current summarization config
    add(ChangeSummarizationStyle(
        isExtractive: summarizationConfig.type == 'extractive'));
    add(ChangeSummarizationLength(
        index: _getIndex(summarizationConfig.length!)));
  }

  FutureOr<void> changeSummarizationLength(
    ChangeSummarizationLength event,
    Emitter<SummarizationConfigState> emit,
  ) {
    final currentState = (state as SummarizationConfigInitial);
    emit(
      currentState.copyWith(
        index: event.index,
        summarizationConfig: currentState.summarizationConfig.copyWith(
          length: _getLength(event.index),
        ),
      ),
    );
  }

  String _getLength(int index) {
    const Map<int, String> map = {0: 'short', 1: 'medium', 2: 'long'};
    return map[index] ?? '';
  }

  int _getIndex(String length) {
    const Map<String, int> map = {'short': 0, 'medium': 1, 'long': 2};
    return map[length] ?? -1;
  }

  FutureOr<void> changeSummarizationStyle(
    ChangeSummarizationStyle event,
    Emitter<SummarizationConfigState> emit,
  ) {
    final currentState = (state as SummarizationConfigInitial);
    emit(
      currentState.copyWith(
        summarizationConfig: currentState.summarizationConfig.copyWith(
          type: event.isExtractive ? 'extractive' : 'abstractive',
        ),
      ),
    );
  }
}
