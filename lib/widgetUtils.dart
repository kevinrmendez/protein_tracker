import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';

class WidgetUtils {
  static Widget button({String text, Function onPressed}) {
    return RaisedButton(
      color: PrimaryColor,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: onPressed,
    );
  }
}
