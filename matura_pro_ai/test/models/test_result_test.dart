import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/test/test_result.dart';

void main() {
  group('TestResult.average', () {
    test('returns 0 when there are no results', () {
      final result = TestResult('Placement');
      expect(result.average, 0);
    });

    test('calculates mean of part results', () {
      final result = TestResult('Placement')
        ..partResults = [80, 90, 70];
      expect(result.average, closeTo(80, 0.001));
    });
  });
}
