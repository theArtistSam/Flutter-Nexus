import 'package:nexus/models/model_configs/summarization_config.dart';
import 'package:nexus/models/model_configs/translation_config.dart';

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
  String? responseMessageId; // New attribute
  ResponseStatus? responseStatus;

  Chat({
    this.text,
    this.messageType,
    this.datetime,
    this.responseMessageId, // Initialize new attribute
    this.responseStatus,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    messageType = json['message_type'];
    datetime = json['datetime'];
    responseMessageId = json['response_message_id']; // Map new attribute
    responseStatus = json['response_status'] != null
        ? ResponseStatus.fromJson(json['response_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['message_type'] = messageType;
    data['datetime'] = datetime;
    // Only include responseMessageId if it's not null
    if (responseMessageId != null) {
      data['response_message_id'] = responseMessageId;
    }
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
