import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/learning_package.dart';

class DownloadButton extends ConsumerStatefulWidget {
  final LearningPackage package;

  const DownloadButton({super.key, required this.package});

  @override
  ConsumerState<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends ConsumerState<DownloadButton> {
  bool _isDownloaded = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleButtonPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isDownloaded ? Colors.green : Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isDownloaded ? Icons.play_arrow : Icons.download,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _isDownloaded ? 'Start Learning' : 'Download',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _handleButtonPress() async {
    if (!_isDownloaded) {
      setState(() {
        _isLoading = true;
      });

      try {
        setState(() {
          _isDownloaded = true;
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.package.title} downloaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to download: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      _showLearningOptionsDialog();
    }
  }

  void _showLearningOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Choose Learning Mode',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select how you want to learn "${widget.package.title}"',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              LearningOptionTile(
                icon: Icons.style,
                title: 'Play Flash Cards',
                description: 'Learn words with interactive flash cards',
                onTap: () {
                  Navigator.of(context).pop();
                  _startLearningMode('flashcards');
                },
              ),
              const SizedBox(height: 12),
              LearningOptionTile(
                icon: Icons.shuffle,
                title: 'Unscramble Sentences',
                description: 'Put words in the correct order',
                onTap: () {
                  Navigator.of(context).pop();
                  _startLearningMode('unscramble');
                },
              ),
              const SizedBox(height: 12),
              LearningOptionTile(
                icon: Icons.connect_without_contact,
                title: 'Match Word & Definition',
                description: 'Connect words with their meanings',
                onTap: () {
                  Navigator.of(context).pop();
                  _startLearningMode('matching');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
          ],
        );
      },
    );
  }

  void _startLearningMode(String mode) {
    if (mode == 'flashcards') {
      context.push('/flash_cards', extra: widget.package);
    } else if (mode == 'unscramble') {
      context.push('/unscramble_sentences', extra: widget.package);
    } else if (mode == 'matching') {
      context.push('/match_word_definition', extra: widget.package);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$mode mode coming soon!'),
          backgroundColor: const Color(0xFF7B68EE),
        ),
      );
    }
  }
}

class LearningOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const LearningOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.purple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
