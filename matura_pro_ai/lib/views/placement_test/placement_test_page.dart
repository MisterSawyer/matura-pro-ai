import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';

import '../../controllers/placement_test_controller.dart';
import '../../models/account.dart';
import '../../controllers/register_controller.dart';

import '../../widgets/three_column_layout.dart';

class PlacementTestPage extends StatefulWidget {
  final Account account;

  const PlacementTestPage({super.key, required this.account});

  @override
  State<PlacementTestPage> createState() => _PlacementTestPageState();
}

class _PlacementTestPageState extends State<PlacementTestPage> {
  final _controller = PlacementTestController();
  List<int?> _answers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _controller.loadQuestions();
    setState(() {
      _answers = List.filled(_controller.questions.length, null);
      _loading = false;
    });
  }

  void _submit() {
    if (_answers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.enterAllAnswers)),
      );
      return;
    }

    final score = _controller.evaluate(_answers.cast<int>());
    final result = (score.toDouble() / _controller.total) * 100.0;

    setState(() {
      RegisterController.updateLastPlacementTestResult(
          widget.account.username, result);
    });

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.placementTestResult,
      arguments: {
        'account': widget.account,
        'score': result,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.placementTest)),
        body: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: ThreeColumnLayout(
              left: const SizedBox(),
              center: Column(children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppStyles.padding),
                    itemCount: _controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = _controller.questions[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${index + 1}. ${question.question}",
                              style: AppStyles.subHeader),
                          ...List.generate(question.options.length, (optIndex) {
                            return RadioListTile<int>(
                              value: optIndex,
                              groupValue: _answers[index],
                              title: Text(question.options[optIndex]),
                              onChanged: (value) {
                                setState(() {
                                  _answers[index] = value;
                                });
                              },
                            );
                          }),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 64),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text(AppStrings.submit),
                )
              ]),
              right: const SizedBox(),
            )));
  }
}
