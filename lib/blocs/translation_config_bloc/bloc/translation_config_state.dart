part of 'translation_config_bloc.dart';

sealed class TranslationConfigState extends Equatable {
  const TranslationConfigState();

  @override
  List<Object> get props => [];
}

final class TranslationConfigInitial extends TranslationConfigState {
  final TranslationConfig translationConfig;
  const TranslationConfigInitial({
    required this.translationConfig,
  });

  TranslationConfigInitial copyWith({TranslationConfig? translationConfig}) {
    return TranslationConfigInitial(
      translationConfig: translationConfig ?? this.translationConfig,
    );
  }

  @override
  List<Object> get props => [translationConfig];
}
