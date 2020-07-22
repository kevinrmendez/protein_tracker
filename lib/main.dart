import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/bloc/FoodService.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/ui/StatisticsScreen.dart';
import 'package:protein_tracker/bloc/DateService.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/ui/calculatorScreen.dart';
import 'package:protein_tracker/ui/trackerScreen.dart';
import 'package:protein_tracker/ui/welcomeScreen.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/components/appDrawer.dart';
import 'package:protein_tracker/dao/food_dao.dart';
import 'package:protein_tracker/dao/protein_dao.dart';
import 'package:protein_tracker/ui/homeScreen.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/ui/settingsScreen.dart';

import 'package:flutter/services.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'app_localizations.dart';

DateTime currentDate;
var preferences;
String formattedDateNow;
String formattedDayCache;
enum Order { ascending, descending }

void resetState() {
  proteinService.resetConsumedProtein();
  print('state reseted');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(AdMobUtils.getAppId());

  currentDate = DateTime.now();
  print("CURRENT TIME: $currentDate");
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy');

  formattedDateNow = formatter.format(currentDate);
  formattedDayCache = formattedDateNow;

  // formattedDayCache = "19-July-2020"; //TEST
  print("FORMATEDDATENOW: $formattedDateNow");
  preferences = await SharedPreferences.getInstance();

  if (preferences.containsKey("first_time_open")) {
    preferences.setBool("first_time_open", false);
  } else {
    preferences.setBool("first_time_open", true);
  }

  // dateService.updateDate(currentDate);
  dateService.updateDateMonth(currentDate);
  proteinListServices.getMonthlyProtein(currentDate);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showWelcomeScreen;

  @override
  void initState() {
    super.initState();

    setState(() {
      showWelcomeScreen = preferences.getBool("first_time_open") ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'MX'),
        const Locale('es', 'AR'),
        const Locale('es', 'ES'),
        const Locale('es', 'GT'),
        // const Locale('hi', 'IN'),
        const Locale('fr', 'FR'),
        const Locale('pt', 'BR'),
        const Locale('pt', 'PT'),
        // const Locale('de', 'DE'),
        // const Locale('it', 'IT'),
      ],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      initialRoute: showWelcomeScreen ? '/welcome' : '/',
      routes: {
        '/': (context) => App(),
        '/welcome': (context) => WelcomeScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: "OpenSans",
          primaryColor: PrimaryColor,
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: BackgroundColor),

      // home: App(),
    );
  }
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Image appIcon;
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
  void initState() {
    super.initState();
    appIcon = Image.asset(
      AppAssets.app_icon,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(
      appIcon.image,
      context,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: BackgroundColor,
        iconTheme: new IconThemeData(color: PrimaryColor),
        elevation: 0.0,
        title: SizedBox(
          child: SvgPicture.asset(
            "assets/protein-tracker-icon.svg",
            height: 40,
            width: 40,
          ),
          height: 40,
          width: 40,
        ),
      ),
      body: _activities[_selectedIndex],
      floatingActionButton: new FloatingActionButton(
        backgroundColor: SecondaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => TrackerScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          // Container(
          // // height: 110,
          // child:
          //   Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // children: <Widget>[
          BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              translatedText(
                "menu_home",
                context,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            title: Text(
              translatedText(
                "menu_statistics",
                context,
              ),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: PrimaryColor,
        onTap: _onItemTapped,
      ),
      // Container(
      //     width: MediaQuery.of(context).size.width,
      //     child: AdMobUtils.admobBanner()),
      // ],
      // ),
      // ),
    );
  }
}
