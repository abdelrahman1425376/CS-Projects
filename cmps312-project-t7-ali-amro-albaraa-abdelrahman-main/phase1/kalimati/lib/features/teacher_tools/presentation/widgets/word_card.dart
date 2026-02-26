import 'package:flutter/material.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final int wordIndex;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageDefinitions;
  final VoidCallback onManageSentences;

  const WordCard({
    super.key,
    required this.word,
    required this.wordIndex,
    required this.onEdit,
    required this.onDelete,
    required this.onManageDefinitions,
    required this.onManageSentences,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: onEdit,
                  tooltip: 'Edit Word',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  color: Colors.red,
                  onPressed: onDelete,
                  tooltip: 'Delete Word',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text('${word.definitions.length} definitions'),
                  backgroundColor: Colors.blue.shade50,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('${word.sentences.length} sentences'),
                  backgroundColor: Colors.green.shade50,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onManageDefinitions,
                    icon: const Icon(Icons.book, size: 16),
                    label: const Text('Manage Definitions'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onManageSentences,
                    icon: const Icon(Icons.chat_bubble, size: 16),
                    label: const Text('Manage Sentences'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
