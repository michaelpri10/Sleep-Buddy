import 'package:flutter/material.dart';
import 'package:sleep_buddy_app/daily_survey.dart';
import 'baseline_survey.dart';

class Survey extends StatelessWidget {
  const Survey({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary),
      padding: const EdgeInsets.all(12),
    );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: style,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BaselineSurveyPage(),
                    ));
              },
              child: const Text("Baseline Survey"),
            ),
          ),
          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DailySurveyPage(),
                  ));
            },
            child: const Text("Daily Survey"),
          ),
        ],
      ),
    );
  }
}
