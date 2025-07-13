
import 'package:flutter/foundation.dart';
import 'test_part.dart';

@immutable
class Test {
  final String name;
  final List<TestPart> parts;

  const Test({
    required this.name,
    required this.parts,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    final partsJson = json['parts'] as List;
    final parts = partsJson.map((e) => TestPart.fromJson(e)).toList();
    return Test(name: json['name'], parts: parts);
  }

}
