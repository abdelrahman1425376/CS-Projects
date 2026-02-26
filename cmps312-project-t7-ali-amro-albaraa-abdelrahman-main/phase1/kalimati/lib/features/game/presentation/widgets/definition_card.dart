import 'package:flutter/material.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/definition.dart';

class DefinitionCard extends StatelessWidget {
  final Definition definition;
  final bool isSelected;
  final bool showCorrect;
  final bool showIncorrect;
  final VoidCallback onTap;

  const DefinitionCard({
    super.key,
    required this.definition,
    required this.isSelected,
    required this.showCorrect,
    required this.showIncorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color backgroundColor;
    IconData? icon;
    Color? iconColor;

    if (showCorrect) {
      borderColor = Colors.green;
      backgroundColor = Colors.green.shade50;
      icon = Icons.check_circle;
      iconColor = Colors.green;
    } else if (showIncorrect) {
      borderColor = Colors.red;
      backgroundColor = Colors.red.shade50;
      icon = Icons.cancel;
      iconColor = Colors.red;
    } else if (isSelected) {
      borderColor = Colors.purple;
      backgroundColor = Colors.purple.withValues(alpha: 0.1);
      icon = null;
      iconColor = null;
    } else {
      borderColor = Colors.grey.shade300;
      backgroundColor = Colors.white;
      icon = null;
      iconColor = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isSelected || showCorrect || showIncorrect ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 12),
              ] else if (isSelected) ...[
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected || showCorrect || showIncorrect
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    if (definition.source.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Source: ${definition.source}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
