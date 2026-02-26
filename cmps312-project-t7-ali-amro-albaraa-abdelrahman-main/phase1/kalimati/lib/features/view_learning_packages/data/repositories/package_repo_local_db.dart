import 'package:class_manager/core/data/database/daos/package_dao.dart';
import 'package:class_manager/features/view_learning_packages/domain/contracts/package_repo.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';

class PackageRepoLocalDB implements PackageRepo {
  final PackageDao _packageDao;

  PackageRepoLocalDB(this._packageDao);
  @override
  Future<void> addPackage(LearningPackage package) async {
    await _packageDao.addPackage(package);
  }

  @override
  Future<void> deletePackage(LearningPackage package) async {
    await _packageDao.deletePackage(package);
  }

  @override
  Stream<List<LearningPackage>> getPackages() => _packageDao.getPackages();

  @override
  Future<List<LearningPackage?>> getPackagesByAuthor(String author) async =>
      await _packageDao.getPackagesByAuthor(author);

  @override
  Future<LearningPackage?> getPackageById(String packageId) async =>
      await _packageDao.getPackageById(packageId);

  @override
  Future<void> updatePackage(LearningPackage package) async {
    await _packageDao.updatePackage(package);
  }

  @override
  Future<List<LearningPackage>> getAllPackages() async =>
      await _packageDao.getAllPackages();

  @override
  Future<List<LearningPackage>> searchPackages(String query) async =>
      await _packageDao.searchPackages(query);

  @override
  Future<List<LearningPackage>> getPackagesByCategory(String category) async =>
      await _packageDao.getPackagesByCategory(category);

  @override
  Future<List<LearningPackage>> getPackagesByLevel(String level) async =>
      await _packageDao.getPackagesByLevel(level);

  @override
  Future<List<LearningPackage>> getPublishedPackages() async =>
      await _packageDao.getPublishedPackages();
}
