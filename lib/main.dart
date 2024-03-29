import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/bloc/settings/settings_bloc.dart';
import 'package:protein_tracker/repository/settings_repository.dart';
import 'bloc/ProteinListService.dart';
import 'ui/statistics_screen/statistics_screen.dart';
import 'bloc/DateService.dart';
import 'bloc/ProteinService.dart';
import 'ui/trackerScreen.dart';
import 'ui/welcome_screen/welcomeScreen.dart';
import 'ui/calendar_screen.dart/calendarScreen.dart';
import 'ui/settingsScreen.dart';
import 'utils/AdMobUtils.dart';
import 'utils/appAssets.dart';
import 'utils/colors.dart';
import 'components/appDrawer.dart';

import 'package:protein_tracker/ui/home_screen/homeScreen.dart';

import 'package:flutter/services.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/ui/core/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'apikeys.dart';
import 'app_localizations.dart';
import 'injection.dart';

// import 'package:cron/cron.dart';

DateTime currentDate;
SharedPreferences preferences;
String formattedDateNow;
String formattedDayCache;
enum Order { ascending, descending }
RegExp regExp = RegExp(r'^[0-9]+$');

void resetState() {
  proteinService.resetConsumedProtein();
  print('state reseted');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);
  Admob.initialize(apikeys["appId"]);
  // Admob.initialize();

  currentDate = DateTime.now();
  print("CURRENT TIME: $currentDate");
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy');

  formattedDateNow = formatter.format(currentDate);
  formattedDayCache = formattedDateNow;

  //RESET CONSUMED PROTEIN ON APP OPEN
  final DateFormat formatterDay = DateFormat('d');
  var todayDay = int.parse(formatterDay.format(currentDate));
  // var todayDay = 27;

  // formattedDayCache = "19-July-2020"; //TEST
  print("FORMATEDDATENOW: $formattedDateNow");
  preferences = await SharedPreferences.getInstance();

  if (preferences.containsKey("first_time_open")) {
    preferences.setBool("first_time_open", false);
  } else {
    preferences.setBool("first_time_open", true);
  }

  //SAVE DATE IN CACHE FOR FIRST TIME
  if (!preferences.containsKey("cache_day")) {
    await preferences.setInt("cache_day", todayDay);
  }

  // dateService.updateDate(currentDate);
  dateService.updateDateMonth(currentDate);
  proteinListServices.getMonthlyProtein(currentDate);
  SettingsRepository settingsRepository = SettingsRepository();

  runApp(BlocProvider(
    // create: (context) => SettingsBloc(),
    create: (context) => getIt<SettingsBloc>(),
    child: MyApp(),
  ));
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
    _restartApp();

    setState(() {
      showWelcomeScreen = preferences.getBool("first_time_open") ?? true;
    });
  }

  _restartApp() async {
    final DateFormat formatterDay = DateFormat('d');
    var todayDay = int.parse(formatterDay.format(currentDate));

    var preferencesDay = await preferences.getInt("cache_day");
    if (preferencesDay != todayDay) {
      proteinService.resetConsumedProtein();
      await preferences.setInt("cache_day", todayDay);
      // var preferencesDay = preferences.getInt("cache_day");
      // assert(preferencesDay == todayDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        print('STATE: ${state.isDarkModeEnabled}');
        return MaterialApp(
          themeMode: state.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
          darkTheme:
              state.isDarkModeEnabled ? AppTheme.dark() : AppTheme.light(),
          // locale: Locale('es', 'MX'),
          // locale: Locale('es', 'MX'),
          locale: state.locale ?? Locale('en'),
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
          theme: state.isDarkModeEnabled ? AppTheme.dark() : AppTheme.light(),
        );
      },
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
  int _selectedIndex = 0;
  final List<Widget> _activities = [
    // StatisticsActivity(),
    HomeScreen(),
    StatisticsScreen(),
    CalendarScreen(),
    SettingsScreen(),
  ];

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
        backgroundColor: Theme.of(context).backgroundColor,
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
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: MenuIcon(Icons.home), title: SizedBox()),
          BottomNavigationBarItem(
              icon: MenuIcon(
                Icons.poll,
              ),
              title: SizedBox()),
          BottomNavigationBarItem(
              icon: MenuIcon(Icons.calendar_today), title: SizedBox()),
          BottomNavigationBarItem(
              icon: MenuIcon(Icons.settings), title: SizedBox()),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: PrimaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MenuIcon extends StatelessWidget {
  final IconData icon;
  MenuIcon(this.icon);
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 27,
    );
  }
}
