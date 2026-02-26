import 'dart:convert';

import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';
import 'package:floor/floor.dart';

class WordListConverter extends TypeConverter<List<Word>, String> {
  @override
  List<Word> decode(String databaseValue) {
    final List<dynamic> jsonList = json.decode(databaseValue);
    return jsonList.map((json) => Word.fromJson(json)).toList();
  }

  @override
  String encode(List<Word> value) => json.encode(value.map((w) => w.toJson()).toList());
}
