import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/SettingsService.dart';
import 'package:protein_tracker/ui/aboutScreen.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:scidart/numdart.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool weightSettingsBool;
  @override
  void initState() {
    weightSettingsBool = intToBool(settingsService.currentWeightSettings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow(
          translatedText(
            "appbar_settings",
            context,
          ),
          context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              translatedText(
                "settings_text_about",
                context,
              ),
            ),
            trailing: Icon(Icons.info),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AboutScreen()));
            },
          ),
          ListTile(
            title: Text(
              translatedText(
                "settings_text_weight",
                context,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('lb'),
                Switch(
                    value: weightSettingsBool,
                    onChanged: (value) {
                      setState(() {
                        weightSettingsBool = value;
                      });
                      settingsService.updateWeightSettings(boolToInt(value));
                    }),
                Text('kg')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
