import 'questions/question_topic.dart';

class TagsAndTopicsResults {
  final Map<String, (double, int)> _tagsResults = {};
  final Map<QuestionTopic, (double, int)> _topicsResults = {};

  Map<String, (double, int)> get tagsResults => _tagsResults;
  Map<QuestionTopic, (double, int)> get topicsResults => _topicsResults;

  void addTagResult(String tag, double result) {
    if (_tagsResults.containsKey(tag) == false) {
      _tagsResults[tag] = (result, 1);
    } else {
      final newAverage =
          ((_tagsResults[tag]!.$1 * _tagsResults[tag]!.$2) + result) /
              (_tagsResults[tag]!.$2 + 1);
      final newMultipilier = _tagsResults[tag]!.$2 + 1;

      _tagsResults[tag] = (newAverage, newMultipilier);
    }
  }

  void addTopicResult(QuestionTopic topic, double result) {
    if (_topicsResults.containsKey(topic) == false) {
      _topicsResults[topic] = (result, 1);
    } else {
      final newAverage =
          ((_topicsResults[topic]!.$1 * _topicsResults[topic]!.$2) + result) /
              (_topicsResults[topic]!.$2 + 1);
      final newMultipilier = _topicsResults[topic]!.$2 + 1;
      _topicsResults[topic] = (newAverage, newMultipilier);
    }
  }

  TagsAndTopicsResults operator +(TagsAndTopicsResults other) {
    final result = TagsAndTopicsResults();

    // Combine tag results
    final allTags = {..._tagsResults.keys, ...other._tagsResults.keys};
    for (var tag in allTags) {
      final val1 = _tagsResults[tag]; // (avg1, count1)
      final val2 = other._tagsResults[tag]; // (avg2, count2)

      if (val1 != null && val2 != null) {
        final totalCount = val1.$2 + val2.$2;
        final weightedAverage =
            ((val1.$1 * val1.$2) + (val2.$1 * val2.$2)) / totalCount;
        result._tagsResults[tag] = (weightedAverage, totalCount);
      } else {
        result._tagsResults[tag] = val1 ?? val2!;
      }
    }

    // Combine topic results
    final allTopics = {..._topicsResults.keys, ...other._topicsResults.keys};
    for (var topic in allTopics) {
      final val1 = _topicsResults[topic];
      final val2 = other._topicsResults[topic];

      if (val1 != null && val2 != null) {
        final totalCount = val1.$2 + val2.$2;
        final weightedAverage =
            ((val1.$1 * val1.$2) + (val2.$1 * val2.$2)) / totalCount;
        result._topicsResults[topic] = (weightedAverage, totalCount);
      } else {
        result._topicsResults[topic] = val1 ?? val2!;
      }
    }

    return result;
  }
}
