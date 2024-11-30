class ContentModel {
  String? contentId;
  String? extractedText;
  String? dateUpdated;
  Translation? translation;
  Summarization? summarization;
  String? type;
  String? title;
  String? folderId;
  String? thumbnail;
  String? link;
  List<String>? tags;

  ContentModel(
      {this.contentId,
      this.extractedText,
      this.dateUpdated,
      this.translation,
      this.summarization,
      this.type,
      this.title,
      this.folderId,
      this.thumbnail,
      this.link,
      this.tags});

  ContentModel copyWith({
    String? contentId,
    String? extractedText,
    String? dateUpdated,
    Translation? translation,
    Summarization? summarization,
    String? type,
    String? title,
    String? folderId,
    String? thumbnail,
    String? link,
    List<String>? tags,
  }) {
    return ContentModel(
      contentId: contentId ?? this.contentId,
      extractedText: extractedText ?? this.extractedText,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      translation: translation ?? this.translation,
      summarization: summarization ?? this.summarization,
      type: type ?? this.type,
      title: title ?? this.title,
      folderId: folderId ?? this.folderId,
      thumbnail: thumbnail ?? this.thumbnail,
      link: link ?? this.link,
      tags: tags ?? this.tags,
    );
  }

  ContentModel.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    extractedText = json['extracted_text'];
    dateUpdated = json['date_updated'];
    translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
    summarization = json['summarization'] != null
        ? Summarization.fromJson(json['summarization'])
        : null;
    type = json['type'];
    title = json['title'];
    folderId = json['folder_id'];
    thumbnail = json['thumbnail'];
    link = json['link'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content_id'] = contentId;
    data['extracted_text'] = extractedText;
    data['date_updated'] = dateUpdated;
    if (translation != null) {
      data['translation'] = translation!.toJson();
    }
    if (summarization != null) {
      data['summarization'] = summarization!.toJson();
    }
    data['type'] = type;
    data['title'] = title;
    data['folder_id'] = folderId;
    data['thumbnail'] = thumbnail;
    data['link'] = link;
    data['tags'] = tags;
    return data;
  }
}

class Translation {
  String? text;
  Status? status;
  TranslationConfig? translationConfig;

  Translation({this.text, this.status, this.translationConfig});

  Translation.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    translationConfig = json['translation_config'] != null
        ? TranslationConfig.fromJson(json['translation_config'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (translationConfig != null) {
      data['translation_config'] = translationConfig!.toJson();
    }
    return data;
  }
}

class Status {
  bool? isLiked;
  bool? isDisliked;

  Status({this.isLiked, this.isDisliked});

  Status.fromJson(Map<String, dynamic> json) {
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

class TranslationConfig {
  String? sourceLanguage;
  String? targetLanguage;

  TranslationConfig({this.sourceLanguage, this.targetLanguage});

  TranslationConfig.fromJson(Map<String, dynamic> json) {
    sourceLanguage = json['source_language'];
    targetLanguage = json['target_language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source_language'] = sourceLanguage;
    data['target_language'] = targetLanguage;
    return data;
  }
}

class Summarization {
  String? text;
  Status? status;
  SummarizationConfig? summarizationConfig;

  Summarization({this.text, this.status, this.summarizationConfig});

  Summarization.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    summarizationConfig = json['summarization_config'] != null
        ? SummarizationConfig.fromJson(json['summarization_config'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (summarizationConfig != null) {
      data['summarization_config'] = summarizationConfig!.toJson();
    }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['length'] = length;
    return data;
  }
}
