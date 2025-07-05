import '../core/utils/hash_utils.dart';
import '../models/account.dart';
import 'register_controller.dart';

// THIS IS ONLY FOR MOCKUP PURPOSES
// IN PRODUCTION YOU WOULD USE A REAL DATABASE
class LoginController {
  Account? login(String username, String password) {
    final hashedInput = HashUtils.hashPassword(password);
    final storedHash = RegisterController.allUsers[username];

    if (storedHash != null && storedHash == hashedInput) {
      return RegisterController.getAccount(username);
    }
    return null;
  }
}