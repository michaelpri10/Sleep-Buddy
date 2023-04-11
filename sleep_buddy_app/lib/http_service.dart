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

  const User({
    this.error = "",
    this.name = "",
    this.email = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      error: json["error"] as String,
      name: json["name"] as String,
      email: json["email"] as String,
    );
  }
}

class HttpService {
  static final _client = http.Client();
  static final _registerUrl = Uri.parse("http://localhost:5000/register");
  static final _loginUrl = Uri.parse("http://localhost:5000/login");
  static final _getUserUrl = Uri.parse("http://localhost:5000/get_user");

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
    // pref.setString("current_user", email);
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
}
