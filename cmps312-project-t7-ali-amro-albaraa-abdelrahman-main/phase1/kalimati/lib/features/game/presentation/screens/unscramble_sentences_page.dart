import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/learning_package.dart';
import 'package:class_manager/features/view_learning_packages/domain/entities/sentence.dart';
import 'package:class_manager/features/game/presentation/widgets/word_chip.dart';

class UnscrambleSentencesPage extends StatefulWidget {
  final LearningPackage package;

  const UnscrambleSentencesPage({super.key, required this.package});

  @override
  State<UnscrambleSentencesPage> createState() =>
      _UnscrambleSentencesPageState();
}

class _UnscrambleSentencesPageState extends State<UnscrambleSentencesPage> {
  int _currentIndex = 0;
  bool _isLooping = false;
  List<String> _scrambledWords = [];
  List<String> _selectedWords = [];
  List<String> _correctWords = [];
  bool _isCorrect = false;
  bool _hasAttempted = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentSentence();
  }

  List<Sentence> get allSentences {
    final sentences = <Sentence>[];
    for (final word in widget.package.words) {
      sentences.addAll(word.sentences);
    }
    return sentences;
  }

  Sentence get currentSentence => allSentences[_currentIndex];

  void _loadCurrentSentence() {
    if (allSentences.isEmpty) return;

    final sentence = currentSentence;
    _correctWords = sentence.text.trim().split(RegExp(r'\s+'));
    _scrambledWords = List<String>.from(_correctWords)..shuffle(Random());
    _selectedWords = [];
    _isCorrect = false;
    _hasAttempted = false;
  }

  void _selectWord(String word) {
    if (_hasAttempted && _isCorrect) return;

    setState(() {
      _scrambledWords.remove(word);
      _selectedWords.add(word);
    });
    HapticFeedback.selectionClick();
  }

  void _unselectWord(String word) {
    if (_hasAttempted && _isCorrect) return;
    setState(() {
      _selectedWords.remove(word);
      _scrambledWords.add(word);
    });
    HapticFeedback.selectionClick();
  }

  void _checkAnswer() {
    if (_selectedWords.length != _correctWords.length) {
      setState(() {
        _hasAttempted = true;
        _isCorrect = false;
      });
      HapticFeedback.heavyImpact();
      _showFeedback(false);
      return;
    }

    final isCorrect = _listsEqual(_selectedWords, _correctWords);
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

  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
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

  void _resetCurrentSentence() {
    setState(() {
      _loadCurrentSentence();
    });
  }

  void _nextSentence() {
    if (_currentIndex < allSentences.length - 1) {
      setState(() {
        _currentIndex++;
        _loadCurrentSentence();
      });
    } else if (_isLooping) {
      setState(() {
        _currentIndex = 0;
        _loadCurrentSentence();
      });
    }
  }

  void _previousSentence() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _loadCurrentSentence();
      });
    } else if (_isLooping) {
      setState(() {
        _currentIndex = allSentences.length - 1;
        _loadCurrentSentence();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allSentences.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Unscramble Sentences')),
        body: const Center(
          child: Text('No sentences available in this package'),
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
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / allSentences.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF7B68EE),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_currentIndex + 1} / ${allSentences.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF7B68EE),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reorder the words to form a meaningful sentence',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedWords.isNotEmpty || _hasAttempted) ...[
                      Text(
                        'Your Answer:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedWords.asMap().entries.map((entry) {
                          final index = entry.key;
                          final word = entry.value;
                          final isCorrectPosition =
                              _hasAttempted &&
                              index < _correctWords.length &&
                              word == _correctWords[index];

                          return WordChip(
                            word: word,
                            isSelected: true,
                            isCorrect: _hasAttempted && _isCorrect,
                            isCorrectPosition: isCorrectPosition,
                            onTap: () => _unselectWord(word),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    Text(
                      'Available Words:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_scrambledWords.isEmpty && !_hasAttempted)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'All words selected!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _scrambledWords.map((word) {
                          return WordChip(
                            word: word,
                            isSelected: false,
                            onTap: () => _selectWord(word),
                          );
                        }).toList(),
                      ),

                    // Show correct answer if wrong
                    if (_hasAttempted && !_isCorrect) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.red[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Correct Answer:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _correctWords.join(' '),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _hasAttempted && _isCorrect
                          ? _resetCurrentSentence
                          : _checkAnswer,
                      icon: Icon(
                        _hasAttempted && _isCorrect
                            ? Icons.refresh
                            : Icons.check,
                      ),
                      label: Text(
                        _hasAttempted && _isCorrect
                            ? 'Try Again'
                            : 'Check Answer',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B68EE),
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
                        onPressed: _currentIndex > 0 || _isLooping
                            ? _previousSentence
                            : null,
                        iconSize: 32,
                        color: const Color(0xFF7B68EE),
                      ),
                      Text(
                        'Sentence ${_currentIndex + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed:
                            _currentIndex < allSentences.length - 1 ||
                                _isLooping
                            ? _nextSentence
                            : null,
                        iconSize: 32,
                        color: const Color(0xFF7B68EE),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
