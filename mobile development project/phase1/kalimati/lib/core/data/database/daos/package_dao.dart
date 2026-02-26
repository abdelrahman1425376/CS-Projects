import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:floor/floor.dart';

@dao
abstract class PackageDao {
  @Query("SELECT * FROM packages")
  Stream<List<LearningPackage>> getPackages();

  @Query("SELECT * FROM packages")
  Future<List<LearningPackage>> getAllPackages();

  @Query(
    "SELECT * FROM packages WHERE LOWER(title) LIKE '%' || LOWER(:query) || '%' OR LOWER(description) LIKE '%' || LOWER(:query) || '%' OR LOWER(keywords) LIKE '%' || LOWER(:query) || '%' OR LOWER(author) LIKE '%' || LOWER(:query) || '%'",
  )
  Future<List<LearningPackage>> searchPackages(String query);

  @insert
  Future<void> addPackage(LearningPackage package);

  @delete
  Future<void> deletePackage(LearningPackage package);

  @Query("SELECT * FROM packages WHERE packageId =:packageId")
  Future<LearningPackage?> getPackageById(String packageId);

  @update
  Future<void> updatePackage(LearningPackage package);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertPackage(LearningPackage package);

  @insert
  Future<void> insertPackages(List<LearningPackage> packages);

  @Query("DELETE FROM packages")
  Future<void> deleteAllPackages();

  @Query("SELECT * FROM packages WHERE category =:category")
  Future<List<LearningPackage>> getPackagesByCategory(String category);

  @Query("SELECT * FROM packages WHERE level =:level")
  Future<List<LearningPackage>> getPackagesByLevel(String level);

  @Query("SELECT * FROM packages WHERE author = :author")
  Future<List<LearningPackage?>> getPackagesByAuthor(String author);

  @Query("SELECT * FROM packages WHERE published = 'true'")
  Future<List<LearningPackage>> getPublishedPackages();
}
