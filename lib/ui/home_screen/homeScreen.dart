import 'package:flutter/material.dart';
import 'package:protein_tracker/ui/home_screen/widgets/daily_status_widget.dart';
import 'package:protein_tracker/ui/home_screen/widgets/motivational_text_widget.dart';
import 'package:protein_tracker/ui/home_screen/widgets/progress_indicator_widget.dart';

import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/fontStyle.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/model/goal.dart';

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
        child: ListView(
          children: <Widget>[
            WidgetUtils.screenTitle(
                title: translatedText("title_today", context),
                context: context),
            MotivationalText(),
            DailyStatus(),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: AdMobUtils.admobBanner()),
            ProgressIndicator(),
            ConsumedCalories(),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

class MotivationalText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Goal>.value(
          value: proteinService.stream,
        ),
        StreamProvider<int>.value(
          value: proteinService.streamConsumedProtein,
        )
      ],
      child: MotivationalTextWidget(),
    );
  }
}

class DailyStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<Goal>.value(
            value: proteinService.stream,
          ),
          StreamProvider<int>.value(
            value: proteinService.streamConsumedProtein,
          )
        ],
        child: WidgetUtils.card(
            title: translatedText(
              "home_label_goal",
              context,
            ),
            child: DailyStatusWidget()));
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
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                stream: proteinService.streamConsumedProtein,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var consumedproteins = snapshot.data ?? 0;
                  return Text(
                    "${consumedproteins * 4} cal",
                    style: TextStyle(fontSize: 28),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Goal>.value(
          value: proteinService.stream,
        ),
        StreamProvider<int>.value(
          value: proteinService.streamConsumedProtein,
        )
      ],
      child: WidgetUtils.card(
          title: translatedText(
            "home_label_protein_consumed",
            context,
          ),
          child: Center(child: ProgressIndicatorWidget())),
    );
  }
}
