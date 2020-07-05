import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/model/FoodService.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/widgetUtils.dart';

class FoodListScreen extends StatefulWidget {
  FoodListScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: <Widget>[
            Text('List here'),
            StreamBuilder(
              stream: foodListServices.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                ListView.builder(itemBuilder: null);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print('add food');
          showDialog(context: context, builder: (_) => AddProteinDialog());
        },
      ),
    );
  }
}

class AddProteinDialog extends StatefulWidget {
  @override
  _AddProteinDialogState createState() => _AddProteinDialogState();
}

class _AddProteinDialogState extends State<AddProteinDialog> {
  String dropdownValueGoal = "";
  String foodName;
  int proteinAmount;
  final _foodNameController = TextEditingController();
  final _proteinAmountController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
        context: context,
        height: MediaQuery.of(context).size.height * .5,
        title: 'Add food',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              Form(
                child: Column(children: [
                  TextField(
                    controller: _foodNameController,
                    decoration: InputDecoration(hintText: 'Food name'),
                    onChanged: (value) {
                      setState(() {
                        foodName = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _proteinAmountController,
                    decoration:
                        InputDecoration(hintText: 'Protein amount in gr'),
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  WidgetUtils.button(
                      text: "Add",
                      onPressed: () {
                        print('add food');
                        print(foodName);
                        print(proteinAmount);
                        Food food = Food(foodName, proteinAmount);
                        foodListServices.add(food);
                        Navigator.pop(context);
                      })
                ]),
              ),
            ],
          ),
        ));
  }
}
