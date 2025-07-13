import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/flashcard/flashcard_controller.dart';
import '../../controllers/flashcard/flashcard_state.dart';
import '../../models/flashcard/flashcard_deck.dart';
import '../../models/tags_and_topics_results.dart';
import '../../providers/flashcard_provider.dart';
import '../../core/theme_defaults.dart';

class FlashcardView extends ConsumerStatefulWidget {
  final FlashcardDeck deck;
  final Future<void> Function(TagsAndTopicsResults) onFinished;

  const FlashcardView({
    super.key,
    required this.deck,
    required this.onFinished,
  });

  @override
  ConsumerState<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends ConsumerState<FlashcardView>
    with SingleTickerProviderStateMixin {
  late final AutoDisposeStateNotifierProvider<FlashcardController, FlashcardState> _controllerProvider;

  late final AnimationController _animationController;
  late final Animation<double> _flipAnimation;

  final TextEditingController _answerController = TextEditingController();
  final TagsAndTopicsResults _results = TagsAndTopicsResults();
  bool _isFront = true;

  @override
  void initState() {
    super.initState();

    // Create provider instance specific to deck
    _controllerProvider = flashcardControllerProvider(widget.deck);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _flipCard(FlashcardController controller) {
    if (_animationController.isAnimating) return;

    setState(() => _isFront = !_isFront);

    _isFront ? _animationController.reverse() : _animationController.forward();
    controller.flipCard();
  }

  Future<void> _handleAnswer(
    FlashcardState state,
    FlashcardController controller,
  ) async {
    if (!_isFront) {
      await _animationController.reverse();
      setState(() => _isFront = true);
    }

    final isCorrect = controller.check(_answerController.text.trim());

    if (isCorrect) {
      controller.markKnown();
      for (final tag in state.currentCard.tags) {
        _results.addTagResult(tag, 1.0);
      }
      for (final topic in state.currentCard.topics) {
        _results.addTopicResult(topic, 1.0);
      }
    } else {
      controller.markUnknown();
      for (final tag in state.currentCard.tags) {
        _results.addTagResult(tag, 0.0);
      }
      for (final topic in state.currentCard.topics) {
        _results.addTopicResult(topic, 0.0);
      }
    }

    _answerController.clear();

    if (state.isLastCard) {
      await widget.onFinished(_results);
    } else {
      controller.nextCard();
    }
  }

  Widget _buildProgressBar(FlashcardState state, ThemeData theme) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        LinearProgressIndicator(
          value: state.fullProgress,
          color: Colors.grey.shade300,
          backgroundColor: Colors.transparent,
          minHeight: 8,
        ),
        LinearProgressIndicator(
          value: state.knownProgress,
          color: theme.colorScheme.primary,
          backgroundColor: Colors.transparent,
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildFlashcard(FlashcardState state, FlashcardController controller, ThemeData theme) {
    final card = state.currentCard;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 256),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: GestureDetector(
          key: ValueKey(state.currentIndex),
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

  Widget _buildActionButtons(FlashcardState state, FlashcardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextField(
            controller: _answerController,
            decoration: const InputDecoration(
              labelText: 'wpisz odpowiedź',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleAnswer(state, controller),
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
    final state = ref.watch(_controllerProvider);
    final controller = ref.read(_controllerProvider.notifier);

    if (state.totalCards == 0) {
      return const Center(
        child: Text('Brak kart', textAlign: TextAlign.center),
      );
    }

    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        _buildProgressBar(state, theme),
        const SizedBox(height: 32),
        _buildFlashcard(state, controller, theme),
        const SizedBox(height: 32),
        _buildActionButtons(state, controller),
      ],
    );
  }
}
