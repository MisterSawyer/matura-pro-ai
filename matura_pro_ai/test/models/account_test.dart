import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/account.dart';
import 'package:matura_pro_ai/models/test/test.dart';
import 'package:matura_pro_ai/models/test/test_progress.dart';
import 'package:matura_pro_ai/models/test/test_result.dart';
import 'package:matura_pro_ai/models/test/test_type.dart';
import 'package:matura_pro_ai/models/tags_and_topics_results.dart';

void main() {
  group('Account', () {
    test('copyWith updates values', () {
      final acc = Account(username: 'user', name: 'A');
      final updated = acc.copyWith(name: 'B');
      expect(updated.username, equals('user'));
      expect(updated.name, equals('B'));
    });

    test('save and finish test', () {
      final acc = Account(username: 'user');
      const test = Test(name: 't1', parts: []);
      final progress = TestProgress(
          test: test,
          partID: 0,
          results: TestResult('t1'),
          tagsAndTopicsResults: TagsAndTopicsResults());
      acc.saveTestState(TestType.placement, progress);
      expect(acc.currentTests[TestType.placement], equals(progress));
      acc.finishCurrentTest(TestType.placement);
      expect(acc.currentTests.containsKey(TestType.placement), isFalse);
    });
  });
}
