class Definition {
  final String text;
  final String source;

  Definition({required this.text, required this.source});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(text: json['text'] ?? '', source: json['source'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'source': source};
  }

  Definition copyWith({String? text, String? source}) {
    return Definition(text: text ?? this.text, source: source ?? this.source);
  }
}
