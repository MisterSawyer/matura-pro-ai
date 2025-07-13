import '../topics.dart';

import '../tags.dart';

class Flashcard {
  final Tags tags;
  final Topics topics;
  final String front;
  final String back;

  bool isKnown;

  Flashcard({
    required this.tags,
    required this.topics,
    required this.front,
    required this.back,
    this.isKnown = false,
  });
  
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      tags: Tags.fromJson(json['tags']),
      topics: Topics.fromJson(json['topics']),
      front: json['front'],
      back: json['back'],
    );
  }

  Map<String, dynamic> toJson() => {
    'tags': tags.toJson(),
    'topics': topics.toJson(),
    'front': front,
    'back': back,
    'isKnown': isKnown,
  };

}
