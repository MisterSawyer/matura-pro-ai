import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/question_type.dart';

void main() {
  group('QuestionType.fromString', () {
    test('parses enum values correctly', () {
      expect(QuestionType.fromString('multiple_choice'),
          QuestionType.multipleChoice);
      expect(QuestionType.fromString('listening'), QuestionType.listening);
    });
  });

  group('QuestionType.stringDesc', () {
    test('returns human readable descriptions', () {
      expect(QuestionType.stringDesc(QuestionType.multipleChoice),
          'Multiple choice');
      expect(QuestionType.stringDesc(QuestionType.listening), 'Listening');
    });
  });
}
