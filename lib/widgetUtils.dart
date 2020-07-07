import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';

class WidgetUtils {
  static Widget button({String text, Function onPressed}) {
    return RaisedButton(
      color: PrimaryColor,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      onPressed: onPressed,
    );
  }

  static Dialog dialog(
      {Widget child,
      BuildContext context,
      String title,
      double height,
      bool showAd = true}) {
    return Dialog(
      child: Container(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )),
            SizedBox(
              height: 10,
            ),
            child,
            SizedBox(
              height: 10,
            ),
            // showAd ? AdmobUtils.admobBanner() : SizedBox()
          ],
        ),
      ),
    );
  }

  static Widget iconText(BuildContext context, {IconData icon, String text}) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 60,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  static Widget card(
      {String title = "", Widget child, Color color = Colors.white}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // margin: EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Card(
            color: color,
            margin: EdgeInsets.symmetric(horizontal: 0),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8), child: child),
          ),
        ],
      ),
    );
  }
}
