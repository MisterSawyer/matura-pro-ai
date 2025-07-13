import 'dart:convert';
import 'package:flutter/services.dart';

import '../../core/constants.dart';
import '../models/flashcard/flashcard_deck.dart';

Future<FlashcardDeck> loadFlashcardDeck(String filename) async {
  final jsonString = await rootBundle.loadString('${AppAssets.flashcardsPath}/$filename');
  final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  return FlashcardDeck.fromJson(jsonMap);
}
