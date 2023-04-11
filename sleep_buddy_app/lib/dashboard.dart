import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_buddy_app/http_service.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardState(),
      child: MaterialApp(
        title: "Dashboard",
        theme: ThemeData(
          // useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const DashboardHome(),
      ),
    );
  }
}

class DashboardState extends ChangeNotifier {}

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  User _currentUser = const User();

  void loadCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("current_user") ?? "");
    User tempUser = await HttpService.getUserByEmail(email);

    setState(() {
      _currentUser = tempUser;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 15, color: theme.colorScheme.onPrimary),
      padding: const EdgeInsets.all(12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        titleTextStyle: const TextStyle(
          fontSize: 40,
        ),
      ),
      body: Column(
        children: [
          Text("Hello, ${_currentUser.name}!"),
          ElevatedButton(
            style: style,
            onPressed: () async {
              // Send logout API call
              await HttpService.logout(_currentUser, context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
