import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/tags.dart' as model_tags;

void main() {
  group('Tags', () {
    test('fromJson accepts list', () {
      final tags = model_tags.Tags.fromJson(['a', 'b']);
      expect(tags.toJson(), ['a', 'b']);
    });

    test('iteration works', () {
      final tags = model_tags.Tags(['x', 'y']);
      expect(tags.first, 'x');
    });
  });
}
