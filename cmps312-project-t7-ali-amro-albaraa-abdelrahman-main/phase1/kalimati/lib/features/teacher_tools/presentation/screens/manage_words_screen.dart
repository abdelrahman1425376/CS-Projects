import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';
import 'package:class_manager/features/view_learning_packages/presentation/providers/learning_package_provider.dart';
import 'package:class_manager/features/teacher_tools/presentation/screens/manage_definitions_screen.dart';
import 'package:class_manager/features/teacher_tools/presentation/screens/manage_sentences_screen.dart';

class ManageWordsScreen extends ConsumerStatefulWidget {
  final String currentUserEmail;
  final LearningPackage package;
  const ManageWordsScreen({
    super.key,
    required this.currentUserEmail,
    required this.package,
  });

  @override
  ConsumerState<ManageWordsScreen> createState() => _ManageWordsScreenState();
}

class _ManageWordsScreenState extends ConsumerState<ManageWordsScreen> {
  late List<Word> wordsList;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    wordsList = List.from(widget.package.words);
  }

  void _addWord() {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Word'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Word *'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Word is required' : null,
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(
                () => wordsList.add(
                  Word(
                    text: controller.text.trim(),
                    definitions: [],
                    sentences: [],
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editWord(int index) {
    final word = wordsList[index];
    final controller = TextEditingController(text: word.text);
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Word'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Word *'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Word is required' : null,
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(
                () => wordsList[index] = word.copyWith(
                  text: controller.text.trim(),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _manageDefinitions(int index) async {
    final updated = await Navigator.push<List>(
      context,
      MaterialPageRoute(
        builder: (_) => ManageDefinitionsScreen(
          word: wordsList[index],
          initialDefinitions: wordsList[index].definitions,
        ),
      ),
    );
    if (updated != null) {
      setState(
        () => wordsList[index] = wordsList[index].copyWith(
          definitions: updated.cast(),
        ),
      );
    }
  }

  Future<void> _manageSentences(int index) async {
    final updated = await Navigator.push<List>(
      context,
      MaterialPageRoute(
        builder: (_) => ManageSentencesScreen(
          word: wordsList[index],
          initialSentences: wordsList[index].sentences,
        ),
      ),
    );
    if (updated != null) {
      setState(
        () => wordsList[index] = wordsList[index].copyWith(
          sentences: updated.cast(),
        ),
      );
    }
  }

  Future<void> _save() async {
    if (widget.currentUserEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (wordsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Package must contain at least one word'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final currentVersion = int.tryParse(widget.package.version) ?? 1;
      final updated = widget.package.copyWith(
        words: wordsList,
        lastUpdatedDate: DateTime.now(),
        version: (currentVersion + 1).toString(),
      );
      await ref
          .read(learningPackageNotifierProvider.notifier)
          .updatePackage(
            widget.package.packageId,
            updated,
            widget.currentUserEmail,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Words updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Words: ${widget.package.title}'),
        actions: [IconButton(onPressed: _addWord, icon: const Icon(Icons.add))],
      ),
      body: wordsList.isEmpty
          ? const Center(child: Text('No words yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: wordsList.length,
              itemBuilder: (_, i) {
                final w = wordsList[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                w.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'definitions':
                                    _manageDefinitions(i);
                                    break;
                                  case 'sentences':
                                    _manageSentences(i);
                                    break;
                                  case 'edit':
                                    _editWord(i);
                                    break;
                                  case 'delete':
                                    setState(() => wordsList.removeAt(i));
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'definitions',
                                  child: Row(
                                    children: [
                                      Icon(Icons.book, size: 20),
                                      SizedBox(width: 8),
                                      Text('Manage Definitions'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'sentences',
                                  child: Row(
                                    children: [
                                      Icon(Icons.chat_bubble, size: 20),
                                      SizedBox(width: 8),
                                      Text('Manage Sentences'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 20),
                                      SizedBox(width: 8),
                                      Text('Edit Word'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete Word',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Chip(
                              label: Text(
                                '${w.definitions.length} definitions',
                              ),
                              labelStyle: const TextStyle(fontSize: 12),
                              backgroundColor: Colors.blue.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            Chip(
                              label: Text('${w.sentences.length} sentences'),
                              labelStyle: const TextStyle(fontSize: 12),
                              backgroundColor: Colors.green.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving...' : 'Save Changes'),
          ),
        ),
      ),
    );
  }
}
