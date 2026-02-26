import 'package:class_manager/core/data/database/daos/user_dao.dart';
import 'package:class_manager/features/auth/domain/contract/user_repo.dart';
import 'package:class_manager/features/auth/domain/entities/user.dart';
import 'package:class_manager/features/auth/domain/enums/user_role.dart';

class UserRepoLocalDB implements UserRepository {
  final UserDao _userDao;

  UserRepoLocalDB(this._userDao);

  @override
  Future<void> signIn(String email, String password) async {
    final user = await _userDao
        .getUserByEmailAndPassword(email, password)
        .first;
    if (user == null) {
      throw Exception('Invalid email or password');
    }
  }

  @override
  Future<void> signUp(User user) async {
    await _userDao.insertUser(user);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userDao.updateUser(user);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDao.deleteUser(user);
  }

  @override
  Future<User?> getUserById(String id) async =>
      await _userDao.getUserById(id).first;

  @override
  Future<User?> getUserByEmail(String email) async =>
      await _userDao.getUserByEmail(email).first;

  @override
  Future<User?> getUserByRole(String role) async {
    final userRole = UserRole.values.firstWhere(
      (r) => r.name.toLowerCase() == role.toLowerCase(),
      orElse: () => throw Exception('Invalid role: $role'),
    );

    final users = await _userDao.getUsersByRole(userRole).first;
    return users.isNotEmpty ? users.first : null;
  }

  @override
  Future<List<User>> getAllUsers() async {
    return await _userDao.getAllUsers();
  }

  @override
  Stream<User?> watchUserById(String id) => _userDao.getUserById(id);

  @override
  Stream<User?> watchUserByEmail(String email) =>
      _userDao.getUserByEmail(email);

  @override
  Stream<List<User>> watchUsersByRole(String role) {
    final userRole = UserRole.values.firstWhere(
      (r) => r.name.toLowerCase() == role.toLowerCase(),
      orElse: () => throw Exception('Invalid role: $role'),
    );
    return _userDao.getUsersByRole(userRole);
  }

  @override
  Stream<User?> watchUserByEmailAndPassword(String email, String password) =>
      _userDao.getUserByEmailAndPassword(email, password);

  @override
  Stream<List<User>> watchUsers() => _userDao.getUsers();
}
