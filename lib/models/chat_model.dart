class ChatModel {
  String? userId;
  String? chatId;
  List<Chat>? conversation;
  String? chatType;
  SummarizationConfig? summarizationConfig;
  TranslationConfig? translationConfig;

  ChatModel({
    this.userId,
    this.chatId,
    this.conversation,
    this.chatType,
    this.summarizationConfig,
    this.translationConfig,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    chatId = json['chat_id'];
    if (json['conversation'] != null) {
      conversation = <Chat>[];
      json['conversation'].forEach((v) {
        conversation!.add(Chat.fromJson(v));
      });
    }
    chatType = json['chat_type'];
    summarizationConfig = json['summarization_config'] != null
        ? SummarizationConfig.fromJson(json['summarization_config'])
        : null;
    translationConfig = json['translation_config'] != null
        ? TranslationConfig.fromJson(json['translation_config'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['chat_id'] = chatId;
    if (conversation != null) {
      data['conversation'] = conversation!.map((v) => v.toJson()).toList();
    }
    data['chat_type'] = chatType;
    if (summarizationConfig != null) {
      data['summarization_config'] = summarizationConfig!.toJson();
    }
    if (translationConfig != null) {
      data['translation_config'] = translationConfig!.toJson();
    }
    return data;
  }
}

class Chat {
  String? text;
  String? messageType;
  String? datetime;
  ResponseStatus? responseStatus;

  Chat({this.text, this.messageType, this.datetime, this.responseStatus});

  Chat.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    messageType = json['message_type'];
    datetime = json['datetime'];
    responseStatus = json['response_status'] != null
        ? ResponseStatus.fromJson(json['response_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['message_type'] = messageType;
    data['datetime'] = datetime;
    if (responseStatus != null) {
      data['response_status'] = responseStatus!.toJson();
    }
    return data;
  }
}

class ResponseStatus {
  bool? isLiked;
  bool? isDisliked;

  ResponseStatus({this.isLiked, this.isDisliked});

  ResponseStatus.fromJson(Map<String, dynamic> json) {
    isLiked = json['is_liked'];
    isDisliked = json['is_disliked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_liked'] = isLiked;
    data['is_disliked'] = isDisliked;
    return data;
  }
}

class SummarizationConfig {
  String? type;
  String? length;

  SummarizationConfig({this.type, this.length});

  SummarizationConfig.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    length = json['length'];
  }
  SummarizationConfig copyWith({
    String? type,
    String? length,
  }) {
    return SummarizationConfig(
      type: type ?? this.type,
      length: length ?? this.length,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['length'] = length;
    return data;
  }
}

class TranslationConfig {
  List<String>? sourceLanguages;
  List<String>? targetLanguages;

  TranslationConfig({this.sourceLanguages, this.targetLanguages});

  TranslationConfig.fromJson(Map<String, dynamic> json) {
    sourceLanguages = json['source_languages'].cast<String>();
    targetLanguages = json['target_languages'].cast<String>();
  }
  TranslationConfig copyWith({
    List<String>? sourceLanguages,
    List<String>? targetLanguages,
  }) {
    return TranslationConfig(
      sourceLanguages: sourceLanguages ?? this.sourceLanguages,
      targetLanguages: targetLanguages ?? this.targetLanguages,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source_languages'] = sourceLanguages;
    data['target_languages'] = targetLanguages;
    return data;
  }
}
