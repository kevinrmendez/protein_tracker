import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/model/dailyProtein.dart';
import 'package:protein_tracker/utils/theme_text.dart';

import '../../../bloc/ProteinListService.dart';
import '../../../bloc/ProteinService.dart';
import '../../../bloc/StatisticsService.dart';
import '../../../model/protein.dart';
import '../../../utils/colors.dart';
import '../../../utils/localization_utils.dart';
import '../../../utils/widgetUtils.dart';

class CalendarProteinDialog extends StatefulWidget {
  // final ProteinEvent event;
  final DailyProtein dailyProtein;
  CalendarProteinDialog(this.dailyProtein);
  // CalendarProteinDialog(this.event);
  @override
  _CalendarProteinDialogState createState() => _CalendarProteinDialogState();
}

class _CalendarProteinDialogState extends State<CalendarProteinDialog> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValueGoal;
  String foodName;
  int proteinAmount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        // title: widget.event.title,
        title: '',
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'goal',
                        style: ThemeText.dialogHeader,
                      ),
                      Text(
                        '${widget.dailyProtein.goal} gr',
                        style: ThemeText.dialogBody,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'protein consumed',
                        style: ThemeText.dialogHeader,
                      ),
                      Text(
                        '${widget.dailyProtein.totalProtein} gr',
                        style: ThemeText.dialogBody,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      WidgetUtils.button(context,
                          fontSize: 16,
                          text: translatedText(
                            "button_edit",
                            context,
                          ),
                          color: DarkGreyColor, onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          print('add food');
                          print(foodName);
                          print(proteinAmount);
                          DateTime now = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('dd-MMMM-yyyy');
                          final String formattedDateNow = formatter.format(now);
                          Protein protein = Protein(
                              name: foodName,
                              amount: proteinAmount,
                              date: formattedDateNow);

                          proteinListServices.add(protein);
                          proteinService.updateConsumedProtein();
                          statisticsService.updateStatisticsData();

                          Navigator.pop(context);
                        } else {}
                      }),
                      // WidgetUtils.button(context,
                      //     fontSize: 16,
                      //     text: translatedText(
                      //       "button_close",
                      //       context,
                      //     ),
                      //     color: DarkGreyColor, onPressed: () {
                      //   Navigator.pop(context);
                      // })
                    ],
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}
