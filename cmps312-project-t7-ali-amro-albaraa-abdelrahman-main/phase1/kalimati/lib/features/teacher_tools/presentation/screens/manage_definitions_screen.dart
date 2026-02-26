import 'package:flutter/material.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/definition.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';

class ManageDefinitionsScreen extends StatefulWidget {
  final Word word;
  final List<Definition> initialDefinitions;
  const ManageDefinitionsScreen({
    super.key,
    required this.word,
    required this.initialDefinitions,
  });

  @override
  State<ManageDefinitionsScreen> createState() =>
      _ManageDefinitionsScreenState();
}

class _ManageDefinitionsScreenState extends State<ManageDefinitionsScreen> {
  late List<Definition> definitions;

  @override
  void initState() {
    super.initState();
    definitions = List.from(widget.initialDefinitions);
  }

  void _addDefinition() {
    final textController = TextEditingController();
    final sourceController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Definition'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Definition *'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Definition is required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: sourceController,
                decoration: const InputDecoration(labelText: 'Source'),
              ),
            ],
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
              setState(() {
                definitions.add(
                  Definition(
                    text: textController.text.trim(),
                    source: sourceController.text.trim(),
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editDefinition(int index) {
    final def = definitions[index];
    final textController = TextEditingController(text: def.text);
    final sourceController = TextEditingController(text: def.source);
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Definition'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Definition *'),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Definition is required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: sourceController,
                decoration: const InputDecoration(labelText: 'Source'),
              ),
            ],
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
              setState(() {
                definitions[index] = def.copyWith(
                  text: textController.text.trim(),
                  source: sourceController.text.trim(),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Definitions: ${widget.word.text}'),
        actions: [
          IconButton(onPressed: _addDefinition, icon: const Icon(Icons.add)),
        ],
      ),
      body: definitions.isEmpty
          ? const Center(child: Text('No definitions yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: definitions.length,
              itemBuilder: (_, i) {
                final d = definitions[i];
                return Card(
                  child: ListTile(
                    title: Text(d.text),
                    subtitle: Text('Source: ${d.source}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editDefinition(i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              setState(() => definitions.removeAt(i)),
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
            onPressed: () => Navigator.of(context).pop(definitions),
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
