import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';

class BlueScreen extends StatelessWidget {
  final Widget child;
  BlueScreen({this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: PrimaryColor,
              child: child),
        ],
      ),
    );
  }
}
