import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class ProteinEvent implements EventInterface {
  final DateTime date;
  final String title;
  final Widget icon;
  final Widget dot;
  final int goal;
  final int proteinConsumed;
  ProteinEvent(
      {this.proteinConsumed,
      this.date,
      this.title,
      this.icon,
      this.dot,
      this.goal})
      : assert(date != null);

  @override
  DateTime getDate() {
    return date;
  }

  @override
  Widget getDot() {
    return dot;
  }

  @override
  Widget getIcon() {
    return icon;
  }

  @override
  String getTitle() {
    return title;
  }
}
