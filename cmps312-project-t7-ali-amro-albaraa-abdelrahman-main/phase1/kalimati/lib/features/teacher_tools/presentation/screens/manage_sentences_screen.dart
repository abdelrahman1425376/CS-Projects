import 'package:flutter/material.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/sentence.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';
import 'package:class_manager/features/teacher_tools/presentation/screens/manage_resources_screen.dart';

class ManageSentencesScreen extends StatefulWidget {
  final Word word;
  final List<Sentence> initialSentences;
  const ManageSentencesScreen({
    super.key,
    required this.word,
    required this.initialSentences,
  });

  @override
  State<ManageSentencesScreen> createState() => _ManageSentencesScreenState();
}

class _ManageSentencesScreenState extends State<ManageSentencesScreen> {
  late List<Sentence> sentences;

  @override
  void initState() {
    super.initState();
    sentences = List.from(widget.initialSentences);
  }

  void _addSentence() {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Sentence'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            decoration: const InputDecoration(labelText: 'Sentence *'),
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Sentence is required' : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() => sentences.add(Sentence(text: textController.text.trim(), resources: [])));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editSentence(int index) {
    final sent = sentences[index];
    final textController = TextEditingController(text: sent.text);
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Sentence'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            decoration: const InputDecoration(labelText: 'Sentence *'),
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Sentence is required' : null,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() => sentences[index] = sent.copyWith(text: textController.text.trim()));
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _manageResources(int index) async {
    final updated = await Navigator.push<List>(
      context,
      MaterialPageRoute(
        builder: (_) => ManageResourcesScreen(
          sentence: sentences[index],
          initialResources: sentences[index].resources,
        ),
      ),
    );
    if (updated != null) {
      setState(() => sentences[index] = sentences[index].copyWith(resources: updated.cast()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentences: ${widget.word.text}'),
        actions: [IconButton(onPressed: _addSentence, icon: const Icon(Icons.add))],
      ),
      body: sentences.isEmpty
          ? const Center(child: Text('No sentences yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sentences.length,
              itemBuilder: (_, i) {
                final s = sentences[i];
                return Card(
                  child: ListTile(
                    title: Text(s.text),
                    subtitle: Text('Resources: ${s.resources.length}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.attach_file), onPressed: () => _manageResources(i)),
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _editSentence(i)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() => sentences.removeAt(i)),
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
            onPressed: () => Navigator.of(context).pop(sentences),
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}


