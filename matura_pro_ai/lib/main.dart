import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';

import 'controllers/register_controller.dart';
import 'services/theme_notifier.dart';

void main() {
  RegisterController.initializeDefaults();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const App(),
    ),
  );

}