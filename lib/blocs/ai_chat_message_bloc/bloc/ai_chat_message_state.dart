part of 'ai_chat_message_bloc.dart';

sealed class AiChatMessageState extends Equatable {
  const AiChatMessageState();

  @override
  List<Object> get props => [];
}

final class AiChatMessageInitial extends AiChatMessageState {
  final SummarizationConfig? summarizationConfig;
  final TranslationConfig? translationConfig;
  final Stream<List<Chat>> conversation;

  const AiChatMessageInitial({
    this.conversation = const Stream.empty(),
    this.summarizationConfig,
    this.translationConfig,
  });

  AiChatMessageInitial copyWith({
    Stream<List<Chat>>? conversation,
    SummarizationConfig? summarizationConfig,
    TranslationConfig? translationConfig,
  }) {
    return AiChatMessageInitial(
      conversation: conversation ?? this.conversation,
      summarizationConfig: summarizationConfig ?? this.summarizationConfig,
      translationConfig: translationConfig ?? this.translationConfig,
    );
  }

  @override
  List<Object> get props => [
        conversation,
        summarizationConfig ?? SummarizationConfig(),
        translationConfig ?? TranslationConfig(),
      ];
}
