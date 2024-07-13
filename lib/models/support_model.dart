// ignore_for_file: unnecessary_getters_setters
class SupportModel {
  String? _userId;
  String? _issueId;
  String? _issueOpenedTime;
  String? _issueClosedTime;
  String? _issueCategory;
  String? _issueStatus;
  List<Message>? _conversation;

  SupportModel(
      {String? userId,
      String? issueId,
      String? issueOpenedTime,
      String? issueClosedTime,
      String? issueCategory,
      String? issueStatus,
      List<Message>? conversation}) {
    if (userId != null) {
      _userId = userId;
    }
    if (issueId != null) {
      _issueId = issueId;
    }
    if (issueOpenedTime != null) {
      _issueOpenedTime = issueOpenedTime;
    }
    if (issueClosedTime != null) {
      _issueClosedTime = issueClosedTime;
    }
    if (issueCategory != null) {
      _issueCategory = issueCategory;
    }
    if (issueStatus != null) {
      _issueStatus = issueStatus;
    }
    if (conversation != null) {
      _conversation = conversation;
    }
  }

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get issueId => _issueId;
  set issueId(String? issueId) => _issueId = issueId;
  String? get issueOpenedTime => _issueOpenedTime;
  set issueOpenedTime(String? issueOpenedTime) =>
      _issueOpenedTime = issueOpenedTime;
  String? get issueClosedTime => _issueClosedTime;
  set issueClosedTime(String? issueClosedTime) =>
      _issueClosedTime = issueClosedTime;
  String? get issueCategory => _issueCategory;
  set issueCategory(String? issueCategory) => _issueCategory = issueCategory;
  String? get issueStatus => _issueStatus;
  set issueStatus(String? issueStatus) => _issueStatus = issueStatus;
  List<Message>? get conversation => _conversation;
  set conversation(List<Message>? conversation) => _conversation = conversation;

  SupportModel.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _issueId = json['issue_id'];
    _issueOpenedTime = json['issue_opened_time'];
    _issueClosedTime = json['issue_closed_time'];
    _issueCategory = json['issue_category'];
    _issueStatus = json['issue_status'];
    if (json['conversation'] != null) {
      _conversation = <Message>[];
      json['conversation'].forEach((v) {
        _conversation!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = _userId;
    data['issue_id'] = _issueId;
    data['issue_opened_time'] = _issueOpenedTime;
    data['issue_closed_time'] = _issueClosedTime;
    data['issue_category'] = _issueCategory;
    data['issue_status'] = _issueStatus;
    if (_conversation != null) {
      data['conversation'] = _conversation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? _senderId;
  String? _timeStamp;
  String? _imageLink;
  String? _messageType;
  String? _text;
  Status? _status;

  Message(
      {String? senderId,
      String? timeStamp,
      String? imageLink,
      String? messageType,
      String? text,
      Status? status}) {
    if (senderId != null) {
      _senderId = senderId;
    }
    if (timeStamp != null) {
      _timeStamp = timeStamp;
    }
    if (imageLink != null) {
      _imageLink = imageLink;
    }
    if (messageType != null) {
      _messageType = messageType;
    }
    if (text != null) {
      _text = text;
    }
    if (status != null) {
      _status = status;
    }
  }

  String? get senderId => _senderId;
  set senderId(String? senderId) => _senderId = senderId;
  String? get timeStamp => _timeStamp;
  set timeStamp(String? timeStamp) => _timeStamp = timeStamp;
  String? get imageLink => _imageLink;
  set imageLink(String? imageLink) => _imageLink = imageLink;
  String? get messageType => _messageType;
  set messageType(String? messageType) => _messageType = messageType;
  String? get text => _text;
  set text(String? text) => _text = text;
  Status? get status => _status;
  set status(Status? status) => _status = status;

  Message.fromJson(Map<String, dynamic> json) {
    _senderId = json['sender_id'];
    _timeStamp = json['time_stamp'];
    _imageLink = json['image_link'];
    _messageType = json['message_type'];
    _text = json['text'];
    _status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_id'] = _senderId;
    data['time_stamp'] = _timeStamp;
    data['image_link'] = _imageLink;
    data['message_type'] = _messageType;
    data['text'] = _text;
    if (_status != null) {
      data['status'] = _status!.toJson();
    }
    return data;
  }
}

class Status {
  bool? _isSent;
  bool? _isSeen;

  Status({bool? isSent, bool? isSeen}) {
    if (isSent != null) {
      _isSent = isSent;
    }
    if (isSeen != null) {
      _isSeen = isSeen;
    }
  }

  bool? get isSent => _isSent;
  set isSent(bool? isSent) => _isSent = isSent;
  bool? get isSeen => _isSeen;
  set isSeen(bool? isSeen) => _isSeen = isSeen;

  Status.fromJson(Map<String, dynamic> json) {
    _isSent = json['is_sent'];
    _isSeen = json['is_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_sent'] = _isSent;
    data['is_seen'] = _isSeen;
    return data;
  }
}
