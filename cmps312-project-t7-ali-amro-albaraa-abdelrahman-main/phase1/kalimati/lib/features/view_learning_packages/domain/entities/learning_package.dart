import 'package:class_manager/core/utils/datetime_converter.dart';
import 'package:class_manager/core/utils/string_list_converter.dart';
import 'package:class_manager/core/utils/word_list_converter.dart';
import 'package:class_manager/features/auth/domain/entities/user.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'packages',
  foreignKeys: [
    ForeignKey(
      childColumns: ['author'],
      parentColumns: ['email'],
      entity: User,
      onDelete: ForeignKeyAction.restrict,
    ),
  ],
)
class LearningPackage {
  @primaryKey
  final String packageId;
  final String author;
  final String category;
  final String description;
  final String iconUrl;

  @TypeConverters([StringListConverter])
  final List<String> keywords;

  final String language;

  @TypeConverters([DatetimeConverter])
  final DateTime lastUpdatedDate;

  final String level;
  final String title;
  final String version;

  @TypeConverters([WordListConverter])
  final List<Word> words;

  final bool published;

  LearningPackage({
    required this.packageId,
    required this.author,
    required this.category,
    required this.description,
    required this.iconUrl,
    required this.keywords,
    required this.language,
    required this.lastUpdatedDate,
    required this.level,
    required this.title,
    required this.version,
    required this.words,
    this.published = true,
  });

  factory LearningPackage.fromJson(Map<String, dynamic> json) {
    return LearningPackage(
      packageId: json['packageId'],
      author: json['author'],
      category: json['category'],
      description: json['description'],
      iconUrl: json['iconUrl'] ?? '',
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((k) => k.toString())
              .toList() ??
          [],
      language: json['language'],
      lastUpdatedDate: DateTime.parse(json['lastUpdatedDate']),
      level: json['level'],
      title: json['title'],
      version: json['version'].toString(),
      words:
          (json['words'] as List<dynamic>?)
              ?.map((w) => Word.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
      published: json['published'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'author': author,
      'category': category,
      'description': description,
      'iconUrl': iconUrl,
      'keywords': keywords,
      'language': language,
      'lastUpdatedDate': lastUpdatedDate.toIso8601String(),
      'level': level,
      'title': title,
      'version': version,
      'words': words.map((w) => w.toJson()).toList(),
      'published': published,
    };
  }

  LearningPackage copyWith({
    String? packageId,
    String? author,
    String? category,
    String? description,
    String? iconUrl,
    List<String>? keywords,
    String? language,
    DateTime? lastUpdatedDate,
    String? level,
    String? title,
    String? version,
    List<Word>? words,
    bool? published,
  }) {
    return LearningPackage(
      packageId: packageId ?? this.packageId,
      author: author ?? this.author,
      category: category ?? this.category,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      keywords: keywords ?? this.keywords,
      language: language ?? this.language,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      level: level ?? this.level,
      title: title ?? this.title,
      version: version ?? this.version,
      words: words ?? this.words,
      published: published ?? this.published,
    );
  }
}
