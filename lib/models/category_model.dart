// ignore_for_file: unnecessary_getters_setters
class CategoryModel {
  String? _icon;
  String? _type;
  String? _tagline;

  CategoryModel({String? icon, String? type, String? tagline}) {
    if (icon != null) {
      _icon = icon;
    }
    if (type != null) {
      _type = type;
    }
    if (tagline != null) {
      _tagline = tagline;
    }
  }

  String? get icon => _icon;
  set icon(String? icon) => _icon = icon;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get tagline => _tagline;
  set tagline(String? tagline) => _tagline = tagline;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _icon = json['icon'];
    _type = json['type'];
    _tagline = json['tagline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = _icon;
    data['type'] = _type;
    data['tagline'] = _tagline;
    return data;
  }
}
