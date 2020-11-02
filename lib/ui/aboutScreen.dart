import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';
import 'package:protein_tracker/utils/localization_utils.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow(
          translatedText(
            "appbar_about",
            context,
          ),
          context),
      body: Container(
        // padding: EdgeInsets.symmetric(vertical: 40),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WidgetUtils.card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    translatedText(
                      "app_title",
                      context,
                    ),
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
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  _text(translatedText(
                    "about_text_description_1",
                    context,
                  )),
                  _text(translatedText(
                    "about_text_description_2",
                    context,
                  )),
                  _text(translatedText(
                    "app_version",
                    context,
                  )),
                  WidgetUtils.button(context,
                      text: translatedText(
                        "button_update",
                        context,
                      ),
                      color: DarkGreyColor, onPressed: () async {
                    String url = AppAssets.appUrl;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  })
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
