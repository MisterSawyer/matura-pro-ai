class Account {
  final String email;
  String name;
  double lastPlacementTestResult;

  Account({
    required this.email,
    required this.name,
    required this.lastPlacementTestResult,
  });

  // Optional: factory to create a default or anonymous account
  factory Account.empty(String email) {
    return Account(
      email: email,
      name: "User",
      lastPlacementTestResult: 0.0,
    );
  }

  // Optional: convert to string or map
  @override
  String toString() {
    return 'Account(email: $email, name: $name, result: $lastPlacementTestResult)';
  }
}
