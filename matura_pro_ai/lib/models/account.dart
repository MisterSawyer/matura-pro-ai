class Account {
  final String username;
  String name;
  double lastPlacementTestResult;

  Account({
    required this.username,
    required this.name,
    required this.lastPlacementTestResult,
  });

  // Optional: factory to create a default or anonymous account
  factory Account.empty(String username) {
    return Account(
      username: username,
      name: "User",
      lastPlacementTestResult: 0.0,
    );
  }

  // Optional: convert to string or map
  @override
  String toString() {
    return 'Account(username: $username, name: $name, result: $lastPlacementTestResult)';
  }
}
