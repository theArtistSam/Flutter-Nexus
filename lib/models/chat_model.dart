class ChatModel {
  String? _user;
  String? _message;
  String? _type;

  ChatModel({String? user, String? message, String? type}) {
    if (user != null) {
      this._user = user;
    }
    if (message != null) {
      this._message = message;
    }
    if (type != null) {
      this._type = type;
    }
  }

  String? get user => _user;
  set user(String? user) => _user = user;
  String? get message => _message;
  set message(String? message) => _message = message;
  String? get type => _type;
  set type(String? type) => _type = type;

  ChatModel.fromJson(Map<String, dynamic> json) {
    _user = json['user'];
    _message = json['message'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this._user;
    data['message'] = this._message;
    data['type'] = this._type;
    return data;
  }
}
