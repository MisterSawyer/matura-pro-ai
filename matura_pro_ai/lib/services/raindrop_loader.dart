import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/raindrop_word.dart';

Future<RaindropWord> loadRaindropWord() async {
  final jsonString = await rootBundle.loadString('assets/raindrop/word_of_the_day.json');
  final jsonMap = json.decode(jsonString);
  return RaindropWord.fromJson(jsonMap);
}
