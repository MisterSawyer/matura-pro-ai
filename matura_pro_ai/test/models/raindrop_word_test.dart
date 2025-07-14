import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/raindrop_word.dart';

void main() {
  test('RaindropWord.fromJson parses fields', () {
    final w = RaindropWord.fromJson({
      'word': 'a',
      'definition': 'd',
      'example': 'e',
      'date': '2024-01-01'
    });
    expect(w.word, 'a');
    expect(w.definition, 'd');
  });
}
