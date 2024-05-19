class Support {
  String? userId;
  String? issueOpenedTime;
  String? selectedCategory;
  List<Category>? allCategories;
  List<Message>? userMessages;
  List<Message>? adminMessages;

  Support({
    this.userId,
    this.issueOpenedTime,
    this.selectedCategory,
    this.allCategories,
    this.userMessages,
    this.adminMessages,
  });

  Support.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    issueOpenedTime = json['issue_opened_time'];
    selectedCategory = json['selected_category'];
    if (json['all_categories'] != null) {
      allCategories = <Category>[];
      json['all_categories'].forEach((v) {
        allCategories!.add(Category.fromJson(v));
      });
    }
    if (json['user_messages'] != null) {
      userMessages = <Message>[];
      json['user_messages'].forEach((v) {
        userMessages!.add(Message.fromJson(v));
      });
    }
    if (json['admin_messages'] != null) {
      adminMessages = <Message>[];
      json['admin_messages'].forEach((v) {
        adminMessages!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['issue_opened_time'] = issueOpenedTime;
    data['selected_category'] = selectedCategory;
    if (allCategories != null) {
      data['all_categories'] = allCategories!.map((v) => v.toJson()).toList();
    }
    if (userMessages != null) {
      data['user_messages'] = userMessages!.map((v) => v.toJson()).toList();
    }
    if (adminMessages != null) {
      data['admin_messages'] = adminMessages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? name;
  String? description;

  Category({this.name, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class Message {
  String? messageId;
  String? timeStamp;
  String? text;
  List<String>? images;
  Status? status;

  Message({
    this.messageId,
    this.timeStamp,
    this.text,
    this.images,
    this.status,
  });

  Message.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    timeStamp = json['time_stamp'];
    text = json['text'];
    images = json['images']?.cast<String>();
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_id'] = messageId;
    data['time_stamp'] = timeStamp;
    data['text'] = text;
    data['images'] = images;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Status {
  bool? isDelivered;
  bool? isSeen;

  Status({this.isDelivered, this.isSeen});

  Status.fromJson(Map<String, dynamic> json) {
    isDelivered = json['is_delivered'];
    isSeen = json['is_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_delivered'] = isDelivered;
    data['is_seen'] = isSeen;
    return data;
  }
}
