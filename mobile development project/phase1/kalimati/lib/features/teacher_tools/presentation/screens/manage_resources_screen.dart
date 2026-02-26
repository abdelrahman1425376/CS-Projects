import 'package:flutter/material.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/sentence.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/resource.dart';
import 'package:class_manager/core/utils/enums.dart';

class ManageResourcesScreen extends StatefulWidget {
  final Sentence sentence;
  final List<Resource> initialResources;
  const ManageResourcesScreen({
    super.key,
    required this.sentence,
    required this.initialResources,
  });

  @override
  State<ManageResourcesScreen> createState() => _ManageResourcesScreenState();
}

class _ManageResourcesScreenState extends State<ManageResourcesScreen> {
  late List<Resource> resources;

  @override
  void initState() {
    super.initState();
    resources = List.from(widget.initialResources);
  }

  void _addResource() {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    ResourceTypeEnum selectedType = ResourceTypeEnum.photo;
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Resource'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title *'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ResourceTypeEnum>(
                      initialValue: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Resource Type *',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: ResourceTypeEnum.photo,
                          child: Text('Photo'),
                        ),
                        DropdownMenuItem(
                          value: ResourceTypeEnum.video,
                          child: Text('Video'),
                        ),
                        DropdownMenuItem(
                          value: ResourceTypeEnum.website,
                          child: Text('Website'),
                        ),
                      ],
                      onChanged: (v) => setState(
                        () => selectedType = v ?? ResourceTypeEnum.photo,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'GitHub URL *',
                        hintText: 'https://github.com/...',
                        prefixIcon: Icon(Icons.link),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'URL is required';
                        if (!v.trim().startsWith('http://') &&
                            !v.trim().startsWith('https://')) {
                          return 'Please enter a valid URL';
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
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  setState(() {
                    resources.add(
                      Resource(
                        title: titleController.text.trim(),
                        url: urlController.text.trim(),
                        type: selectedType,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editResource(int index) {
    final res = resources[index];
    final titleController = TextEditingController(text: res.title);
    final urlController = TextEditingController(text: res.url);
    ResourceTypeEnum selectedType = res.type;
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Resource'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title *'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ResourceTypeEnum>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Resource Type *',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: ResourceTypeEnum.photo,
                          child: Text('Photo'),
                        ),
                        DropdownMenuItem(
                          value: ResourceTypeEnum.video,
                          child: Text('Video'),
                        ),
                        DropdownMenuItem(
                          value: ResourceTypeEnum.website,
                          child: Text('Website'),
                        ),
                      ],
                      onChanged: (v) => setState(
                        () => selectedType = v ?? ResourceTypeEnum.photo,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'GitHub URL *',
                        hintText: 'https://github.com/...',
                        prefixIcon: Icon(Icons.link),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'URL is required';
                        }
                        if (!v.trim().startsWith('http://') &&
                            !v.trim().startsWith('https://')) {
                          return 'Please enter a valid URL';
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
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  setState(() {
                    resources[index] = res.copyWith(
                      title: titleController.text.trim(),
                      url: urlController.text.trim(),
                      type: selectedType,
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources: ${widget.sentence.text}'),
        actions: [
          IconButton(onPressed: _addResource, icon: const Icon(Icons.add)),
        ],
      ),
      body: resources.isEmpty
          ? const Center(child: Text('No resources yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: resources.length,
              itemBuilder: (_, i) {
                final r = resources[i];
                String typeLabel;
                switch (r.type) {
                  case ResourceTypeEnum.photo:
                    typeLabel = 'Photo';
                    break;
                  case ResourceTypeEnum.video:
                    typeLabel = 'Video';
                    break;
                  case ResourceTypeEnum.website:
                    typeLabel = 'Website';
                    break;
                }
                return Card(
                  child: ListTile(
                    title: Text(r.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeLabel,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editResource(i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              setState(() => resources.removeAt(i)),
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
            onPressed: () => Navigator.of(context).pop(resources),
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
