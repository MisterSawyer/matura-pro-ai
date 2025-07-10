import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/flashcard_controller.dart';
import '../../core/theme_defaults.dart';

class FlashcardView extends StatefulWidget {
  final FlashcardController controller;
  final Future<void> Function() onFinished;

  const FlashcardView({
    super.key,
    required this.controller,
    required this.onFinished,
  });

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TextEditingController _answerController;
  late Animation<double> _flipAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    widget.controller.resetDeck();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation =
        Tween<double>(begin: 0, end: pi).animate(_animationController);

    _answerController = TextEditingController();
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
    } else {
      controller.markUnknown();
    }
    _answerController.clear();
    
    if (controller.isLastCard) {
      await widget.onFinished();
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
                labelText: 'write answer',
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
    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: Consumer<FlashcardController>(
        builder: (context, controller, _) {
          final theme = Theme.of(context);

          return Column(
            children: [
              Center(
                child: Text(
                  controller.deck.name,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
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
