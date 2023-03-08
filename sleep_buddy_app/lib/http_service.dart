import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:sleep_buddy_app/dashboard.dart';

class HttpService {
  static final _client = http.Client();
  static final _registerUrl = Uri.parse("http://localhost:5000/register");
  static final _loginUrl = Uri.parse("http://localhost:5000/login");

  static register(username, email, password, context) async {
    http.Response response = await _client.post(_registerUrl, body: {
      "username": username,
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json[0] == "register_success") {
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

  static login(email, password, context) async {
    http.Response response = await _client.post(_loginUrl, body: {
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json[0] == "login_success") {
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
}
