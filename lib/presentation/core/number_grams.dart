import 'package:flutter/material.dart';

class NumberGrams extends StatelessWidget {
  final int grams;
  const NumberGrams({
    Key key,
    this.grams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Flexible(
            child: Text(
              "$grams",
              style: TextStyle(
                fontSize: 90,
                // color: textColor
              ),
            ),
          ),
        ),
        Text('gr',
            style: TextStyle(
              fontSize: 28,
            ))
      ],
    );
  }
}
