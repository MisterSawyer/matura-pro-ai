class TextInputQuestion {
  final String question;
  final List<String> acceptedAnswers;

  TextInputQuestion({required this.question, required this.acceptedAnswers});

  factory TextInputQuestion.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'text_input') {
      throw Exception('Invalid question type: ${json['type']}');
    }
    return TextInputQuestion(
        question: json['question'] as String,
        acceptedAnswers: List<String>.from(json['acceptedAnswers']));
  }
}
