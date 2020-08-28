import 'package:flutter/material.dart';

import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:protein_tracker/utils/enums.dart';

Widget _titleText(text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
  );
}

Widget _bodyText(text) {
  return Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: 24),
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
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: PrimaryColor,
            padding: EdgeInsets.symmetric(vertical: 40),
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
                  child: _text('Do you know your protein intake'),
                  // child: _text(translatedText(
                  //   "welcome_text_goal_updated",
                  //   context,
                  // )
                  // ),
                ),
                WidgetUtils.button(context,
                    width: MediaQuery.of(context).size.width, text: 'yes',
                    // text: translatedText(
                    //   "welcome_button_skip",
                    //   context,
                    // ),
                    onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => SetupGoalScreen()),
                      (Route<dynamic> route) => false);
                }, color: Colors.white, textColor: PrimaryColor),
                WidgetUtils.button(context,
                    width: MediaQuery.of(context).size.width, text: 'no',
                    // text: translatedText(
                    //   "welcome_button_skip",
                    //   context,
                    // ),
                    onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => SetupCalculatorScreen()),
                      (Route<dynamic> route) => false);
                }, color: Colors.white, textColor: PrimaryColor),
              ],
            ),
          ),
        ],
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
          _titleText('Set your protein goal'),
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
                            proteinService.setGoal(1);
                          } else {
                            proteinService.setGoal(goal);
                          }
                        } else {
                          proteinService.setGoal(1);
                        }
                        showDialog(
                            context: context,
                            builder: (_) => ConfirmationDialog(
                                  title: 'your goal has been added',
                                  description:
                                      'congratulations you have set up your protein goal! You can change this goal any time from the app',
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

  @override
  void initState() {
    _index = 0;
    _weight = 0;
    goal = 0;
    _weightUnit = WeightUnit.lb;
    _femaleStatus = FemaleStatus.none;
    _proteinGoal = ProteinGoal.maintenance;
    _activityLevel = Activity.moderate;
    super.initState();
  }

  _buildRadioButton(String text, value, groupValue) {
    return Theme(
      data: ThemeData.dark(),
      child: Container(
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
          _bodyText(
            'What is your weight?',
          ),
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
              WidgetUtils.inputField(
                keyboardType: TextInputType.number,
                controller: _weightController,
                labelText: "weight",
                // labelText: translatedText(
                //   "welcome_dialog_goal_label",
                //   context,
                // ),
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
                if (_weightformKey.currentState.validate()) {
                  if (regExp.hasMatch(goal.toString())) {
                    if (goal == 0) {
                      proteinService.setGoal(1);
                    } else {
                      proteinService.setGoal(goal);
                    }
                  } else {
                    proteinService.setGoal(1);
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
          _bodyText('What is your gender?'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRadioButton('male', Gender.male, _gender),
                SizedBox(
                  width: 40,
                ),
                _buildRadioButton('female', Gender.female, _gender),
              ],
            ),
          ),
          _gender == Gender.female
              ? Column(children: [
                  // _bodyText('What is your status?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildRadioButton(
                          'none', FemaleStatus.none, _femaleStatus),
                      _buildRadioButton(
                          'lactanting', FemaleStatus.lactanting, _femaleStatus),
                      _buildRadioButton(
                          'pregnant', FemaleStatus.pregnant, _femaleStatus)
                    ],
                  ),
                ])
              : SizedBox(),
          WidgetUtils.button(context,
              width: MediaQuery.of(context).size.width, text: 'continue',
              // text: translatedText(
              //   "welcome_button_skip",
              //   context,
              // ),
              onPressed: () {
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
          _bodyText('What is your activity level?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildRadioButton(
                  'sedentary', Activity.sedentary, _activityLevel),
              _buildRadioButton('moderate', Activity.moderate, _activityLevel),
              _buildRadioButton('active', Activity.active, _activityLevel)
            ],
          ),
          WidgetUtils.button(context,
              width: MediaQuery.of(context).size.width, text: 'continue',
              // text: translatedText(
              //   "welcome_button_skip",
              //   context,
              // ),
              onPressed: () {
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
          _bodyText('What is your goal?'),
          Column(
            children: <Widget>[
              _buildRadioButton(
                  'maintenance', ProteinGoal.maintenance, _proteinGoal),
              _buildRadioButton(
                  'muscle gain', ProteinGoal.muscleGain, _proteinGoal),
              _buildRadioButton('fat loss', ProteinGoal.fatLoss, _proteinGoal)
            ],
          ),
          WidgetUtils.button(context,
              width: MediaQuery.of(context).size.width, text: 'calculate',
              // text: translatedText(
              //   "welcome_button_skip",
              //   context,
              // ),
              onPressed: () {
            setState(() {
              _index++;
            });
          }, color: Colors.white, textColor: PrimaryColor),
        ],
      ),
    );
  }

  _buildScreen5() {
    return Center(
      child: Column(
        children: <Widget>[
          _bodyText('Result'),
          _numberText(100),
          _bodyText('gr'),
          WidgetUtils.button(context,
              width: MediaQuery.of(context).size.width,
              text: 'set protein goal',
              // text: translatedText(
              //   "welcome_button_skip",
              //   context,
              // ),
              onPressed: () {
            proteinService.setGoal(goal);
            showDialog(
                context: context,
                builder: (_) => ConfirmationDialog(
                      title: 'your goal has been added',
                      description:
                          'congratulations you have set up your protein goal! You can change this goal any time from the app',
                    ));
            print('protein Goal set');
          }, color: Colors.white, textColor: PrimaryColor),
        ],
      ),
    );
  }

  // Widget _radioButton(
  //   String label,
  //   groupValue,
  //   value,
  // ) {
  //   return Row(
  //     children: <Widget>[
  //       Radio(
  //         activeColor: PrimaryColor,
  //         value: value,
  //         groupValue: groupValue,
  //         onChanged: (value) {
  //           setState(() {
  //             if (value is Gender) {
  //               _gender = value;
  //             }
  //             if (value is FemaleStatus) {
  //               _femaleStatus = value;
  //             }
  //           });
  //         },
  //       ),
  //       Text(label)
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlueScreen(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _titleText('Calculate protein'),
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

class BlueScreen extends StatelessWidget {
  final Widget child;
  BlueScreen({this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: PrimaryColor,
              // padding: EdgeInsets.symmetric(vertical: 40),
              child: child),
        ],
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final bool showChangeGoalButton;

  ConfirmationDialog(
      {this.title, this.description, this.showChangeGoalButton = false});

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .4,
        title: title,
        // title: translatedText(
        //   "welcome_dialog_goal_title",
        //   context,
        // ),
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(description),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  WidgetUtils.button(context,
                      fontSize: 14,
                      padding: EdgeInsets.zero,
                      width: MediaQuery.of(context).size.width * .3,
                      text: "continue",
                      // text: translatedText(
                      //   "button_yes",
                      //   context,
                      // ),
                      color: DarkGreyColor, onPressed: () async {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => App()),
                        (Route<dynamic> route) => false);
                  }),
                  showChangeGoalButton
                      ? Container(
                          margin: EdgeInsets.only(left: 10),
                          child: WidgetUtils.button(context,
                              fontSize: 14,
                              padding: EdgeInsets.zero,
                              width: MediaQuery.of(context).size.width * .3,
                              text: 'change goal',
                              // text: translatedText(
                              //   "button_yes",
                              //   context,
                              // ),
                              color: DarkGreyColor, onPressed: () async {
                            Navigator.of(context).pop();
                          }),
                        )
                      : SizedBox()
                ],
              )
            ],
          ),
        ));
  }
}

