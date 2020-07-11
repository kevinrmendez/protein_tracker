import 'package:flutter/material.dart';
import 'package:protein_tracker/utils/colors.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/bloc/proteinGoal.dart';
import 'package:protein_tracker/utils/widgetUtils.dart';

class GoalScreen extends StatefulWidget {
  GoalScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _formKey = GlobalKey<FormState>();

  final proteinGoalController = TextEditingController();
  int _proteinGoal;
  @override
  void initState() {
    super.initState();
    _proteinGoal = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Protein Goal',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              WidgetUtils.card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Current protein goal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                          // color: DarkGreyColor,
                          ),
                    ),
                  ),
                  color: PrimaryColor),
              StreamBuilder(
                stream: proteinService.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapshot.data.toString(),
                        style: TextStyle(fontSize: 90),
                      ),
                      Text(
                        ' gr',
                        style: TextStyle(fontSize: 28),
                      )
                    ],
                  );
                },
              ),
              Text(
                'per day',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextFormField(
                          controller: proteinGoalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'goal',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'add your daily protein goal';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: WidgetUtils.button(
                            text: 'set goal',
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _proteinGoal =
                                    int.parse(proteinGoalController.text);
                                proteinService.setGoal(_proteinGoal);
                                print('goal set: $_proteinGoal');
                              }
                            },
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
