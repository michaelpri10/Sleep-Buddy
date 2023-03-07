import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'register.dart';

void main() {
  runApp(const SleepBuddy());
}

class SleepBuddy extends StatelessWidget {
  const SleepBuddy({super.key});

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
        home: const RegisterPage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}
