import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';

abstract class PackageRepo {
  Stream<List<LearningPackage>> getPackages();
  Future<List<LearningPackage>> getAllPackages();
  Future<List<LearningPackage>> searchPackages(String query);
  Future<LearningPackage?> getPackageById(String packageId);
  Future<void> addPackage(LearningPackage package);
  Future<void> updatePackage(LearningPackage package);
  Future<void> deletePackage(LearningPackage package);
  Future<List<LearningPackage>> getPackagesByCategory(String category);
  Future<List<LearningPackage>> getPackagesByLevel(String level);
  Future<List<LearningPackage?>> getPackagesByAuthor(String author);
  Future<List<LearningPackage>> getPublishedPackages();
}
