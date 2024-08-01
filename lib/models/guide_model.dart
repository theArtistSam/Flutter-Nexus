// ignore_for_file: unnecessary_getters_setters

class GuideModel {
  String? _guideId;
  String? _title;
  String? _description;
  String? _type;
  String? _link;
  String? _thumbnail;
  String? _datePosted;
  bool? _isVisible;
  int? _totalLikes;
  List<String>? _viewedBy;
  List<String>? _likedBy;

  GuideModel(
      {String? guideId,
      String? title,
      String? description,
      String? type,
      String? link,
      int? totalLikes,
      String? thumbnail,
      String? datePosted,
      bool? isVisible,
      List<String>? viewedBy,
      List<String>? likedBy}) {
    if (guideId != null) {
      _guideId = guideId;
    }
    if (title != null) {
      _title = title;
    }
    if (description != null) {
      _description = description;
    }
    if (totalLikes != null) {
      _totalLikes = totalLikes;
    }
    if (type != null) {
      _type = type;
    }
    if (link != null) {
      _link = link;
    }
    if (thumbnail != null) {
      _thumbnail = thumbnail;
    }
    if (datePosted != null) {
      _datePosted = datePosted;
    }
    if (isVisible != null) {
      _isVisible = isVisible;
    }
    if (viewedBy != null) {
      _viewedBy = viewedBy;
    }
    if (likedBy != null) {
      _likedBy = likedBy;
    }
  }
  GuideModel copyWith({
    String? guideId,
    String? title,
    String? description,
    String? type,
    String? link,
    String? thumbnail,
    String? datePosted,
    bool? isVisible,
    int? totalLikes,
    List<String>? viewedBy,
    List<String>? likedBy,
  }) {
    return GuideModel(
      guideId: guideId ?? _guideId,
      title: title ?? _title,
      description: description ?? _description,
      type: type ?? _type,
      link: link ?? _link,
      thumbnail: thumbnail ?? _thumbnail,
      datePosted: datePosted ?? _datePosted,
      isVisible: isVisible ?? _isVisible,
      totalLikes: totalLikes ?? _totalLikes,
      viewedBy: viewedBy ?? _viewedBy,
      likedBy: likedBy ?? _likedBy,
    );
  }
  String? get guideId => _guideId;
  set guideId(String? guideId) => _guideId = guideId;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get link => _link;
  set link(String? link) => _link = link;
  String? get thumbnail => _thumbnail;
  set thumbnail(String? thumbnail) => _thumbnail = thumbnail;
  String? get datePosted => _datePosted;
  set datePosted(String? datePosted) => _datePosted = datePosted;
  bool? get isVisible => _isVisible;
  set isVisible(bool? isVisible) => _isVisible = isVisible;
  List<String>? get viewedBy => _viewedBy;
  set viewedBy(List<String>? viewedBy) => _viewedBy = viewedBy;
  List<String>? get likedBy => _likedBy;
  set likedBy(List<String>? likedBy) => _likedBy = likedBy;

  GuideModel.fromJson(Map<String, dynamic> json) {
    _guideId = json['guide_id'];
    _title = json['title'];
    _description = json['description'];
    _type = json['type'];
    _link = json['link'];
    _thumbnail = json['thumbnail'];
    _datePosted = json['date_posted'];
    _isVisible = json['is_visible'];
    _totalLikes = json['total_likes'];
    _viewedBy = json['viewed_by'].cast<String>();
    _likedBy = json['liked_by'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['guide_id'] = _guideId;
    data['title'] = _title;
    data['description'] = _description;
    data['type'] = _type;
    data['link'] = _link;
    data['thumbnail'] = _thumbnail;
    data['date_posted'] = _datePosted;
    data['is_visible'] = _isVisible;
    data['viewed_by'] = _viewedBy;
    data['liked_by'] = _likedBy;
    data['total_likes'] = _totalLikes;
    return data;
  }
}
