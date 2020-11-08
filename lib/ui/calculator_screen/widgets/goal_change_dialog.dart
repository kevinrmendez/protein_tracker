import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

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
