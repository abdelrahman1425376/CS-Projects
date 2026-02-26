import 'package:flutter/material.dart';

class MatchGameActionButtons extends StatelessWidget {
  final int currentIndex;
  final int totalWords;
  final bool isLooping;
  final bool hasAttempted;
  final bool isCorrect;
  final VoidCallback onCheckAnswer;
  final VoidCallback onResetCurrentWord;
  final VoidCallback onPreviousWord;
  final VoidCallback onNextWord;

  const MatchGameActionButtons({
    super.key,
    required this.currentIndex,
    required this.totalWords,
    required this.isLooping,
    required this.hasAttempted,
    required this.isCorrect,
    required this.onCheckAnswer,
    required this.onResetCurrentWord,
    required this.onPreviousWord,
    required this.onNextWord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: hasAttempted && isCorrect
                      ? onResetCurrentWord
                      : onCheckAnswer,
                  icon: Icon(
                    hasAttempted && isCorrect ? Icons.refresh : Icons.check,
                  ),
                  label: Text(
                    hasAttempted && isCorrect ? 'Try Again' : 'Check Answer',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: currentIndex > 0 || isLooping
                        ? onPreviousWord
                        : null,
                    iconSize: 32,
                    color: Colors.purple,
                  ),
                  Text(
                    'Word ${currentIndex + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: currentIndex < totalWords - 1 || isLooping
                        ? onNextWord
                        : null,
                    iconSize: 32,
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
