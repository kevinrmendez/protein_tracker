import 'package:flutter/material.dart';
import 'package:protein_tracker/domain/dailyProtein.dart';
import 'package:protein_tracker/presentation/proteins/trackerScreen.dart';
import 'package:protein_tracker/presentation/core/theme/theme_text.dart';

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
                          color: Theme.of(context).buttonColor, onPressed: () {
                        print('pressed');
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => TrackerScreen(
                                  title: 'SDF',
                                )));
                      }),
                    ],
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}
