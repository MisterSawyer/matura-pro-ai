import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';

import '../../routes/app_routes.dart';
import '../../providers/account_provider.dart';
import '../../providers/auth_provider.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<String?> _authUser(LoginData data) async {
    final auth = ref.read(authServiceProvider);
    final account = auth.login(data.name, data.password);

    if (account == null) return AppStrings.invalidCredentials;

    ref.read(accountProvider.notifier).setAccount(account);
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    final auth = ref.read(authServiceProvider);

    if (data.name == null || data.name!.isEmpty) {
      return AppStrings.usernameMissing;
    }
    if (data.password == null || data.password!.isEmpty) {
      return AppStrings.passwordError;
    }

    final success = auth.register(data.name!, data.password!);

    return success ? null : AppStrings.userExists;
  }

  Future<String?> _recoverPassword(String name) async {
    assert(false);
    return 'Password recovery not supported.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FlutterLogin(
              title: AppStrings.appTitle,
              logo: const AssetImage(AppAssets.logoPath),
              userType: LoginUserType.name,
              onLogin: _authUser,
              onSignup: _signupUser,
              onRecoverPassword: _recoverPassword,
              onSubmitAnimationCompleted: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              userValidator: (value) => (value == null || value.isEmpty)
                  ? AppStrings.usernameMissing
                  : null,
              passwordValidator: (value) => (value == null || value.isEmpty)
                  ? AppStrings.passwordError
                  : null,
              scrollable: false,
              loginAfterSignUp: false,
              hideForgotPasswordButton: true,
              messages: LoginMessages(
                userHint: AppStrings.username,
                passwordHint: AppStrings.password,
                loginButton: AppStrings.login,
                signupButton: AppStrings.register,
                signUpSuccess: AppStrings.registrationSuccess,
                confirmPasswordError: AppStrings.passwordMismatch,
                flushbarTitleError: AppStrings.error,
                flushbarTitleSuccess: AppStrings.success,
              ),
              theme: LoginTheme(
                logoWidth: 1.0,
                cardInitialHeight: 100.0,
                headerMargin: 0.0,
                pageColorDark: theme.scaffoldBackgroundColor,
                primaryColor: theme.scaffoldBackgroundColor,
                accentColor: theme.highlightColor,
                errorColor: theme.colorScheme.error,
                cardTheme: CardTheme(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  color: theme.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                authButtonPadding: const EdgeInsets.all(ThemeDefaults.padding),
                providerButtonPadding: const EdgeInsets.all(ThemeDefaults.padding),
                buttonTheme: LoginButtonTheme(
                  backgroundColor: theme.buttonTheme.colorScheme?.primary,
                  highlightColor: theme.buttonTheme.colorScheme?.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
