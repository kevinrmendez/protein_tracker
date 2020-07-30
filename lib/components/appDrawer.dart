import 'package:flutter/material.dart';
import 'package:protein_tracker/ui/FoodListScreen.dart';
import 'package:protein_tracker/ui/calculatorScreen.dart';
import 'package:protein_tracker/ui/calendarScreen.dart';
import 'package:protein_tracker/ui/welcomeScreen.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/ui/goalScreen.dart';
import 'package:protein_tracker/ui/settingsScreen.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Drawer(
        child: Container(
          color: BackgroundColor,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: SizedBox(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/drawer-header.jpg'),
                      fit: BoxFit.cover),
                  // color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text(
                  translatedText(
                    "app_drawer_goal",
                    context,
                  ),
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.star,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GoalScreen()));
                },
              ),
              ListTile(
                title: Text(
                  translatedText(
                    "app_drawer_food_list",
                    context,
                  ),
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.room_service,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => FoodListScreen()));
                },
              ),
              ListTile(
                title: Text(
                  translatedText(
                    "app_drawer_food_calculator",
                    context,
                  ),
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.phone_android,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CalculatorScreen()));
                },
              ),
              ListTile(
                title: Text(
                  translatedText(
                    "app_drawer_calendar",
                    context,
                  ),
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CalendarScreen()));
                },
              ),

              ListTile(
                title: Text(
                  translatedText(
                    "app_drawer_review_app",
                    context,
                  ),

                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.rate_review,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () async {
                  String url = AppAssets.appUrl;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              ListTile(
                title: Text(
                  translatedText(
                    "app_drawer_food_settings",
                    context,
                  ),
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.settings,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SettingsScreen()));
                },
              ),

              // ListTile(
              //   title: Text(
              //     "Welcome",
              //     // style: TextStyle(color: Theme.of(context).primaryColor),
              //   ),
              //   trailing: Icon(
              //     Icons.settings,
              //     color: Theme.of(context).accentColor,
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (BuildContext context) => WelcomeScreen()));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
