import 'package:floor/floor.dart';

class DatetimeConverter extends TypeConverter<DateTime, String> {
  @override
  DateTime decode(String databaseValue) =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(databaseValue) ?? 0);

  @override
  String encode(DateTime value) => '${value.millisecondsSinceEpoch}';
}
