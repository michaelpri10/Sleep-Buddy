import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleep_buddy_app/http_service.dart';
import 'package:sleep_buddy_app/survey.dart';

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
  int _selectedIndex = 0;
  User _currentUser = const User();
  BaselineSurvey _baselineSurvey = const BaselineSurvey();
  DailySurvey _dailySurvey = const DailySurvey();

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("current_user") ?? "");
    User tempUser = await HttpService.getUserByEmail(email);
    BaselineSurvey tempBaselineSurvey =
        await HttpService.getBaselineByEmail(email);
    DailySurvey tempDailySurvey =
        await HttpService.getDailyByEmailDate(email, '2023-04-25');

    setState(() {
      _currentUser = tempUser;
      _baselineSurvey = tempBaselineSurvey;
      _dailySurvey = tempDailySurvey;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void _navChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 15, color: theme.colorScheme.onPrimary),
      padding: const EdgeInsets.all(12),
    );

    List<Widget> widgetOptions = <Widget>[
      Column(
        children: [
          Text("Hello, ${_currentUser.name}!"),
          Text("Start Date: ${_currentUser.start_date}"),
          Text("Number of drinks: ${_dailySurvey.number_of_drinks}"),
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
      const Survey(),
      Column(
        children: const [
          Text("Settings"),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sleep Buddy"),
        titleTextStyle: const TextStyle(
          fontSize: 40,
        ),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _navChange(index);
          if (index == 0) {
            loadUserData();
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: "Survey",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: _selectedIndex,
      ),
    );
  }
}
