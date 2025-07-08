import 'question.dart';
import 'question_type.dart';

class CategoryQuestion extends Question {
  final String question;
  final List<String> items;
  final List<String> categories;
  final Map<int, int> correctMatches; // itemIndex -> categoryIndex

  CategoryQuestion({
    required super.type,
    required this.question,
    required this.items,
    required this.categories,
    required this.correctMatches,
  });

  factory CategoryQuestion.fromJson(Map<String, dynamic> json) {
    final rawMatches = (json['correctMatches'] as Map).map(
      (k, v) => MapEntry(int.parse(k), v as int),
    );

    return CategoryQuestion(
      type: QuestionType.fromString(json['type'] as String),
      question: json['question'],
      items: List<String>.from(json['items']),
      categories: List<String>.from(json['categories']),
      correctMatches: rawMatches,
    );
  }
}