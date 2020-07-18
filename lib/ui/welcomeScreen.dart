import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: WidgetUtils.appBarBackArrow('About protein tracker', context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: PrimaryColor,
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .8,
              margin: EdgeInsets.only(bottom: 20),
              child: _title(context),
            ),
            Image.asset(
              AppAssets.protein_icon_white,
              width: 100,
              height: 100,
            ),
            _text(
                'we recommend you to set your daily protein goal before using the app'),
            WidgetUtils.button(context,
                text: 'set protein goal',
                onPressed: () {},
                color: Colors.white,
                textColor: PrimaryColor),
            WidgetUtils.button(context, text: 'skip', onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => App()),
                  (Route<dynamic> route) => false);
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (BuildContext context) => App()));
            }, color: Colors.white, textColor: PrimaryColor),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Welcome to ',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
        Text(
          'Protein Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 40),
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
        style: TextStyle(fontSize: 22, color: Colors.white),
      ));
}
