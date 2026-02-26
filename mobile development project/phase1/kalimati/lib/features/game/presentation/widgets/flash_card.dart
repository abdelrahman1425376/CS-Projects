import 'package:flutter/material.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/resource.dart';
import 'package:class_manager/core/utils/enums.dart';

class FlashCard extends StatelessWidget {
  final Word currentWord;
  final Animation<double> flipAnimation;
  final bool isFlipped;
  final VoidCallback onFlip;
  final Function(Resource) onResourceTap;

  const FlashCard({
    super.key,
    required this.currentWord,
    required this.flipAnimation,
    required this.isFlipped,
    required this.onFlip,
    required this.onResourceTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: GestureDetector(
        onTap: onFlip,
        child: AnimatedBuilder(
          animation: flipAnimation,
          builder: (context, child) {
            final angle = flipAnimation.value * 3.14159;
            final isFront = flipAnimation.value < 0.5;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isFront
                  ? _buildCardFront()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _buildCardBack(),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardHeight = screenWidth > 800 ? 350.0 : 300.0;
        final fontSize = screenWidth > 800 ? 40.0 : 36.0;
        final iconSize = screenWidth > 800 ? 72.0 : 64.0;

        return Container(
          margin: const EdgeInsets.all(24),
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories, size: iconSize, color: Colors.white),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    currentWord.text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tap to flip',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBack() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardHeight = screenWidth > 800 ? 350.0 : 300.0;
        final titleFontSize = screenWidth > 800 ? 28.0 : 24.0;
        final contentPadding = screenWidth > 800 ? 32.0 : 24.0;

        return Container(
          margin: const EdgeInsets.all(24),
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          currentWord.text,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flip),
                        onPressed: onFlip,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const Divider(),
                  if (currentWord.definitions.isNotEmpty) ...[
                    const Text(
                      'Definitions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...currentWord.definitions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final def = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    def.text,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  if (def.source.isNotEmpty)
                                    Text(
                                      'Source: ${def.source}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                  if (currentWord.sentences.isNotEmpty) ...[
                    const Text(
                      'Example Sentences:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...currentWord.sentences.map(
                      (sentence) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sentence.text,
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (sentence.resources.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                children: sentence.resources.map((resource) {
                                  IconData icon;
                                  Color color;
                                  switch (resource.type) {
                                    case ResourceTypeEnum.photo:
                                      icon = Icons.image;
                                      color = Colors.blue;
                                      break;
                                    case ResourceTypeEnum.video:
                                      icon = Icons.video_library;
                                      color = Colors.red;
                                      break;
                                    case ResourceTypeEnum.website:
                                      icon = Icons.link;
                                      color = Colors.green;
                                      break;
                                  }
                                  return InkWell(
                                    onTap: () => onResourceTap(resource),
                                    child: Chip(
                                      label: Text(
                                        resource.title,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      avatar: Icon(
                                        icon,
                                        size: 14,
                                        color: color,
                                      ),
                                      padding: EdgeInsets.zero,
                                      labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
