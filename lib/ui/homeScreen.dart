import 'package:flutter/material.dart';
import 'package:protein_tracker/model/goal.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/ui/trackerScreen.dart';
import 'package:protein_tracker/utils/fontStyle.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:provider/provider.dart';
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
        title: 'Status',
        child: Container(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            consumedProtein >= goal
                ? 'You have reached your daily goal, well done!'
                : consumedProtein >= goal / 4 * 3
                    ? 'You almost reach your goal, keep it up'
                    : consumedProtein >= goal / 2
                        ? 'You are more than half way of your goal'
                        : consumedProtein >= goal / 4
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
}

class DailyStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<Goal>.value(
        value: proteinService.stream,
      ),
      StreamProvider<int>.value(
        value: proteinService.streamConsumedProtein,
      )
    ], child: WidgetUtils.card(title: 'Goal', child: DailyStatusWidget()));
  }
}

class DailyStatusWidget extends StatelessWidget {
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
                "goal: $goal gr",
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
                'remaining : ${remainingProtein ?? 0} gr',
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
          title: 'Protein consumed',
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
