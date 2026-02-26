// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  PackageDao? _packageDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` TEXT NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `role` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `packages` (`packageId` TEXT NOT NULL, `author` TEXT NOT NULL, `category` TEXT NOT NULL, `description` TEXT NOT NULL, `iconUrl` TEXT NOT NULL, `keywords` TEXT NOT NULL, `language` TEXT NOT NULL, `lastUpdatedDate` TEXT NOT NULL, `level` TEXT NOT NULL, `title` TEXT NOT NULL, `version` TEXT NOT NULL, `words` TEXT NOT NULL, `published` INTEGER NOT NULL, FOREIGN KEY (`author`) REFERENCES `users` (`email`) ON UPDATE NO ACTION ON DELETE RESTRICT, PRIMARY KEY (`packageId`))');
        await database.execute(
            'CREATE UNIQUE INDEX `index_users_email` ON `users` (`email`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  PackageDao get packageDao {
    return _packageDaoInstance ??= _$PackageDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'password': item.password,
                  'role': item.role.index
                },
            changeListener),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'password': item.password,
                  'role': item.role.index
                },
            changeListener),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'password': item.password,
                  'role': item.role.index
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Stream<List<User>> getUsers() {
    return _queryAdapter.queryListStream('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            role: UserRole.values[row['role'] as int]),
        queryableName: 'users',
        isView: false);
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            role: UserRole.values[row['role'] as int]));
  }

  @override
  Stream<User?> getUserById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            role: UserRole.values[row['role'] as int]),
        arguments: [id],
        queryableName: 'users',
        isView: false);
  }

  @override
  Stream<User?> getUserByEmail(String email) {
    return _queryAdapter.queryStream('SELECT * FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            role: UserRole.values[row['role'] as int]),
        arguments: [email],
        queryableName: 'users',
        isView: false);
  }

  @override
  Stream<List<User>> getUsersByRole(UserRole role) {
    return _queryAdapter.queryListStream('SELECT * FROM users WHERE role = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            role: UserRole.values[row['role'] as int]),
        arguments: [role.index],
        queryableName: 'users',
        isView: false);
  }

  @override
  Stream<User?> getUserByEmailAndPassword(
    String email,
    String password,
  ) {
    return _queryAdapter.queryStream(
        'SELECT * FROM users WHERE email = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            role: UserRole.values[row['role'] as int]),
        arguments: [email, password],
        queryableName: 'users',
        isView: false);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM users');
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$PackageDao extends PackageDao {
  _$PackageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _learningPackageInsertionAdapter = InsertionAdapter(
            database,
            'packages',
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keywords': _stringListConverter.encode(item.keywords),
                  'language': item.language,
                  'lastUpdatedDate':
                      _datetimeConverter.encode(item.lastUpdatedDate),
                  'level': item.level,
                  'title': item.title,
                  'version': item.version,
                  'words': _wordListConverter.encode(item.words),
                  'published': item.published ? 1 : 0
                },
            changeListener),
        _learningPackageUpdateAdapter = UpdateAdapter(
            database,
            'packages',
            ['packageId'],
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keywords': _stringListConverter.encode(item.keywords),
                  'language': item.language,
                  'lastUpdatedDate':
                      _datetimeConverter.encode(item.lastUpdatedDate),
                  'level': item.level,
                  'title': item.title,
                  'version': item.version,
                  'words': _wordListConverter.encode(item.words),
                  'published': item.published ? 1 : 0
                },
            changeListener),
        _learningPackageDeletionAdapter = DeletionAdapter(
            database,
            'packages',
            ['packageId'],
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keywords': _stringListConverter.encode(item.keywords),
                  'language': item.language,
                  'lastUpdatedDate':
                      _datetimeConverter.encode(item.lastUpdatedDate),
                  'level': item.level,
                  'title': item.title,
                  'version': item.version,
                  'words': _wordListConverter.encode(item.words),
                  'published': item.published ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LearningPackage> _learningPackageInsertionAdapter;

  final UpdateAdapter<LearningPackage> _learningPackageUpdateAdapter;

  final DeletionAdapter<LearningPackage> _learningPackageDeletionAdapter;

  @override
  Stream<List<LearningPackage>> getPackages() {
    return _queryAdapter.queryListStream('SELECT * FROM packages',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keywords: _stringListConverter.decode(row['keywords'] as String),
            language: row['language'] as String,
            lastUpdatedDate:
                _datetimeConverter.decode(row['lastUpdatedDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as String,
            words: _wordListConverter.decode(row['words'] as String),
            published: (row['published'] as int) != 0),
        queryableName: 'packages',
        isView: false);
  }

  @override
  Future<List<LearningPackage>> getAllPackages() async {
    return _queryAdapter.queryList('SELECT * FROM packages',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keywords: _stringListConverter.decode(row['keywords'] as String),
            language: row['language'] as String,
            lastUpdatedDate:
                _datetimeConverter.decode(row['lastUpdatedDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as String,
            words: _wordListConverter.decode(row['words'] as String),
            published: (row['published'] as int) != 0));
  }

  @override
  Future<List<LearningPackage>> searchPackages(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM packages WHERE LOWER(title) LIKE \'%\' || LOWER(?1) || \'%\' OR LOWER(description) LIKE \'%\' || LOWER(?1) || \'%\' OR LOWER(keywords) LIKE \'%\' || LOWER(?1) || \'%\' OR LOWER(author) LIKE \'%\' || LOWER(?1) || \'%\'',
        mapper: (Map<String, Object?> row) => LearningPackage(packageId: row['packageId'] as String, author: row['author'] as String, category: row['category'] as String, description: row['description'] as String, iconUrl: row['iconUrl'] as String, keywords: _stringListConverter.decode(row['keywords'] as String), language: row['language'] as String, lastUpdatedDate: _datetimeConverter.decode(row['lastUpdatedDate'] as String), level: row['level'] as String, title: row['title'] as String, version: row['version'] as String, words: _wordListConverter.decode(row['words'] as String), published: (row['published'] as int) != 0),
        arguments: [query]);
  }

  @override
  Future<LearningPackage?> getPackageById(String packageId) async {
    return _queryAdapter.query('SELECT * FROM packages WHERE packageId =?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keywords: _stringListConverter.decode(row['keywords'] as String),
            language: row['language'] as String,
            lastUpdatedDate:
                _datetimeConverter.decode(row['lastUpdatedDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as String,
            words: _wordListConverter.decode(row['words'] as String),
            published: (row['published'] as int) != 0),
        arguments: [packageId]);
  }

  @override
  Future<void> deleteAllPackages() async {
    await _queryAdapter.queryNoReturn('DELETE FROM packages');
  }

  @override
  Future<List<LearningPackage>> getPackagesByCategory(String category) async {
    return _queryAdapter.queryList('SELECT * FROM packages WHERE category =?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keywords: _stringListConverter.decode(row['keywords'] as String),
            language: row['language'] as String,
            lastUpdatedDate:
                _datetimeConverter.decode(row['lastUpdatedDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as String,
            words: _wordListConverter.decode(row['words'] as String),
            published: (row['published'] as int) != 0),
        arguments: [category]);
  }

  @override
  Future<List<LearningPackage>> getPackagesByLevel(String level) async {
    return _queryAdapter.queryList('SELECT * FROM packages WHERE level =?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keywords: _stringListConverter.decode(row['keywords'] as String),
            language: row['language'] as String,
            lastUpdatedDate:
                _datetimeConverter.decode(row['lastUpdatedDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as String,
            words: _wordListConverter.decode(row['words'] as String),
            published: (row['published'] as int) != 0),
        arguments: [level]);
  }

  @override
  Future<List<LearningPackage?>> getPackagesByAuthor(String author) async {
    return _queryAdapter.queryList('SELECT * FROM packages WHERE author = ?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keywords: _stringListConverter.decode(row['keywords'] as String),
            language: row['language'] as String,
            lastUpdatedDate:
                _datetimeConverter.decode(row['lastUpdatedDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as String,
            words: _wordListConverter.decode(row['words'] as String),
            published: (row['published'] as int) != 0),
        arguments: [author]);
  }

  @override
  Future<List<LearningPackage>> getPublishedPackages() async {
    return _queryAdapter.queryList(
        'SELECT * FROM packages WHERE published = \'true\'',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keywords: _stringListConverter.decode(row['keywords'] as String),
            language: row['language'] as String,
            lastUpdatedDate:
                _datetimeConverter.decode(row['lastUpdatedDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as String,
            words: _wordListConverter.decode(row['words'] as String),
            published: (row['published'] as int) != 0));
  }

  @override
  Future<void> addPackage(LearningPackage package) async {
    await _learningPackageInsertionAdapter.insert(
        package, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertPackage(LearningPackage package) async {
    await _learningPackageInsertionAdapter.insert(
        package, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertPackages(List<LearningPackage> packages) async {
    await _learningPackageInsertionAdapter.insertList(
        packages, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePackage(LearningPackage package) async {
    await _learningPackageUpdateAdapter.update(
        package, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePackage(LearningPackage package) async {
    await _learningPackageDeletionAdapter.delete(package);
  }
}

// ignore_for_file: unused_element
final _stringListConverter = StringListConverter();
final _wordListConverter = WordListConverter();
final _datetimeConverter = DatetimeConverter();
