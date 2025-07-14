import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/test/test_part_controller.dart';
import '../controllers/test/test_part_state.dart';
import '../models/test/test_part.dart';

/// Provides a [TestPartController] managing a specific [TestPart].
final testPartControllerProvider = StateNotifierProvider.autoDispose
    .family<TestPartController, TestPartState, TestPart>((ref, part) {
  return TestPartController(part: part);
});
