import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/application/proteins/proteins.dart';
import 'package:protein_tracker/domain/goal.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int goal;

  const ProgressIndicatorWidget({Key key, this.goal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Goal initGoal = Goal(1);
    // Goal proteinGoal = Provider.of<Goal>(context) ?? initGoal;
    // int consumedProtein = Provider.of<int>(context) ?? 0;
    // int goal;
    if (goal == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      // goal = proteinGoal.amount;
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
        return CircularStepProgressIndicator(
          totalSteps: goal,
          currentStep: consumedProtein,
          // stepSize: 0,
          selectedColor: PrimaryColor,
          unselectedColor: Colors.grey[200],
          // padding: 8,
          width: 180,
          height: 180,
          selectedStepSize: 15,
          child: Center(
              child: Container(
            child: Wrap(
              runSpacing: -25,
              // direction: Axis.vertical,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  "$consumedProtein",
                  style: TextStyle(
                    fontSize: 60,
                  ),
                ),
                Text(
                  'gr',
                  style: TextStyle(fontSize: 30),
                )
              ],
            ),
          )),
        );
      });
    }
  }
}