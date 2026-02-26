import 'package:flutter/material.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/definition.dart';
import 'definition_card.dart';

class DefinitionsList extends StatelessWidget {
  final List<Definition> availableDefinitions;
  final Definition? selectedDefinition;
  final Definition? correctDefinition;
  final bool hasAttempted;
  final bool isCorrect;
  final Function(Definition) onDefinitionSelected;

  const DefinitionsList({
    super.key,
    required this.availableDefinitions,
    required this.selectedDefinition,
    required this.correctDefinition,
    required this.hasAttempted,
    required this.isCorrect,
    required this.onDefinitionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select the correct definition:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              ...availableDefinitions.map((definition) {
                final isSelected = selectedDefinition == definition;
                final isCorrectAnswer = definition == correctDefinition;
                final showCorrect =
                    hasAttempted && isCorrect && isCorrectAnswer;
                final showIncorrect =
                    hasAttempted &&
                    !isCorrect &&
                    isSelected &&
                    !isCorrectAnswer;

                return DefinitionCard(
                  definition: definition,
                  isSelected: isSelected,
                  showCorrect: showCorrect,
                  showIncorrect: showIncorrect,
                  onTap: () => onDefinitionSelected(definition),
                );
              }).toList(),

              if (hasAttempted && !isCorrect) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Correct Answer:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        correctDefinition!.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (correctDefinition!.source.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Source: ${correctDefinition!.source}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
