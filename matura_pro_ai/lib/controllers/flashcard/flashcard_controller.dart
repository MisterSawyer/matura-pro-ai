import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/questions/question_topic.dart';
import '../../models/flashcard/flashcard_deck.dart';

import 'flashcard_state.dart';

class FlashcardController extends StateNotifier<FlashcardState> {
  FlashcardController(FlashcardDeck deck)
      : super(FlashcardState(
          deck: deck,
          workingDeck: deck,
          currentIndex: 0,
          isFrontVisible: true,
        ));

  void flipCard() {
    state = state.copyWith(isFrontVisible: !state.isFrontVisible);
  }

  void markKnown() {
    state.currentCard.isKnown = true;
    state = state.copyWith(); // trigger state update
  }

  bool check(String value) {
    return state.currentCard.back.trim().toLowerCase() ==
        value.trim().toLowerCase();
  }

  void markUnknown() {
    state.currentCard.isKnown = false;
    state = state.copyWith();
  }

  void nextCard() {
    final isLast = state.currentIndex >= state.workingDeck.cards.length - 1;
    final newIndex = isLast ? 0 : state.currentIndex + 1;
    state = state.copyWith(currentIndex: newIndex, isFrontVisible: true);
  }

  void resetDeck({QuestionTopic? topic}) {
    for (var card in state.deck.cards) {
      card.isKnown = false;
    }

    final filteredDeck = topic != null
        ? FlashcardDeck(
            name: state.deck.name,
            cards: state.deck.cards.where((c) => c.topics.contains(topic)).toList(),
          )
        : state.deck;

    state = state.copyWith(
      workingDeck: filteredDeck,
      currentIndex: 0,
      isFrontVisible: true,
    );
  }
}
