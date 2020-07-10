import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/StatisticsScreen.dart';
import 'package:protein_tracker/calculatorScreen.dart';
import 'package:protein_tracker/colors.dart';
import 'package:protein_tracker/components/appDrawer.dart';
import 'package:protein_tracker/dao/food_dao.dart';
import 'package:protein_tracker/dao/protein_dao.dart';
import 'package:protein_tracker/homeScreen.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/settingsScreen.dart';

import 'package:flutter/services.dart';

DateTime currentDate;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  currentDate = DateTime.now();
  print("CURRENT TIME: $currentDate");
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formattedDateNow = formatter.format(currentDate);
  print(formattedDateNow);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: PrimaryColor,
        primarySwatch: Colors.grey,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _counter = 0;
  int _selectedIndex = 0;
  final List<Widget> _activities = [
    // StatisticsActivity(),
    HomeScreen(),
    CalculatorScreen(),
    StatisticsScreen(),
  ];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        // Here we take the value from theApp object that was created by
        // the App.build method, and use it to set our appbar title.
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(
          'Protein Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _activities[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            title: Text('Calculator'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            title: Text('Statistics'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: PrimaryColor,
        onTap: _onItemTapped,
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
