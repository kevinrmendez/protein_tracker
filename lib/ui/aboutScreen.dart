import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow('About protein tracker', context),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .7,
              margin: EdgeInsets.only(bottom: 20),
              child: _title(context),
            ),
            _text(
                'protein tracker is a free app that helps you to track your protein intake'),
            _text('version 1.0.0'),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'About',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1,
        ),
        Text(
          'protein tracker',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }

  Widget _text(text) => Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ));
}
