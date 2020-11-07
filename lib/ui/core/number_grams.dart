import 'package:flutter/material.dart';

class NumberGrams extends StatelessWidget {
  final Color textColor;
  final int grams;
  const NumberGrams({
    Key key,
    this.grams,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(
            "$grams",
            style: TextStyle(fontSize: 90, color: textColor),
          ),
        ),
        Text('gr',
            style: TextStyle(
              fontSize: 28,
              color: textColor,
            ))
      ],
    );
  }
}
