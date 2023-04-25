import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sleep_buddy_app/http_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
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
        key: _loginFormKey,
        child: Column(
          children: [
            const Image(image: AssetImage('assets/logo.png')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
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
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
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
              onPressed: () async {
                if (_loginFormKey.currentState!.validate()) {
                  // Send login API call
                  await HttpService.login(email, password, context);
                }
              },
              child: const Text("Login"),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: RichText(
                text: TextSpan(
                  text: "Not a member yet? Register.",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pop(context);
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
