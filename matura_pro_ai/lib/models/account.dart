import 'user_stats.dart';

class Account {
  final String username;

  String _name;
  String sex;
  final UserStats _stats = UserStats();

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

}
