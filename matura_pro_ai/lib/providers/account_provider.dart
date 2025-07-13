import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/account.dart';

/// A [StateNotifier] that manages the current logged-in account state.
class AccountNotifier extends StateNotifier<Account?> {
  AccountNotifier() : super(null);

  /// Clears the current user (e.g., on logout).
  void logout() {
    state = null;
  }

  /// Updates the user's display name.
  void updateName(String name) {
    if (state != null) {
      // Force state refresh to trigger listeners
      state = state!.copyWith(name: name);
    }
  }

  /// Replace the whole account object (e.g., when updated externally).
  void setAccount(Account account) {
    state = account;
  }
}

/// Global provider for accessing/modifying the current user.
final accountProvider = StateNotifierProvider<AccountNotifier, Account?>(
  (ref) => AccountNotifier(),
);
