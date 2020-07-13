import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

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
  bool _isCalculated;
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

  Widget _subtitle(text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  int calculateProteinIntake() {
    setState(() {
      proteinIntake = 40;
      _isCalculated = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _weight = 65;
    _weightRounded = _weight.round();
    _isCalculated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow('Protein intake calculator', context),
      body: Center(
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: WidgetUtils.card(
                  color: PrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          " $proteinIntake",
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ),
                      ),
                      Text(
                        'gr',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[],
                    ),
                    _subtitle('Weight'),
                    Text("$_weightRounded kg"),
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
                        _subtitle('Gender'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                    Column(
                      children: <Widget>[
                        _subtitle('Activity'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        _subtitle('Goal'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                      ],
                    ),
                  ],
                )),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: WidgetUtils.button(
                  text: 'calculate',
                  onPressed: () {
                    calculateProteinIntake();
                  },
                ),
              ),
              _isCalculated
                  ? WidgetUtils.button(
                      text: 'set as protein goal',
                      onPressed: () {
                        proteinService.setGoal(proteinIntake);
                        showDialog(
                            context: context,
                            builder: (_) => GoalChangeDialog());
                      })
                  : SizedBox()
            ],
          ),
        ]),
      ),
    );
  }
}

class GoalChangeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .34,
        title: 'Protein Goal',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'your daily protein intake goal has been changed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              WidgetUtils.button(
                  text: 'close',
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ));
    ;
  }
}
