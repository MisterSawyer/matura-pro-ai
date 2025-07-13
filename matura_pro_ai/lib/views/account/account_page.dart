import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';
import '../../widgets/scrollable_layout.dart';
import '../../providers/account_provider.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _onSave();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _onSave() {
    final account = ref.read(accountProvider);
    final newName = _nameController.text;

    if (account != null && account.name != newName && newName.isNotEmpty) {
      ref.read(accountProvider.notifier).updateName(newName);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.nameUpdateSucess)),
      );
    }
  }

  void _onLogout() {
    ref.read(accountProvider.notifier).logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = ref.watch(accountProvider);

    final newName = account?.name ?? '';
    final currentText = _nameController.text;

    // Sync controller only if value changed externally
    if (currentText != newName) {
      _nameController.value = TextEditingValue(
        text: newName,
        selection: TextSelection.collapsed(offset: newName.length),
      );
    }

    return Container(
      color: theme.scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _onSave(); // Save only if popping
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: ScrollableLayout(
            maxWidth: 400,
            children: [
              Center(
                child: Text(
                  "Konto",
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              const Center(child: Icon(Icons.account_circle, size: 64)),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "${AppStrings.username}: ${account?.username ?? '-'}",
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: const InputDecoration(
                    labelText: AppStrings.name,
                  ),
                ),
              ),
              const SizedBox(height: 128),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: theme.colorScheme.errorContainer,
                  ),
                  onPressed: _onLogout,
                  child: const Text(AppStrings.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
