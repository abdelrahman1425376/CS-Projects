import 'package:flutter/material.dart';

class FlashCardProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalWords;

  const FlashCardProgressIndicator({
    super.key,
    required this.currentIndex,
    required this.totalWords,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / totalWords,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${currentIndex + 1} / $totalWords',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
