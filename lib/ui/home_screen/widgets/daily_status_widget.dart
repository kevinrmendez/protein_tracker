import 'package:flutter/material.dart';
import 'package:protein_tracker/model/goal.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:provider/provider.dart';

class DailyStatusWidget extends StatelessWidget {
  // FOR TESTING DAILY PROTEIN DATA
  // _buildDailyProtein() {
  //   return Row(
  //     children: <Widget>[
  //       Text('dailyProtein: '),
  //       Column(
  //           children: dailyProteinServices.currentList
  //               .map((e) => Text(e.totalProtein.toString()))
  //               .toList()),
  //     ],
  //   );
  // }

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
      var remainingProtein = goal - consumedProtein;
      remainingProtein = remainingProtein > 0 ? remainingProtein : 0;
      return Column(
        children: <Widget>[
          // _buildDailyProtein(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.star,
                color: DarkGreyColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${translatedText(
                  "text_goal",
                  context,
                )}: $goal gr',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.timelapse,
                color: DarkGreyColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                ' ${translatedText(
                  "text_remaining",
                  context,
                )} : ${remainingProtein ?? 0} gr',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ],
      );
    }
  }
}
