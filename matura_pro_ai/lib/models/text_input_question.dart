class TextInputQuestion {
  final String question;
  final List<String> acceptedAnswers;

  TextInputQuestion({required this.question, required this.acceptedAnswers});

  factory TextInputQuestion.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'text_input') {
      throw Exception('Invalid question type: ${json['type']}');
    }
    final rawAnswers = List<String>.from(json['acceptedAnswers']);
    final normalizedAnswers =
        rawAnswers.map((a) => a.trim().toLowerCase()).toList();

    return TextInputQuestion(
      question: json['question'] as String,
      acceptedAnswers: normalizedAnswers,
    );
  }
}
