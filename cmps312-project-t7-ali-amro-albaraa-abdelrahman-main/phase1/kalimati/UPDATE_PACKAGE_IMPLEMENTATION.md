# Update Package Function Implementation Guide

This document outlines how to implement the "update packages" functionality and integrate it into the UI.

## Overview

The update package feature allows teachers to edit existing learning packages. This requires changes at multiple layers:
1. **Domain Layer**: Extend `LearningPackage.copyWith()` to support all fields
2. **Repository Interface**: Add `updatePackage()` method
3. **Repository Implementation**: Implement the update logic
4. **Provider Layer**: Add `updatePackage()` method to the notifier
5. **UI Layer**: Create edit dialog and wire it to the Edit button

---

## Step 1: Extend LearningPackage.copyWith() Method

**File**: `lib/features/learning_packages/domain/entities/learning_package.dart`

Currently, `copyWith()` only supports the `published` field. We need to extend it to support all fields for full editing capability.

### Current Implementation (lines 81-98):
```dart
LearningPackage copyWith({bool? published}) {
  return LearningPackage(
    packageId: packageId,
    author: author,
    category: category,
    description: description,
    iconUrl: iconUrl,
    keywords: keywords,
    language: language,
    lastUpdatedDate: lastUpdatedDate,
    level: level,
    title: title,
    version: version,
    words: words,
    published: published ?? this.published,
  );
}
```

### Updated Implementation:
```dart
LearningPackage copyWith({
  String? packageId,
  String? author,
  String? category,
  String? description,
  String? iconUrl,
  List<String>? keywords,
  String? language,
  DateTime? lastUpdatedDate,
  String? level,
  String? title,
  String? version,
  List<Word>? words,
  bool? published,
}) {
  return LearningPackage(
    packageId: packageId ?? this.packageId,
    author: author ?? this.author,
    category: category ?? this.category,
    description: description ?? this.description,
    iconUrl: iconUrl ?? this.iconUrl,
    keywords: keywords ?? this.keywords,
    language: language ?? this.language,
    lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
    level: level ?? this.level,
    title: title ?? this.title,
    version: version ?? this.version,
    words: words ?? this.words,
    published: published ?? this.published,
  );
}
```

**Note**: `packageId` and `author` should typically not be changed, but including them in `copyWith` provides flexibility.

---

## Step 2: Add updatePackage() to Repository Interface

**File**: `lib/features/learning_packages/domain/contracts/learning_package_repository.dart`

Add the method signature to the abstract class:

```dart
Future<LearningPackage> updatePackage(
  String packageId,
  LearningPackage updatedPackage,
  String currentUserEmail,
);
```

**Full updated interface section** (add after `createPackage` method, around line 14):
```dart
Future<LearningPackage> createPackage(
  LearningPackage package,
  String currentUserEmail,
);
Future<LearningPackage> updatePackage(
  String packageId,
  LearningPackage updatedPackage,
  String currentUserEmail,
);
Future<List<LearningPackage>> getDownloadedPackages();
```

---

## Step 3: Implement updatePackage() in Repository

**File**: `lib/features/learning_packages/data/repositories/learning_package_local_repository.dart`

Add the implementation after the `createPackage` method (around line 167):

```dart
@override
Future<LearningPackage> updatePackage(
  String packageId,
  LearningPackage updatedPackage,
  String currentUserEmail,
) async {
  // Find the existing package
  final packages = await getAllPackages();
  final existingPackage = packages.firstWhere(
    (pkg) => pkg.packageId == packageId,
    orElse: () => throw Exception('Package not found'),
  );

  // Verify ownership
  if (existingPackage.author != currentUserEmail) {
    throw Exception('Unauthorized: You can only update your own packages');
  }

  // Ensure packageId and author don't change
  if (updatedPackage.packageId != packageId) {
    throw Exception('Cannot change package ID');
  }
  if (updatedPackage.author != currentUserEmail) {
    throw Exception('Cannot change package author');
  }

  // Validate required fields
  if (updatedPackage.title.trim().isEmpty) {
    throw Exception('Package title is required');
  }
  if (updatedPackage.description.trim().isEmpty) {
    throw Exception('Package description is required');
  }
  if (updatedPackage.words.isEmpty) {
    throw Exception('Package must contain at least one word');
  }

  // Update the package in cache
  if (_cachedPackages != null) {
    _cachedPackages = _cachedPackages!.map((pkg) {
      if (pkg.packageId == packageId) {
        // Preserve published status from current state
        final currentPublished = pkg.published;
        return updatedPackage.copyWith(
          lastUpdatedDate: DateTime.now(), // Update timestamp
          published: currentPublished, // Preserve published status
        );
      }
      return pkg;
    }).toList();
  } else {
    throw Exception('Packages cache not initialized');
  }

  // Return the updated package
  return _cachedPackages!.firstWhere((pkg) => pkg.packageId == packageId);
}
```

