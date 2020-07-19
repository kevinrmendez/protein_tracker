import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/SettingsService.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:scidart/numdart.dart';

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
  final weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String dropdownValueActivity = 'sedentary';
  String dropdownValueGoal = 'maintenance';
  int proteinIntake = 0;
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

  calculateProteinIntake() {
    double proteinAmount = 0;
    int result;

    switch (dropdownValueActivity) {
      case "sedentary":
        {
          switch (dropdownValueGoal) {
            case "maintenance":
              {
                proteinAmount = 1.2;
              }
              break;
            case "muscle gain":
              {
                proteinAmount = 1.4;
              }
              break;
            case "fat loss":
              {
                proteinAmount = 1.2;
              }
              break;

              break;
            default:
          }
        }
        break;
      case "moderate":
        {
          switch (dropdownValueGoal) {
            case "maintenance":
              {
                proteinAmount = 1.4;
              }
              break;
            case "muscle gain":
              {
                proteinAmount = 2;
              }
              break;
            case "fat loss":
              {
                proteinAmount = 1.3;
              }
              break;

            default:
          }
        }
        break;
      case "active":
        {
          switch (dropdownValueGoal) {
            case "maintenance":
              {
                proteinAmount = 1.6;
              }
              break;
            case "muscle gain":
              {
                proteinAmount = 2.7;
              }
              break;
            case "fat loss":
              {
                proteinAmount = 1.4;
              }
              break;
            default:
          }
        }
        break;
      default:
    }
    if (_femaleStatus != FemaleStatus.none) {
      switch (_femaleStatus) {
        case FemaleStatus.pregnant:
          {
            proteinAmount = 1.8;
          }
          break;
        case FemaleStatus.lactanting:
          {
            proteinAmount = 1.5;
          }
          break;

          break;
        default:
      }
    }
    //calculate protein intake
    result = (proteinAmount * _weight).round();

    //convert lbs to kgs
    if (settingsService.currentWeightSettings == 0) {
      result = (result * .45359237).round();
    }

    setState(() {
      proteinIntake = result;
      _isCalculated = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _weight = 0;
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
            children: <Widget>[
              Container(
                child: WidgetUtils.card(
                  color: PrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
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
                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _subtitle('Weight'),
                        Text(settingsService.currentWeightSettings == 0
                            ? 'lb'
                            : 'kg'),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'weight',
                            ),
                            validator: (value) {
                              int weightLimit = intToBool(
                                      settingsService.currentWeightSettings)
                                  ? 600
                                  : 1300;

                              if (value.isEmpty) {
                                return 'add your weight';
                              }
                              if (value == "0") {
                                return 'your weight must be greater than 0';
                              }
                              if (int.parse(value) > weightLimit)
                                return 'your weight is too high';
                            },
                            onChanged: (weight) {
                              setState(() {
                                _weight = double.parse(weight);
                                _weightRounded = _weight.round();
                              });
                            },
                          ),
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                padding: EdgeInsets.symmetric(vertical: 0),
                child: WidgetUtils.button(
                  context,
                  color: DarkGreyColor,
                  text: 'calculate',
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      calculateProteinIntake();
                    }
                  },
                ),
              ),
              _isCalculated
                  ? WidgetUtils.button(context,
                      text: 'set as protein goal',
                      color: DarkGreyColor, onPressed: () {
                      proteinService.setGoal(proteinIntake);
                      showDialog(
                          context: context, builder: (_) => GoalChangeDialog());
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
              WidgetUtils.button(context, text: 'close', onPressed: () {
                Navigator.pop(context);
              })
            ],
          ),
        ));
    ;
  }
}
