import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleep_buddy_app/date_picker.dart';
import 'package:sleep_buddy_app/radio_question.dart';

class BaselineSurvey extends StatefulWidget {
  const BaselineSurvey({super.key});

  @override
  State<BaselineSurvey> createState() => BaselineSurveyState();
}

class BaselineSurveyState extends State<BaselineSurvey> {
  final GlobalKey<FormState> _baselineSurveyKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary),
      padding: const EdgeInsets.all(12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Baseline Survey"),
        titleTextStyle: const TextStyle(
          fontSize: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _baselineSurveyKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DatePickerFormField(
                  initialValue: DateTime.now(),
                  decoration: const InputDecoration(
                    labelText: "Select the date you began this study",
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please select a date";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _formData["start_date"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText:
                        "How many hours of sleep per night do you think you get on average?",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a value";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _formData["average_sleep"] = int.parse(value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RatingScale(
                  question:
                      "How happy are you with the amount of sleep you get on average?",
                  onChanged: (value) {
                    _formData["sleep_happiness"] = value;
                  },
                  lowest: "Very Unhappy",
                  highest: "Very Happy",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RatingScale(
                  question: "How often do you feel sleep deprived?",
                  onChanged: (value) {
                    _formData["sleep_deprived"] = value;
                  },
                  lowest: "Rarely Ever",
                  highest: "Almost Always",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "Have you ever tracked your sleep?",
                  labels: const ["Yes", "No"],
                  amount: 2,
                  onChanged: (value) {
                    _formData["tracked_sleep"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  enabled: _formData["tracked_sleep"] == 0,
                  decoration: const InputDecoration(
                    labelText:
                        "If you have tracked your sleep, what insights did you gain from doing so?",
                  ),
                  onSaved: (value) {
                    if (value != null) {
                      _formData["sleep_insights"] = value;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "How many times a week do you drink on average?",
                  labels: const ["0 Days", "1-2 Days", "3-4 Days", "5+ Days"],
                  amount: 4,
                  onChanged: (value) {
                    _formData["drinking_days_average"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question:
                      "How many days a week do you take recreational drugs on average?",
                  labels: const ["0 Days", "1-2 Days", "3-4 Days", "5+ Days"],
                  amount: 4,
                  onChanged: (value) {
                    _formData["drugs_days_average"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question:
                      "How many days a week do you consume caffeine on average?",
                  labels: const ["0 Days", "1-2 Days", "3-4 Days", "5+ Days"],
                  amount: 4,
                  onChanged: (value) {
                    _formData["caffeine_days_average"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "How many days a week do you exercise on average?",
                  labels: const ["0 Days", "1-2 Days", "3-4 Days", "5+ Days"],
                  amount: 4,
                  onChanged: (value) {
                    _formData["exercise_days_average"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question:
                      "How much time on average do you spend on your device directly before going to bed?",
                  labels: const [
                    "0 Minutes",
                    "1-15 Minutes",
                    "15-30 Minutes",
                    "30-60 Minutes",
                    "60+ Minutes"
                  ],
                  amount: 5,
                  onChanged: (value) {
                    _formData["device_time_average"] = value;
                  },
                ),
              ),
              ElevatedButton(
                style: style,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingScale extends StatefulWidget {
  final String question;
  final Function(int) onChanged;
  final String lowest;
  final String highest;

  const RatingScale({
    Key? key,
    required this.question,
    required this.onChanged,
    required this.lowest,
    required this.highest,
  }) : super(key: key);

  @override
  RatingScaleState createState() => RatingScaleState();
}

class RatingScaleState extends State<RatingScale> {
  int _rating = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: const TextStyle(fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRadioButton(1),
            _buildRadioButton(2),
            _buildRadioButton(3),
            _buildRadioButton(4),
            _buildRadioButton(5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.lowest),
            Text(widget.highest),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(int value) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: _rating,
          onChanged: (int? newValue) {
            setState(() {
              _rating = newValue!;
              widget.onChanged(_rating);
            });
          },
        ),
        Text(value.toString()),
      ],
    );
  }
}
