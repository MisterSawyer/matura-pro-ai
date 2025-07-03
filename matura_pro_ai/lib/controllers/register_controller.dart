import '../core/utils/hash_utils.dart';
import '../models/account.dart';

// THIS IS ONLY FOR MOCKUP PURPOSES
// IN PRODUCTION YOU WOULD USE A REAL DATABASE
class RegisterController {
  static final Map<String, String> _userPasswords = {};
  static final Map<String, Account> _userAccounts = {};

  bool register(String email, String password) {
    if (_userPasswords.containsKey(email)) return false;

    final hashed = HashUtils.hashPassword(password);
    _userPasswords[email] = hashed;

    _userAccounts[email] = Account(
      email: email,
      name: "User ${_userAccounts.length + 1}",
      lastPlacementTestResult: 0.0,
    );

    return true;
  }

  static void updateName(String email, String newName) {
    final account = _userAccounts[email];
    if (account != null) {
      account.name = newName;
    }
  }

  static void updateLastPlacementTestResult(String email, double result) {
    final account = _userAccounts[email];
    if (account != null) {
      account.lastPlacementTestResult = result;
    }
  }

  static Map<String, String> get allUsers => _userPasswords;
  static Account? getAccount(String email) => _userAccounts[email];
}