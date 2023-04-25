// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_buddy_app/dashboard.dart';
import 'package:sleep_buddy_app/login.dart';
import 'package:sleep_buddy_app/register.dart';

class User {
  final String error;
  final String name;
  final String email;
  final String watch_id;
  final String start_date;

  const User({
    this.error = "",
    this.name = "",
    this.email = "",
    this.watch_id = "",
    this.start_date = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      error: json["error"] as String,
      name: json["name"] as String,
      email: json["email"] as String,
      watch_id: json["watch_id"] as String,
      start_date: json["start_date"] as String,
    );
  }
}

class BaselineSurvey {
  final String error;
  final String email;
  final String start_date;
  final int average_sleep;
  final int sleep_happiness;
  final int sleep_deprived;
  final bool tracked_sleep;
  final String sleep_insights;
  final int drinking_days_average;
  final int drugs_days_average;
  final int caffeine_days_average;
  final int exercise_days_average;
  final int device_time_average;

  const BaselineSurvey({
    this.error = "",
    this.email = "",
    this.start_date = "",
    this.average_sleep = -1,
    this.sleep_happiness = -1,
    this.sleep_deprived = -1,
    this.tracked_sleep = false,
    this.sleep_insights = "",
    this.drinking_days_average = -1,
    this.drugs_days_average = -1,
    this.caffeine_days_average = -1,
    this.exercise_days_average = -1,
    this.device_time_average = -1,
  });

  factory BaselineSurvey.fromJson(Map<String, dynamic> json) {
    return BaselineSurvey(
      error: json["error"] as String,
      email: json["email"] as String,
      start_date: json["start_date"] as String,
      average_sleep: json["average_sleep"] as int,
      sleep_happiness: json["sleep_happiness"] as int,
      sleep_deprived: json["sleep_deprived"] as int,
      tracked_sleep: json["tracked_sleep"] as bool,
      sleep_insights: json["sleep_insights"] as String,
      drinking_days_average: json["drinking_days_average"] as int,
      drugs_days_average: json["drugs_days_average"] as int,
      caffeine_days_average: json["caffeine_days_average"] as int,
      exercise_days_average: json["exercise_days_average"] as int,
      device_time_average: json["device_time_average"] as int,
    );
  }
}

class DailySurvey {
  final String error;
  final String email;
  final String survey_date;
  final bool sleep_was_tracked;
  final int estimated_sleep;
  final int minutes_in_bed_before_sleep;
  final bool alcohol_before_sleeping;
  final int number_of_drinks;
  final int length_of_drinking;
  final bool caffeine_before_sleeping;
  final int caffeine_cups;
  final int caffeine_length;
  final bool exercise_yesterday;
  final int length_of_exercise;
  final bool stress_yesterday;
  final String stress_reasons;

  const DailySurvey({
    this.error = "",
    this.email = "",
    this.survey_date = "",
    this.sleep_was_tracked = false,
    this.estimated_sleep = -1,
    this.minutes_in_bed_before_sleep = -1,
    this.alcohol_before_sleeping = false,
    this.number_of_drinks = -1,
    this.length_of_drinking = -1,
    this.caffeine_before_sleeping = false,
    this.caffeine_cups = -1,
    this.caffeine_length = -1,
    this.exercise_yesterday = false,
    this.length_of_exercise = -1,
    this.stress_yesterday = false,
    this.stress_reasons = "",
  });

  factory DailySurvey.fromJson(Map<String, dynamic> json) {
    return DailySurvey(
      error: json["error"] as String,
      email: json["email"] as String,
      survey_date: json["survey_date"] as String,
      sleep_was_tracked: json["sleep_was_tracked"] as bool,
      estimated_sleep: json["estimated_sleep"] as int,
      minutes_in_bed_before_sleep: json["minutes_in_bed_before_sleep"] as int,
      alcohol_before_sleeping: json["alcohol_before_sleeping"] as bool,
      number_of_drinks: json["number_of_drinks"] as int,
      length_of_drinking: json["length_of_drinking"] as int,
      caffeine_before_sleeping: json["caffeine_before_sleeping"] as bool,
      caffeine_cups: json["caffeine_cups"] as int,
      caffeine_length: json["caffeine_length"] as int,
      exercise_yesterday: json["exercise_yesterday"] as bool,
      length_of_exercise: json["length_of_exercise"] as int,
      stress_yesterday: json["stress_yesterday"] as bool,
      stress_reasons: json["stress_reasons"] as String,
    );
  }
}

