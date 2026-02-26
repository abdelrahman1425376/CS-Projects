import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/features/auth/presentaion/providers/auth_provider.dart';
import 'package:class_manager/features/view_learning_packages/presentation/providers/learning_package_provider.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:class_manager/features/teacher_tools/presentation/screens/manage_words_screen.dart';

class PackageCard extends ConsumerWidget {
  final LearningPackage package;

  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordCount = package.words.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  package.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: package.published
                      ? Colors.green.shade400.withValues(alpha: 0.1)
                      : Colors.grey.shade600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      package.published
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 14,
                      color: package.published
                          ? Colors.green.shade400
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      package.published ? 'Published' : 'Unpublished',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: package.published
                            ? Colors.green.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Expanded(
            child: Text(
              package.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$wordCount ${wordCount == 1 ? 'word' : 'words'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.auto_stories, size: 16),
                    color: Colors.blue,
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      final currentUser = ref
                          .read(currentUserNotifierProvider)
                          .value;
                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User not logged in'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ManageWordsScreen(
                            currentUserEmail: currentUser.email,
                            package: package,
                          ),
                        ),
                      );
                    },
                    tooltip: 'Manage Words',
                  ),

                  IconButton(
                    icon: Icon(
                      package.published
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 16,
                    ),
                    color: package.published
                        ? Colors.grey.shade600
                        : Colors.green.shade400,
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      _togglePublishStatus(context, ref, package);
                    },
                    tooltip: package.published ? 'Unpublish' : 'Publish',
                  ),

                  IconButton(
                    icon: Icon(Icons.edit, size: 16),
                    color: Colors.grey.shade600,
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      final currentUser = ref
                          .read(currentUserNotifierProvider)
                          .value;
                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User not logged in'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      _showEditPackageDialog(
                        context,
                        ref,
                        currentUser.email,
                        package,
                      );
                    },
                    tooltip: 'Edit',
                  ),

                  IconButton(
                    icon: Icon(Icons.delete, size: 16),
                    color: Colors.red.shade400,
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      _showDeleteDialog(context, ref, package);
                    },
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _togglePublishStatus(
    BuildContext context,
    WidgetRef ref,
    LearningPackage package,
  ) async {
    try {
      final updatedPackage = package.copyWith(
        published: !package.published,
        lastUpdatedDate: DateTime.now(),
      );

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

      await ref
          .read(learningPackageNotifierProvider.notifier)
          .updatePackage(package.packageId, updatedPackage, currentUser.email);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              updatedPackage.published
                  ? '${package.title} published successfully'
                  : '${package.title} unpublished successfully',
            ),
            backgroundColor: updatedPackage.published
                ? Colors.green.shade400
                : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating publish status: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    LearningPackage package,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Package'),
          content: Text('Are you sure you want to delete "${package.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
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

                try {
                  await ref
                      .read(learningPackageNotifierProvider.notifier)
                      .deletePackage(package);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${package.title} deleted successfully'),
                        backgroundColor: Colors.green.shade400,
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
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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

    final titleController = TextEditingController(text: package.title);
    final descriptionController = TextEditingController(
      text: package.description,
    );
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
                        initialValue: selectedLevel,
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
                      final currentUser = ref
                          .read(currentUserNotifierProvider)
                          .value;
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

                      await ref
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
                              '${package.title} updated successfully',
                            ),
                            backgroundColor: Colors.green.shade400,
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
                    backgroundColor: Colors.blue,
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
}
