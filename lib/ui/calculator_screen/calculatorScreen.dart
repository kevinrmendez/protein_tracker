import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

import '../../bloc/ProteinService.dart';
import '../../bloc/SettingsService.dart';
import '../../services/protein_calculator_service.dart';
import '../../utils/colors.dart';
import '../../utils/enums.dart';
import '../../utils/localization_utils.dart';
import '../../utils/widgetUtils.dart';
import 'widgets/error_dialog.dart';
import 'widgets/goal_change_dialog.dart';

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CalculatorScreen> {
  Gender _gender = Gender.male;
  FemaleStatus _femaleStatus = FemaleStatus.none;
  // ProteinGoal _goal = ProteinGoal.maintenance;
  final weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Activity dropdownValueActivity = Activity.none;
  ProteinGoal dropdownValueGoal = ProteinGoal.none;
  int proteinIntake = 0;

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
    setState(() {
      proteinIntake = ProteinCalculatorService.calculateProtein(
          activityValue: dropdownValueActivity,
          proteinGoalValue: dropdownValueGoal,
          femaleStatusValue: _femaleStatus,
          weight: _weight,
          currentWeightSettings: settingsService.currentWeightSettings);
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
          title: translatedText(
            "appbar_calculator",
            context,
          ),
          context: context),
      body: Center(
        child: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: WidgetUtils.colorCard(
                  context,
                  // color: PrimaryColor,
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
