import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

import '../../../main.dart';

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
        title: title,
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
              Column(
                children: <Widget>[
                  WidgetUtils.button(context,
                      text: translatedText(
                        "welcome_button_continue",
                        context,
                      ),
                      color: DarkGreyColor, onPressed: () async {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => App()),
                        (Route<dynamic> route) => false);
                  }),
                  showChangeGoalButton
                      ? WidgetUtils.button(context,
                          padding: EdgeInsets.zero,
                          text: translatedText(
                            "welcome_change_goal",
                            context,
                          ),
                          color: DarkGreyColor, onPressed: () async {
                          Navigator.of(context).pop();
                        })
                      : SizedBox()
                ],
              )
            ],
          ),
        ));
  }
}
