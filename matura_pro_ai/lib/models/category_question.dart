class CategoryQuestion 
{
  final String question;
  final List<String> items;
  final List<String> categories; 
  final Map<String, String> correctMatches;

  CategoryQuestion({
    required this.question,
    required this.items,
    required this.categories,
    required this.correctMatches,
  });

  factory CategoryQuestion.fromJson(Map<String, dynamic> json) {
    return CategoryQuestion(
      question: json['question'],
      items: List<String>.from(json['items']),
      categories: List<String>.from(json['categories']),
      correctMatches: Map<String, String>.from(json['correctMatches']),
    );
  }
}