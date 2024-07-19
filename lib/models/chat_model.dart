// class ChatModel {
//   String? _user;
//   String? _message;
//   String? _type;

//   ChatModel({String? user, String? message, String? type}) {
//     if (user != null) {
//       this._user = user;
//     }
//     if (message != null) {
//       this._message = message;
//     }
//     if (type != null) {
//       this._type = type;
//     }
//   }

//   String? get user => _user;
//   set user(String? user) => _user = user;
//   String? get message => _message;
//   set message(String? message) => _message = message;
//   String? get type => _type;
//   set type(String? type) => _type = type;

//   ChatModel.fromJson(Map<String, dynamic> json) {
//     _user = json['user'];
//     _message = json['message'];
//     _type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user'] = this._user;
//     data['message'] = this._message;
//     data['type'] = this._type;
//     return data;
//   }
// }

// ignore_for_file: unnecessary_getters_setters

class ChatModel {
  String? _userId;
  String? _chatId;
  List<Chat>? _conversation;
  String? _chatType;
  SummarizationConfig? _summarizationConfig;
  TranslationConfig? _translationConfig;

  ChatModel(
      {String? userId,
      String? chatId,
      List<Chat>? conversation,
      String? chatType,
      SummarizationConfig? summarizationConfig,
      TranslationConfig? translationConfig}) {
    if (userId != null) {
      _userId = userId;
    }
    if (chatId != null) {
      _chatId = chatId;
    }
    if (conversation != null) {
      _conversation = conversation;
    }
    if (chatType != null) {
      _chatType = chatType;
    }
    if (summarizationConfig != null) {
      _summarizationConfig = summarizationConfig;
    }
    if (translationConfig != null) {
      _translationConfig = translationConfig;
    }
  }

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get chatId => _chatId;
  set chatId(String? chatId) => _chatId = chatId;
  List<Chat>? get conversation => _conversation;
  set conversation(List<Chat>? conversation) => _conversation = conversation;
  String? get chatType => _chatType;
  set chatType(String? chatType) => _chatType = chatType;
  SummarizationConfig? get summarizationConfig => _summarizationConfig;
  set summarizationConfig(SummarizationConfig? summarizationConfig) =>
      _summarizationConfig = summarizationConfig;
  TranslationConfig? get translationConfig => _translationConfig;
  set translationConfig(TranslationConfig? translationConfig) =>
      _translationConfig = translationConfig;

  ChatModel.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _chatId = json['chat_id'];
    if (json['conversation'] != null) {
      _conversation = <Chat>[];
      json['conversation'].forEach((v) {
        _conversation!.add(Chat.fromJson(v));
      });
    }
    _chatType = json['chat_type'];
    _summarizationConfig = json['summarization_config'] != null
        ? SummarizationConfig.fromJson(json['summarization_config'])
        : null;
    _translationConfig = json['translation_config'] != null
        ? TranslationConfig.fromJson(json['translation_config'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = _userId;
    data['chat_id'] = _chatId;
    if (_conversation != null) {
      data['conversation'] = _conversation!.map((v) => v.toJson()).toList();
    }
    data['chat_type'] = _chatType;
    if (_summarizationConfig != null) {
      data['summarization_config'] = _summarizationConfig!.toJson();
    }
    if (_translationConfig != null) {
      data['translation_config'] = _translationConfig!.toJson();
    }
    return data;
  }
}

class Chat {
  String? _text;
  String? _messageType;
  String? _datetime;
  ResponseStatus? _responseStatus;

  Chat(
      {String? text,
      String? messageType,
      String? datetime,
      ResponseStatus? responseStatus}) {
    if (text != null) {
      _text = text;
    }
    if (messageType != null) {
      _messageType = messageType;
    }
    if (datetime != null) {
      _datetime = datetime;
    }
    if (responseStatus != null) {
      _responseStatus = responseStatus;
    }
  }

  String? get text => _text;
  set text(String? text) => _text = text;
  String? get messageType => _messageType;
  set messageType(String? messageType) => _messageType = messageType;
  String? get datetime => _datetime;
  set datetime(String? datetime) => _datetime = datetime;
  ResponseStatus? get responseStatus => _responseStatus;
  set responseStatus(ResponseStatus? responseStatus) =>
      _responseStatus = responseStatus;

  Chat.fromJson(Map<String, dynamic> json) {
    _text = json['text'];
    _messageType = json['message_type'];
    _datetime = json['datetime'];
    _responseStatus = json['response_status'] != null
        ? ResponseStatus.fromJson(json['response_status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = _text;
    data['message_type'] = _messageType;
    data['datetime'] = _datetime;
    if (_responseStatus != null) {
      data['response_status'] = _responseStatus!.toJson();
    }
    return data;
  }
}

class ResponseStatus {
  bool? _isLiked;
  bool? _isDisliked;

  ResponseStatus({bool? isLiked, bool? isDisliked}) {
    if (isLiked != null) {
      _isLiked = isLiked;
    }
    if (isDisliked != null) {
      _isDisliked = isDisliked;
    }
  }

  bool? get isLiked => _isLiked;
  set isLiked(bool? isLiked) => _isLiked = isLiked;
  bool? get isDisliked => _isDisliked;
  set isDisliked(bool? isDisliked) => _isDisliked = isDisliked;

  ResponseStatus.fromJson(Map<String, dynamic> json) {
    _isLiked = json['is_liked'];
    _isDisliked = json['is_disliked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_liked'] = _isLiked;
    data['is_disliked'] = _isDisliked;
    return data;
  }
}

class SummarizationConfig {
  String? _length;
  int? _sentences;
  String? _style;

  SummarizationConfig({String? length, int? sentences, String? style}) {
    if (length != null) {
      _length = length;
    }
    if (sentences != null) {
      _sentences = sentences;
    }
    if (style != null) {
      _style = style;
    }
  }

  String? get length => _length;
  set length(String? length) => _length = length;
  int? get sentences => _sentences;
  set sentences(int? sentences) => _sentences = sentences;
  String? get style => _style;
  set style(String? style) => _style = style;

  SummarizationConfig.fromJson(Map<String, dynamic> json) {
    _length = json['length'];
    _sentences = json['sentences'];
    _style = json['style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = _length;
    data['sentences'] = _sentences;
    data['style'] = _style;
    return data;
  }
}

class TranslationConfig {
  String? _sourceLanguage;
  String? _targetLanguage;

  TranslationConfig({String? sourceLanguage, String? targetLanguage}) {
    if (sourceLanguage != null) {
      _sourceLanguage = sourceLanguage;
    }
    if (targetLanguage != null) {
      _targetLanguage = targetLanguage;
    }
  }

  String? get sourceLanguage => _sourceLanguage;
  set sourceLanguage(String? sourceLanguage) =>
      _sourceLanguage = sourceLanguage;
  String? get targetLanguage => _targetLanguage;
  set targetLanguage(String? targetLanguage) =>
      _targetLanguage = targetLanguage;

  TranslationConfig.fromJson(Map<String, dynamic> json) {
    _sourceLanguage = json['source-language'];
    _targetLanguage = json['target-language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source-language'] = _sourceLanguage;
    data['target-language'] = _targetLanguage;
    return data;
  }
}
