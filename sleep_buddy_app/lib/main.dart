import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sleep_buddy_app/dashboard.dart';
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SleepBuddy());
}

class SleepBuddy extends StatefulWidget {
  const SleepBuddy({super.key});

  @override
  State<SleepBuddy> createState() => _SleepBuddyState();
}

class _SleepBuddyState extends State<SleepBuddy> {
  String _currentUser = "";

  void loadCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = (prefs.getString("current_user") ?? "");
    });
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: "Sleep Buddy",
        theme: ThemeData(
          // useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: _currentUser.isEmpty ? const RegisterPage() : const Dashboard(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}
