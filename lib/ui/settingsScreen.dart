import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/SettingsService.dart';
import 'package:protein_tracker/ui/aboutScreen.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:scidart/numdart.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow('Settings', context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('About the app'),
            trailing: Icon(Icons.info),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AboutScreen()));
            },
          ),
          ListTile(
            title: Text('Weight Unit'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('lb'),
                Switch(
                    value: intToBool(settingsService.currentWeightSettings),
                    onChanged: (value) {
                      int weightSettings = value ? 1 : 0;
                      settingsService.updateWeightSettings(weightSettings);
                    }),
                Text('kg')
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AboutScreen()));
            },
          ),
        ],
      ),
    );
  }
}
