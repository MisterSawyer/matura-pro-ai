import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/flashcard/flashcard.dart';
import 'package:matura_pro_ai/models/flashcard/flashcard_deck.dart';

void main() {
  group('Flashcard', () {
    test('fromJson and toJson round trip', () {
      final card = Flashcard.fromJson({
        'tags': ['a'],
        'topics': ['human'],
        'front': 'f',
        'back': 'b'
      });
      expect(card.front, 'f');
      final json = card.toJson();
      expect(json['front'], 'f');
      expect(json['back'], 'b');
    });
  });

  group('FlashcardDeck', () {
    test('fromJson parses cards', () {
      final deck = FlashcardDeck.fromJson({
        'name': 'test',
        'cards': [
          {
            'tags': ['a'],
            'topics': ['home'],
            'front': 'A',
            'back': 'B'
          }
        ]
      });
      expect(deck.cards.length, 1);
      expect(deck.cards.first.front, 'A');
    });
  });
}
