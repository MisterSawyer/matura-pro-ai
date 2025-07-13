import '../models/account.dart';
import '../core/utils/hash_utils.dart';

class AuthService {
  final Map<String, String> _userPasswords = {};
  final Map<String, Account> _userAccounts = {};

  bool register(String username, String password) {
    if (_userPasswords.containsKey(username)) return false;

    final hashed = HashUtils.hashPassword(password);
    _userPasswords[username] = hashed;
    _userAccounts[username] = Account(username: username);
    return true;
  }

  Account? login(String username, String password) {
    final hashedInput = HashUtils.hashPassword(password);
    final storedHash = _userPasswords[username];

    if (storedHash != null && storedHash == hashedInput) {
      return _userAccounts[username];
    }
    return null;
  }

  void initializeDefaults() {
    register("admin", "admin");
    _userAccounts["admin"]?.stats.markPlacementTestTaken();
  }

  Account? getAccount(String username) => _userAccounts[username];
  Map<String, String> get allUsers => _userPasswords;
}
