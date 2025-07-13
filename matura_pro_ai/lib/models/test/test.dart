import 'test_part.dart';

class Test {
  final String name;
  final List<TestPart> parts;

  Test({
    required this.name,
    required this.parts,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    final partsJson = json['parts'] as List;
    final parts = partsJson.map((e) => TestPart.fromJson(e)).toList();
    return Test(name: json['name'], parts: parts);
  }

}
