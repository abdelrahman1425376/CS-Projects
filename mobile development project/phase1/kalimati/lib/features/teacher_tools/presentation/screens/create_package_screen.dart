import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/features/view_learning_packages/presentation/providers/learning_package_provider.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';

class CreatePackageScreen extends ConsumerStatefulWidget {
  final String currentUserEmail;
  const CreatePackageScreen({super.key, required this.currentUserEmail});

  @override
  ConsumerState<CreatePackageScreen> createState() =>
      _CreatePackageScreenState();
}

class _CreatePackageScreenState extends ConsumerState<CreatePackageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _languageController = TextEditingController(text: 'English');
  String _selectedLevel = 'Beginner';
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.currentUserEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    final packageId = 'p${DateTime.now().millisecondsSinceEpoch}';
    final newPackage = LearningPackage(
      packageId: packageId,
      author: widget.currentUserEmail,
      category: _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
      iconUrl: '',
      keywords: [],
      language: _languageController.text.trim(),
      lastUpdatedDate: DateTime.now(),
      level: _selectedLevel,
      title: _titleController.text.trim(),
      version: '1',
      words: [Word(text: 'Example', definitions: [], sentences: [])],
      published: false,
    );
    try {
      await ref
          .read(learningPackageNotifierProvider.notifier)
          .createPackage(newPackage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newPackage.title} created successfully'),
            backgroundColor: Colors.green.shade400,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Package')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      hintText: 'Enter package title',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Title is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      hintText: 'Enter package description',
                    ),
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Description is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category *',
                      hintText: 'e.g., Travel, Health and Fitness',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Category is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLevel,
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
                    onChanged: (v) =>
                        setState(() => _selectedLevel = v ?? 'Beginner'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _languageController,
                    decoration: const InputDecoration(
                      labelText: 'Language *',
                      hintText: 'e.g., English',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Language is required'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: const Icon(Icons.save),
                    label: Text(_submitting ? 'Creating...' : 'Create'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
