import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/test/test.dart';
import 'package:matura_pro_ai/models/test/test_part.dart';
import 'package:matura_pro_ai/models/test/test_result.dart';
import 'package:matura_pro_ai/models/tags_and_topics_results.dart';
import 'package:matura_pro_ai/controllers/test/test_controller.dart';

void main() {
  test('calculateResults aggregates parts', () {
    final part = TestPart.fromJson({
      'name': 'p',
      'questions': [
        {
          'type': 'multiple_choice',
          'tags': [],
          'topics': [],
          'question': 'Q',
          'options': ['a'],
          'correctIndexes': [0]
        }
      ]
    });
    final test = Test(name: 't', parts: [part]);
    final controller = TestController(test);
    final sub = controller.currentPart.currentQuestionController() as dynamic;
    sub.addAnswer(0);
    final (res, tags) = controller.calculateResults();
    expect(res.partResults.first, 1);
  });
}
