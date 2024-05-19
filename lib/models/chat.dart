class Chat {
  String? userId;
  List<ChatText>? allTranslations;
  List<ChatText>? allSummarizations;

  Chat({this.userId, this.allTranslations, this.allSummarizations});

  Chat.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    if (json['all_translations'] != null) {
      allTranslations = <ChatText>[];
      json['all_translations'].forEach((v) {
        allTranslations!.add(ChatText.fromJson(v['chat_text']));
      });
    }
    if (json['all_summarizations'] != null) {
      allSummarizations = <ChatText>[];
      json['all_summarizations'].forEach((v) {
        allSummarizations!.add(ChatText.fromJson(v['chat_text']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    if (allTranslations != null) {
      data['all_translations'] =
          allTranslations!.map((v) => {'chat_text': v.toJson()}).toList();
    }
    if (allSummarizations != null) {
      data['all_summarizations'] =
          allSummarizations!.map((v) => {'chat_text': v.toJson()}).toList();
    }
    return data;
  }
}

class ChatText {
  String? originalText;
  String? responseText;
  String? datetime;
  ResponseStatus? responseStatus;

  ChatText(
      {this.originalText,
      this.responseText,
      this.datetime,
      this.responseStatus});

  ChatText.fromJson(Map<String, dynamic> json) {
    originalText = json['original_text'];
    responseText = json['response_text'];
    datetime = json['datetime'];
    responseStatus = json['response_status'] != null
        ? ResponseStatus.fromJson(json['response_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['original_text'] = originalText;
    data['response_text'] = responseText;
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
