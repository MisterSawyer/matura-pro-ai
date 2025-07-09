import 'test_result.dart';

class UserStats 
{
  bool placementTestTaken = false;
  TestResult placementTestResult = TestResult();

  UserStats();

  @override
  String toString() {
    return 'UserStats( placementTestTaken: $placementTestTaken, placementTestResult: $placementTestResult)';
  }

  void setTestResult(TestResult results)
  {
    placementTestTaken = true;
    placementTestResult = results;
  }
}
