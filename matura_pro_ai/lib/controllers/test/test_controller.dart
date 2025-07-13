import 'test_part_controller.dart';
import '../../models/test/test.dart';

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

  bool get isLastPart => _currentPartID >= _partControllers.length - 1;
  TestPartController get currentPart => _partControllers[_currentPartID];
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
}
