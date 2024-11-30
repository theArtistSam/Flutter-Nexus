part of 'translation_config_bloc.dart';

sealed class TranslationConfigEvent extends Equatable {
  const TranslationConfigEvent();

  @override
  List<Object> get props => [];
}

class UpdateTranslationConfig extends TranslationConfigEvent {}
