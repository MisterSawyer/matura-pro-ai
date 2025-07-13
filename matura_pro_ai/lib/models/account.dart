import 'package:matura_pro_ai/models/test/test_type.dart';

import 'user_stats.dart';
import '../controllers/test/test_controller.dart';

class Account {
  final String username;

  String _name;
  String sex;

  final Map<TestType, TestController> _currentTests = {};
  final UserStats _stats = UserStats();

  Map<TestType, TestController> get currentTests => _currentTests;

  Account({
    required this.username,
    this.sex = 'male',
  }) : _name = username;  

  String get name => _name;
  UserStats get stats => _stats;

  void setName(String name)
  {
    _name = name;
  }

  @override
  String toString() {
    final statsStr = _stats.toString();
    return 'Account(username: $username, name: $_name, stats: $statsStr)';
  }

  void saveTestState(TestType type, TestController testController)
  {
    _currentTests[type] = testController;
  }

  void finishCurrentTest(TestType type)
  {
    _currentTests.remove(type);
  }

}
