import 'dart:async';
import 'package:class_manager/core/data/database/daos/package_dao.dart';
import 'package:class_manager/core/utils/datetime_converter.dart';
import 'package:class_manager/core/utils/string_list_converter.dart';
import 'package:class_manager/core/utils/word_list_converter.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/user_dao.dart';
import 'package:class_manager/features/auth/domain/entities/user.dart';
import 'package:class_manager/features/auth/domain/enums/user_role.dart';

part 'database.g.dart';

@TypeConverters([StringListConverter, WordListConverter, DatetimeConverter])
@Database(version: 1, entities: [User, LearningPackage])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  PackageDao get packageDao;
}
