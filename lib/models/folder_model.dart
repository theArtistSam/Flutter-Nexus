// ignore_for_file: unnecessary_new, prefer_collection_literals

class FolderModel {
  String? folderId;
  String? title;
  int? icon;
  String? dateUpdated;

  FolderModel({
    this.folderId,
    this.title,
    this.icon,
    this.dateUpdated,
  });
  FolderModel copyWith({
    String? folderId,
    String? title,
    int? icon,
    List<String>? contents,
    String? dateUpdated,
  }) {
    return FolderModel(
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  FolderModel.fromJson(Map<String, dynamic> json) {
    folderId = json['folder_id'];
    title = json['title'];
    icon = json['icon'];
    dateUpdated = json['date_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folder_id'] = folderId;
    data['title'] = title;
    data['icon'] = icon;
    data['date_updated'] = dateUpdated;
    return data;
  }
}
