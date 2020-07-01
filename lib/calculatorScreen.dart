import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key key, this.title}) : super(key: key);

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

enum Gender { male, female }
enum ProteinGoal { maintenance, muscleGain, fatLoss }

class _MyHomePageState extends State<CalculatorScreen> {
  Gender _gender = Gender.male;
  ProteinGoal _goal = ProteinGoal.maintenance;

  String dropdownValue = 'sedentary';
  String dropdownValueGoal = 'maintenance';
  int proteinIntake = 20;
  int _counter = 0;
  int _selectedIndex = 0;
  double _weight;
  int _weightRounded;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget _radioButton(
    String label,
    groupValue,
    value,
  ) {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: PrimaryColor,
          value: value,
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
        ),
        Text(label)
      ],
    );
  }

  int calculateProteinIntake() {
    setState(() {
      proteinIntake = 40;
    });
  }

  @override
  void initState() {
    super.initState();
    _weight = 65;
    _weightRounded = _weight.round();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: ListView(children: <Widget>[
        Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    " $proteinIntake",
                    style: TextStyle(fontSize: 70),
                  ),
                ),
                Text(
                  'gr',
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Weight'),
                  Text(" $_weightRounded"),
                  Slider(
                    activeColor: PrimaryColor,
                    label: 'weight',
                    value: _weight,
                    onChanged: (weight) {
                      setState(() {
                        _weight = weight;
                        _weightRounded = weight.round();
                      });
                    },
                    min: 0,
                    max: 500,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Gender'),
                          _radioButton(
                            'male',
                            _gender,
                            Gender.male,
                          ),
                          _radioButton(
                            'female',
                            _gender,
                            Gender.female,
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('activity'),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: PrimaryColor),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'sedentary',
                          'moderate',
                          'active',
                          'very active'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('goal'),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: dropdownValueGoal,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: PrimaryColor),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValueGoal = newValue;
                          });
                        },
                        items: <String>[
                          'maintenance',
                          'muscle gain',
                          'fat loss'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  RaisedButton(
                    child: Text('calculate'),
                    onPressed: () {
                      calculateProteinIntake();
                    },
                  )
                ],
              )),
            )
          ],
        ),
      ]),
    );
  }
}
