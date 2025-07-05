import 'package:flutter/material.dart';
import 'app/app.dart';

import 'controllers/register_controller.dart';

void main() {
  RegisterController.initializeDefaults();
  runApp(const App());
}