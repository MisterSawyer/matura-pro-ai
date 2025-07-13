import 'test_result.dart';
import 'tags_and_topics_results.dart';

import 'test_type.dart';

class UserStats 
{
  bool placementTestTaken = false;

  Map<TestType, List<TestResult>> testResults = {};
  TagsAndTopicsResults tagsAndTopicsResults = TagsAndTopicsResults();

  UserStats();

  @override
  String toString() {
    return 'UserStats( placementTestTaken: $placementTestTaken, testResults: $testResults)';
  }


  void markPlacementTestTaken() {
    placementTestTaken = true;
  }

  void addTestResult(TestType type, TestResult results)
  {
    if(testResults.containsKey(type) == false) testResults[type] = [];
    testResults[type]!.add(results);
  }
}
