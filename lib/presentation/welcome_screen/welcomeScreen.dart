import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/application/settings/settings_bloc.dart';
import 'package:protein_tracker/domain/calculator/activity.dart';
import 'package:protein_tracker/domain/calculator/female_status.dart';
import 'package:protein_tracker/domain/calculator/gender.dart';
import 'package:protein_tracker/domain/calculator/protein_goal.dart';
import 'package:protein_tracker/domain/settings/weight_unit.dart';

import '../../application/ProteinService.dart';
import '../../main.dart';
import '../../services/protein_calculator_service.dart';
import '../../utils/appAssets.dart';
import '../../utils/colors.dart';
import '../../utils/localization_utils.dart';
import '../../utils/widgetUtils.dart';
import '../core/number_grams.dart';
import 'widgets/blue_screen.dart';
import 'widgets/confirmation_dialog.dart';

Widget _titleText(text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
  );
}

Widget _numberText(int number) {
  return Text(
    "$number",
    style: TextStyle(
        fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
  );
}

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget _title(BuildContext context) {
    return Column(
      children: <Widget>[
        _titleText(
          translatedText(
            "welcome_title_welcome",
            context,
          ),
        ),
        _titleText(
          translatedText(
            "welcome_title_app_name",
            context,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlueScreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(bottom: 20),
              child: _title(context),
            ),
            Image.asset(
              AppAssets.protein_icon_white,
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: _text(translatedText(
                "welcome_question",
                context,
              )),
            ),
            WidgetUtils.button(context,
                width: MediaQuery.of(context).size.width,
                text: translatedText(
                  "welcome_yes",
                  context,
                ), onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SetupGoalScreen()),
                  (Route<dynamic> route) => false);
            }, color: Colors.white, textColor: PrimaryColor),
            WidgetUtils.button(context,
                width: MediaQuery.of(context).size.width,
                text: translatedText(
                  "welcome_no",
                  context,
                ), onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => SetupCalculatorScreen()),
                  (Route<dynamic> route) => false);
            }, color: Colors.white, textColor: PrimaryColor),
          ],
        ),
      ),
    );
  }

  Widget _text(text) => Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, color: Colors.white),
      ));
}

class SetupGoalScreen extends StatefulWidget {
  @override
  _SetupGoalScreenState createState() => _SetupGoalScreenState();
}

class _SetupGoalScreenState extends State<SetupGoalScreen> {
  final _formKey = GlobalKey<FormState>();

  int goal;
  final _goalController = TextEditingController();

