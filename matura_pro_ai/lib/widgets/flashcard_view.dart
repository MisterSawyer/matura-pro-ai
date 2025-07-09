import 'package:flutter/material.dart';
import 'dart:math';

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_animationController.isAnimating) return;

    setState(() {
      _isFront = !_isFront;
    });

    if (_isFront) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    widget.controller.flipCard();
  }

  Future<void> _handleAnswer(bool known) async {
    if (!_isFront) {
      await _animationController.reverse(); // Flip back before switching
      setState(() {
        _isFront = true;
      });
    }

    if (known) {
      widget.controller.markKnown();
    } else {
      widget.controller.markUnknown();
    }

    if (widget.controller.isLastCard) {
      await widget.onFinished();
      return;
    }

    setState(() {
      widget.controller.nextCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.controller;
    final card = controller.currentCard;

    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(ThemeDefaults.padding),
        child: Column(
          children: [
            Center(child : Text(widget.controller.deck.name, style : theme.textTheme.titleLarge)),
            // Progress Bar
            Stack(
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
            ),
            const SizedBox(height: 32),

            // Card
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
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
                  key: ValueKey(controller.currentIndex),
                  onTap: _flipCard,
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
                          color: isFrontVisible
                              ? theme.primaryColor
                              : theme.cardColor,
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
                                  isFrontVisible
                                      ? card.front
                                      : card.back,
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
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(ThemeDefaults.padding),
                    ),
                    child: const Icon(Icons.clear),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleAnswer(true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(ThemeDefaults.padding),
                    ),
                    child: const Icon(Icons.check),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
