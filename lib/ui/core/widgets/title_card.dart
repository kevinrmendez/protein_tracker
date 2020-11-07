import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class TitleCard extends StatelessWidget {
  final String title;

  const TitleCard({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return   WidgetUtils.card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                          // color: DarkGreyColor,
                          ),
                    ),
                  ),
                  color: PrimaryColor);
  }
}