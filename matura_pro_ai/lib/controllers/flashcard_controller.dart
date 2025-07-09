import '../models/flashcard.dart';
import '../models/flashcard_deck.dart';

class FlashcardController {
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
  }

  void markKnown() {
    currentCard.isKnown = true;
  }

  void markUnknown() {
    currentCard.isKnown = false;
  }

  void nextCard() {
    _isFrontVisible = true;
    if (_currentIndex < deck.cards.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
  }

  void resetDeck() {
    _currentIndex = 0;
    _isFrontVisible = true;
    for (var card in deck.cards) {
      card.isKnown = false;
    }
  }


}
