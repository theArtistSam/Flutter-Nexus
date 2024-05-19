class ContentModel {
  String? contentId;
  String? extractedText;
  String? dateUpdated;
  Translation? translation;
  Translation? summarization;
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

  ContentModel.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    extractedText = json['extracted_text'];
    dateUpdated = json['date_updated'];
    translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
    summarization = json['summarization'] != null
        ? Translation.fromJson(json['summarization'])
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

  Translation({this.text, this.status});

  Translation.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (status != null) {
      data['status'] = status!.toJson();
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
