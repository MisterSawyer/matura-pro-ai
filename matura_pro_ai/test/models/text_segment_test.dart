import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/text_segment.dart';

void main() {
  group('TextSegment', () {
    test('text factory creates text segment', () {
      final seg = TextSegment.text('abc');
      expect(seg.text, 'abc');
      expect(seg.isGap, isFalse);
    });

    test('gap factory creates gap segment', () {
      final seg = TextSegment.gap(1);
      expect(seg.gapIndex, 1);
      expect(seg.isGap, isTrue);
    });
  });
}
