import 'package:class_manager/features/view_learning_packages/domain/entities/definition.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/sentence.dart';

class Word {
  final String text;
  final List<Definition> definitions;
  final List<Sentence> sentences;

  Word({
    required this.text,
    required this.definitions,
    required this.sentences,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      text: json['text'] ?? '',
      definitions:
          (json['definitions'] as List<dynamic>?)
              ?.map((d) => Definition.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      sentences:
          (json['sentences'] as List<dynamic>?)
              ?.map((s) => Sentence.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'definitions': definitions.map((d) => d.toJson()).toList(),
      'sentences': sentences.map((s) => s.toJson()).toList(),
    };
  }

  Word copyWith({
    String? text,
    List<Definition>? definitions,
    List<Sentence>? sentences,
  }) {
    return Word(
      text: text ?? this.text,
      definitions: definitions ?? this.definitions,
      sentences: sentences ?? this.sentences,
    );
  }
}
