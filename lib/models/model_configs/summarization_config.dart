class SummarizationConfig {
  String? type;
  String? length;

  SummarizationConfig({this.type, this.length});

  SummarizationConfig.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    length = json['length'];
  }
  SummarizationConfig copyWith({
    String? type,
    String? length,
  }) {
    return SummarizationConfig(
      type: type ?? this.type,
      length: length ?? this.length,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['length'] = length;
    return data;
  }
}
