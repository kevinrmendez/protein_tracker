import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';

class WidgetUtils {
  static Widget button(BuildContext context,
      {String text, Function onPressed, Color color, Color textColor}) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 6, 20, 6),
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: color == null ? SecondaryColor : color,
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Container(
        height: height,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  width: MediaQuery.of(context).size.width,
                  // color: Theme.of(context).primaryColor,
                  child: title.isEmpty
                      ? SizedBox()
                      : Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: PrimaryColor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        )),
              SizedBox(
                height: 18,
              ),
              Center(child: child),
              showAd ? AdMobUtils.admobBanner() : SizedBox(),
            ],
          ),
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
            color: MediumGreyColor,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: MediumGreyColor),
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
            style: TextStyle(fontSize: 20, color: MediumGreyColor),
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

  static AppBar appBarBackArrow(String title, BuildContext context,
      {List<Widget> actions}) {
    return AppBar(
      centerTitle: true,
      backgroundColor: BackgroundColor,
      iconTheme: new IconThemeData(color: PrimaryColor),
      elevation: 0.0,
      actions: actions,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            // color: PrimaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
