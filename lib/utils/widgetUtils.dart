import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/AdMobUtils.dart';
import 'package:protein_tracker/utils/appAssets.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/utils/theme_text.dart';

class WidgetUtils {
  static Widget button(BuildContext context,
      {String text,
      double fontSize = 20,
      double width,
      // double height = 45,
      Function onPressed,
      Color color,
      Color textColor,
      EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(20, 0, 20, 0)}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
      padding: padding,
      width: width,
      // height: height,
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
              fontSize: fontSize),
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
      margin: EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            helperText: '',
            // fillColor: Colors.white,
            filled: true,
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }

  static Widget dialog(
      {Widget child,
      BuildContext context,
      String title,
      double height,
      Color color = Colors.black}) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              // height: height,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      // color: Theme.of(context).primaryColor,
                      child: title.isEmpty
                          ? SizedBox()
                          : Container(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Text(title,
                                  textAlign: TextAlign.center,
                                  style: ThemeText.dialogHeader),
                            )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(child: child),
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 5,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
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
            // color: color,
            margin: EdgeInsets.symmetric(horizontal: 0),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8), child: child),
          ),
        ],
      ),
    );
  }

  static Widget colorCard(BuildContext context,
      {String title = "", Widget child, Color color}) {
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
            color: color ?? Theme.of(context).primaryColor,
            margin: EdgeInsets.symmetric(horizontal: 0),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8), child: child),
          ),
        ],
      ),
    );
  }

  static AppBar appBarBackArrow(
      {String title, BuildContext context, List<Widget> actions}) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).backgroundColor,
      iconTheme: new IconThemeData(color: PrimaryColor),
      elevation: 0.0,
      actions: actions,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: title == null
          ? SizedBox()
          : Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  // color: PrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
    );
  }

  static Widget screenTitle(
      {String title,
      BuildContext context,
      TextAlign textAlign = TextAlign.left}) {
    return Container(
      // color: Colors.red,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20),
      child: Text(
        title,
        textAlign: textAlign,
        style: ThemeText.bigTextTitle,
      ),
    );
  }
}
