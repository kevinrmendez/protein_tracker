import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/application/proteins/proteins.dart';
import 'package:protein_tracker/application/settings/settings_bloc.dart';
import 'package:protein_tracker/presentation/home_screen/widgets/daily_status.dart';
// import 'package:protein_tracker/ui/home_screen/widgets/daily_status_widget.dart';
import 'package:protein_tracker/presentation/home_screen/widgets/motivational_text_widget.dart';
import 'package:protein_tracker/presentation/home_screen/widgets/progress_indicator_widget.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';

import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              translatedText('dialog_close_app_title', context),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            content: new Text(
                translatedText('dialog_close_app_description', context)),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(translatedText('button_yes', context),
                    style: TextStyle(color: DarkGreyColor)),
              ),
              FlatButton(
                onPressed: () async {
                  // Navigator.of(context).pop(false);
                  String url = AppAssets.appUrl;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: new Text(
                  translatedText("button_review", context),
                  style: TextStyle(color: DarkGreyColor),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(translatedText('button_no', context),
                    style: TextStyle(color: DarkGreyColor)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Center(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ListView(
              children: <Widget>[
                WidgetUtils.screenTitle(
                    title: translatedText("title_today", context),
                    context: context),
                MotivationalText(goal: state.goal),
                DailyStatus(goal: state.goal),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: AdMobUtils.admobBanner()),
                ProgressIndicator(),
                ConsumedCalories(),
                SizedBox(
                  height: 40,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class ConsumedCalories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.card(
        title: translatedText(
          "home_label_calories_consumed",
          context,
        ),
        child: BlocBuilder<ProteinsBloc, ProteinsState>(
          builder: (BuildContext context, state) {
            if (state is ProteinsLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ProteinsLoadFailure) {
              return Center(
                  child:
                      Text('Sorry we are not able to load your information'));
            }
            var consumedproteins = (state as ProteinsLoadSuccess)
                .proteins
                .fold(0, (value, element) => value + element.amount);
            print(
                "PROTEINS LENGTH ${(state as ProteinsLoadSuccess).proteins.length}");
            return Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${consumedproteins * 4} cal",
                        style: TextStyle(fontSize: 28),
                      )
                    ])
              ],
            );
          },
        ));
  }
}

class ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.card(
        title: translatedText(
          "home_label_protein_consumed",
          context,
        ),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            print("STATE GOAL: ${state.goal}");
            return Container(
                height: 200,
                child:
                    Center(child: ProgressIndicatorWidget(goal: state.goal)));
          },
        ));
  }
}
