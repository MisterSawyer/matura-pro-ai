import 'package:flutter/foundation.dart';

import 'user_stats.dart';
import 'test/test_type.dart';
import 'test/test_progress.dart';

@immutable
class Account {
  final String username;

  final String? name;
  final String? sex;

  final Map<TestType, TestProgress> _currentTests = {};
  final UserStats _stats = UserStats();

  Map<TestType, TestProgress> get currentTests => _currentTests;

  Account({
    required this.username,
    this.sex,
    this.name,
  });

  UserStats get stats => _stats;

  @override
  String toString() {
    final statsStr = _stats.toString();
    return 'Account(username: $username, name: $name, stats: $statsStr)';
  }

  Account copyWith({
    String? username,
    String? name,
    String? sex,
    Map<TestType, TestProgress>? currentTests,
    UserStats? stats,
  }) {
    final newAccount = Account(
      username: username ?? this.username,
      name: name ?? this.name,
      sex: sex ?? this.sex,
    );

    newAccount._currentTests.addAll(currentTests ?? _currentTests);
    newAccount._stats
        .merge(stats ?? _stats);

    return newAccount;
  }

  void saveTestState(TestType type, TestProgress testProgress) {
    _currentTests[type] = testProgress;
  }

  void finishCurrentTest(TestType type) {
    _currentTests.remove(type);
  }
}
