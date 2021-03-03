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
  GlobalKey expansionTile = GlobalKey();
  @override
  void initState() {
    weightSettingsBool = intToBool(settingsService.currentWeightSettings);
    super.initState();
  }

  _buildLanguageTile(
      {String title,
      String languageCode,
      String countryCode,
      bool isSelected}) {
    return ListTile(
      onTap: () {
        BlocProvider.of<SettingsBloc>(context)
            .add(SettingsLocaleChanged(Locale(languageCode, countryCode)));
      },
      title: Text(
        title,
        style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
    );
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
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  print("StateWeight: ${state.weigthUnit}");
                  return Switch(
                      value: state.weigthUnit == 0 ? false : true,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(SettingsWeightUnitChanged(boolToInt(value)));
                      });
                },
              ),
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
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ExpansionTile(
              key: expansionTile,
              title: Text(translatedText("language", context)),
              children: [
                _buildLanguageTile(
                    title: translatedText("language_en", context),
                    languageCode: 'en',
                    countryCode: 'US',
                    isSelected: state.locale.languageCode == 'en'),
                _buildLanguageTile(
                  title: translatedText("language_es", context),
                  languageCode: 'es',
                  countryCode: 'ES',
                  isSelected: state.locale.languageCode == 'es',
                ),
                _buildLanguageTile(
                    title: translatedText("language_fr", context),
                    languageCode: 'fr',
                    countryCode: 'FR',
                    isSelected: state.locale.languageCode == 'fr'),
                _buildLanguageTile(
                    title: translatedText("language_pt", context),
                    languageCode: 'pt',
                    countryCode: 'PT',
                    isSelected: state.locale.languageCode == 'pt'),
              ],
            );
          },
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return SwitchListTile(
              title: const Text('darkMode'),
              onChanged: (value) {
                BlocProvider.of<SettingsBloc>(context)
                    .add(SettingsDarkModeChanged(value));
              },
              value: (BlocProvider.of<SettingsBloc>(context).state)
                  .isDarkModeEnabled,
            );
          },
        )
      ],
    );
  }
}
