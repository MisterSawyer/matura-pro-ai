
import 'package:flutter/material.dart';
import '../../controllers/test_part_controller.dart';

import '../../routes/app_routes.dart';

import '../../models/account.dart';

import '../../widgets/test_page.dart';
import 'placement_test_part_result_page.dart';


class PlacementTestPage extends StatelessWidget {
  final Account account;

  const PlacementTestPage({super.key, required this.account});

  Future<void> _handleSubmit(BuildContext context) async
  {
    account.stats.placementTestTaken = true;

    await Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: {'account': account},
    );
  }

  Future<void> _handlePartExit(BuildContext context) async
  {
    account.stats.placementTestTaken = true;

    await Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: {'account': account},
    );
  }

  Future<bool> _handlePartFinished(BuildContext context, TestPartController part) async
  {
    account.stats.placementTestResult.partNames.add(part.name);
    account.stats.placementTestResult.partResults.add(part.evaluate());

    return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlacementTestPartResultPage(
            account: account,
            part: part,
            onExit: () => _handlePartExit(context),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return TestPage(
      filename: 'placement_test.json',
      label: 'Test',
      account: account,
      onSubmit: () => _handleSubmit(context),
      onPartFinished: (part) => _handlePartFinished(context, part),
    );
  }
}