import 'package:class_manager/core/data/database/database_service.dart';
import 'package:class_manager/features/view_learning_packages/data/repositories/package_repo_local_db.dart';
import 'package:class_manager/features/view_learning_packages/domain/contracts/package_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';

final learningPackageRepositoryProvider = FutureProvider<PackageRepoLocalDB>((
  ref,
) async {
  final database = await DatabaseService.getDatabase();
  return PackageRepoLocalDB(database.packageDao);
});

class LearningPackageNotifier extends AsyncNotifier<List<LearningPackage>> {
  late final PackageRepo packageRepo;

  @override
  Future<List<LearningPackage>> build() async {
    final database = await DatabaseService.getDatabase();
    packageRepo = PackageRepoLocalDB(database.packageDao);
    return await packageRepo.getAllPackages();
  }

  Future<void> searchPackages(String keyword) async {
    if (keyword.isEmpty) {
      state = AsyncValue.data(await packageRepo.getAllPackages());
    } else {
      state = const AsyncValue.loading();
      try {
        final packages = await packageRepo.searchPackages(keyword);
        state = AsyncValue.data(packages);
      } catch (e, stackTrace) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  Future<void> filterByLevel(String level) async {
    state = const AsyncValue.loading();
    try {
      final packages = await packageRepo.getPackagesByLevel(level);
      state = AsyncValue.data(packages);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> filterByCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final packages = await packageRepo.getPackagesByCategory(category);
      state = AsyncValue.data(packages);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deletePackage(LearningPackage package) async {
    try {
      await packageRepo.deletePackage(package);

      resetToAllPackages();
    } catch (e, stackTrace) {
      debugPrint('Error deleting package: $e');
      state = AsyncValue.error(e, stackTrace);

      rethrow;
    }
  }

  Future<void> createPackage(LearningPackage package) async {
    try {
      final createdPackage = await packageRepo.addPackage(package);

      resetToAllPackages();
      return createdPackage;
    } catch (e, stackTrace) {
      debugPrint('Error creating package: $e');
      state = AsyncValue.error(e, stackTrace);

      rethrow;
    }
  }

  Future<void> updatePackage(
    String packageId,
    LearningPackage updatedPackage,
    String currentUserEmail,
  ) async {
    try {
      final updated = await packageRepo.updatePackage(updatedPackage);

      resetToAllPackages();
      return updated;
    } catch (e, stackTrace) {
      debugPrint('Error updating package: $e');
      state = AsyncValue.error(e, stackTrace);

      rethrow;
    }
  }

  Future<LearningPackage?> getPackageById(String packageId) async {
    return await packageRepo.getPackageById(packageId);
  }

  void resetToAllPackages() async {
    state = const AsyncValue.loading();
    try {
      final packages = await packageRepo.getAllPackages();
      state = AsyncValue.data(packages);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<LearningPackage>> getPublishedPackages() async {
    return packageRepo.getPublishedPackages();
  }

  Future<List<LearningPackage>> getAllPackages() async {
    return packageRepo.getAllPackages();
  }
}

final learningPackageNotifierProvider =
    AsyncNotifierProvider<LearningPackageNotifier, List<LearningPackage>>(
      () => LearningPackageNotifier(),
    );
