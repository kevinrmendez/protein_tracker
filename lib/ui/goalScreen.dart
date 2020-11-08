import 'package:flutter/material.dart';

import '../bloc/DailyProteinService.dart';
import '../bloc/ProteinService.dart';
import '../main.dart';
import '../model/dailyProtein.dart';
import '../utils/colors.dart';
import '../utils/dateUtils.dart';
import '../utils/localization_utils.dart';
import '../utils/widgetUtils.dart';
import 'core/number_grams.dart';
import 'core/widgets/title_card.dart';

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
              StreamBuilder(
                stream: proteinService.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                      break;
                    default:
                      return NumberGrams(
                        grams: snapshot.data.amount,
                      );
                  }
                },
              ),
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
                  color: DarkGreyColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _proteinGoal = int.parse(proteinGoalController.text);
                      proteinService.setGoal(_proteinGoal);
                      print('goal set: $_proteinGoal');

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
                      dailyProteinServices.currentList.forEach((element) {
                        print(element.toString());
                      });
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