class HttpService {
  static final _client = http.Client();
  static final _registerUrl = Uri.parse("http://localhost:5000/register");
  static final _loginUrl = Uri.parse("http://localhost:5000/login");
  static final _getUserUrl = Uri.parse("http://localhost:5000/get_user");
  static final _saveBaselineUrl =
      Uri.parse("http://localhost:5000/save_baseline");
  static final _getBaselineUrl =
      Uri.parse("http://localhost:5000/get_baseline");
  static final _saveDailyUrl = Uri.parse("http://localhost:5000/save_daily");
  static final _getDailyUrl = Uri.parse("http://localhost:5000/get_daily");

  static register(name, email, password, context) async {
    http.Response response = await _client.post(_registerUrl, body: {
      "name": name,
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json[0] == "register_success") {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        await EasyLoading.showError(json[0]);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static login(email, password, context) async {
    http.Response response = await _client.post(_loginUrl, body: {
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json[0] == "login_success") {
        await EasyLoading.showSuccess(json[0]);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("current_user", email);
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        await EasyLoading.showError(json[0]);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static logout(user, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("current_user");
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  static Future<User> getUserByEmail(email) async {
    User fetchedUser = const User();
    http.Response response = await _client.post(_getUserUrl, body: {
      "email": email,
    });

    if (response.statusCode == 200) {
      var json = Map<String, dynamic>.from(jsonDecode(response.body));
      fetchedUser = User.fromJson(json);
      if (fetchedUser.error.isNotEmpty) {
        await EasyLoading.showError("Error: ${fetchedUser.error}");
      }
    } else {
      await EasyLoading.showError(
          "Error Code: ${response.statusCode.toString()}");
    }
    return fetchedUser;
  }

  static saveBaseline(email, data, context) async {
    http.Response response = await _client.post(_saveBaselineUrl, body: {
      "data": json.encode(data),
      "email": email,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json[0] == "survey_success") {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        await EasyLoading.showError(json[0]);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static Future<BaselineSurvey> getBaselineByEmail(email) async {
    BaselineSurvey fetchedBaseline = const BaselineSurvey();
    http.Response response = await _client.post(_getBaselineUrl, body: {
      "email": email,
    });

    if (response.statusCode == 200) {
      var json = Map<String, dynamic>.from(jsonDecode(response.body));
      fetchedBaseline = BaselineSurvey.fromJson(json);
      if (fetchedBaseline.error.isNotEmpty) {
        await EasyLoading.showError("Error: ${fetchedBaseline.error}");
      }
    } else {
      await EasyLoading.showError("Error: ${response.statusCode.toString()}");
    }
    return fetchedBaseline;
  }

  static saveDaily(email, data, context) async {
    http.Response response = await _client.post(_saveDailyUrl, body: {
      "data": json.encode(data),
      "email": email,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json[0] == "survey_success") {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        await EasyLoading.showError(json[0]);
      }
    } else {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    }
  }

  static Future<DailySurvey> getDailyByEmailDate(email, date) async {
    DailySurvey fetchedBaseline = const DailySurvey();
    http.Response response = await _client.post(_getDailyUrl, body: {
      "email": email,
      "date": date,
    });

    if (response.statusCode == 200) {
      var json = Map<String, dynamic>.from(jsonDecode(response.body));
      fetchedBaseline = DailySurvey.fromJson(json);
      if (fetchedBaseline.error.isNotEmpty) {
        await EasyLoading.showError("Error: ${fetchedBaseline.error}");
      }
    } else {
      await EasyLoading.showError("Error: ${response.statusCode.toString()}");
    }
    return fetchedBaseline;
  }
}
