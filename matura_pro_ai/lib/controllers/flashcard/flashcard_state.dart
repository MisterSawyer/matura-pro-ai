import '../../models/flashcard/flashcard.dart';
import '../../models/flashcard/flashcard_deck.dart';

class FlashcardState {
  final FlashcardDeck deck;
  final FlashcardDeck workingDeck;
  final int currentIndex;
  final bool isFrontVisible;

  FlashcardState({
    required this.deck,
    required this.workingDeck,
    required this.currentIndex,
    required this.isFrontVisible,
  });

  Flashcard get currentCard => workingDeck.cards[currentIndex];
  bool get isLastCard => currentIndex == workingDeck.cards.length - 1;

  double get knownProgress =>
      workingDeck.cards.where((c) => c.isKnown).length / workingDeck.cards.length;
  double get fullProgress => currentIndex / workingDeck.cards.length;
  int get correctAnswers => workingDeck.cards.where((c) => c.isKnown).length;

  int get totalCards => workingDeck.cards.length;

  FlashcardState copyWith({
    FlashcardDeck? deck,
    FlashcardDeck? workingDeck,
    int? currentIndex,
    bool? isFrontVisible,
  }) {
    return FlashcardState(
      deck: deck ?? this.deck,
      workingDeck: workingDeck ?? this.workingDeck,
      currentIndex: currentIndex ?? this.currentIndex,
      isFrontVisible: isFrontVisible ?? this.isFrontVisible,
    );
  }
}