  @override
  void initState() {
    goal = 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlueScreen(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _titleText(translatedText(
            "welcome_set_protein_goal",
            context,
          )),
          _numberText(
            goal,
          ),
          _titleText('gr'),
          Container(
            padding: EdgeInsetsDirectional.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(children: [
                    WidgetUtils.inputField(
                      keyboardType: TextInputType.number,
                      controller: _goalController,
                      labelText: translatedText(
                        "welcome_dialog_goal_label",
                        context,
                      ),
                      onChanged: (value) {
                        setState(() {
                          goal = int.parse(value);
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return translatedText(
                            "welcome_error_value_empty",
                            context,
                          );
                        }
                        if (!regExp.hasMatch(value)) {
                          return translatedText(
                            "error_only_numbers",
                            context,
                          );
                        }
                        if (value == "0") {
                          return translatedText(
                            "goal_error_value_0",
                            context,
                          );
                        }
                        return null;
                      },
                    ),
                    WidgetUtils.button(context,
                        width: MediaQuery.of(context).size.width,
                        text: translatedText(
                          "button_add",
                          context,
                        ),
                        color: Colors.white,
                        textColor: PrimaryColor, onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (regExp.hasMatch(goal.toString())) {
                          if (goal == 0) {
                            BlocProvider.of<SettingsBloc>(context)
                                .add(SettingsGoalChanged(1));
                            // proteinService.setGoal(1);
                          } else {
                            BlocProvider.of<SettingsBloc>(context)
                                .add(SettingsGoalChanged(goal));
                            // proteinService.setGoal(goal);
                          }
                        } else {
                          proteinService.setGoal(1);
                        }
                        showDialog(
                            context: context,
                            builder: (_) => ConfirmationDialog(
                                  title: translatedText(
                                    "welcome_protein_goal_set_title",
                                    context,
                                  ),
                                  description: translatedText(
                                    "welcome_protein_goal_set",
                                    context,
                                  ),
                                  showChangeGoalButton: true,
                                ));

                        // proteinService.setGoal(goal);
                        // widget.callback();
                        // Navigator.pop(context);
                      } else {}
                    }),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SetupCalculatorScreen extends StatefulWidget {
  @override
  _SetupCalculatorScreenState createState() => _SetupCalculatorScreenState();
}

class _SetupCalculatorScreenState extends State<SetupCalculatorScreen> {
  int _index;
  int _weight;
  Gender _gender = Gender.male;
  WeightUnit _weightUnit;
  FemaleStatus _femaleStatus;
  Activity _activityLevel;
  ProteinGoal _proteinGoal;

  final _formKey = GlobalKey<FormState>();
  final _weightformKey = GlobalKey<FormState>();
  static Widget _screen1, _screen2, _screen3;
  List<Widget> _screens = [_screen1, _screen2, _screen3];

  int goal;
  final _goalController = TextEditingController();
  final _weightController = TextEditingController();

  calculateProteinIntake(bool isWeigthUnitKg) {
    setState(() {
      goal = ProteinCalculatorService.calculateProtein(
          activityValue: _activityLevel,
          proteinGoalValue: _proteinGoal,
          femaleStatusValue: _femaleStatus,
          weight: _weight.toDouble(),
          currentWeightSettings: isWeigthUnitKg);
      // _isCalculated = true;
    });
  }

  @override
  void initState() {
    _index = 0;
    _weight = 0;
    goal = 0;
    // _weightUnit = WeightUnit.lb;
    _femaleStatus = FemaleStatus.none;
    _proteinGoal = ProteinGoal.maintenance;
    _activityLevel = Activity.moderate;
    super.initState();
  }

  _buildRadioButton(String text, value, groupValue) {
    return Theme(
      data: ThemeData.dark(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Radio(
              activeColor: Colors.white,
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
                  if (value is WeightUnit) {
                    _weightUnit = value;
                  }
                  if (value is ProteinGoal) {
                    _proteinGoal = value;
                  }
                  if (value is Activity) {
                    _activityLevel = value;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildScreen1() {
    return Center(
      child: Column(
        children: <Widget>[
          _titleText(translatedText(
            "welcome_question_weight",
            context,
          )),
          _numberText(_weight),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildRadioButton('lb', WeightUnit.lb, _weightUnit),
              _buildRadioButton('kg', WeightUnit.kg, _weightUnit),
            ],
          ),
          Form(
            key: _weightformKey,
            child: Column(children: [
              Container(
                height: 80,
                child: WidgetUtils.inputField(
                  keyboardType: TextInputType.number,
                  controller: _weightController,
                  labelText: translatedText(
                    "word_weight",
                    context,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _weight = int.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return translatedText(
                        "welcome_error_value_empty",
                        context,
                      );
                    }
                    if (!regExp.hasMatch(value)) {
                      return translatedText(
                        "error_only_numbers",
                        context,
                      );
                    }
                    if (value == "0") {
                      return translatedText(
                        "goal_error_value_0",
                        context,
                      );
                    }
                    if (int.parse(value) > 1000) {
                      return translatedText(
                        "food_error_value_too_high",
                        context,
                      );
                    }
                    return null;
                  },
                ),
              ),
              WidgetUtils.button(context,
                  width: MediaQuery.of(context).size.width,
                  text: translatedText(
                    "button_add",
                    context,
                  ),
                  color: Colors.white,
                  textColor: PrimaryColor, onPressed: () async {
                if (_weightformKey.currentState.validate()) {
                  if (regExp.hasMatch(goal.toString())) {
                    if (goal == 0) {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(SettingsGoalChanged(1));
                      // proteinService.setGoal(1);
                    } else {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(SettingsGoalChanged(goal));
                      // proteinService.setGoal(goal);
                    }
                  } else {
                    BlocProvider.of<SettingsBloc>(context)
                        .add(SettingsGoalChanged(1));
                    // proteinService.setGoal(1);
                  }
                  setState(() {
                    _index++;
                  });
                }
              }),
            ]),
          ),
        ],
      ),
    );
  }

  _buildScreen2() {
    return Center(
      child: Column(
        children: <Widget>[
          _titleText(translatedText(
            "welcome_question_gender",
            context,
          )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRadioButton(
                    translatedText(
                      "calculator_radio_button_gender_male",
                      context,
                    ),
                    Gender.male,
                    _gender),
                SizedBox(
                  width: 40,
                ),
                _buildRadioButton(
                    translatedText(
                      "calculator_radio_button_gender_female",
                      context,
                    ),
                    Gender.female,
                    _gender),
              ],
            ),
          ),
          _gender == Gender.female
              ? Column(children: [
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildRadioButton(
                          translatedText(
                            "calculator_radio_button_gender_female_none",
                            context,
                          ),
                          FemaleStatus.none,
                          _femaleStatus),
                      SizedBox(
                        width: 15,
                      ),
                      _buildRadioButton(
                          translatedText(
                            "calculator_radio_button_gender_female_lactanting",
                            context,
                          ),
                          FemaleStatus.lactanting,
                          _femaleStatus),
                      SizedBox(
                        width: 15,
                      ),
                      _buildRadioButton(
                          translatedText(
                            "calculator_radio_button_gender_female_pregnant",
                            context,
                          ),
                          FemaleStatus.pregnant,
                          _femaleStatus)
                    ],
                  ),
                ])
              : SizedBox(),
          WidgetUtils.button(context,
              width: MediaQuery.of(context).size.width,
              text: translatedText(
                "welcome_button_continue",
                context,
              ), onPressed: () {
            setState(() {
              _index++;
            });
          }, color: Colors.white, textColor: PrimaryColor),
        ],
      ),
    );
  }

  _buildScreen3() {
    return Center(
      child: Column(
        children: <Widget>[
          _titleText(
            translatedText(
              "welcome_question_activity",
              context,
            ),
          ),
          Column(
            children: <Widget>[
              _buildRadioButton(
                  translatedText(
                    "calculator_dropDownValue_activity_sedentary",
                    context,
                  ),
                  Activity.sedentary,
                  _activityLevel),
              _buildRadioButton(
                  translatedText(
                    "calculator_dropDownValue_activity_moderate",
                    context,
                  ),
                  Activity.moderate,
                  _activityLevel),
              _buildRadioButton(
                  translatedText(
                    "calculator_dropDownValue_activity_active",
                    context,
                  ),
                  Activity.active,
                  _activityLevel)
            ],
          ),
          WidgetUtils.button(context,
              width: MediaQuery.of(context).size.width,
              text: translatedText(
                "welcome_button_continue",
                context,
              ), onPressed: () {
            setState(() {
              _index++;
            });
          }, color: Colors.white, textColor: PrimaryColor),
        ],
      ),
    );
  }

  _buildScreen4() {
    return Center(
      child: Column(
        children: <Widget>[
          _titleText(
            translatedText(
              "welcome_question_goal",
              context,
            ),
          ),
          Column(
            children: <Widget>[
              _buildRadioButton(
                  translatedText(
                    "calculator_dropDownValue_activity_maintenance",
                    context,
                  ),
                  ProteinGoal.maintenance,
                  _proteinGoal),
              _buildRadioButton(
                  translatedText(
                    "calculator_dropDownValue_activity_muscle_gain",
                    context,
                  ),
                  ProteinGoal.muscleGain,
                  _proteinGoal),
              _buildRadioButton(
                  translatedText(
                    "calculator_dropDownValue_activity_fat_loss",
                    context,
                  ),
                  ProteinGoal.fatLoss,
                  _proteinGoal)
            ],
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return WidgetUtils.button(context,
                  width: MediaQuery.of(context).size.width,
                  text: translatedText(
                    "calculator_button_calculate",
                    context,
                  ), onPressed: () {
                setState(() {
                  calculateProteinIntake(state.weigthUnit);
                  _index++;
                });
              }, color: Colors.white, textColor: PrimaryColor);
            },
          ),
        ],
      ),
    );
  }

  _buildScreen5() {
    return Center(
      child: Column(
        children: <Widget>[
          _titleText(translatedText(
            "welcome_protein_goal_result",
            context,
          )),
          NumberGrams(
            grams: goal,
          ),
          WidgetUtils.button(context,
              width: MediaQuery.of(context).size.width,
              text: translatedText(
                "welcome_protein_goal_set_button",
                context,
              ), onPressed: () {
            BlocProvider.of<SettingsBloc>(context)
                .add(SettingsGoalChanged(goal));
            // proteinService.setGoal(goal);
            showDialog(
                context: context,
                builder: (_) => ConfirmationDialog(
                      title: translatedText(
                        "welcome_protein_goal_set_title",
                        context,
                      ),
                      description: translatedText(
                        "welcome_protein_goal_set",
                        context,
                      ),
                    ));
          }, color: Colors.white, textColor: PrimaryColor),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlueScreen(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          [
            _buildScreen1(),
            _buildScreen2(),
            _buildScreen3(),
            _buildScreen4(),
            _buildScreen5()
          ][_index]
        ],
      ),
    );
  }
}
