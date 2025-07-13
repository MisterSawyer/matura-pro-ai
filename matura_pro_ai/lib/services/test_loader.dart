import 'dart:convert';
import 'package:flutter/services.dart';

import '../../core/constants.dart';

import '../models/test/test.dart';

Future<Test> loadTest(String filename) async {
  final jsonString = await rootBundle.loadString('${AppAssets.testsPath}/$filename');
  final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  return Test.fromJson(jsonMap);
}