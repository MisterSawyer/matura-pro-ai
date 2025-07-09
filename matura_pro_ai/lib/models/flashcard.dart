class Flashcard {
  final String front;
  final String back;
  bool isKnown;

  Flashcard({
    required this.front,
    required this.back,
    this.isKnown = false,
  });
  
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      front: json['front'],
      back: json['back'],
    );
  }

  Map<String, dynamic> toJson() => {
    'front': front,
    'back': back,
    'isKnown': isKnown,
  };

}
