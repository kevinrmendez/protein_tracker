import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/proteinGoal.dart';
import 'package:protein_tracker/trackerScreen.dart';
import 'package:protein_tracker/widgetUtils.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          MotivationalText(),
          ProgressIndicator(),
          DailyStatus(),
          WidgetUtils.button(
            text: 'track protein',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => TrackerScreen()));
              print('track food');
            },
          ),
          // SizedBox(
          //   height: 10,
          // )
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
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          proteinGoalServices.currentConsumedProtein >=
                  proteinGoalServices.current
              ? 'You have reached your daily goal, well done!'
              : proteinGoalServices.currentConsumedProtein >=
                      proteinGoalServices.current / 4 * 3
                  ? 'You almost reach your goal, keep it up'
                  : proteinGoalServices.currentConsumedProtein >=
                          proteinGoalServices.current / 2
                      ? 'You are half way of your goal'
                      : proteinGoalServices.currentConsumedProtein >=
                              proteinGoalServices.current / 4
                          ? 'You are starting to eat protein'
                          : 'start tracking your protein intake',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white
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
                stream: proteinGoalServices.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    "goal: ${snapshot.data} gr",
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
                'remaining : ${proteinGoalServices.currentConsumedProtein > proteinGoalServices.current ? 0 : proteinGoalServices.current - proteinGoalServices.currentConsumedProtein} gr',
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

class ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.card(
      title: 'Consumed protein',
      child: Center(
        child: CircularStepProgressIndicator(
          totalSteps: proteinGoalServices.current,
          currentStep: proteinGoalServices.currentConsumedProtein,
          // stepSize: 0,
          selectedColor: PrimaryColor,
          unselectedColor: Colors.grey[200],
          // padding: 8,
          width: 200,
          height: 200,
          selectedStepSize: 15,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${proteinGoalServices.currentConsumedProtein}",
                      style: TextStyle(
                        fontSize: 80,
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
      ),
    );
  }
}
