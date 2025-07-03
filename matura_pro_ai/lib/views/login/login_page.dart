import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';

import '../../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = LoginController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLogin() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final account = _controller.login(email, password);

    if (account != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: account,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.invalidCredentials)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.login), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: AppStrings.email),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: AppStrings.password),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onLogin,
              child: const Text(AppStrings.login),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: const Text("${AppStrings.registerEntry} ${AppStrings.register}"),
            ),
          ],
        ),
      ),
    );
  }
}