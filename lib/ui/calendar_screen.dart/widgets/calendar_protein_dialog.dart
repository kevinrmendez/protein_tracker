import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:protein_tracker/bloc/ProteinListService.dart';
import 'package:protein_tracker/bloc/ProteinService.dart';
import 'package:protein_tracker/bloc/StatisticsService.dart';
import 'package:protein_tracker/model/protein.dart';
import 'package:protein_tracker/model/protein_event.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/localization_utils.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class CalendarProteinDialog extends StatefulWidget {
  final ProteinEvent event;
  CalendarProteinDialog(this.event);
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

  _text(text) {
    return Text(
      text,
      style: TextStyle(fontSize: 19),
    );
  }

  _textBold(text) {
    return Text(
      text,
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        title: widget.event.title,
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
                      _textBold('goal '),
                      _text('${widget.event.goal} gr')
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _textBold('protein consumed '),
                      _text('${widget.event.proteinConsumed} gr')
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      WidgetUtils.button(context,
                          fontSize: 16,
                          text: translatedText(
                            "button_close",
                            context,
                          ),
                          color: DarkGreyColor, onPressed: () {
                        Navigator.pop(context);
                      })
                    ],
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}
