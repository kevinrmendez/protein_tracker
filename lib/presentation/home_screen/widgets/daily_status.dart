import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/bloc/proteins/proteins.dart';
import 'package:protein_tracker/model/goal.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:provider/provider.dart';

class DailyStatus extends StatelessWidget {
  final int goal;

  const DailyStatus({Key key, this.goal}) : super(key: key);
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
    // Goal initGoal = Goal(1);
    // Goal proteinGoal = Provider.of<Goal>(context) ?? initGoal;
    // int consumedProtein = Provider.of<int>(context) ?? 0;
    // int goal;
    if (goal == null) {
      return CircularProgressIndicator();
    } else {
      // goal = proteinGoal.amount;
      // var remainingProtein = goal - consumedProtein;
      // remainingProtein = remainingProtein > 0 ? remainingProtein : 0;
      return BlocBuilder<ProteinsBloc, ProteinsState>(
          builder: (context, state) {
        if (state is ProteinsLoadInProgress) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ProteinsLoadFailure) {
          return Center(
              child: Text('Sorry we are not able to load your information'));
        }
        var consumedProtein = (state as ProteinsLoadSuccess)
            .proteins
            .fold(0, (value, element) => value + element.amount);
        var remainingProtein = goal - consumedProtein;
        remainingProtein = remainingProtein > 0 ? remainingProtein : 0;

        return WidgetUtils.card(
          child: Column(children: <Widget>[
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
                  )}: $goal  gr',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
            ])
          ]),
        );
      });
    }
  }
}
