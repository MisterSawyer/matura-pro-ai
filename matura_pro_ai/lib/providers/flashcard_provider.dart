import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/flashcard/flashcard_controller.dart';
import '../controllers/flashcard/flashcard_state.dart';
import '../models/flashcard/flashcard_deck.dart';

/// Provides a [FlashcardController] managing a specific [FlashcardDeck].
/// Automatically disposed when unused.
///
/// Usage:
/// ```dart
/// final state = ref.watch(flashcardControllerProvider(deck));
/// final controller = ref.read(flashcardControllerProvider(deck).notifier);
/// ```
final flashcardControllerProvider = StateNotifierProvider.autoDispose
    .family<FlashcardController, FlashcardState, FlashcardDeck>((ref, deck) {
  return FlashcardController(deck);
});
