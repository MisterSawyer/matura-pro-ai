import 'test_part_controller.dart';

class TestController 
{
  int _currentPartID = 0;
  final List<TestPartController> _partControllers = [];

  Future<void> load(dynamic jsonObj) async {
    _currentPartID = 0;
    for (final part in jsonObj) {
      final partController = TestPartController();
      await partController.load(part);
      _partControllers.add(partController);
    }
  }

  bool get isLastPart => _currentPartID >= _partControllers.length - 1;
  TestPartController get currentPart => _partControllers[_currentPartID];

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
}
