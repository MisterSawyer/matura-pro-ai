import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/flashcard/flashcard.dart';
import 'package:matura_pro_ai/models/flashcard/flashcard_deck.dart';
import 'package:matura_pro_ai/controllers/flashcard/flashcard_controller.dart';
import 'package:matura_pro_ai/models/tags.dart' as model_tags;
import 'package:matura_pro_ai/models/topics.dart';

void main() {
  test('flip and nextCard', () {
    final deck = FlashcardDeck(name: 'd', cards: [
      Flashcard(tags: model_tags.Tags([]), topics: Topics([]), front: 'a', back: 'b')
    ]);
    final c = FlashcardController(deck);
    expect(c.state.isFrontVisible, isTrue);
    c.flipCard();
    expect(c.state.isFrontVisible, isFalse);
    c.nextCard();
    expect(c.state.currentIndex, 0);
  });
}
