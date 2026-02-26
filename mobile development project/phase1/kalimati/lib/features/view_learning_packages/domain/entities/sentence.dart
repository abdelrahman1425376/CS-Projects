import 'package:class_manager/features/view_learning_packages/domain/entities/resource.dart';

class Sentence {
  final String text;
  final List<Resource> resources;

  Sentence({required this.text, required this.resources});

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      text: json['text'] ?? '',
      resources:
          (json['resources'] as List<dynamic>?)
              ?.map((r) => Resource.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'resources': resources.map((r) => r.toJson()).toList(),
    };
  }

  Sentence copyWith({String? text, List<Resource>? resources}) {
    return Sentence(
      text: text ?? this.text,
      resources: resources ?? this.resources,
    );
  }
}