// class WelcomeScreen extends StatefulWidget {
//   WelcomeScreen({Key key}) : super(key: key);

//   @override
//   _WelcomeScreenState createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   bool _isGoalAdded;

//   @override
//   void initState() {
//     _isGoalAdded = false;
//     super.initState();
//   }

//   void callback() {
//     setState(() {
//       _isGoalAdded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             color: PrimaryColor,
//             padding: EdgeInsets.symmetric(vertical: 40),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   width: MediaQuery.of(context).size.width * .8,
//                   margin: EdgeInsets.only(bottom: 20),
//                   child: _title(context),
//                 ),
//                 Image.asset(
//                   AppAssets.protein_icon_white,
//                   width: 100,
//                   height: 100,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 _isGoalAdded
//                     ? Container(
//                         margin: EdgeInsets.symmetric(horizontal: 20),
//                         child: _text(translatedText(
//                           "welcome_text_goal_updated",
//                           context,
//                         )),
//                       )
//                     : Container(
//                         margin: EdgeInsets.symmetric(horizontal: 20),
//                         child: _text(translatedText(
//                           "welcome_text_set_up",
//                           context,
//                         )),
//                       ),
//                 _isGoalAdded
//                     ? WidgetUtils.button(context,
//                         width: MediaQuery.of(context).size.width,
//                         text: translatedText(
//                           "welcome_button_continue",
//                           context,
//                         ), onPressed: () {
//                         Navigator.of(context).pushAndRemoveUntil(
//                             MaterialPageRoute(builder: (context) => App()),
//                             (Route<dynamic> route) => false);
//                       }, color: Colors.white, textColor: PrimaryColor)
//                     : Column(
//                         children: <Widget>[
//                           Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             child: WidgetUtils.button(context,
//                                 width: MediaQuery.of(context).size.width,
//                                 text: translatedText(
//                                   "welcome_button_set_protein",
//                                   context,
//                                 ), onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   builder: (_) =>
//                                       GoalDialog(callback: this.callback));
//                             }, color: Colors.white, textColor: PrimaryColor),
//                           ),
//                           WidgetUtils.button(context,
//                               width: MediaQuery.of(context).size.width,
//                               text: translatedText(
//                                 "welcome_button_skip",
//                                 context,
//                               ), onPressed: () {
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(builder: (context) => App()),
//                                 (Route<dynamic> route) => false);
//                           }, color: Colors.white, textColor: PrimaryColor),
//                         ],
//                       ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
