import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/core/data/database/database_service.dart';
import 'package:class_manager/features/auth/data/repositories/user_repo_local_db.dart';
import 'package:class_manager/features/auth/domain/contract/user_repo.dart';
import 'package:class_manager/features/auth/domain/entities/user.dart';

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final database = await DatabaseService.getDatabase();
  return UserRepoLocalDB(database.userDao);
});

class CurrentUserNotifier extends AsyncNotifier<User?> {
  late final UserRepository userRepo;

  @override
  Future<User?> build() async {
    userRepo = await ref.watch(userRepositoryProvider.future);
    return null;
  }

  Future<bool> login(String email, String password) async {
    try {
      final trimmedEmail = email.trim();
      final trimmedPassword = password.trim();

      await userRepo.signIn(trimmedEmail, trimmedPassword);

      final user = await userRepo.getUserByEmail(trimmedEmail);

      if (user != null) {
        state = AsyncValue.data(user);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }

  Future<bool> signUp(User user) async {
    try {
      await userRepo.signUp(user);
      state = AsyncValue.data(user);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      await userRepo.updateUser(user);
      state = AsyncValue.data(user);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<User?> getUserByEmail(String email) async =>
      await userRepo.getUserByEmail(email);

  Future<User?> getUserById(String id) async => await userRepo.getUserById(id);

  Future<List<User>> getAllUsers() async => await userRepo.getAllUsers();

  Future<void> deleteUser(User user) async {
    await userRepo.deleteUser(user);

    final currentUser = state.value;
    if (currentUser?.id == user.id) {
      logout();
    }
  }
}

final currentUserNotifierProvider =
    AsyncNotifierProvider<CurrentUserNotifier, User?>(
      () => CurrentUserNotifier(),
    );
