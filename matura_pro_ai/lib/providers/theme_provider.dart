import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_notifier.dart';

final themeNotifierProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier();
});
