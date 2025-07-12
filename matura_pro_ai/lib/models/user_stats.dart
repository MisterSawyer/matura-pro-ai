import 'test_result.dart';
import 'tags_and_topics_results.dart';

class UserStats 
{
  bool placementTestTaken = false;
  List<TestResult> placementTestResult = [];
  TagsAndTopicsResults tagsAndTopicsResults = TagsAndTopicsResults();

  UserStats();

  @override
  String toString() {
    return 'UserStats( placementTestTaken: $placementTestTaken, placementTestResult: $placementTestResult)';
  }


  void markPlacementTestTaken() {
    placementTestTaken = true;
  }

  void addTestResult(TestResult results)
  {
    placementTestResult.add(results);
  }


}
