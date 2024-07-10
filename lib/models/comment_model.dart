// ignore_for_file: unnecessary_getters_setters, prefer_collection_literals, unnecessary_new

class CommentModel {
  String? _userId;
  String? _commentId;
  String? _text;
  List<String>? _likedBy;
  int? _totalLikes;
  String? _dateCreated;

  CommentModel({
    String? userId,
    String? commentId,
    String? text,
    List<String>? likedBy,
    int? totalLikes,
    String? dateCreated,
  }) {
    if (userId != null) {
      _userId = userId;
    }
    if (commentId != null) {
      _commentId = commentId;
    }
    if (text != null) {
      _text = text;
    }
    if (likedBy != null) {
      _likedBy = likedBy;
    }
    if (totalLikes != null) {
      _totalLikes = totalLikes;
    }
    if (dateCreated != null) {
      _dateCreated = dateCreated;
    }
  }

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get commentId => _commentId;
  set commentId(String? commentId) => _commentId = commentId;
  String? get text => _text;
  set text(String? text) => _text = text;
  List<String>? get likedBy => _likedBy;
  set likedBy(List<String>? likedBy) => _likedBy = likedBy;
  int? get totalLikes => _totalLikes;
  set totalLikes(int? totalLikes) => _totalLikes = totalLikes;
  String? get dateCreated => _dateCreated;
  set dateCreated(String? dateCreated) => _dateCreated = dateCreated;

  CommentModel.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _commentId = json['comment_id'];
    _text = json['text'];
    _likedBy = json['liked_by'].cast<String>();
    _totalLikes = json['total_likes'];
    _dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = _userId;
    data['comment_id'] = _commentId;
    data['text'] = _text;
    data['liked_by'] = _likedBy;
    data['total_likes'] = _totalLikes;
    data['date_created'] = _dateCreated;
    return data;
  }
}
