import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/bloc/settings/settings_bloc.dart';
import 'package:scidart/numdart.dart';

import '../bloc/SettingsService.dart';
import '../services/export_data_service.dart';
import '../utils/localization_utils.dart';
import '../utils/widgetUtils.dart';
import 'aboutScreen.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        WidgetUtils.screenTitle(
            title: translatedText(
              "settings_title",
              context,
            ),
            context: context),
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
        Platform.isAndroid
            ? ListTile(
                title: Text(
                  translatedText(
                    "settings_export_csv",
                    context,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.import_export),
                  onPressed: () async {
                    print('exporting data');
                    ExportDataService.exportDataToEmail(
                      emailBody: translatedText("email_body", context),
                      emailSubject: translatedText("email_subject", context),
                    );
                  },
                ),
              )
            : SizedBox(),
        ListTile(
          onTap: () {
            BlocProvider.of<SettingsBloc>(context)
                .add(SettingsLocaleChanged(Locale('es', 'ES')));
          },
          title: Text('change to spanish'),
        ),
        ListTile(
          onTap: () {
            BlocProvider.of<SettingsBloc>(context)
                .add(SettingsLocaleChanged(Locale('en', 'US')));
          },
          title: Text('change to english'),
        )
      ],
    );
  }
}
