part of 'summarization_config_bloc.dart';

sealed class SummarizationConfigState extends Equatable {
  const SummarizationConfigState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class SummarizationConfigInitial extends SummarizationConfigState {
  final int index;
  final SummarizationConfig summarizationConfig;
  const SummarizationConfigInitial({
    this.index = 1,
    required this.summarizationConfig,
  });

  SummarizationConfigInitial copyWith({
    int? index,
    SummarizationConfig? summarizationConfig,
  }) {
    return SummarizationConfigInitial(
      index: index ?? this.index,
      summarizationConfig: summarizationConfig ?? this.summarizationConfig,
    );
  }

  @override
  List<Object> get props => [index, summarizationConfig];
}
