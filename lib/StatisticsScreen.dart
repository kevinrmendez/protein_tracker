import 'package:flutter/material.dart';
import 'package:protein_tracker/components/proteinChart.dart';
import 'package:protein_tracker/main.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * .4,
                child: ProteinChart.withSampleData())
          ],
        ),
      ),
    );
  }

  Widget _text(text) => Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ));
}
