import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow('About protein tracker', context),
      body: Container(
        // padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WidgetUtils.card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Protein Tracker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                        // color: DarkGreyColor,
                        ),
                  ),
                ),
                color: PrimaryColor),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  _text(
                      'My Protein Tracker is a free app that helps you to calculate and track your protein intake.'),
                  _text(
                      "In order to keep free the app for everybody and support it's development, it contains some ads."),
                  _text('version 1.0.0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(text) => Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ));
}
