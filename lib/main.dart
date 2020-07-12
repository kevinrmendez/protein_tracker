import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/StatisticsScreen.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/calculatorScreen.dart';
import 'package:protein_tracker/trackerScreen.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/components/appDrawer.dart';
import 'package:protein_tracker/dao/food_dao.dart';
import 'package:protein_tracker/dao/protein_dao.dart';
import 'package:protein_tracker/homeScreen.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/settingsScreen.dart';

import 'package:flutter/services.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime currentDate;
var preferences;
String formattedDateNow;

void resetState() {
  proteinService.resetConsumedProtein();
  print('state reseted');
}

void getDailyproteinListfromDb() {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  currentDate = DateTime.now();
  print("CURRENT TIME: $currentDate");
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  formattedDateNow = formatter.format(currentDate);
  preferences = await SharedPreferences.getInstance();
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
      appBar: WidgetUtils.appBar('Protein Tracker'),
      body: _activities[_selectedIndex],
      floatingActionButton: new FloatingActionButton(
        backgroundColor: PrimaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => TrackerScreen()));
          print('track food');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
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
    );
  }
}