**Key Points**:
- Validates ownership (only author can update)
- Prevents changing `packageId` and `author`
- Validates required fields
- Updates `lastUpdatedDate` automatically
- Preserves `published` status (use `togglePublishStatus` to change it)
- Updates the cached package list

---

## Step 4: Add updatePackage() to Provider

**File**: `lib/features/learning_packages/presentation/providers/learning_package_provider.dart`

Add the method after `createPackage` (around line 103):

```dart
Future<LearningPackage?> updatePackage(
  String packageId,
  LearningPackage updatedPackage,
  String currentUserEmail,
) async {
  try {
    final updated = await packageRepo.updatePackage(
      packageId,
      updatedPackage,
      currentUserEmail,
    );
    // Refresh the packages list
    resetToAllPackages();
    return updated;
  } catch (e, stackTrace) {
    // Handle error - log and set error state
    debugPrint('Error updating package: $e');
    state = AsyncValue.error(e, stackTrace);
    // Re-throw for UI handling
    rethrow;
  }
}
```

**Key Points**:
- Calls repository method
- Refreshes the packages list after update
- Handles errors and re-throws for UI handling

---

## Step 5: Create Edit Dialog in UI

**File**: `lib/features/teacher_tools/presentation/screens/teacher_tools_page.dart`

Add a new method `_showEditPackageDialog` in the `TeacherToolsPage` class (after `_showCreatePackageDialog`, around line 210):

```dart
void _showEditPackageDialog(
  BuildContext context,
  WidgetRef ref,
  String currentUserEmail,
  LearningPackage package,
) {
  if (currentUserEmail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User not logged in'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Pre-populate controllers with existing package data
  final titleController = TextEditingController(text: package.title);
  final descriptionController = TextEditingController(text: package.description);
  final categoryController = TextEditingController(text: package.category);
  final languageController = TextEditingController(text: package.language);
  String selectedLevel = package.level;
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Package'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        hintText: 'Enter package title',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Enter package description',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        hintText: 'e.g., Travel, Health and Fitness',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Category is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedLevel,
                      decoration: const InputDecoration(labelText: 'Level *'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Beginner',
                          child: Text('Beginner'),
                        ),
                        DropdownMenuItem(
                          value: 'Intermediate',
                          child: Text('Intermediate'),
                        ),
                        DropdownMenuItem(
                          value: 'Advanced',
                          child: Text('Advanced'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedLevel = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: languageController,
                      decoration: const InputDecoration(
                        labelText: 'Language *',
                        hintText: 'e.g., English',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Language is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  // Create updated package using copyWith
                  final updatedPackage = package.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    category: categoryController.text.trim(),
                    level: selectedLevel,
                    language: languageController.text.trim(),
                    lastUpdatedDate: DateTime.now(),
                    // Increment version (simple increment)
                    version: (int.tryParse(package.version) ?? 0 + 1).toString(),
                  );

                  try {
                    final result = await ref
                        .read(learningPackageNotifierProvider.notifier)
                        .updatePackage(
                          package.packageId,
                          updatedPackage,
                          currentUserEmail,
                        );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${result?.title ?? package.title} updated successfully',
                          ),
                          backgroundColor: const Color(0xFF2ECC71),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      );
    },
  );
}
```

**Key Points**:
- Pre-populates all fields with existing package data
- Uses the same form structure as create dialog for consistency
- Updates `lastUpdatedDate` automatically
- Increments version number
- Preserves `packageId`, `author`, `words`, and `published` status
- Shows success/error messages

---

## Step 6: Wire Edit Button to Dialog

**File**: `lib/features/teacher_tools/presentation/screens/teacher_tools_page.dart`

Update the Edit button's `onPressed` handler in the `_PackageCard` widget (around line 671-683):

### Current Implementation:
```dart
IconButton(
  icon: Icon(Icons.edit, size: 18),
  color: Colors.grey[600],
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit feature coming soon!'),
        backgroundColor: Color(0xFF3498DB),
      ),
    );
  },
  tooltip: 'Edit',
),
```

### Updated Implementation:
```dart
IconButton(
  icon: Icon(Icons.edit, size: 18),
  color: Colors.grey[600],
  onPressed: () {
    final currentUser = ref.read(currentUserNotifierProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Access the parent widget's method via context
    // Since _PackageCard is a ConsumerWidget, we need to pass the method
    // Option 1: Pass callback from parent
    // Option 2: Make _PackageCard accept an onEdit callback
    // Option 3: Call the method directly if we make it accessible
    
    // For now, we'll add the method to _PackageCard class
    _showEditPackageDialog(context, ref, currentUser.email, package);
  },
  tooltip: 'Edit',
),
```

**Better Approach**: Add the edit dialog method to `_PackageCard` class itself:

Add this method to the `_PackageCard` class (after `_showDeleteDialog`, around line 786):

