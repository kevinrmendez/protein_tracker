import 'package:flutter/material.dart';
import 'package:protein_tracker/model/goal.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:provider/provider.dart';

class MotivationalTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Goal initGoal = Goal(1);
    Goal proteinGoal = Provider.of<Goal>(context) ?? initGoal;
    int consumedProtein = Provider.of<int>(context) ?? 0;
    int goal;
    if (proteinGoal == null) {
      return SizedBox();
    } else {
      goal = proteinGoal.amount;
      return WidgetUtils.card(
        color: consumedProtein >= goal ? GreenColor : PrimaryColor,
        title: translatedText(
          "home_label_status",
          context,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            consumedProtein >= goal
                ? translatedText(
                    "home_motivational_5_completed",
                    context,
                  )
                : consumedProtein >= goal / 4 * 3
                    ? translatedText(
                        "home_motivational_4_halfway",
                        context,
                      )
                    : consumedProtein >= goal / 2
                        ? translatedText(
                            "home_motivational_3_halfway",
                            context,
                          )
                        : consumedProtein >= goal / 4
                            ? translatedText(
                                "home_motivational_2_continue_tracking",
                                context,
                              )
                            : consumedProtein == 0
                                ? translatedText(
                                    "home_motivational_0_start_tracking",
                                    context,
                                  )
                                : translatedText(
                                    "home_motivational_1_started_tracking",
                                    context,
                                  ),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
                // color: DarkGreyColor,
                ),
          ),
        ),
      );
    }
  }
}
