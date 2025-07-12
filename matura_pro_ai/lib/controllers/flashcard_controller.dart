import 'package:flutter/foundation.dart';

import '../models/flashcard.dart';
import '../models/flashcard_deck.dart';
import '../models/questions/question_topic.dart';

class FlashcardController extends ChangeNotifier {
  final FlashcardDeck deck;
  FlashcardDeck _workingDeck;

  int _currentIndex = 0;
  bool _isFrontVisible = true;

  FlashcardController(this.deck) : _workingDeck = deck;

  Flashcard get currentCard => _workingDeck.cards[_currentIndex];
  bool get isFrontVisible => _isFrontVisible;
  int get currentIndex => _currentIndex;
  int get totalCards => _workingDeck.cards.length;
  bool get isLastCard => _currentIndex == _workingDeck.cards.length - 1;
  double get knownProgress =>
      _workingDeck.cards.where((c) => c.isKnown).length / _workingDeck.cards.length;
  double get fullProgress => _currentIndex / _workingDeck.cards.length;
  int get correctAnswers => _workingDeck.cards.where((c) => c.isKnown).length;

  void flipCard() {
    _isFrontVisible = !_isFrontVisible;
    notifyListeners(); // reactive update
  }

  void markKnown() {
    currentCard.isKnown = true;
    notifyListeners(); // updates progress
  }

  bool check(String value) {
    return currentCard.back.trim().toLowerCase() == value.trim().toLowerCase();
  }

  void markUnknown() {
    currentCard.isKnown = false;
    notifyListeners(); // updates progress
  }

  void nextCard() {
    _isFrontVisible = true;
    if (_currentIndex < deck.cards.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    notifyListeners(); // notifies card change
  }

  void resetDeck({QuestionTopic? topic}) {
    _currentIndex = 0;
    _isFrontVisible = true;
    for (var card in deck.cards) {
      card.isKnown = false;
    }

    if (topic != null) {
      _workingDeck = FlashcardDeck(
        name: deck.name,
        cards:
            deck.cards.where((c) => c.topics.contains(topic)).toList(),
      );
    } else {
      _workingDeck = deck;
    }

    notifyListeners(); // resets everything
  }
}
