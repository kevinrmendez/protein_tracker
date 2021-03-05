import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/application/proteins/proteins.dart';
import 'package:protein_tracker/domain/goal.dart';
import 'package:protein_tracker/presentation/home_screen/homeScreen.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
// import 'package:provider/provider.dart';

class MotivationalText extends StatelessWidget {
  final int goal;

  const MotivationalText({Key key, this.goal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Goal initGoal = Goal(1);
    // Goal proteinGoal = Provider.of<Goal>(context) ?? initGoal;
    // int consumedProtein = Provider.of<int>(context) ?? 0;
    // int goal;
    // if (proteinGoal == null) {
    //   return SizedBox();
    // } else {
    //   goal = proteinGoal.amount;
    //   return

    return goal == null
        ? CircularProgressIndicator()
        : BlocBuilder<ProteinsBloc, ProteinsState>(builder: (context, state) {
            if (state is ProteinsLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ProteinsLoadFailure) {
              return Center(
                  child:
                      Text('Sorry we are not able to load your information'));
            }
            var consumedProtein = (state as ProteinsLoadSuccess)
                .proteins
                .fold(0, (value, element) => value + element.amount);
            return WidgetUtils.colorCard(
              context,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                      // color: DarkGreyColor,
                      ),
                ),
              ),
            );
          });
  }
}
