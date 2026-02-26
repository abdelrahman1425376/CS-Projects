import 'package:class_manager/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> signIn(String email, String password);
  Future<void> signUp(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
  Future<User?> getUserById(String id);
  Future<User?> getUserByEmail(String email);
  Future<User?> getUserByRole(String role);
  Future<List<User>> getAllUsers();

  Stream<List<User>> watchUsers();
  Stream<User?> watchUserById(String id);
  Stream<User?> watchUserByEmail(String email);
  Stream<List<User>> watchUsersByRole(String role);
  Stream<User?> watchUserByEmailAndPassword(String email, String password);
}
