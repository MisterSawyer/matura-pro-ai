import 'package:flutter/foundation.dart';

import 'test.dart';
import 'test_result.dart';
import '../tags_and_topics_results.dart';

@immutable
class TestProgress {
  final Test test;
  final int partID;
  final TestResult results;
  final TagsAndTopicsResults tagsAndTopicsResults;

  const TestProgress({
    required this.test,
    required this.partID,
    required this.results,
    required this.tagsAndTopicsResults,
  });
}
