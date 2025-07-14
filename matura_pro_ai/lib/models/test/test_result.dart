class TestResult
{
  final String name;
  List<String> partNames = [];
  List<double> partResults = [];
  List<List<bool>> questionResults = [];

  TestResult(this.name);

  double get average => partResults.isEmpty
      ? 0
      : partResults.reduce((a, b) => a + b) / partResults.length;
}
