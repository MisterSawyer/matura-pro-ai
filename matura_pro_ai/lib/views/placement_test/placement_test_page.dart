
import 'package:flutter/material.dart';
import '../../controllers/test_part_controller.dart';

import '../../routes/app_routes.dart';

import '../../models/account.dart';

import 'package:matura_pro_ai/widgets/test_page.dart';


class PlacementTestPage extends StatelessWidget {
  final Account account;

  const PlacementTestPage({super.key, required this.account});

  void _handleSubmit(BuildContext context, double score) {

    account.stats.placementTestResult = score;
    account.stats.placementTestTaken = true;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: {'account': account},
    );
  }

  void _handlePartFinished(BuildContext context, TestPartController part)
  {
    // Navigator.pushReplacementNamed(
    //   context,
    //   AppRoutes.home,
    //   arguments: {'account': account},
    // );
  }

  @override
  Widget build(BuildContext context) {
    return TestPage(
      filename: 'placement_test.json',
      label: 'Placement Test',
      account: account,
      onSubmit: (score) => _handleSubmit(context, score),
      onPartFinished: (part) => _handlePartFinished(context, part),
    );
  }
}