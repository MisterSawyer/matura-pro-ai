import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matura_pro_ai/core/constants.dart';
import 'package:matura_pro_ai/models/test/test_progress.dart';

import '../../controllers/test/test_controller.dart';
import '../../controllers/test/test_part_controller.dart';
import '../../models/test/test_type.dart';
import '../../models/test/test.dart';
import '../../routes/app_routes.dart';
import '../../providers/account_provider.dart';
import '../../services/test_loader.dart';
import '../../widgets/scrollable_layout.dart';
import '../../widgets/test/test_page.dart';
import 'placement_test_part_result_page.dart';

class PlacementTestLoaderPage extends ConsumerStatefulWidget {
  const PlacementTestLoaderPage({super.key});

  @override
  ConsumerState<PlacementTestLoaderPage> createState() =>
      _PlacementTestLoaderPageState();
}

class _PlacementTestLoaderPageState
    extends ConsumerState<PlacementTestLoaderPage> {
  late final TestController _testController;
  Test? _test;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    final account = ref.read(accountProvider);
    if (account == null) return;

    if (account.currentTests[TestType.placement] != null) {
      setState(() {
        _test = account.currentTests[TestType.placement]!.test;
        _testController =
            TestController.progress(account.currentTests[TestType.placement]!);
        _loading = false;
      });
      return;
    }

    final test = await loadTest('placement_test.json');
    setState(() {
      _test = test;
      _testController = TestController(test);
      _loading = false;
    });
  }

  Future<void> _handleTestStarted(BuildContext context, Test test) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestPage(
          testController: _testController,
          label: AppStrings.placementTest,
          onTestEnded: () => _handleTestEnded(context),
          onPartFinished: (part) => _handlePartFinished(context, part),
        ),
      ),
    );
  }

  Future<bool> _handlePartFinished(
      BuildContext context, TestPartController part) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => PlacementTestPartResultPage(
              part: part,
              isLastPart: _testController.isLastPart,
            ),
          ),
        ) ??
        false;
  }

  Future<void> _handleTestEnded(BuildContext context) async {
    final account = ref.read(accountProvider);
    if (account == null) return;

    final (testResults, tagsAndTopicsResults) = _testController.calculateResults(
        fromResults: account.currentTests[TestType.placement]?.results,
        fromTagsAndTopicsResults: account.currentTests[TestType.placement]?.tagsAndTopicsResults);

    if (_testController.isLastPart == false) {
      assert(_testController.currentPart.isLastQuestion);
      
      _testController.nextPart();

      final partID = _testController.currentPartID + (account.currentTests[TestType.placement]?.partID ?? 0);

      account.saveTestState(
          TestType.placement,
          TestProgress(
              test: _test!,
              partID: partID,
              results: testResults,
              tagsAndTopicsResults: tagsAndTopicsResults));
    } else {
      account.stats.markPlacementTestTaken();
      account.stats.addTestResult(TestType.placement, testResults);
      account.stats.tagsAndTopicsResults += tagsAndTopicsResults;
      account.finishCurrentTest(TestType.placement);
    }

    await Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);

    if (_loading || _test == null || account == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            account.currentTests.containsKey(TestType.placement),
      ),
      body: ScrollableLayout(maxWidth: 400, children: [
        Center(
          child: Text(
            "Sprawdź swój poziom i ucz się skuteczniej!",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: Text(
            "Zanim zaczniemy wspólną naukę, zróbmy krótki test."
            "\nDzięki niemu dowiemy się, od czego najlepiej zacząć, żeby nauka była naprawdę skuteczna."
            "\n\nSkłada się z 3 sekcji: słuchanie, czytanie, transformacje językowe."
            "\n\nCałość zajmie około 15 minut, ale spokojnie – po każdej części możesz zrobić przerwę, a Twoje odpowiedzi zostaną zapisane."
            "\n\nNa końcu zobaczysz swój wynik\nw statystykach, co pozwoli Ci śledzić postępy od samego początku!",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton(
            onPressed: () => _handleTestStarted(context, _test!),
            child: const Text("${AppStrings.letsBegin}!"),
          ),
        ),
      ]),
    );
  }
}
