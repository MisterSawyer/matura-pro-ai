class PlacementQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  PlacementQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory PlacementQuestion.fromJson(Map<String, dynamic> json) {
    return PlacementQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'] as int,
    );
  }
}