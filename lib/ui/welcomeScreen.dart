import 'package:flutter/material.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isGoalAdded;

  @override
  void initState() {
    _isGoalAdded = false;
    super.initState();
  }

  void callback() {
    setState(() {
      _isGoalAdded = true;
    });
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
                _isGoalAdded
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: _text(translatedText(
                          "welcome_text_goal_updated",
                          context,
                        )),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: _text(translatedText(
                          "welcome_text_set_up",
                          context,
                        )),
                      ),
                _isGoalAdded
                    ? WidgetUtils.button(context, text: 'continue',
                        onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => App()),
                            (Route<dynamic> route) => false);
                      }, color: Colors.white, textColor: PrimaryColor)
                    : Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: WidgetUtils.button(context,
                                text: translatedText(
                                  "welcome_button_set_protein",
                                  context,
                                ), onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      GoalDialog(callback: this.callback));
                            }, color: Colors.white, textColor: PrimaryColor),
                          ),
                          WidgetUtils.button(context,
                              text: translatedText(
                                "welcome_button_skip",
                                context,
                              ), onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => App()),
                                (Route<dynamic> route) => false);
                          }, color: Colors.white, textColor: PrimaryColor),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          translatedText(
            "welcome_title_welcome",
            context,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
        ),
        Text(
          translatedText(
            "welcome_title_app_name",
            context,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ],
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

class GoalDialog extends StatefulWidget {
  final Function callback;
  GoalDialog({this.callback});

  @override
  _GoalDialogState createState() => _GoalDialogState();
}

class _GoalDialogState extends State<GoalDialog> {
  final _formKey = GlobalKey<FormState>();

  int goal;
  final _goalController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .37,
        title: translatedText(
          "welcome_dialog_goal_title",
          context,
        ),
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
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
                      if (value == "0") {
                        return translatedText(
                          "welcome_error_value_greater_0",
                          context,
                        );
                      }
                      return null;
                    },
                  ),
                  WidgetUtils.button(context,
                      text: translatedText(
                        "button_add",
                        context,
                      ),
                      color: DarkGreyColor, onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      proteinService.setGoal(goal);
                      widget.callback();
                      Navigator.pop(context);
                    } else {}
                  })
                ]),
              ),
            ],
          ),
        ));
  }
}
