import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/flashcard_controller.dart';
import '../../core/theme_defaults.dart';
import '../../models/questions/question_topic.dart';
import '../../models/tags_and_topics_results.dart';

class FlashcardView extends StatefulWidget {
  final FlashcardController controller;
  final Future<void> Function(TagsAndTopicsResults) onFinished;
  final QuestionTopic? topic;


  const FlashcardView({
    super.key,
    required this.controller,
    required this.onFinished,
    this.topic,
  });

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _answerController = TextEditingController();
  late Animation<double> _flipAnimation;
  bool _isFront = true;

  final TagsAndTopicsResults _results = TagsAndTopicsResults();

  @override
  void initState() {
    super.initState();
    widget.controller.resetDeck(topic: widget.topic);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation =
        Tween<double>(begin: 0, end: pi).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _flipCard(FlashcardController controller) {
    if (_animationController.isAnimating) return;

    setState(() {
      _isFront = !_isFront;
    });

    if (_isFront) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    controller.flipCard();
  }

  Future<void> _handleAnswer(FlashcardController controller) async {
    if (!_isFront) {
      await _animationController.reverse();
      setState(() {
        _isFront = true;
      });
    }

    if (controller.check(_answerController.text)) {
      controller.markKnown();
      for (var tag in controller.currentCard.tags){ _results.addTagResult(tag, 1.0); }
      for(var topic in controller.currentCard.topics){ _results.addTopicResult(topic, 1.0); }
    } else {
      controller.markUnknown();
      for (var tag in controller.currentCard.tags){ _results.addTagResult(tag, 0.0); }
      for(var topic in controller.currentCard.topics){ _results.addTopicResult(topic, 0.0); }
    }
    _answerController.clear();
    
    if (controller.isLastCard) {
      await widget.onFinished(_results);
    } else {
      controller.nextCard();
    }
  }

  Widget _buildProgressBar(FlashcardController controller, ThemeData theme) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        LinearProgressIndicator(
          value: controller.fullProgress,
          color: Colors.grey.shade300,
          backgroundColor: Colors.transparent,
          minHeight: 8,
        ),
        LinearProgressIndicator(
          value: controller.knownProgress,
          color: theme.colorScheme.primary,
          backgroundColor: Colors.transparent,
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildFlashcard(FlashcardController controller, ThemeData theme) {   
    final card = controller.currentCard;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 256),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        },
        child: GestureDetector(
          key: ValueKey(controller.currentIndex),
          onTap: () => _flipCard(controller),
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, _) {
              final angle = _flipAnimation.value;
              final isFrontVisible = angle <= pi / 2;

              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(angle);

              return Transform(
                alignment: Alignment.center,
                transform: transform,
                child: Card(
                  color: isFrontVisible ? theme.primaryColor : theme.cardColor,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(isFrontVisible ? 0 : pi),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          isFrontVisible ? card.front : card.back,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: isFrontVisible
                                ? Colors.white
                                : theme.textTheme.headlineMedium?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(FlashcardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'wpisz odpowiedź',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              )),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleAnswer(controller),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(ThemeDefaults.padding),
            ),
            child: const Icon(Icons.check),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.controller.totalCards == 0) 
    {
      return 
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400),
      child: Container(
        alignment: Alignment.center,
        child: const Text('Brak kart'),
      ),
      );
    }

    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: Consumer<FlashcardController>(
        builder: (context, controller, _) {
          final theme = Theme.of(context);

          return Column(
            children: [
              const SizedBox(height: 8),
              _buildProgressBar(controller, theme),
              const SizedBox(height: 32),
              _buildFlashcard(controller, theme),
              const SizedBox(height: 32),
              _buildActionButtons(controller),
            ],
          );
        },
      ),
    );
  }
}
