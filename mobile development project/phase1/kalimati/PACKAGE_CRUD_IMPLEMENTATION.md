# Package CRUD Implementation Guide

## Overview

This document outlines the safest and best practices for implementing **Delete** and **Create** package functionality in the Kalimati learning package system.

## Architecture Understanding

### Current State Management

- **Repository Pattern**: `LearningPackageLocalRepository` manages in-memory state
- **State Storage**: Packages cached in `_cachedPackages` list
- **Provider Pattern**: Riverpod `AsyncNotifier` manages UI state
- **Singleton Repository**: Repository instance is shared to preserve state

### Key Constraints

1. **Data Source**: Packages loaded from `assets/data/packages.json` (read-only)
2. **In-Memory State**: All modifications are in-memory only (not persisted to JSON)
3. **Author Validation**: Only package author can delete/modify their packages
4. **State Consistency**: Must maintain cache consistency after operations

---

## 1. Delete Package Implementation

### Safety Considerations

#### ✅ **Best Practices**

1. **Authorization Check**

   - Verify current user is the package author
   - Prevent unauthorized deletions
   - Return clear error messages

2. **Confirmation Dialog**

   - Require user confirmation before deletion
   - Show package title in confirmation
   - Provide cancel option

3. **State Management**

   - Remove from `_cachedPackages` list
   - Remove from `_publishedPackageIds` set (if unpublished)
   - Remove from `_downloadedPackageIds` list (if downloaded)
   - Update UI state safely

4. **Error Handling**

   - Handle cases where package doesn't exist
   - Handle authorization failures
   - Provide user-friendly error messages

5. **UI Feedback**
   - Show loading state during deletion
   - Show success/error messages
   - Update package list immediately

### Implementation Strategy

```dart
// Repository Layer
Future<void> deletePackage(String packageId, String currentUserEmail) async {
  // 1. Find package
  // 2. Verify ownership
  // 3. Remove from all tracking sets
  // 4. Remove from cache
  // 5. Return success/error
}

// Provider Layer
Future<void> deletePackage(String packageId, String currentUserEmail) async {
  // 1. Call repository
  // 2. Handle errors
  // 3. Refresh state (use resetToAllPackages, not invalidateSelf)
  // 4. Return result for UI feedback
}

// UI Layer
void _handleDelete(BuildContext context, WidgetRef ref, LearningPackage package) {
  // 1. Show confirmation dialog
  // 2. Call provider method
  // 3. Show loading indicator
  // 4. Show success/error message
}
```

---

## 2. Create Package Implementation

### Safety Considerations

#### ✅ **Best Practices**

1. **Input Validation**

   - Validate all required fields (title, description, level, etc.)
   - Validate package structure (at least one word)
   - Validate author matches current user
   - Validate packageId uniqueness

2. **ID Generation**

   - Generate unique packageId (e.g., `p${timestamp}_${random}`)
   - Ensure no collisions with existing packages

3. **Default Values**

   - Set `published: false` by default (unpublished)
   - Set `lastUpdatedDate: DateTime.now()`
   - Set `version: "1"`
   - Initialize empty `keywords: []` if not provided

4. **State Management**

   - Add to `_cachedPackages` list
   - Add to `_publishedPackageIds` set if unpublished
   - Update UI state safely

5. **Error Handling**

   - Validate all inputs before creation
   - Handle duplicate packageId errors
   - Provide clear validation error messages

6. **UI Flow**
   - Create form/dialog for package input
   - Show validation errors inline
   - Show loading state during creation
   - Navigate to package or show success message

### Implementation Strategy

```dart
// Repository Layer
Future<LearningPackage> createPackage(
  LearningPackage package,
  String currentUserEmail,
) async {
  // 1. Validate ownership (author == currentUserEmail)
  // 2. Validate packageId uniqueness
  // 3. Validate required fields
  // 4. Add to cache
  // 5. Add to unpublished set (if unpublished)
  // 6. Return created package
}

// Provider Layer
Future<LearningPackage?> createPackage(
  LearningPackage package,
  String currentUserEmail,
) async {
  // 1. Call repository
  // 2. Handle validation errors
  // 3. Refresh state
  // 4. Return created package or null on error
}

// UI Layer
void _handleCreate(BuildContext context, WidgetRef ref) {
  // 1. Show create form/dialog
  // 2. Collect user input
  // 3. Validate inputs
  // 4. Call provider method
  // 5. Show loading indicator
  // 6. Show success/error message
  // 7. Navigate or refresh list
}
```

---

## 3. Critical Implementation Details

### State Refresh Pattern

**❌ DON'T USE:**

```dart
ref.invalidateSelf(); // Recreates repository, loses state
```

**✅ USE INSTEAD:**

```dart
resetToAllPackages(); // Updates state, preserves repository
```

### Error Handling Pattern

**✅ ALWAYS:**

```dart
try {
  // Operation
  await repository.operation();
  // Refresh state
  resetToAllPackages();
} catch (e, stackTrace) {
  // Log error
  debugPrint('Error: $e');
  // Set error state
  state = AsyncValue.error(e, stackTrace);
  // Re-throw for UI handling
  throw e;
}
```

### Authorization Pattern

**✅ ALWAYS CHECK:**

```dart
if (package.author != currentUserEmail) {
  throw Exception('Unauthorized: You can only modify your own packages');
}
```

### ID Generation Pattern

**✅ SAFE ID GENERATION:**

```dart
String generatePackageId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = (timestamp % 10000).toString().padLeft(4, '0');
  return 'p${timestamp}_$random';
}
```

---

## 4. UI Implementation Guidelines

### Delete Button Flow

1. **Click Delete Icon** → Show confirmation dialog
2. **User Confirms** → Show loading indicator
3. **Call Provider** → Delete package
4. **On Success** → Show success message, refresh list
5. **On Error** → Show error message, keep package visible

### Create Button Flow

1. **Click Create Button** → Show create form/dialog
2. **User Fills Form** → Validate inputs
3. **User Submits** → Show loading indicator
4. **Call Provider** → Create package
5. **On Success** → Show success message, refresh list, optionally navigate
6. **On Error** → Show validation errors, keep form open

---

## 5. Testing Checklist

### Delete Package

- [ ] Can delete own package
- [ ] Cannot delete other user's package
- [ ] Confirmation dialog appears
- [ ] Package removed from list after deletion
- [ ] Success message shown
- [ ] Error message shown on failure
- [ ] Published count updates correctly

### Create Package

- [ ] Can create package with valid data
- [ ] Cannot create package with missing required fields
- [ ] Cannot create package with duplicate ID
- [ ] Package appears in list after creation
- [ ] Package is unpublished by default
- [ ] Success message shown
- [ ] Validation errors shown for invalid inputs

---

## 6. Security Considerations

1. **Always validate ownership** before delete/create
2. **Never trust client-side data** - validate all inputs
3. **Generate IDs server-side** (or with strong randomness)
4. **Sanitize user inputs** to prevent injection
5. **Rate limit** create operations to prevent abuse

---

## Summary

The safest implementation follows these principles:

1. **Validate everything** - ownership, inputs, state
2. **Handle errors gracefully** - clear messages, proper state
3. **Preserve repository state** - use `resetToAllPackages()`, not `invalidateSelf()`
4. **Provide user feedback** - loading, success, error states
5. **Maintain consistency** - update all related state (cache, sets, UI)
