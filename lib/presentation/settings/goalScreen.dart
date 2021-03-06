import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protein_tracker/application/DailyProteinService.dart';
import 'package:protein_tracker/application/ProteinService.dart';
import 'package:protein_tracker/application/settings/settings_bloc.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/domain/dailyProtein.dart';
import 'package:protein_tracker/presentation/core/number_grams.dart';
import 'package:protein_tracker/presentation/core/widgets/title_card.dart';

import 'package:protein_tracker/utils/dateUtils.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class GoalScreen extends StatefulWidget {
  GoalScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _formKey = GlobalKey<FormState>();

  final proteinGoalController = TextEditingController();
  int _proteinGoal;
  @override
  void initState() {
    super.initState();
    _proteinGoal = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow(
          title: translatedText(
            "appbar_goal",
            context,
          ),
          context: context),
      body: ListView(children: <Widget>[
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TitleCard(
                  title: translatedText(
                "goal_title",
                context,
              )),
              BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                var goal = state.goal;
                return goal == null
                    ? CircularProgressIndicator()
                    : NumberGrams(
                        grams: goal,
                      );
              }),
              Text(
                translatedText(
                  "goal_text_per_day",
                  context,
                ),
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextFormField(
                          controller: proteinGoalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: translatedText(
                              "goal_label_goal",
                              context,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return translatedText(
                                "goal_error_value_empty",
                                context,
                              );
                            }
                            if (value == "0") {
                              return translatedText(
                                "goal_error_value_0",
                                context,
                              );
                            }
                            if (!regExp.hasMatch(value)) {
                              return translatedText(
                                "error_only_numbers",
                                context,
                              );
                            }
                            if (int.parse(value) > 2000)
                              return translatedText(
                                "goal_error_value_too_high",
                                context,
                              );
                            return null;
                          },
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: WidgetUtils.button(
                  context,
                  width: MediaQuery.of(context).size.width,
                  text: translatedText(
                    "goal_button_goal",
                    context,
                  ),
                  color: Theme.of(context).buttonColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _proteinGoal = int.parse(proteinGoalController.text);

                      BlocProvider.of<SettingsBloc>(context)
                          .add(SettingsGoalChanged(_proteinGoal));

                      //update DailyProtein goal
                      var currentGoal = proteinService.current?.amount ?? 0;
                      var proteinConsumed =
                          proteinService.currentConsumedProtein ?? 0;
                      var today = DateUtils.formattedToday();
                      var isGoalAchieved =
                          proteinConsumed >= currentGoal ? 1 : 0;
                      var dailyProteinId = await dailyProteinServices
                          .getDailyProteinIdByDate(today);

                      if (dailyProteinId == null) {
                        var dailyProtein = DailyProtein(
                            date: today,
                            totalProtein: proteinConsumed,
                            isGoalAchieved: isGoalAchieved,
                            goal: currentGoal);
                        dailyProteinServices.add(dailyProtein);
                      } else {
                        var dailyProtein = DailyProtein(
                            id: dailyProteinId,
                            date: today,
                            totalProtein: proteinConsumed,
                            isGoalAchieved: isGoalAchieved,
                            goal: currentGoal);
                        dailyProteinServices.update(dailyProtein);
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}