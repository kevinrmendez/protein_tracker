import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/DailyProteinService.dart';
import 'package:protein_tracker/model/goal.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/ui/trackerScreen.dart';
import 'package:protein_tracker/utils/fontStyle.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Text(
              translatedText(
                "title_today",
                context,
              ),
              textAlign: TextAlign.center,
              style: AppFontStyle.title,
            ),
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

class MotivationalTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Goal initGoal = Goal(1);
    Goal proteinGoal = Provider.of<Goal>(context) ?? initGoal;
    int consumedProtein = Provider.of<int>(context) ?? 0;
    int goal;
    if (proteinGoal == null) {
      return SizedBox();
    } else {
      goal = proteinGoal.amount;
      return WidgetUtils.card(
        color: consumedProtein >= goal ? GreenColor : PrimaryColor,
        title: translatedText(
          "home_label_status",
          context,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            consumedProtein >= goal
                ? translatedText(
                    "home_motivational_5_completed",
                    context,
                  )
                : consumedProtein >= goal / 4 * 3
                    ? translatedText(
                        "home_motivational_4_halfway",
                        context,
                      )
                    : consumedProtein >= goal / 2
                        ? translatedText(
                            "home_motivational_3_halfway",
                            context,
                          )
                        : consumedProtein >= goal / 4
                            ? translatedText(
                                "home_motivational_2_continue_tracking",
                                context,
                              )
                            : consumedProtein == 0
                                ? translatedText(
                                    "home_motivational_0_start_tracking",
                                    context,
                                  )
                                : translatedText(
                                    "home_motivational_1_started_tracking",
                                    context,
                                  ),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
                // color: DarkGreyColor,
                ),
          ),
        ),
      );
    }
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

class DailyStatusWidget extends StatelessWidget {
  // FOR TESTING DAILY PROTEIN DATA
  // _buildDailyProtein() {
  //   return Row(
  //     children: <Widget>[
  //       Text('dailyProtein: '),
  //       Column(
  //           children: dailyProteinServices.currentList
  //               .map((e) => Text(e.totalProtein.toString()))
  //               .toList()),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Goal initGoal = Goal(1);
    Goal proteinGoal = Provider.of<Goal>(context) ?? initGoal;
    int consumedProtein = Provider.of<int>(context) ?? 0;
    int goal;
    if (proteinGoal == null) {
      return SizedBox();
    } else {
      goal = proteinGoal.amount;
      var remainingProtein = goal - consumedProtein;
      remainingProtein = remainingProtein > 0 ? remainingProtein : 0;
      return Column(
        children: <Widget>[
          // _buildDailyProtein(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.star,
                color: DarkGreyColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${translatedText(
                  "text_goal",
                  context,
                )}: $goal gr',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.timelapse,
                color: DarkGreyColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                ' ${translatedText(
                  "text_remaining",
                  context,
                )} : ${remainingProtein ?? 0} gr',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ],
      );
    }
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

class ProgressIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Goal initGoal = Goal(1);
    Goal proteinGoal = Provider.of<Goal>(context) ?? initGoal;
    int consumedProtein = Provider.of<int>(context) ?? 0;
    int goal;
    if (proteinGoal == null) {
      return CircularProgressIndicator();
    } else {
      goal = proteinGoal.amount;
      return CircularStepProgressIndicator(
        totalSteps: goal,
        currentStep: consumedProtein,
        // stepSize: 0,
        selectedColor: PrimaryColor,
        unselectedColor: Colors.grey[200],
        // padding: 8,
        width: 180,
        height: 180,
        selectedStepSize: 15,
        child: Center(
            child: Container(
          child: Wrap(
            runSpacing: -25,
            // direction: Axis.vertical,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(
                "$consumedProtein",
                style: TextStyle(
                  fontSize: 60,
                ),
              ),
              Text(
                'gr',
                style: TextStyle(fontSize: 30),
              )
            ],
          ),
        )

            // Text('consumed'),
            ),
      );
    }
  }
}
