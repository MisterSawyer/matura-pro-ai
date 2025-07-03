import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';

import '../../controllers/register_controller.dart';
import '../../widgets/three_column_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _controller = RegisterController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onRegister() {
    final email = _emailController.text;
    final password = _passwordController.text;

    final success = _controller.register(email, password);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.registrationSuccess)),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.userExists)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: Padding(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: ThreeColumnLayout(
            left: const SizedBox(),
            center: Column(
              children: [
                TextField(
                    controller: _emailController,
                    decoration:
                        const InputDecoration(labelText: AppStrings.email)),
                TextField(
                    controller: _passwordController,
                    decoration:
                        const InputDecoration(labelText: AppStrings.password),
                    obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _onRegister,
                    child: const Text(AppStrings.register)),
              ],
            ),
            right: const SizedBox(),
          )),
    );
  }
}
