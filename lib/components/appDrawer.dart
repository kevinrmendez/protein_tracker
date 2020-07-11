import 'package:flutter/material.dart';
import 'package:protein_tracker/FoodListScreen.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/goalScreen.dart';
import 'package:protein_tracker/homeScreen.dart';
import 'package:protein_tracker/settingsScreen.dart';

import '../main.dart';

class AppDrawer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: Drawer(
        child: Container(
          color: GreyColor,
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
                  "Home",
                  // style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                trailing: Icon(
                  Icons.home,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => App()));
                },
              ),
              ListTile(
                title: Text(
                  "Goal",
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
                  "Food List",
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
                  "Settings",
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
            ],
          ),
        ),
      ),
    );
  }
}
