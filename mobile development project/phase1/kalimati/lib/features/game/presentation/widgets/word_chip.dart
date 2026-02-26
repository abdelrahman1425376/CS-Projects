import 'package:flutter/material.dart';

class WordChip extends StatelessWidget {
  final String word;
  final bool isSelected;
  final bool isCorrect;
  final bool isCorrectPosition;
  final VoidCallback onTap;

  const WordChip({
    super.key,
    required this.word,
    required this.isSelected,
    required this.onTap,
    this.isCorrect = false,
    this.isCorrectPosition = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    if (isSelected) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        textColor = Colors.white;
        icon = Icons.check;
      } else if (isCorrectPosition) {
        backgroundColor = Colors.orange;
        textColor = Colors.white;
      } else {
        backgroundColor = Colors.purple;
        textColor = Colors.white;
      }
    } else {
      backgroundColor = Colors.grey.shade200;
      textColor = Colors.black87;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              word,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(Icons.close, size: 16, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}
