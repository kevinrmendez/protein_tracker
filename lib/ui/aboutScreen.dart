import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/appAssets.dart';
import '../utils/colors.dart';
import '../utils/localization_utils.dart';
import '../utils/widgetUtils.dart';
import 'core/widgets/title_card.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.appBarBackArrow(
          title: translatedText(
            "appbar_about",
            context,
          ),
          context: context),
      body: Container(
        child: ListView(
          children: <Widget>[
            TitleCard(
              title: translatedText(
                "app_title",
                context,
              ),
            ),
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
                  Platform.isAndroid
                      ? WidgetUtils.button(context,
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
                      : SizedBox()
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
