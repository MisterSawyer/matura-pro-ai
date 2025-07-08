import 'user_stats.dart';

class Account {
  final String username;

  String _name;
  final UserStats _stats = UserStats(placementTestTaken: false, placementTestResult: 0.0);

  Account({
    required this.username,
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

}
