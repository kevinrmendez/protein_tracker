import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

import 'package:protein_tracker/bloc/SettingsService.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:protein_tracker/utils/colors.dart';

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Gender { male, female }
enum FemaleStatus { none, pregnant, lactanting }
enum ProteinGoal { none, maintenance, muscleGain, fatLoss }
enum Activity { none, sedentary, moderate, active }

class _MyHomePageState extends State<CalculatorScreen> {
  Gender _gender = Gender.male;
  FemaleStatus _femaleStatus = FemaleStatus.none;
  ProteinGoal _goal = ProteinGoal.maintenance;
  final weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Activity dropdownValueActivity = Activity.none;
  ProteinGoal dropdownValueGoal = ProteinGoal.none;
  int proteinIntake = 0;
  int _counter = 0;
  int _selectedIndex = 0;
  bool _isCalculated;
  double _weight;
  int _weightRounded;

  List<Activity> activityList = [
    Activity.none,
    Activity.sedentary,
    Activity.moderate,
    Activity.active
  ];
  List<ProteinGoal> goalList = [
    ProteinGoal.none,
    ProteinGoal.maintenance,
    ProteinGoal.muscleGain,
    ProteinGoal.fatLoss,
  ];

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
      case Activity.sedentary:
        {
          switch (dropdownValueGoal) {
            case ProteinGoal.maintenance:
              {
                proteinAmount = 1.2;
              }
              break;
            case ProteinGoal.muscleGain:
              {
                proteinAmount = 1.4;
              }
              break;
            case ProteinGoal.fatLoss:
              {
                proteinAmount = 1.2;
              }
              break;

              break;
            default:
          }
        }
        break;
      case Activity.moderate:
        {
          switch (dropdownValueGoal) {
            case ProteinGoal.maintenance:
              {
                proteinAmount = 1.4;
              }
              break;
            case ProteinGoal.muscleGain:
              {
                proteinAmount = 2;
              }
              break;
            case ProteinGoal.fatLoss:
              {
                proteinAmount = 1.3;
              }
              break;

            default:
          }
        }
        break;
      case Activity.active:
        {
          switch (dropdownValueGoal) {
            case ProteinGoal.maintenance:
              {
                proteinAmount = 1.6;
              }
              break;
            case ProteinGoal.muscleGain:
              {
                proteinAmount = 2.7;
              }
              break;
            case ProteinGoal.fatLoss:
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
    String getDropDownActivityText(Activity activity) {
      switch (activity) {
        case Activity.none:
          {
            return '';
          }
        case Activity.sedentary:
          {
            return translatedText(
              "calculator_dropDownValue_activity_sedentary",
              context,
            );
          }
        case Activity.moderate:
          {
            return translatedText(
              "calculator_dropDownValue_activity_moderate",
              context,
            );
          }
        case Activity.active:
          {
            return translatedText(
              "calculator_dropDownValue_activity_active",
              context,
            );
          }

          break;
        default:
      }
    }

    String getDropDownProteinGoalText(ProteinGoal goal) {
      switch (goal) {
        case ProteinGoal.none:
          {
            return '';
          }
        case ProteinGoal.maintenance:
          {
            return translatedText(
              "calculator_dropDownValue_activity_maintenance",
              context,
            );
          }
        case ProteinGoal.muscleGain:
          {
            return translatedText(
              "calculator_dropDownValue_activity_muscle_gain",
              context,
            );
          }
        case ProteinGoal.fatLoss:
          {
            return translatedText(
              "calculator_dropDownValue_activity_fat_loss",
              context,
            );
          }

          break;
        default:
      }
    }

    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow(
          translatedText(
            "appbar_calculator",
            context,
          ),
          context),
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
                        _subtitle(
                          translatedText(
                            "calculator_subtitle_weight",
                            context,
                          ),
                        ),
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
                              labelText: translatedText(
                                "calculator_label_weight",
                                context,
                              ),
                            ),
                            validator: (value) {
                              int weightLimit = intToBool(
                                      settingsService.currentWeightSettings)
                                  ? 600
                                  : 1300;

                              if (value.isEmpty) {
                                return translatedText(
                                  "calculator_error_emptyValue",
                                  context,
                                );
                              }
                              if (value == "0") {
                                return translatedText(
                                  "calculator_error_value_0",
                                  context,
                                );
                              }
                              if (int.parse(value) > weightLimit)
                                return translatedText(
                                  "calculator_error_value_too_high",
                                  context,
                                );
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
                            _subtitle(
                              translatedText(
                                "calculator_subtitle_gender",
                                context,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _radioButton(
                                  translatedText(
                                    "calculator_radio_button_gender_male",
                                    context,
                                  ),
                                  _gender,
                                  Gender.male,
                                ),
                                _radioButton(
                                  translatedText(
                                    "calculator_radio_button_gender_female",
                                    context,
                                  ),
                                  _gender,
                                  Gender.female,
                                )
                              ],
                            ),
                          ],
                        ),
                        _gender == Gender.female
                            ? Wrap(
                                direction: Axis.vertical,
                                // alignment: WrapAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _radioButton(
                                    translatedText(
                                      "calculator_radio_button_gender_female_none",
                                      context,
                                    ),
                                    _femaleStatus,
                                    FemaleStatus.none,
                                  ),
                                  _radioButton(
                                    translatedText(
                                      "calculator_radio_button_gender_female_pregnant",
                                      context,
                                    ),
                                    _femaleStatus,
                                    FemaleStatus.pregnant,
                                  ),
                                  _radioButton(
                                    translatedText(
                                      "calculator_radio_button_gender_female_lactanting",
                                      context,
                                    ),
                                    _femaleStatus,
                                    FemaleStatus.lactanting,
                                  )
                                ],
                              )
                            : SizedBox(),
                        Column(
                          children: <Widget>[
                            _subtitle(
                              translatedText(
                                "calculator_subtitle_activity",
                                context,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                DropdownButton<Activity>(
                                  value: dropdownValueActivity,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: PrimaryColor),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (Activity newValue) {
                                    setState(() {
                                      dropdownValueActivity = newValue;
                                    });
                                  },
                                  items: activityList
                                      .map<DropdownMenuItem<Activity>>(
                                          (Activity value) {
                                    return DropdownMenuItem<Activity>(
                                      value: value,
                                      child:
                                          Text(getDropDownActivityText(value)),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            _subtitle(
                              translatedText(
                                "calculator_subtitle_goal",
                                context,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                DropdownButton<ProteinGoal>(
                                  value: dropdownValueGoal,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: PrimaryColor),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (ProteinGoal newValue) {
                                    setState(() {
                                      dropdownValueGoal = newValue;
                                    });
                                  },
                                  items: goalList
                                      .map<DropdownMenuItem<ProteinGoal>>(
                                          (ProteinGoal value) {
                                    return DropdownMenuItem<ProteinGoal>(
                                      value: value,
                                      child: Text(
                                          getDropDownProteinGoalText(value)),
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
              WidgetUtils.button(
                context,
                width: MediaQuery.of(context).size.width,
                color: DarkGreyColor,
                text: translatedText(
                  "calculator_button_calculate",
                  context,
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (dropdownValueGoal == ProteinGoal.none ||
                        dropdownValueActivity == Activity.none) {
                      showDialog(
                          context: context, builder: (_) => ErrorDialog());
                    } else {
                      calculateProteinIntake();
                    }
                  }
                },
              ),
              _isCalculated
                  ? WidgetUtils.button(context,
                      width: MediaQuery.of(context).size.width,
                      text: translatedText(
                        "calculator_button_protein_goal",
                        context,
                      ),
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
        title: translatedText(
          "calculator_dialog_goal_change_title",
          context,
        ),
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  translatedText(
                    "calculator_dialog_goal_change_text",
                    context,
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              WidgetUtils.button(context,
                  width: MediaQuery.of(context).size.width,
                  color: DarkGreyColor,
                  text: translatedText(
                    "calculator_button_close",
                    context,
                  ), onPressed: () {
                Navigator.pop(context);
              })
            ],
          ),
        ));
  }
}

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .4,
        title: translatedText(
          "calculator_dialog_error_title",
          context,
        ),
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  translatedText(
                    "calculator_dialog_error_text",
                    context,
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              WidgetUtils.button(context,
                  color: DarkGreyColor,
                  width: MediaQuery.of(context).size.width,
                  text: translatedText(
                    "calculator_button_close",
                    context,
                  ), onPressed: () {
                Navigator.pop(context);
              })
            ],
          ),
        ));
  }
}
