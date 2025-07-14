class TestResult
{
  final String name;
  List<String> partNames = [];
  List<double> partResults = [];
  final Map<String, double> skillBreakdown = {};

  TestResult(this.name);

  static const Map<String, double> _defaultWeights = {
    'reading': 0.33,
    'grammar': 0.34,
    'listening': 0.33,
  };

  double weightedScore({Map<String, double>? weights}) {
    final w = weights ?? _defaultWeights;
    if (skillBreakdown.isEmpty) {
      return partResults.isEmpty
          ? 0
          : partResults.reduce((a, b) => a + b) / partResults.length;
    }
    double score = 0;
    for (final entry in skillBreakdown.entries) {
      final weight = w[entry.key] ?? 0;
      score += entry.value * weight;
    }
    return score;
  }

  double get average => weightedScore();
}
