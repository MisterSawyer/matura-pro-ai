class UserStats 
{
  bool placementTestTaken;
  double placementTestResult;

  UserStats({
    this.placementTestTaken = false,
    this.placementTestResult = 0.0
  });

  @override
  String toString() {
    return 'UserStats( placementTestTaken: $placementTestTaken, placementTestResult: $placementTestResult)';
  }

  void setTestResult(double result)
  {
    placementTestTaken = true;
    placementTestResult = result;
  }
}
