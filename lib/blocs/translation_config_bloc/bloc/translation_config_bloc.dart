import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nexus/models/chat_model.dart';
import 'package:nexus/models/model_configs/translation_config.dart';

part 'translation_config_event.dart';
part 'translation_config_state.dart';

class TranslationConfigBloc
    extends Bloc<TranslationConfigEvent, TranslationConfigState> {
  final TranslationConfig translationConfig;
  final String chatId;
  TranslationConfigBloc({
    required this.translationConfig,
    required this.chatId,
  }) : super(TranslationConfigInitial(translationConfig: translationConfig)) {
    // on<>
  }
}
