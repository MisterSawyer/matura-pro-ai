import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/user_stats.dart';
import 'package:matura_pro_ai/models/test/test_result.dart';
import 'package:matura_pro_ai/models/test/test_type.dart';

void main() {
  group('UserStats', () {
    test('markPlacementTestTaken', () {
      final stats = UserStats();
      stats.markPlacementTestTaken();
      expect(stats.placementTestTaken, isTrue);
    });

    test('addTestResult stores results', () {
      final stats = UserStats();
      stats.addTestResult(TestType.placement, TestResult('t'));
      expect(stats.testResults[TestType.placement]!.length, 1);
    });

    test('merge combines data', () {
      final a = UserStats();
      final b = UserStats();
      b.markPlacementTestTaken();
      b.addTestResult(TestType.placement, TestResult('x'));
      a.merge(b);
      expect(a.placementTestTaken, isTrue);
      expect(a.testResults[TestType.placement]!.length, 1);
    });
  });
}
