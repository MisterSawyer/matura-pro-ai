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

  void addTestResult(TestResult results)
  {
    placementTestTaken = true;
    placementTestResult.add(results);
  }
}
