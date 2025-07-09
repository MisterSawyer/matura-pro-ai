import 'flashcard.dart';

class FlashcardDeck {
  final String name;
  final List<Flashcard> cards;

  FlashcardDeck({
    required this.name,
    required this.cards,
  });

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) {
    final cardsJson = json['cards'] as List;
    final cards = cardsJson.map((e) => Flashcard.fromJson(e)).toList();
    return FlashcardDeck(name: json['name'], cards: cards);
  }

}
