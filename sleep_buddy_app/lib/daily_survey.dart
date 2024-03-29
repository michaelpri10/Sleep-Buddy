import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_buddy_app/date_picker.dart';
import 'package:sleep_buddy_app/radio_question.dart';

import 'http_service.dart';

class DailySurveyPage extends StatefulWidget {
  const DailySurveyPage({super.key});

  @override
  State<DailySurveyPage> createState() => DailySurveyState();
}

class DailySurveyState extends State<DailySurveyPage> {
  User _currentUser = const User();

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("current_user") ?? "");
    User tempUser = await HttpService.getUserByEmail(email);

    setState(() {
      _currentUser = tempUser;
    });
  }

  final GlobalKey<FormState> _dailySurveyKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "survey_date": DateTime.now().toString().split(" ")[0],
    "sleep_was_tracked": false,
    "estimated_sleep": -1,
    "minutes_in_bed_before_sleep": -1,
    "alcohol_before_sleeping": false,
    "number_of_drinks": -1,
    "length_of_drinking": -1,
    "caffeine_before_sleeping": false,
    "caffeine_cups": -1,
    "caffeine_length": -1,
    "exercise_yesterday": false,
    "length_of_exercise": -1,
    "stress_yesterday": false,
    "stress_reasons": "",
  };

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary),
      padding: const EdgeInsets.all(12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Survey"),
        titleTextStyle: const TextStyle(
          fontSize: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _dailySurveyKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DatePickerFormField(
                  initialValue: DateTime.now(),
                  decoration: const InputDecoration(
                    labelText: "Select the date for this survey",
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please select a date";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _formData["survey_date"] = value.toString().split(" ")[0];
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "Did your Fitbit track your sleep last night?",
                  labels: const ["Yes", "No"],
                  amount: 2,
                  onChanged: (value) {
                    setState(() {
                      _formData["sleep_was_tracked"] =
                          value == 0 ? true : false;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  enabled: !_formData["sleep_was_tracked"],
                  decoration: const InputDecoration(
                    labelText:
                        "If not, how many hours of sleep would you estimate that you got?",
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      _formData["estimated_sleep"] = int.parse(value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question:
                      "How long were you in bed attempting to sleep before the time your watch stated you began sleeping?",
                  labels: const [
                    "0-15 Minutes",
                    "15-30 Minutes",
                    "30-60 Minutes",
                    "60-120 Minutes",
                    "120+ Minutes"
                  ],
                  amount: 5,
                  onChanged: (value) {
                    _formData["minutes_in_bed_before_sleep"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "Did you drink alcohol yesterday?",
                  labels: const ["Yes", "No"],
                  amount: 2,
                  onChanged: (value) {
                    _formData["alcohol_before_sleeping"] =
                        value == 0 ? true : false;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "If yes, how many standard drinks did you have?",
                  labels: const [
                    "1-2 Drinks",
                    "3-5 Drinks",
                    "6-8 Drinks",
                    "9+ Drinks"
                  ],
                  amount: 4,
                  onChanged: (value) {
                    _formData["number_of_drinks"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question:
                      "If yes, over how long of a period of time were you drinking?",
                  labels: const [
                    "Less than 1 Hour",
                    "1-3 Hours",
                    "3-6 Hours",
                    "6+ hours"
                  ],
                  amount: 4,
                  onChanged: (value) {
                    _formData["length_of_drinking"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "Did you consume caffeine yesterday?",
                  labels: const ["Yes", "No"],
                  amount: 2,
                  onChanged: (value) {
                    _formData["caffeine_before_sleeping"] =
                        value == 0 ? true : false;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question:
                      "If yes, how many cups of coffee (or equivalent caffeine servings) did you have?",
                  labels: const ["1-2 Cups", "3-4 Cups", "5-6 Cups", "6+ Cups"],
                  amount: 4,
                  onChanged: (value) {
                    _formData["caffeine_cups"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question:
                      "If yes, how long before sleeping did you last have caffeine?",
                  labels: const [
                    "Less than 1 Hour",
                    "1-3 Hours",
                    "3-6 Hours",
                    "6+ hours"
                  ],
                  amount: 4,
                  onChanged: (value) {
                    _formData["caffeine_length"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "Did you exercise yesterday?",
                  labels: const ["Yes", "No"],
                  amount: 2,
                  onChanged: (value) {
                    _formData["exercise_yesterday"] = value == 0 ? true : false;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "If yes, for how long did you exercise?",
                  labels: const [
                    "0-30 Minutes",
                    "30-60 Minutes",
                    "60+ Minutes",
                  ],
                  amount: 3,
                  onChanged: (value) {
                    _formData["length_of_exercise"] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioQuestion(
                  question: "Did you experience any abnormal stress yesterday?",
                  labels: const ["Yes", "No"],
                  amount: 2,
                  onChanged: (value) {
                    _formData["stress_yesterday"] = value == 0 ? true : false;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  enabled: _formData["stress_yesterday"],
                  decoration: const InputDecoration(
                    labelText: "If yes, describe why in 1-2 sentences?",
                  ),
                  onSaved: (value) {
                    if (value != null) {
                      _formData["stress_reasons"] = value;
                    }
                  },
                ),
              ),
              ElevatedButton(
                style: style,
                onPressed: () async {
                  _dailySurveyKey.currentState!.save();
                  await HttpService.saveDaily(
                      _currentUser.email, _formData, context);
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
