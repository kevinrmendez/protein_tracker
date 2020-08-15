import 'package:flutter/material.dart';

import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

Widget _titleText(text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
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
                          builder: (context) => SetupGoalScreen()),
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
    goal = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlueScreen(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _titleText('Set your protein goal'),
          Text(
            "$goal",
            style: TextStyle(
                fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
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
  ConfirmationDialog({this.title, this.description});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  WidgetUtils.button(context,
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
                  })
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
