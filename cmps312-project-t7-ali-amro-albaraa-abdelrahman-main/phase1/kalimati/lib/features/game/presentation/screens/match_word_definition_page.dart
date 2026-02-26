import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/word.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/definition.dart';
import '../widgets/match_game_progress_indicator.dart';
import '../widgets/match_game_instructions.dart';
import '../widgets/word_display_card.dart';
import '../widgets/definitions_list.dart';
import '../widgets/match_game_action_buttons.dart';

class MatchWordDefinitionPage extends StatefulWidget {
  final LearningPackage package;

  const MatchWordDefinitionPage({super.key, required this.package});

  @override
  State<MatchWordDefinitionPage> createState() =>
      _MatchWordDefinitionPageState();
}

class _MatchWordDefinitionPageState extends State<MatchWordDefinitionPage> {
  int _currentIndex = 0;
  bool _isLooping = false;
  List<Word> _wordsWithDefinitions = [];
  List<Definition> _availableDefinitions = [];
  Definition? _selectedDefinition;
  Definition? _correctDefinition;
  bool _hasAttempted = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _initializeWords();
    _loadCurrentWord();
  }

  void _initializeWords() {
    _wordsWithDefinitions = widget.package.words
        .where((word) => word.definitions.isNotEmpty)
        .toList();
  }

  Word get currentWord => _wordsWithDefinitions[_currentIndex];

  void _loadCurrentWord() {
    if (_wordsWithDefinitions.isEmpty) return;

    final word = currentWord;
    _correctDefinition =
        word.definitions[Random().nextInt(word.definitions.length)];

    final allDefinitions = <Definition>[];
    for (final w in widget.package.words) {
      if (w.text != word.text) {
        allDefinitions.addAll(w.definitions);
      }
    }

    _availableDefinitions = [_correctDefinition!];
    if (allDefinitions.isNotEmpty) {
      final shuffledDistractors = List<Definition>.from(allDefinitions)
        ..shuffle(Random());
      final numDistractors = min(3, shuffledDistractors.length);
      _availableDefinitions.addAll(shuffledDistractors.take(numDistractors));
    }

    _availableDefinitions.shuffle(Random());
    _selectedDefinition = null;
    _hasAttempted = false;
    _isCorrect = false;
  }

  void _selectDefinition(Definition definition) {
    if (_hasAttempted && _isCorrect) return;
    setState(() {
      _selectedDefinition = definition;
    });
    HapticFeedback.selectionClick();
  }

  void _checkAnswer() {
    if (_selectedDefinition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a definition'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final isCorrect = _selectedDefinition == _correctDefinition;
    setState(() {
      _hasAttempted = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      HapticFeedback.mediumImpact();
      _showFeedback(true);
    } else {
      HapticFeedback.heavyImpact();
      _showFeedback(false);
    }
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isCorrect ? 'Correct! Well done!' : 'Incorrect. Try again!',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetCurrentWord() {
    setState(() {
      _loadCurrentWord();
    });
  }

  void _nextWord() {
    if (_currentIndex < _wordsWithDefinitions.length - 1) {
      setState(() {
        _currentIndex++;
        _loadCurrentWord();
      });
    } else if (_isLooping) {
      setState(() {
        _currentIndex = 0;
        _loadCurrentWord();
      });
    }
  }

  void _previousWord() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _loadCurrentWord();
      });
    } else if (_isLooping) {
      setState(() {
        _currentIndex = _wordsWithDefinitions.length - 1;
        _loadCurrentWord();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_wordsWithDefinitions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Match Word & Definition')),
        body: const Center(
          child: Text('No words with definitions available in this package'),
        ),
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
            MatchGameProgressIndicator(
              currentIndex: _currentIndex,
              totalWords: _wordsWithDefinitions.length,
            ),

            const MatchGameInstructions(),

            WordDisplayCard(word: currentWord),

            Expanded(
              child: DefinitionsList(
                availableDefinitions: _availableDefinitions,
                selectedDefinition: _selectedDefinition,
                correctDefinition: _correctDefinition,
                hasAttempted: _hasAttempted,
                isCorrect: _isCorrect,
                onDefinitionSelected: _selectDefinition,
              ),
            ),

            MatchGameActionButtons(
              currentIndex: _currentIndex,
              totalWords: _wordsWithDefinitions.length,
              isLooping: _isLooping,
              hasAttempted: _hasAttempted,
              isCorrect: _isCorrect,
              onCheckAnswer: _checkAnswer,
              onResetCurrentWord: _resetCurrentWord,
              onPreviousWord: _previousWord,
              onNextWord: _nextWord,
            ),
          ],
        ),
      ),
    );
  }
}
