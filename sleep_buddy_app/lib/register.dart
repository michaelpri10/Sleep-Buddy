import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login.dart';
// import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<AppState>();
    ThemeData theme = Theme.of(context);
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 30, color: theme.colorScheme.onPrimary),
      padding: const EdgeInsets.all(12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sleep Buddy"),
        titleTextStyle: const TextStyle(
          fontSize: 40,
        ),
      ),
      body: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid username";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an valid email";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              style: style,
              onPressed: () {
                if (_registerFormKey.currentState!.validate()) {
                  print("SUCCESS");
                  // Send API call here
                }
              },
              child: const Text("Register"),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: RichText(
                text: TextSpan(
                  text: "Already a member? Login.",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                    },
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
