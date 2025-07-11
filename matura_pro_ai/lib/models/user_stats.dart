import 'test_result.dart';

class UserStats 
{
  bool placementTestTaken = false;
  List<TestResult> placementTestResult = [];

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