```dart
void _showEditPackageDialog(
  BuildContext context,
  WidgetRef ref,
  String currentUserEmail,
  LearningPackage package,
) {
  if (currentUserEmail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User not logged in'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Pre-populate controllers with existing package data
  final titleController = TextEditingController(text: package.title);
  final descriptionController = TextEditingController(text: package.description);
  final categoryController = TextEditingController(text: package.category);
  final languageController = TextEditingController(text: package.language);
  String selectedLevel = package.level;
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Package'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        hintText: 'Enter package title',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Enter package description',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        hintText: 'e.g., Travel, Health and Fitness',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Category is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedLevel,
                      decoration: const InputDecoration(labelText: 'Level *'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Beginner',
                          child: Text('Beginner'),
                        ),
                        DropdownMenuItem(
                          value: 'Intermediate',
                          child: Text('Intermediate'),
                        ),
                        DropdownMenuItem(
                          value: 'Advanced',
                          child: Text('Advanced'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedLevel = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: languageController,
                      decoration: const InputDecoration(
                        labelText: 'Language *',
                        hintText: 'e.g., English',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Language is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  // Create updated package using copyWith
                  final currentVersion = int.tryParse(package.version) ?? 1;
                  final updatedPackage = package.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    category: categoryController.text.trim(),
                    level: selectedLevel,
                    language: languageController.text.trim(),
                    lastUpdatedDate: DateTime.now(),
                    version: (currentVersion + 1).toString(),
                  );

                  try {
                    final currentUser = ref.read(currentUserNotifierProvider).value;
                    if (currentUser == null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User not logged in'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      return;
                    }

                    final result = await ref
                        .read(learningPackageNotifierProvider.notifier)
                        .updatePackage(
                          package.packageId,
                          updatedPackage,
                          currentUser.email,
                        );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${result?.title ?? package.title} updated successfully',
                          ),
                          backgroundColor: const Color(0xFF2ECC71),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      );
    },
  );
}
```

Then update the Edit button (around line 671):

```dart
IconButton(
  icon: Icon(Icons.edit, size: 18),
  color: Colors.grey[600],
  onPressed: () {
    final currentUser = ref.read(currentUserNotifierProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _showEditPackageDialog(context, ref, currentUser.email, package);
  },
  tooltip: 'Edit',
),
```

---

## Implementation Summary

### Files to Modify:

1. **`lib/features/learning_packages/domain/entities/learning_package.dart`**
   - Extend `copyWith()` method to support all fields

2. **`lib/features/learning_packages/domain/contracts/learning_package_repository.dart`**
   - Add `updatePackage()` method signature

3. **`lib/features/learning_packages/data/repositories/learning_package_local_repository.dart`**
   - Implement `updatePackage()` method

4. **`lib/features/learning_packages/presentation/providers/learning_package_provider.dart`**
   - Add `updatePackage()` method to notifier

5. **`lib/features/teacher_tools/presentation/screens/teacher_tools_page.dart`**
   - Add `_showEditPackageDialog()` method to `_PackageCard` class
   - Update Edit button's `onPressed` handler

### Key Features:

✅ **Ownership Validation**: Only package authors can update their packages  
✅ **Field Validation**: Required fields are validated before update  
✅ **Automatic Updates**: `lastUpdatedDate` and `version` are updated automatically  
✅ **Status Preservation**: `published` status is preserved (use toggle for that)  
✅ **Immutable Updates**: `packageId` and `author` cannot be changed  
✅ **Error Handling**: Comprehensive error handling with user-friendly messages  
✅ **UI Feedback**: Success/error snackbars inform users of operation results  

### Testing Checklist:

- [ ] Edit button opens dialog with pre-filled data
- [ ] All form fields are editable
- [ ] Validation works (empty fields show errors)
- [ ] Update succeeds and shows success message
- [ ] Package list refreshes after update
- [ ] Updated fields are reflected in the UI
- [ ] Version increments correctly
- [ ] `lastUpdatedDate` updates correctly
- [ ] Cannot edit packages owned by other users
- [ ] Error messages display correctly on failure

---

## Notes

1. **Version Increment**: The current implementation uses a simple increment. You may want to implement semantic versioning (e.g., 1.0.0 → 1.0.1) if needed.

2. **Words Editing**: The current implementation doesn't allow editing words in the package. To add word editing:
   - Create a separate dialog/page for word management
   - Add word CRUD operations to the repository
   - Update the package's words list when words are modified

3. **Keywords Editing**: Similar to words, keywords editing is not included. Add a multi-select or tag input field if needed.

4. **Icon URL**: Icon URL editing is not included in the basic form. Add an image picker or URL input field if needed.

5. **Published Status**: The update function preserves the published status. Use the existing toggle publish/unpublish button to change it.

---

## Future Enhancements

- Add word editing functionality
- Add keywords management
- Add icon/image upload
- Add version history/rollback
- Add bulk edit capabilities
- Add undo/redo functionality


