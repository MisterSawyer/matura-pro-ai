import 'package:flutter/material.dart';
import 'dart:math';

import '../controllers/flashcard_controller.dart';

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

    if (_isFront) {
      _animationController.forward(from: 0);
    } else {
      _animationController.reverse(from: pi);
    }

    setState(() {
      _isFront = !_isFront;
    });

    widget.controller.flipCard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.controller;
    final card = controller.currentCard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Grey full-progress background
                LinearProgressIndicator(
                  value: controller.fullProgress, // e.g. answered/total
                  color: Colors.grey.shade300,
                  backgroundColor: Colors.transparent,
                  minHeight: 8,
                ),
                // Colored known-progress foreground
                LinearProgressIndicator(
                  value: controller.knownProgress, // e.g. known/total
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Colors.transparent,
                  minHeight: 8,
                ),
              ],
            ),
            const SizedBox(height: 64),
                        Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      controller.markUnknown();
                      _isFront = true;
                      _animationController.value = 0;
                    });

                    if (controller.isLastCard) {
                      return await widget.onFinished();
                    }

                    setState(() {
                      controller.nextCard();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.clear),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      controller.markKnown();
                      _isFront = true;
                      _animationController.value = 0;
                    });

                    if (controller.isLastCard) {
                      return await widget.onFinished();
                    }

                    setState(() {
                      controller.nextCard();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.check),
                ),
              ],
            ),
            const SizedBox(height: 64),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
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
                                isFrontVisible ? card.front : card.back,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
