import 'test_part_controller.dart';
import '../../models/test/test.dart';
import '../../models/test/test_result.dart';
import '../../models/test/test_progress.dart';
import '../../models/tags_and_topics_results.dart';

class TestController
{
  int _currentPartID = 0;
  Test test;
  final List<TestPartController> _partControllers = [];

  TestController(this.test) 
  {
    for (final part in test.parts) {
      _partControllers.add(TestPartController(part : part));
    }
  }

  TestController.progress(TestProgress testProgress)
  : test = testProgress.test, _currentPartID = 0
  {
    for (int i = testProgress.partID; i < test.parts.length; i++){
      _partControllers.add(TestPartController(part : test.parts[i]));
    }
  }

  bool get isLastPart => _currentPartID >= _partControllers.length - 1;
  TestPartController get currentPart => _partControllers[_currentPartID];
  int get currentPartID => _currentPartID;
  List<TestPartController> get parts => _partControllers;

  void clear()
  {
    _currentPartID = 0;
    for (final part in _partControllers) {
      part.clear();
    }
  }

  void nextPart()
  {
    if(isLastPart) return;
    _currentPartID++;
  }

  (TestResult, TagsAndTopicsResults) calculateResults({TestResult? fromResults, TagsAndTopicsResults? fromTagsAndTopicsResults})
  {
    TestResult results = fromResults ?? TestResult(test.name);
    TagsAndTopicsResults tagsAndTopicsResults = fromTagsAndTopicsResults ?? TagsAndTopicsResults();

    for (int i = 0; i <= currentPartID; i++) {
      results.partNames.add(parts[i].name);
      final partScore = parts[i].evaluate();
      results.partResults.add(partScore);

      final qResults =
          parts[i].questions.map((q) => q.evaluate() == 1).toList();
      results.questionResults.add(qResults);

      for (final question in parts[i].questions) {
        double score = question.evaluate();
        for (var tag in question.tags) {
          tagsAndTopicsResults.addTagResult(tag, score);
        }
        for (var topic in question.topics) {
          tagsAndTopicsResults.addTopicResult(topic, score);
        }
      }
    }

    return (results, tagsAndTopicsResults);
  }
}
