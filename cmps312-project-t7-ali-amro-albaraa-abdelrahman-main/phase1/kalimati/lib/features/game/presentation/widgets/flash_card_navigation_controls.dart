import 'package:flutter/material.dart';

class FlashCardNavigationControls extends StatelessWidget {
  final int currentIndex;
  final int totalWords;
  final bool isLooping;
  final bool isFlipped;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFlip;

  const FlashCardNavigationControls({
    super.key,
    required this.currentIndex,
    required this.totalWords,
    required this.isLooping,
    required this.isFlipped,
    required this.onPrevious,
    required this.onNext,
    required this.onFlip,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: currentIndex > 0 || isLooping ? onPrevious : null,
                iconSize: 32,
                color: Colors.purple,
              ),
              ElevatedButton.icon(
                onPressed: onFlip,
                icon: Icon(isFlipped ? Icons.undo : Icons.flip),
                label: Text(isFlipped ? 'Show Word' : 'Show Answer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: currentIndex < totalWords - 1 || isLooping
                    ? onNext
                    : null,
                iconSize: 32,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
