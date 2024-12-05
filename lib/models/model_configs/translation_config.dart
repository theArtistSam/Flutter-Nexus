class TranslationConfig {
  List<String>? sourceLanguages;
  List<String>? targetLanguages;

  TranslationConfig({this.sourceLanguages, this.targetLanguages});

  TranslationConfig.fromJson(Map<String, dynamic> json) {
    sourceLanguages = json['source_languages'];
    targetLanguages = json['target_languages'];
  }
  TranslationConfig copyWith({
    List<String>? sourceLanguages,
    List<String>? targetLanguages,
  }) {
    return TranslationConfig(
      sourceLanguages: sourceLanguages ?? this.sourceLanguages,
      targetLanguages: targetLanguages ?? this.targetLanguages,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source_languages'] = sourceLanguages;
    data['target_languages'] = targetLanguages;
    return data;
  }
}
