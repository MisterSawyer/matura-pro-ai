class RaindropWord {
  final String word;
  final String definition;
  final String example;
  final String date;

  RaindropWord({required this.word, required this.definition, required this.example, required this.date});

  factory RaindropWord.fromJson(Map<String, dynamic> json) {
    return RaindropWord(
      word: json['word'],
      definition: json['definition'],
      example: json['example'],
      date: json['date'],
    );
  }
}
