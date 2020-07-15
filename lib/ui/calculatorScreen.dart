import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Gender { male, female }
enum FemaleStatus { none, pregnant, lactanting }
enum ProteinGoal { maintenance, muscleGain, fatLoss }

class _MyHomePageState extends State<CalculatorScreen> {
  Gender _gender = Gender.male;
  FemaleStatus _femaleStatus = FemaleStatus.none;
  ProteinGoal _goal = ProteinGoal.maintenance;

  String dropdownValueActivity = 'sedentary';
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
              if (value is Gender) {
                _gender = value;
              }
              if (value is FemaleStatus) {
                _femaleStatus = value;
              }
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
    double proteinAmount = 0;
    int result;

    switch (dropdownValueActivity) {
      case "sedentary":
        {
          proteinAmount = 1.2;
        }
        break;
      case "moderate":
        {
          proteinAmount = 1.8;
        }
        break;
      case "active":
        {
          proteinAmount = 2;
        }
        break;

        break;
      default:
    }
    result = (proteinAmount * _weight).round();
    setState(() {
      proteinIntake = result;
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
                    _gender == Gender.female
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _radioButton(
                                'none',
                                _femaleStatus,
                                FemaleStatus.none,
                              ),
                              _radioButton(
                                'pregnant',
                                _femaleStatus,
                                FemaleStatus.pregnant,
                              ),
                              _radioButton(
                                'lactanting',
                                _femaleStatus,
                                FemaleStatus.lactanting,
                              )
                            ],
                          )
                        : SizedBox(),
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
                              value: dropdownValueActivity,
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
                                  dropdownValueActivity = newValue;
                                });
                              },
                              items: <String>[
                                'sedentary',
                                'moderate',
                                'active',
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
