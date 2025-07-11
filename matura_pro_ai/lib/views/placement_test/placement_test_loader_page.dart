import 'package:flutter/material.dart';

import '../../controllers/test_controller.dart';
import '../../controllers/test_part_controller.dart';

import '../../routes/app_routes.dart';

import '../../models/account.dart';
import '../../models/test.dart';
import '../../models/test_result.dart';

import '../../services/test_loader.dart';

import '../../widgets/test_page.dart';
import 'placement_test_part_result_page.dart';

class PlacementTestLoaderPage extends StatefulWidget {
  final Account account;

  const PlacementTestLoaderPage({super.key, required this.account});

  @override
  State<PlacementTestLoaderPage> createState() => _PlacementTestLoaderPageState();
}

class _PlacementTestLoaderPageState extends State<PlacementTestLoaderPage> {
  late final TestController _testController;
  Test? _test;

  bool _loading = true;

  late final TestResult results;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    final test = await loadTest('placement_test.json');
    setState(() {
      _test = test;
      _testController = TestController(test);
      results = TestResult(_test!.name);
      _loading = false;
    });
  }

  Future<void> _handleTestEnded(BuildContext context) async {

    widget.account.stats.markPlacementTestTaken();
    widget.account.stats.addTestResult(results);

    await Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: {'account': widget.account},
    );
  }

  Future<bool> _handlePartFinished(BuildContext context, TestPartController part) async {
    results.partNames.add(part.name);
    results.partResults.add(part.evaluate());

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
        true;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _test == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return TestPage(
      testController: _testController,
      label: 'Test poziomujacy',
      account: widget.account,
      onTestEnded: () => _handleTestEnded(context),
      onPartFinished: (part) => _handlePartFinished(context, part),
    );
  }
}
