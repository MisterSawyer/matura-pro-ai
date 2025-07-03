import 'package:flutter/material.dart';

class AppStrings {
  static const String appTitle = 'Matura Pro AI';
  static const String home = 'Home';
  static const String backHome = 'Back to Home';
  static const String appName = 'Matura Pro AI';
  static const String login = 'Login';
  static const String register = 'Register';
  static const String registerEntry = 'Don\'t have an account?';
  static const String name = 'Name';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String account = 'Account';
  static const String placementTest = 'Placement Test';
  static const String takeTest = 'Take Placement Test';
  static const String goToAccount = 'Go to Account';
  static const String logout = 'Logout';
  static const String saveName = 'Save Name';
  static const String nameUpdateSucess = 'Name updated successfully';
  static const String testCompleted = 'Test completed!';
  static const String enterAllAnswers = 'Please answer all questions';
  static const String invalidCredentials = 'Invalid credentials';
  static const String userExists = 'User already exists';
  static const String registrationSuccess = 'Registration successful';
  static const String testResult = 'Test Result';
  static const String welcome = 'Welcome';
  static const String lastTest = 'Last Placement Test';
  static const String submit = 'Submit';
  static const String wellDone = 'Well done';
}

class AppAssets {
  static const String placementQuestions = 'assets/placement_questions.json';
}

class AppStyles {
  static const double padding = 16.0;

  static const TextStyle header = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subHeader = TextStyle(
    fontSize: 16,
  );

  static const TextStyle paragraph = TextStyle(
    fontSize: 16,
  );
}