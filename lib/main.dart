import 'package:flutter/material.dart';
import 'package:protein_tracker/calculatorScreen.dart';
import 'package:protein_tracker/components/appDrawer.dart';
import 'package:protein_tracker/homeScreen.dart';
import 'package:protein_tracker/settingsScreen.dart';

void main() => runApp(MyApp());

const PrimaryColor = const Color(0xFF00BCD4);
const GreyColor = const Color(0xFFEEEEEE);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    SettingsScreen()
  ];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        // Here we take the value from theApp object that was created by
        // the App.build method, and use it to set our appbar title.
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(
          'Protein Tracker',
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
            icon: Icon(Icons.settings),
            title: Text('Settings'),
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
