import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/trackerScreen.dart';
import 'package:protein_tracker/utils/fontStyle.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          Text(
            "Today",
            textAlign: TextAlign.center,
            style: AppFontStyle.title,
          ),
          // RaisedButton(
          //   child: Text("reset"),
          //   onPressed: () {
          //     print('reset');
          //     resetState();
          //   },
          // ),
          MotivationalText(),
          DailyStatus(),
          ProgressIndicator(),
          ConsumedCalories(),
        ],
      ),
    );
  }
}

class MotivationalText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.card(
      color: PrimaryColor,
      title: 'Status',
      child: Container(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
        child: Text(
          proteinService.currentConsumedProtein >= proteinService.current
              ? 'You have reached your daily goal, well done!'
              : proteinService.currentConsumedProtein >=
                      proteinService.current / 4 * 3
                  ? 'You almost reach your goal, keep it up'
                  : proteinService.currentConsumedProtein >=
                          proteinService.current / 2
                      ? 'You are half way of your goal'
                      : proteinService.currentConsumedProtein >=
                              proteinService.current / 4
                          ? 'You are starting to eat protein'
                          : 'start tracking your protein intake',
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

class DailyStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.card(
      title: 'Goal',
      child: Column(
        children: <Widget>[
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
              StreamBuilder(
                stream: proteinService.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var goal = snapshot.data ?? 0;
                  return Text(
                    "goal: $goal gr",
                    style: TextStyle(fontSize: 16),
                  );
                },
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
                'remaining : ${proteinService.currentConsumedProtein > proteinService.current ? 0 : proteinService.current - proteinService.currentConsumedProtein} gr',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Icon(Icons.timelapse),
          //     Text(
          //       'avarage daily protein intake : 40gr',
          //       style: TextStyle(fontSize: 18),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}

class ConsumedCalories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.card(
      title: 'Calories consumed from protein',
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
    return WidgetUtils.card(
      title: 'Protein consumed',
      child: StreamBuilder(
          stream: proteinService.streamConsumedProtein,
          builder: (context, snapshot) {
            var consumedproteins = snapshot.data ?? 0;
            return Center(
              child: CircularStepProgressIndicator(
                totalSteps: proteinService.current,
                currentStep: consumedproteins,
                // stepSize: 0,
                selectedColor: PrimaryColor,
                unselectedColor: Colors.grey[200],
                // padding: 8,
                width: 180,
                height: 180,
                selectedStepSize: 15,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$consumedproteins",
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
                      // Text('consumed'),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
