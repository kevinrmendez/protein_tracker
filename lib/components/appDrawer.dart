import 'dart:io';

import 'package:flutter/material.dart';
import 'package:protein_tracker/ui/FoodListScreen.dart';
import 'package:protein_tracker/ui/calculator_screen/calculatorScreen.dart';
import 'package:protein_tracker/ui/calendar_screen.dart/calendarScreen.dart';
import 'package:protein_tracker/ui/welcome_screen/welcomeScreen.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/ui/goalScreen.dart';
import 'package:protein_tracker/ui/settingsScreen.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Drawer(
        child: Container(
          // color: Theme.of(context).backgroundColor,
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
              Platform.isAndroid
                  ? ListTile(
                      title: Text(
                        translatedText(
                          "app_drawer_review_app",
                          context,
                        ),
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
                    )
                  : SizedBox(),
              Platform.isAndroid
                  ? ListTile(
                      title: Text(
                        translatedText(
                          "app_drawer_share",
                          context,
                        ),
                      ),
                      trailing: Icon(
                        Icons.share,
                        // color: Theme.of(context).accentColor,
                      ),
                      onTap: () {
                        String url = AppAssets.appUrl;
                        print('sharing');
                        Share.share("${translatedText(
                          'text_share_app',
                          context,
                        )} $url");
                      },
                    )
                  : SizedBox(),
              ListTile(
                title: Text(
                  "Welcome",
                ),
                trailing: Icon(
                  Icons.settings,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WelcomeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
