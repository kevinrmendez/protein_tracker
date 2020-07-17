import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';

class WidgetUtils {
  static Widget button(
      {String text, Function onPressed, Color color, Color textColor}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: 240,
      height: 45,
      child: RaisedButton(
        color: color == null ? PrimaryColor : color,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor == null ? Colors.white : textColor,
              fontSize: 22),
        ),
        onPressed: onPressed,
      ),
    );
  }

  static Widget inputField(
      {TextInputType keyboardType = TextInputType.text,
      TextEditingController controller,
      String labelText,
      Function(String) onChanged,
      Function(String) validator}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 68,
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
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
        child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 7,
            ),
            child,
            // SizedBox(
            //   height: 5,
            // ),
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
            color: DarkMediumGreyColor,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: DarkMediumGreyColor),
          ),
        ],
      ),
    );
  }

  static Widget imageText(BuildContext context,
      {IconData icon, String text, String asset}) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsetsDirectional.only(bottom: 5),
            child: Image.asset(
              asset,
              width: 50,
              height: 50,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: DarkMediumGreyColor),
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
            margin: EdgeInsets.only(bottom: 5),
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

  static AppBar appBarBackArrow(String title, BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: LightGreyColor,
      iconTheme: new IconThemeData(color: PrimaryColor),
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title:
          // Icon(Icons.delete),
          Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
