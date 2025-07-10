import 'tags.dart';

class Flashcard {
  final Tags tags;
  final String front;
  final String back;
  bool isKnown;

  Flashcard({
    required this.tags,
    required this.front,
    required this.back,
    this.isKnown = false,
  });
  
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      tags: Tags.fromJson(json['tags']),
      front: json['front'],
      back: json['back'],
    );
  }

  Map<String, dynamic> toJson() => {
    'tags': tags.toJson(),
    'front': front,
    'back': back,
    'isKnown': isKnown,
  };

}
