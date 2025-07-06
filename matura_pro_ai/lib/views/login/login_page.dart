import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/register_controller.dart';
import '../../models/account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Account? _loggedInAccount;

  Future<String?> _authUser(LoginData data) async {
    final account = LoginController().login(data.name, data.password);
    if (account == null) return AppStrings.invalidCredentials;
    _loggedInAccount = account;
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    if (data.name == null || data.name!.isEmpty) return 'Enter a username';
    final success = RegisterController.register(
      data.name!,
      data.password ?? '',
    );
    return success ? null : AppStrings.userExists;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FlutterLogin(
      title: AppStrings.appName,
      logo: const AssetImage('assets/images/logo.png'),
      userType: LoginUserType.name, // accept usernames like "admin"
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: (email) async => 'Password recovery not supported.',
      onSubmitAnimationCompleted: () {
        if (!mounted || _loggedInAccount == null) return;
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
          arguments: _loggedInAccount,
        );
      },
      userValidator: (value) =>
          (value == null || value.isEmpty) ? 'Enter a username' : null,
      passwordValidator: (value) => (value == null) ? 'Invalid password' : null,
      loginAfterSignUp: false,
      hideForgotPasswordButton: true,

      messages: LoginMessages(
        userHint: AppStrings.username,
        passwordHint: AppStrings.password,
        loginButton: AppStrings.login,
        signupButton: AppStrings.register,
        signUpSuccess: AppStrings.registrationSuccess,
        confirmPasswordError: 'Passwords do not match',
        flushbarTitleError: 'Error',
        flushbarTitleSuccess: 'Success',
      ),
      theme: LoginTheme(
        primaryColor: theme.primaryColor,
        accentColor: theme.highlightColor,
        errorColor: Colors.redAccent,
        cardTheme: const CardTheme(margin: EdgeInsets.only(top: 100)),
        authButtonPadding: const EdgeInsets.all(AppStyles.padding),
        providerButtonPadding: const EdgeInsets.all(AppStyles.padding),
        buttonTheme: LoginButtonTheme(
          backgroundColor: theme.buttonTheme.colorScheme?.primary,
          highlightColor: theme.buttonTheme.colorScheme?.onPrimary,
        ),
      ),

      children: const [],
    );
  }
}
