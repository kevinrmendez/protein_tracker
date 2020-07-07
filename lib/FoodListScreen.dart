import 'package:flutter/material.dart';
import 'package:protein_tracker/main.dart';
import 'package:protein_tracker/FoodService.dart';
import 'package:protein_tracker/model/food.dart';
import 'package:protein_tracker/widgetUtils.dart';

class FoodListScreen extends StatefulWidget {
  FoodListScreen({Key key, this.title}) : super(key: key);

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
      body: StreamBuilder<List<Food>>(
        stream: foodListServices.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.data.length == 0) {
            return Center(
                child: WidgetUtils.iconText(context,
                    icon: Icons.room_service, text: 'your food list is empty'));
          } else {
            return ListView.builder(
                itemCount: foodListServices.currentList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  Food foodItem = snapshot.data[index];
                  return Card(
                    child: ListTile(
                        title: Text(foodItem.name),
                        subtitle:
                            Text("${foodItem.proteinAmount.toString()} gr"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            foodListServices.remove(index);
                          },
                        )),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
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
  final _formKey = GlobalKey<FormState>();
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
        height: MediaQuery.of(context).size.height * .52,
        title: 'Add food',
        showAd: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _foodNameController,
                    decoration: InputDecoration(
                        // hintText: 'chicken',
                        border: OutlineInputBorder(),
                        labelText: 'Food name'),
                    onChanged: (value) {
                      setState(() {
                        foodName = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'food is empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _proteinAmountController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // hintText: 'Protein amount in gr',
                        labelText: 'Protein amount in gr',
                        errorStyle: TextStyle(color: RedColor)),
                    onChanged: (value) {
                      setState(() {
                        proteinAmount = int.parse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "protein amount is empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  WidgetUtils.button(
                      text: "Add",
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print('add food');
                          print(foodName);
                          print(proteinAmount);
                          Food food = Food(foodName, proteinAmount);
                          foodListServices.add(food);
                          Navigator.pop(context);
                        } else {}
                      })
                ]),
              ),
            ],
          ),
        ));
  }
}
