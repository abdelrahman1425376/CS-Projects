import 'dart:convert';
import 'package:floor/floor.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    if (databaseValue.isEmpty) return [];
    try {
      final List<dynamic> jsonList = json.decode(databaseValue);
      return jsonList.map((item) => item.toString()).toList();
    } catch (e) {
      return databaseValue.split(',').where((s) => s.isNotEmpty).toList();
    }
  }

  @override
  String encode(List<String> value) => json.encode(value);
}
