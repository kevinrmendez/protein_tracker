import 'dart:io';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:scidart/numdart.dart';

import 'package:protein_tracker/bloc/DailyProteinService.dart';
import 'package:protein_tracker/bloc/SettingsService.dart';
import 'package:protein_tracker/model/dailyProtein.dart';
import 'package:protein_tracker/ui/aboutScreen.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

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
          ListTile(
            title: Text(
              "export data as csv",
            ),
            trailing: IconButton(
              icon: Icon(Icons.import_export),
              onPressed: () async {
                print('exporting data');
                _exportData();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _exportData() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.absolute.path;
    print(path);
    File file = File('$path/protein.csv');
    List<DailyProtein> dailyProtein = dailyProteinServices.currentList;
    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i < dailyProtein.length; i++) {
      if (i == 0) {
        List<dynamic> header = List();
        header.add("");
        header.add("date");
        header.add("goal");
        header.add("daily protein");
        header.add("goal achieved");
        rows.add(header);
      }
      List<dynamic> row = List();
      row.add(dailyProtein[i].id);
      row.add(dailyProtein[i].date);
      row.add(dailyProtein[i].goal);
      row.add(dailyProtein[i].totalProtein);
      row.add(dailyProtein[i].isGoalAchieved == 1 ? "yes" : "no");
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);

    file.writeAsString(csv);
    String filePath = '$path/protein.csv';

    filePath = file.path;

    final Email email = Email(
        body: translatedText("email_body", context),
        subject: translatedText("email_subject", context),
        // recipients: ['example@example.com'],
        attachmentPaths: [filePath]);
    print("FILEPATHS: ${filePath.toString()}");
    await FlutterEmailSender.send(email);
    print('file email sended');
  }
}
