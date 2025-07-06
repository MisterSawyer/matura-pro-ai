class MultipleChoiceQuestion {
  final String question;
  final List<String> options;
  final List<int> correctIndexes;

  MultipleChoiceQuestion({
    required this.question,
    required this.options,
    required this.correctIndexes,
  });

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'multiple_choice') {
      throw Exception('Invalid question type: ${json['type']}');
    }
    return MultipleChoiceQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctIndexes: List<int>.from(json['correctIndexes']),
    );
  }
}
