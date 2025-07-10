import 'package:flutter/foundation.dart';

import '../models/flashcard.dart';
import '../models/flashcard_deck.dart';

class FlashcardController extends ChangeNotifier {
  final FlashcardDeck deck;
  int _currentIndex = 0;
  bool _isFrontVisible = true;

  FlashcardController(this.deck);

  Flashcard get currentCard => deck.cards[_currentIndex];
  bool get isFrontVisible => _isFrontVisible;
  int get currentIndex => _currentIndex;
  int get totalCards => deck.cards.length;
  bool get isLastCard => _currentIndex == deck.cards.length - 1;
  double get knownProgress => deck.cards.where((c) => c.isKnown).length / deck.cards.length;
  double get fullProgress => _currentIndex / deck.cards.length;
  int get correctAnswers => deck.cards.where((c) => c.isKnown).length;
  
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

  void resetDeck() {
    _currentIndex = 0;
    _isFrontVisible = true;
    for (var card in deck.cards) {
      card.isKnown = false;
    }
    notifyListeners(); // resets everything
  }
}

