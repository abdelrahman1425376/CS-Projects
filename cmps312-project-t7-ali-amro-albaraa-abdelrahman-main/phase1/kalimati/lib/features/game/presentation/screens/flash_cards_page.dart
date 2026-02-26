import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/resource.dart';
import '../widgets/flash_card.dart';
import '../widgets/flash_card_progress_indicator.dart';
import '../widgets/flash_card_navigation_controls.dart';
import '../widgets/resource_dialog.dart';

class FlashCardsPage extends StatefulWidget {
  final LearningPackage package;

  const FlashCardsPage({super.key, required this.package});

  @override
  State<FlashCardsPage> createState() => _FlashCardsPageState();
}

class _FlashCardsPageState extends State<FlashCardsPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _isLooping = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  List<Word> get words => widget.package.words;
  Word get currentWord => words[_currentIndex];

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _nextCard() {
    if (_currentIndex < words.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
        _flipController.reset();
      });
    } else if (_isLooping) {
      setState(() {
        _currentIndex = 0;
        _isFlipped = false;
        _flipController.reset();
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
        _flipController.reset();
      });
    } else if (_isLooping) {
      setState(() {
        _currentIndex = words.length - 1;
        _isFlipped = false;
        _flipController.reset();
      });
    }
  }

  void _showResourceDialog(Resource resource) {
    showDialog(
      context: context,
      builder: (context) => ResourceDialog(resource: resource),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flash Cards')),
        body: const Center(child: Text('No words available in this package')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.package.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_isLooping ? Icons.loop : Icons.loop_outlined),
            onPressed: () {
              setState(() {
                _isLooping = !_isLooping;
              });
              HapticFeedback.lightImpact();
            },
            tooltip: _isLooping ? 'Disable Loop' : 'Enable Loop',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            FlashCardProgressIndicator(
              currentIndex: _currentIndex,
              totalWords: words.length,
            ),

            Expanded(
              child: Center(
                child: FlashCard(
                  currentWord: currentWord,
                  flipAnimation: _flipAnimation,
                  isFlipped: _isFlipped,
                  onFlip: _flipCard,
                  onResourceTap: _showResourceDialog,
                ),
              ),
            ),

            FlashCardNavigationControls(
              currentIndex: _currentIndex,
              totalWords: words.length,
              isLooping: _isLooping,
              isFlipped: _isFlipped,
              onPrevious: _previousCard,
              onNext: _nextCard,
              onFlip: _flipCard,
            ),
          ],
        ),
      ),
    );
  }
}
