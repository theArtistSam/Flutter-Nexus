// ignore_for_file: unnecessary_getters_setters

class PostModel {
  String? _postId;
  String? _userId;
  String? _description;
  String? _dateCreated;
  List<String>? _images;
  int? _totalLikes;
  int? _totalComments;
  int? _totalShares;
  Permissions? _permissions;
  List<String>? _likedBy;
  List<String>? _savedBy;

  PostModel({
    String? postId,
    String? userId,
    String? description,
    String? dateCreated,
    List<String>? images,
    int? totalLikes,
    int? totalComments,
    int? totalShares,
    Permissions? permissions,
    List<String>? likedBy,
    List<String>? savedBy,
  }) {
    if (postId != null) {
      _postId = postId;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (description != null) {
      _description = description;
    }
    if (dateCreated != null) {
      _dateCreated = dateCreated;
    }
    if (images != null) {
      _images = images;
    }
    if (totalLikes != null) {
      _totalLikes = totalLikes;
    }
    if (totalComments != null) {
      _totalComments = totalComments;
    }
    if (totalShares != null) {
      _totalShares = totalShares;
    }
    if (permissions != null) {
      _permissions = permissions;
    }
    if (likedBy != null) {
      _likedBy = likedBy;
    }
    if (savedBy != null) {
      _savedBy = savedBy;
    }
  }

  String? get postId => _postId;
  set postId(String? postId) => _postId = postId;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get dateCreated => _dateCreated;
  set dateCreated(String? dateCreated) => _dateCreated = dateCreated;
  List<String>? get images => _images;
  set images(List<String>? images) => _images = images;
  int? get totalLikes => _totalLikes;
  set totalLikes(int? totalLikes) => _totalLikes = totalLikes;
  int? get totalComments => _totalComments;
  set totalComments(int? totalComments) => _totalComments = totalComments;
  int? get totalShares => _totalShares;
  set totalShares(int? totalShares) => _totalShares = totalShares;
  Permissions? get permissions => _permissions;
  set permissions(Permissions? permissions) => _permissions = permissions;
  List<String>? get likedBy => _likedBy;
  set likedBy(List<String>? likedBy) => _likedBy = likedBy;
  List<String>? get savedBy => _savedBy;
  set savedBy(List<String>? savedBy) => _savedBy = savedBy;

  PostModel.fromJson(Map<String, dynamic> json) {
    _postId = json['post_id'];
    _userId = json['user_id'];
    _description = json['description'];
    _dateCreated = json['date_created'];
    _images = json['images'].cast<String>();
    _totalLikes = json['total_likes'];
    _totalComments = json['total_comments'];
    _totalShares = json['total_shares'];
    _permissions = json['permissions'] != null
        ? Permissions.fromJson(json['permissions'])
        : null;
    _likedBy = json['liked_by'].cast<String>();
    _savedBy = json['saved_by'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = _postId;
    data['user_id'] = _userId;
    data['description'] = _description;
    data['date_created'] = _dateCreated;
    data['images'] = _images;
    data['total_likes'] = _totalLikes;
    data['total_comments'] = _totalComments;
    data['total_shares'] = _totalShares;
    if (_permissions != null) {
      data['permissions'] = _permissions!.toJson();
    }
    data['liked_by'] = _likedBy;
    data['saved_by'] = _savedBy;

    return data;
  }
}

class Permissions {
  bool? _isPrivate;
  bool? _commentAllowed;
  bool? _likeAllowed;
  bool? _shareAllowed;

  Permissions(
      {bool? isPrivate,
      bool? commentAllowed,
      bool? likeAllowed,
      bool? shareAllowed}) {
    if (isPrivate != null) {
      _isPrivate = isPrivate;
    }
    if (commentAllowed != null) {
      _commentAllowed = commentAllowed;
    }
    if (likeAllowed != null) {
      _likeAllowed = likeAllowed;
    }
    if (shareAllowed != null) {
      _shareAllowed = shareAllowed;
    }
  }

  bool? get isPrivate => _isPrivate;
  set isPrivate(bool? isPrivate) => _isPrivate = isPrivate;
  bool? get commentAllowed => _commentAllowed;
  set commentAllowed(bool? commentAllowed) => _commentAllowed = commentAllowed;
  bool? get likeAllowed => _likeAllowed;
  set likeAllowed(bool? likeAllowed) => _likeAllowed = likeAllowed;
  bool? get shareAllowed => _shareAllowed;
  set shareAllowed(bool? shareAllowed) => _shareAllowed = shareAllowed;

  Permissions.fromJson(Map<String, dynamic> json) {
    _isPrivate = json['is_private'];
    _commentAllowed = json['comment_allowed'];
    _likeAllowed = json['like_allowed'];
    _shareAllowed = json['share_allowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_private'] = _isPrivate;
    data['comment_allowed'] = _commentAllowed;
    data['like_allowed'] = _likeAllowed;
    data['share_allowed'] = _shareAllowed;
    return data;
  }
}
