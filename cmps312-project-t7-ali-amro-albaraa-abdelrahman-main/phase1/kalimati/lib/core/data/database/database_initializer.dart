import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:class_manager/core/data/database/database.dart';
import 'package:class_manager/features/auth/domain/entities/user.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';

class DatabaseInitializer {
  final AppDatabase database;

  DatabaseInitializer(this.database);

  
  Future<void> initializeUsers() async {
    try {
      
      final jsonString = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      
      final existingUsers = await database.userDao.getAllUsers();

      
      bool needsInitialization = true;
      if (existingUsers.isNotEmpty) {
        
        final jsonEmails = jsonList
            .map((json) => (json as Map<String, dynamic>)['email'] as String)
            .toSet();
        final existingEmails = existingUsers.map((u) => u.email).toSet();

        
        if (jsonEmails.every((email) => existingEmails.contains(email))) {
          needsInitialization = false;
          debugPrint(
            'Users already initialized. Found ${existingUsers.length} users.',
          );
        } else {
          
          debugPrint('Some users missing. Clearing and re-initializing...');
          for (final user in existingUsers) {
            await database.userDao.deleteUser(user);
          }
        }
      }

      if (needsInitialization) {
        
        for (int i = 0; i < jsonList.length; i++) {
          final jsonUser = jsonList[i] as Map<String, dynamic>;
          
          if (!jsonUser.containsKey('id')) {
            jsonUser['id'] = 'user_${DateTime.now().millisecondsSinceEpoch}_$i';
          }
          final user = User.fromJson(jsonUser);
          try {
            await database.userDao.insertUser(user);
            debugPrint('Inserted user: ${user.email}');
          } catch (e) {
            debugPrint('Error inserting user ${jsonUser['email']}: $e');
           
            try {
              await database.userDao.updateUser(user);
              debugPrint('Updated user: ${user.email}');
            } catch (updateError) {
              debugPrint(
                'Error updating user ${jsonUser['email']}: $updateError',
              );
            }
          }
        }
        debugPrint('Initialized ${jsonList.length} users from users.json');
      }
    } catch (e) {
      
      debugPrint('Error initializing users: $e');
    }
  }

  
  Future<void> initializePackages() async {
    try {
      
      final jsonString = await rootBundle.loadString(
        'assets/data/packages.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      
      try {
        await database.packageDao.deleteAllPackages();
        debugPrint('Cleared existing packages from database');
      } catch (e) {
        debugPrint('Error clearing packages: $e');
      }

      
      for (int i = 0; i < jsonList.length; i++) {
        final jsonPackage = jsonList[i] as Map<String, dynamic>;
        
        if (!jsonPackage.containsKey('packageId')) {
          jsonPackage['packageId'] =
              'package_${DateTime.now().millisecondsSinceEpoch}_$i';
        }
        final package = LearningPackage.fromJson(jsonPackage);
        try {
          await database.packageDao.addPackage(package);
          debugPrint('Inserted package: ${package.title}');
        } catch (e) {
          debugPrint('Error inserting package ${jsonPackage['title']}: $e');
          
          try {
            await database.packageDao.updatePackage(package);
            debugPrint('Updated package: ${package.title}');
          } catch (updateError) {
            debugPrint(
              'Error updating package ${jsonPackage['title']}: $updateError',
            );
          }
        }
      }
      debugPrint(
        'Initialized ${jsonList.length} packages from packages.json',
      );
    } catch (e) {
      
      debugPrint('Error initializing packages: $e');
    }
  }
}
