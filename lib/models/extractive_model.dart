class ExtractiveModel {
  String? _modelName;
  Arguments? _arguments;
  String? _text;

  ExtractiveModel({String? modelName, Arguments? arguments, String? text}) {
    if (modelName != null) {
      _modelName = modelName;
    }
    if (arguments != null) {
      _arguments = arguments;
    }
    if (text != null) {
      _text = text;
    }
  }

  String? get modelName => _modelName;
  set modelName(String? modelName) => _modelName = modelName;
  Arguments? get arguments => _arguments;
  set arguments(Arguments? arguments) => _arguments = arguments;
  String? get text => _text;
  set text(String? text) => _text = text;

  ExtractiveModel.fromJson(Map<String, dynamic> json) {
    _modelName = json['model_name'];
    _arguments = json['arguments'] != null
        ? Arguments.fromJson(json['arguments'])
        : null;
    _text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model_name'] = _modelName;
    if (_arguments != null) {
      data['arguments'] = _arguments!.toJson();
    }
    data['text'] = _text;
    return data;
  }
}

class Arguments {
  String? _sentences;

  Arguments({String? sentences}) {
    if (sentences != null) {
      _sentences = sentences;
    }
  }

  String? get sentences => _sentences;
  set sentences(String? sentences) => _sentences = sentences;

  Arguments.fromJson(Map<String, dynamic> json) {
    _sentences = json['sentences'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sentences'] = _sentences;
    return data;
  }
}
