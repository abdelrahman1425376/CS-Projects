import 'package:floor/floor.dart';
import 'package:class_manager/features/auth/domain/entities/user.dart';
import 'package:class_manager/features/auth/domain/enums/user_role.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Stream<List<User>> getUsers();

  @Query('SELECT * FROM users')
  Future<List<User>> getAllUsers();

  @Query('SELECT * FROM users WHERE id = :id')
  Stream<User?> getUserById(String id);

  @Query('SELECT * FROM users WHERE email = :email')
  Stream<User?> getUserByEmail(String email);

  @Query('SELECT * FROM users WHERE role = :role')
  Stream<List<User>> getUsersByRole(UserRole role);

  @insert
  Future<void> insertUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);

  @Query('SELECT * FROM users WHERE email = :email AND password = :password')
  Stream<User?> getUserByEmailAndPassword(String email, String password);

  @Query('DELETE FROM users')
  Future<void> deleteAllUsers();
}
