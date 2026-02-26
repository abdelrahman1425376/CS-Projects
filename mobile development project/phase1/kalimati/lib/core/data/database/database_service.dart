import 'package:class_manager/core/data/database/database.dart';
import 'package:class_manager/core/data/database/database_initializer.dart';

class DatabaseService {
  static AppDatabase? _database;
  static DatabaseInitializer? _initializer;

  
  static Future<AppDatabase> getDatabase() async {
    if (_database == null) {
      _database = await $FloorAppDatabase
          .databaseBuilder('app_database.db')
          .build();
      _initializer = DatabaseInitializer(_database!);
      await _initializer!.initializeUsers();
      await _initializer!.initializePackages();
    }
    return _database!;
  }

  
  static DatabaseInitializer? get initializer => _initializer;
}
