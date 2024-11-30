part of 'summarization_config_bloc.dart';

sealed class SummarizationConfigEvent extends Equatable {
  const SummarizationConfigEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ChangeSummarizationLength extends SummarizationConfigEvent {
  final int index;
  const ChangeSummarizationLength({required this.index});
}

class ChangeSummarizationStyle extends SummarizationConfigEvent {
  final bool isExtractive;
  const ChangeSummarizationStyle({required this.isExtractive});
}

class UpdateSummarizationConfig extends SummarizationConfigEvent {}
