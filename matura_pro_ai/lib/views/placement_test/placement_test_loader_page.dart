import 'package:flutter/material.dart';
import 'package:matura_pro_ai/models/test/test_type.dart';

import '../../controllers/test/test_controller.dart';
import '../../controllers/test/test_part_controller.dart';

import '../../routes/app_routes.dart';

import '../../models/account.dart';
import '../../models/test/test.dart';
import '../../models/test/test_result.dart';
import '../../models/tags_and_topics_results.dart';

import '../../services/test_loader.dart';

import '../../widgets/scrollable_layout.dart';
import '../../widgets/test/test_page.dart';

import 'placement_test_part_result_page.dart';

class PlacementTestLoaderPage extends StatefulWidget {
  final Account account;

  const PlacementTestLoaderPage({super.key, required this.account});

  @override
  State<PlacementTestLoaderPage> createState() =>
      _PlacementTestLoaderPageState();
}

class _PlacementTestLoaderPageState extends State<PlacementTestLoaderPage> {
  late final TestController _testController;
  Test? _test;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async 
  {
    // restore currently saved test
    if(widget.account.currentTests[TestType.placement] != null)
    {
      setState(() {
        _test = widget.account.currentTests[TestType.placement]!.test;
        _testController = widget.account.currentTests[TestType.placement]!;
        _loading = false;
      });
      return;
    }

    // load new test from file
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
                    label: 'Test poziomujacy',
                    onTestEnded: () =>
                        _handleTestEnded(
                            context),
                    onPartFinished: (part) =>
                        _handlePartFinished(context, part),
                  )),
        ) ??
        true;
  }

  Future<bool> _handlePartFinished(
      BuildContext context, TestPartController part) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => PlacementTestPartResultPage(
              account: widget.account,
              part: part,
              isLastPart: _testController.isLastPart,
            ),
          ),
        ) ??
        false;
  }

  Future<void> _handleTestEnded(BuildContext context) async 
  {
    if(_testController.isLastPart == false)
    {
      assert(_testController.currentPart.isLastQuestion);
      _testController.nextPart();
      widget.account.saveTestState(TestType.placement, _testController);
    }
    else
    {
      TestResult results = TestResult(_test!.name);
      TagsAndTopicsResults tagsAndTopicsResults = TagsAndTopicsResults();

      for(final part in _testController.parts)
      {
        results.partNames.add(part.name);
        results.partResults.add(part.evaluate());

        for(final question in part.questions)
        {
          double currentQuestionScore = question.evaluate();
          double multipier = 1.0;
          for (var tag in question.tags) {
            tagsAndTopicsResults.addTagResult(tag, currentQuestionScore * multipier);
          }
          for (var topic in question.topics) {
            tagsAndTopicsResults.addTopicResult(
                topic, currentQuestionScore * multipier);
          }
        }
      }

      widget.account.stats.markPlacementTestTaken();
      widget.account.stats.addTestResult(TestType.placement, results);

      widget.account.stats.tagsAndTopicsResults += tagsAndTopicsResults;

      widget.account.finishCurrentTest(TestType.placement);
    }

    await Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: {'account': widget.account},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _test == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.account.currentTests.containsKey(TestType.placement) == true, 
      ),
      body: ScrollableLayout(maxWidth: 400, children: [
        Center(
            child: Text("Sprawdz swoj poziom i ucz sie skuteczniej!",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center)),
        const SizedBox(
          height: 32,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "Zanim zaczniemy wspólną naukę, zróbmy krótki test."
            "\nDzięki niemu dowiemy się, od czego najlepiej zacząć, żeby nauka była naprawdę skuteczna."
            "\n\nSkłada się z 3 sekcji:  słuchanie, czytanie, transformacje językowe."
            "\n\nCałość zajmie około 15 minut, ale spokojnie – po każdej części możesz zrobić przerwę, a Twoje odpowiedzi zostaną zapisane."
            "\n\nNa końcu zobaczysz swój wynik\nw statystykach, co pozwoli Ci śledzić postępy od samego początku!",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              await _handleTestStarted(context, _test!);
            },
            child: const Text("Zaczynamy!"),
          ),
        ),
      ]),
    );
  }
}
