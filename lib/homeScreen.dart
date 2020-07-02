import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/proteinGoal.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularStepProgressIndicator(
            totalSteps: 100,
            currentStep: 74,
            stepSize: 10,
            selectedColor: PrimaryColor,
            unselectedColor: Colors.grey[200],
            padding: 0,
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
                        '40',
                        style: TextStyle(fontSize: 80),
                      ),
                      Text(
                        'gr',
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                  Text('consumed'),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.star),
              StreamBuilder(
                stream: proteinGoalServices.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text("goal: ${snapshot.data} gr");
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.timelapse), Text('remaining : 40gr')],
          ),
          RaisedButton(
            color: PrimaryColor,
            child: Text(
              'track protein',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              print('track food');
            },
          )
        ],
      ),
    );
  }
}
