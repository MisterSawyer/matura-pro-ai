import '../core/utils/hash_utils.dart';
import '../models/account.dart';

// THIS IS ONLY FOR MOCKUP PURPOSES
// IN PRODUCTION YOU WOULD USE A REAL DATABASE
class RegisterController {
  static final Map<String, String> _userPasswords = {};
  static final Map<String, Account> _userAccounts = {};

  static bool register(String username, String password) {
    if (_userPasswords.containsKey(username)) return false;

    final hashed = HashUtils.hashPassword(password);
    _userPasswords[username] = hashed;

    _userAccounts[username] = Account(
      username: username,
    );

    return true;
  }

  // This is only for mockup development purposes
  static void initializeDefaults() {
    register("admin", "admin");
    getAccount("admin")?.stats.placementTestTaken = true;
  }


  static Map<String, String> get allUsers => _userPasswords;
  static Account? getAccount(String username) => _userAccounts[username];
}